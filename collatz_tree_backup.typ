// --- Hilfsfunktionen für Collatz-Baum ---
#let has_odd_collatz_predecessor(n) = {
  if n <= 4 { return false }
  if calc.rem(n - 1, 3) == 0 {
    let m = int((n - 1) / 3)
    return calc.odd(m)
  }
  return false
}

#let get_odd_predecessor(n) = {
  if has_odd_collatz_predecessor(n) {
    return int((n - 1) / 3)
  }
  return none
}

// --- Collatz Tree Funktion ---
#let collatz_tree(max_levels, scale: 1.0) = {
  // Skalierte Größen
  let r-circle = 16pt * scale
  let h-spacing = 2.2cm * scale
  let v-spacing = 1.6cm * scale
  let f-size = 10pt * scale
  let stroke-width = 2.5pt * scale
  let arrow-size = 10pt * scale

  // Farben
  let circle-fill-color = rgb(200, 180, 230)
  let circle-stroke-color = rgb(120, 80, 160)
  let arrow-color = rgb(80, 60, 120)
  let text-color = black

  // Datenstrukturen
  let nodes = ()
  let arrows = ()
  let branch-counters = (:)

  // Schritt 1: Baue den Hauptstamm (2er-Potenzen bei x=0)
  for level in range(1, max_levels + 1) {
    let val = calc.pow(2, level - 1)
    // stem_id identifiziert den Ast (unabhängig von x-Position!)
    // Hauptstamm hat stem_id = 1
    nodes.push((value: val, level: level, x: 0, stem_id: 1))

    if level < max_levels {
      // Pfeil von oben nach unten: von val * 2 zu val
      arrows.push((from: val * 2, to: val, type: "vertical"))
    }
  }

  // Schritt 2: Iteriere level-weise und baue Abzweigungen
  let max-iterations = max_levels * 3
  let iteration = 0

  while iteration < max-iterations {
    iteration = iteration + 1
    let added-new-nodes = false

    for check-level in range(1, max_levels + 1) {
      let current-nodes = nodes
      let nodes-at-level = current-nodes.filter(n => n.level == check-level)

      for node in nodes-at-level {
        if has_odd_collatz_predecessor(node.value) {
          let odd-pred = get_odd_predecessor(node.value)

          // Prüfe ob dieser Vorgänger schon existiert
          let pred-exists = nodes.any(n => n.value == odd-pred and n.level == check-level)

          if not pred-exists {
            added-new-nodes = true

            // Bestimme den richtigen Counter: Verwende stem_id als Ast-Identifier
            // stem_id bleibt konstant auch wenn der Ast verschoben wird
            let counter-key = "stem-" + str(node.stem_id)
            let counter = branch-counters.at(counter-key, default: 0)

            // Bestimme die Seite: erste Abzweigung = rechts (1), zweite = links (-1)
            let side = if calc.rem(counter, 2) == 0 { 1 } else { -1 }

            // Erhöhe den Zähler
            branch-counters.insert(counter-key, counter + 1)

            // Die stem_id für den neuen Ast ist der Startwert dieses Astes
            let new-stem-id = odd-pred
            let new-x = node.x + side

            if side == -1 {
              // Links-Abzweigung: Verschiebe alle Knoten mit x > 0 und x >= target-x
              let old-node-x = node.x
              let target-x = node.x - 1

              let shifted-nodes = ()
              for old-node in nodes {
                if old-node.x > 0 and old-node.x >= target-x {
                  shifted-nodes.push((value: old-node.value, level: old-node.level, x: old-node.x + 1, stem_id: old-node.stem_id))
                } else {
                  shifted-nodes.push(old-node)
                }
              }
              nodes = shifted-nodes

              // Nach dem Verschieben node-Referenz aktualisieren
              if old-node-x > 0 and old-node-x >= target-x {
                node = nodes.find(n => n.value == node.value and n.level == node.level)
              }

              if old-node-x == 0 {
                new-x = -1
              } else {
                new-x = target-x
              }
            } else {
              new-x = node.x + side
            }

            // Baue den kompletten Ast von odd-pred aufwärts
            let current-val = odd-pred
            let current-level = check-level

            while current-level <= max_levels {
              nodes.push((value: current-val, level: current-level, x: new-x, stem_id: new-stem-id))

              if current-level == check-level {
                arrows.push((from: odd-pred, to: node.value, type: "horizontal"))
              }

              if current-level < max_levels {
                let next-val = current-val * 2
                arrows.push((from: next-val, to: current-val, type: "vertical"))
                current-val = next-val
                current-level = current-level + 1
              } else {
                break
              }
            }
          }
        }
      }
    }

    if not added-new-nodes { break }
  }

  // Finde min/max x für Breite
  let min-x = 0
  let max-x = 0
  for node in nodes {
    if node.x < min-x { min-x = node.x }
    if node.x > max-x { max-x = node.x }
  }

  let total-width = (max-x - min-x + 1) * h-spacing
  let total-height = max_levels * v-spacing

  let grid-to-pos(x, level) = {
    let px = (x - min-x) * h-spacing + h-spacing / 2
    let py = total-height - (level - 1) * v-spacing - v-spacing / 2
    return (px, py)
  }

  // Zeichne den Baum
  block(
    width: total-width,
    height: total-height + v-spacing,
    breakable: false,
    {
      // Zuerst alle Pfeil-Linien zeichnen
      for arrow in arrows {
        let from-node = nodes.find(n => n.value == arrow.from)
        let to-node = nodes.find(n => n.value == arrow.to)

        if from-node == none or to-node == none { continue }

        let from-pos = grid-to-pos(from-node.x, from-node.level)
        let to-pos = grid-to-pos(to-node.x, to-node.level)

        if arrow.type == "vertical" {
          let start-y = from-pos.at(1) + r-circle
          let end-y = to-pos.at(1) - r-circle
          let x = from-pos.at(0)

          place(top + left, line(
            start: (x, start-y),
            end: (x, end-y - arrow-size),
            stroke: stroke-width + arrow-color
          ))
        } else {
          let start-x = from-pos.at(0)
          let end-x = to-pos.at(0)
          let y = from-pos.at(1)

          if start-x < end-x {
            let sx = start-x + r-circle
            let ex = end-x - r-circle
            place(top + left, line(
              start: (sx, y),
              end: (ex - arrow-size, y),
              stroke: stroke-width + arrow-color
            ))
          } else {
            let sx = start-x - r-circle
            let ex = end-x + r-circle
            place(top + left, line(
              start: (sx, y),
              end: (ex + arrow-size, y),
              stroke: stroke-width + arrow-color
            ))
          }
        }
      }

      // Dann die Kreise
      for node in nodes {
        let pos = grid-to-pos(node.x, node.level)
        place(top + left,
          dx: pos.at(0) - r-circle,
          dy: pos.at(1) - r-circle,
          circle(
            radius: r-circle,
            fill: circle-fill-color,
            stroke: 3pt * scale + circle-stroke-color,
            align(center + horizon, text(size: f-size, weight: "bold", fill: text-color, str(node.value)))
          )
        )
      }

      // Pfeilspitzen
      for arrow in arrows {
        let from-node = nodes.find(n => n.value == arrow.from)
        let to-node = nodes.find(n => n.value == arrow.to)

        if from-node == none or to-node == none { continue }

        let from-pos = grid-to-pos(from-node.x, from-node.level)
        let to-pos = grid-to-pos(to-node.x, to-node.level)
        let arrow-width = 8pt * scale

        if arrow.type == "vertical" {
          let end-y = to-pos.at(1) - r-circle
          let x = from-pos.at(0)

          place(top + left,
            dx: x - arrow-width / 2,
            dy: end-y - arrow-size,
            polygon(
              fill: arrow-color,
              stroke: none,
              (0pt, 0pt),
              (arrow-width, 0pt),
              (arrow-width / 2, arrow-size)
            )
          )
        } else {
          let start-x = from-pos.at(0)
          let end-x = to-pos.at(0)
          let y = from-pos.at(1)

          if start-x < end-x {
            let ex = end-x - r-circle
            place(top + left,
              dx: ex - arrow-size,
              dy: y - arrow-width / 2,
              polygon(
                fill: arrow-color,
                stroke: none,
                (0pt, 0pt),
                (0pt, arrow-width),
                (arrow-size, arrow-width / 2)
              )
            )
          } else {
            let ex = end-x + r-circle
            place(top + left,
              dx: ex + arrow-size,
              dy: y - arrow-width / 2,
              polygon(
                fill: arrow-color,
                stroke: none,
                (0pt, 0pt),
                (0pt, arrow-width),
                (-arrow-size, arrow-width / 2)
              )
            )
          }
        }
      }
    }
  )
}
