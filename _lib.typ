// Importe (Packages)

#import "@preview/codly:1.3.0": *
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/ribbony:0.1.0": *

// Eigene Definitionen importieren
#import "_config.typ": *

// Funktionen

#let info-box(title: "INFO", body) = block(
   width: 100%,
   inset: 12pt,
   radius: 8pt,
   stroke: config.colors.boxes.info.frame,
   fill: config.colors.boxes.info.fill,
)[
   // Titelzeile
   #text(
      weight: "bold",
      fill: config.colors.boxes.info.title,
      size: 14pt,
   )[#title]

   #v(2pt)

   // Fließtext
   #text(
      size: 12pt,
   )[ #body ]
]

#let code-box(title: "CODE", body) = block(
   width: 100%,
   inset: 12pt,
   radius: 8pt,
   stroke: config.colors.boxes.code.frame,
   fill: config.colors.boxes.code.fill,
)[
  // Titelzeile
  #text(
    weight: "bold",
    fill: config.colors.boxes.code.title,
    size: 14pt,
  )[#title]

  #v(2pt)

  // Fließtext
  #text(
    size: 12pt,
  )[ #body ]
]

// Mit Hilfe der Funktion nameref() kann man den tatsächlichen Text
// einer z.B. Kapitelüberschrift referenzieren.
// Anwendung im markup mode: #nameref(<label>)
// Die spitzen Klammern innerhalb der runden Klammern sind also wichtig.
#let nameref(label) = context {
  let elems = query(label)
  if elems.len() > 0 {
    elems.first().body
  } else {
    [**Referenz nicht gefunden**]
  }
}

// Koch'sche Schneeflockenkurve
#let koch-snowflake(n) = {
  let complex-add(c1, c2) = { c1.zip(c2).map(array.sum) }
  let complex-multiply(c1, c2) = (c1.at(0) * c2.at(0) - c1.at(1) * c2.at(1), c1.at(0) * c2.at(1) + c1.at(1) * c2.at(0))
  let complex-inverse-array(a) = { a.map(c => c.map(x => -x)) }
  let complex-multiply-array(a, c) = { a.map(c1 => complex-multiply(c1, c)) }
  let complex-add-array(a1, a2) = { a1.zip(a2).map(cs => complex-add(..cs)) }
  
  let koch-snowflake-impl(n) = {
    if n == 0 {
      return (90deg, 210deg, 330deg).map(phi => (calc.cos(phi), calc.sin(phi)))
    }
    let pts = koch-snowflake-impl(n - 1)
    let diff = complex-add-array(pts.slice(1) + (pts.first(),), complex-inverse-array(pts))
    let points = (
      pts,
      complex-add-array(pts, complex-multiply-array(diff, (1/3, 0))),
      complex-add-array(pts, complex-multiply-array(diff, (0.5, -0.5 * calc.sqrt(3) / 3))),
      complex-add-array(pts, complex-multiply-array(diff, (2/3, 0))),
    )
    return array.zip(..points).join()
  }
  return koch-snowflake-impl(n)
}

// Collatz Diagramme/Funktionen
// 
// --- Hilfsfunktion: Pfeilspitze ---
//#let arrow-head(pos, angle, scale, col: arrow-color) = {
#let arrow-head(pos, angle, scale, col: config.colors.collatz.arrow) = {
  let w = 3.5pt * scale
  let h = 8pt * scale 
  
  place(top + left, dx: pos.at(0), dy: pos.at(1),
    rotate(angle, origin: left, 
      polygon(
        fill: col, 
        stroke: none, 
        (0pt, 0pt),     
        (-w, -h), 
        (w, -h) 
      )
    )
  )
}

// --- Collatz Logik ---
#let collatz_all(start) = {
  let seq = (start,)
  let current = start
  while current != 1 {
    if calc.even(current) {
      current = int(current / 2)
    } else {
      current = current * 3 + 1
    }
    seq.push(current)
  }
  return seq
}

// --- Visualisierung ---
#let collatz_visualizer(start_val, max_rows, scale: 1.0, padding: 10pt) = {
   let sequence = collatz_all(start_val)
   
   // 1. Grundmaße definieren
   let r-circle = 15pt * scale        
   let cell-w = 1.5cm * scale         
   let cell-h = 2.0cm * scale         
   let col-gap = 1.0cm * scale
   let text-size = 11pt * scale
   let stroke-w = 2.5pt * scale
   let arrow-h = 8pt * scale 
   let circle-stroke-style = stroke-w + config.colors.collatz.circle-stroke
   let v-padding = 0.5cm * scale
   let pad = padding * scale
   let dist = 4pt * scale  // Den Abstand zum Kreis (4pt) benennen wir

   // 2. Geometrie des Bogens berechnen
   // Der Bogen spannt sich über die Hälfte des Abstands zwischen Spaltenmitte und Guttermitte.
   // Radius = (Breite Zelle + Breite Lücke) / 4
   let arc-radius = (cell-w + col-gap) / 4
   let kappa = 0.55228 

   // 3. Dynamische Ränder berechnen (statt fester Werte)
   // Wir brauchen oben Platz für: Radius des Kreises + Radius des Bogens + Puffer
   let top-buffer = 10pt * scale // Kleiner Sicherheitsabstand oben und unten
   let bottom-padding = 0pt
   let top-offset = pad + r-circle + dist + arc-radius + arrow-h
   
   // Berechnete Gesamthöhe:
   // (Anzahl Zeilen * Zeilenhöhe) + Platz oben + Platz unten für den Bogen
   let total-cols = int(calc.ceil(sequence.len() / max_rows))
   let total-width = total-cols * cell-w + (calc.max(0, total-cols - 1) * col-gap) + 2 * pad

   // Der letzte Kreis endet bei: (max_rows * cell-h) - (cell-h / 2) + top-offset + r-circle
   // Wir machen es einfacher: Block-Höhe = Nutzlast + Ränder
   // Nutzlast-Höhe ist etwa: (max_rows - 1) * cell-h
   // Dazu oben 'top-offset' und unten Platz für den unteren Bogen (arc-radius + buffer)
   let total-height = (max_rows - 1) * cell-h + top-offset + r-circle + dist + arc-radius + pad

   align(center)[
      // Debug-Rahmen (optional, zum Testen einkommentieren):
      // #box(stroke: 0.5pt + red, 
      #block(width: total-width, height: total-height, {
      
         for (i, num) in sequence.enumerate() {
         let c = int(i / max_rows)
         let r = calc.rem(i, max_rows)
         
         let cx = pad + c * (cell-w + col-gap) + cell-w/2
         let cy = r * cell-h + top-offset
         
         // Kreis zeichnen
         place(top + left, dx: cx - cell-w/2, dy: cy - cell-h/2, 
            box(width: cell-w, height: cell-h, align(center + horizon)[
               #circle(radius: r-circle, stroke: circle-stroke-style, fill: config.colors.collatz.circle-fill)[
               #set align(center + horizon)
               #text(size: text-size, weight: "bold", fill: config.colors.collatz.text)[#num]
               ]
            ])
         )
         
         if i < sequence.len() - 1 {
            
            if r < max_rows - 1 {
               // === FALL A: Vertikal ===
               let start-y = cy + r-circle + (4pt * scale)
               let end-y   = cy + cell-h - r-circle - (4pt * scale)
               
               place(curve(
                  stroke: stroke-w + config.colors.collatz.arrow,
                  curve.move((cx, start-y)),
                  curve.line((cx, end-y - arrow-h)) 
               ))
               arrow-head((cx, end-y), 0deg, scale, col: config.colors.collatz.arrow)
            } 
            else {
               // === FALL B: Snake ===
               let next-cx = cx + cell-w + col-gap
               let mx      = (cx + next-cx) / 2  
               
               let width = mx - cx      
               let radius = width / 2  // Identisch mit arc-radius von oben 
               let k = radius * kappa   

               let start-y = cy + r-circle + (4pt * scale)
               let dest-y  = top-offset - r-circle - (4pt * scale)
               let arrow-base-y = dest-y - arrow-h

               let arc-bottom = start-y + radius
               let arc-top    = arrow-base-y - radius

               place(curve(
                  stroke: stroke-w + config.colors.collatz.arrow,
                  
                  curve.move((cx, start-y)),
                  
                  // Unterer Bogen
                  curve.cubic(
                     (cx, start-y + k),                
                     (cx + radius - k, arc-bottom),    
                     (cx + radius, arc-bottom)         
                  ),
                  curve.cubic(
                     (cx + radius + k, arc-bottom),    
                     (mx, start-y + k),                
                     (mx, start-y) 
                  ),
                  
                  curve.line((mx, arrow-base-y)),
                  
                  // Oberer Bogen
                  curve.cubic(
                     (mx, arrow-base-y - k),           
                     (mx + radius - k, arc-top),       
                     (mx + radius, arc-top)            
                  ),
                  curve.cubic(
                     (mx + radius + k, arc-top),       
                     (next-cx, arrow-base-y - k),      
                     (next-cx, arrow-base-y) 
                  ),
               ))
               arrow-head((next-cx, dest-y), 0deg, scale, col: config.colors.collatz.arrow)
            }
           }
         }
      })
    // ) // Ende Debug-Box
  ]
}

#let collatz_visualizer_horizontal(start_val, scale: 1.0, padding: 10pt) = {
  let sequence = collatz_all(start_val)

  let pad = padding * scale // Skaliertes Padding

  // Maße
  let r-circle = 15pt * scale        
  let cell-w = 1.5cm * scale         
  let cell-h = 2 * r-circle
  let col-gap = 0.6cm * scale 
  
  // NEU: Hier stellst du den Abstand oben/unten ein
  let padding-top = 0.5cm * scale
  let padding-bottom = 0pt
  
  let text-size = 11pt * scale
  let stroke-w = 2.5pt * scale
  let circle-stroke-style = stroke-w + config.colors.collatz.circle-stroke
  let arrow-h = 8pt * scale 

   // Breite: Inhalt + Lücken + Padding links/rechts
  let content-width = sequence.len() * cell-w + (sequence.len() - 1) * col-gap
  let total-width = content-width + 2 * pad

  // Höhe: Exakt der Kreisdurchmesser + Padding oben/unten (ohne extra cell-h Luft)
  let total-height = 2 * r-circle + 2 * pad
  
  align(center)[
    #block(width: total-width, height: total-height, { // inset wäre auch möglich, aber so ist es präziser
      
      for (i, num) in sequence.enumerate() {
        let cx = pad + i * (cell-w + col-gap) + cell-w/2
        
        // NEU: Vertikale Mitte basiert jetzt auf der vergrößerten Box
        let cy = total-height / 2
        
        // 1. Kreis
        place(top + left, dx: cx - cell-w/2, dy: cy - r-circle, 
          box(width: cell-w, height: 2 * r-circle, align(center + horizon)[
            #circle(radius: r-circle, stroke: circle-stroke-style, fill: config.colors.collatz.circle-fill)[
              #set align(center + horizon)
              #text(size: text-size, weight: "bold", fill: config.colors.collatz.text)[#num]
            ]
          ])
        )
        
        // 2. Horizontaler Pfeil
        if i < sequence.len() - 1 {
           let next-cx = pad + (i + 1) * (cell-w + col-gap) + cell-w/2
           
           let start-x = cx + r-circle + (4pt * scale)
           let dest-x = next-cx - r-circle - (4pt * scale)
           
           place(curve(
             stroke: stroke-w + config.colors.collatz.arrow,
             curve.move((start-x, cy)),
             curve.line((dest-x - arrow-h, cy))
           ))
           
           arrow-head((dest-x, cy), -90deg, scale, col: config.colors.collatz.arrow)
        }
      }
    })
  ]
}

// --- Hilfsfunktionen für Collatz-Baum ---
#let has_odd_predecessor(n) = {
  if n <= 4 { return false }
  if calc.rem(n - 1, 3) == 0 {
    let m = int((n - 1) / 3)
    return calc.odd(m)
  }
  return false
}

#let get_odd_predecessor(n) = {
  if has_odd_predecessor(n) {
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
  let circle-fill-color = config.colors.collatz.circle-fill
  let circle-stroke-color = config.colors.collatz.circle-stroke
  let arrow-color = config.colors.collatz.arrow
  let text-color = config.colors.collatz.text

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
        if has_odd_predecessor(node.value) {
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

            // Prüfe ob die Zielposition belegt ist
            let target-x = node.x + side
            let position-occupied = nodes.any(n => n.x == target-x and n.level == check-level)

            if position-occupied and side == 1 {
              // Rechts-Abzweigung: Sammle Äste an target-x und rechts davon
              let stems-to-shift = ()

              for n in nodes {
                if n.x >= target-x and n.stem_id not in stems-to-shift {
                  stems-to-shift.push(n.stem_id)
                }
              }

              // Verschiebe alle Knoten mit diesen stem_ids um 1 nach rechts
              let shifted = ()
              for n in nodes {
                if n.stem_id in stems-to-shift and n.x > 0 {
                  shifted.push((value: n.value, level: n.level, x: n.x + 1, stem_id: n.stem_id))
                } else {
                  shifted.push(n)
                }
              }
              nodes = shifted

              // Aktualisiere node-Referenz falls nötig
              if node.stem_id in stems-to-shift and node.x > 0 {
                node = nodes.find(n => n.value == node.value and n.level == node.level)
              }
            } else if position-occupied and side == -1 {
              // Links-Abzweigung und Position belegt: Verschiebe den Ast, von dem wir abzweigen, plus Sub-Äste
              let old-node-x = node.x  // Merke die alte Position BEVOR wir verschieben
              let stems-to-shift = (node.stem_id,)

              // Finde alle Äste, die von diesem Ast abzweigen
              for n in nodes {
                if n.stem_id == node.stem_id and has_odd_predecessor(n.value) {
                  let pred = get_odd_predecessor(n.value)
                  for pred-node in nodes {
                    if pred-node.value == pred and pred-node.level == n.level and pred-node.stem_id != node.stem_id {
                      if pred-node.stem_id not in stems-to-shift {
                        stems-to-shift.push(pred-node.stem_id)
                      }
                    }
                  }
                }
              }

              // Verschiebe alle Knoten mit diesen stem_ids um 1 nach rechts
              let shifted = ()
              for n in nodes {
                if n.stem_id in stems-to-shift and n.x > 0 {
                  shifted.push((value: n.value, level: n.level, x: n.x + 1, stem_id: n.stem_id))
                } else {
                  shifted.push(n)
                }
              }
              nodes = shifted

              // Aktualisiere node-Referenz
              if node.x > 0 and node.stem_id in stems-to-shift {
                node = nodes.find(n => n.value == node.value and n.level == node.level)
              }

              // Überschreibe target-x mit der alten Position
              target-x = old-node-x
            }

            // Setze new-x basierend auf der Richtung
            if side == -1 and node.x == 0 {
              new-x = -1  // Links vom Hauptstamm
            } else if position-occupied {
              // Position war belegt, wir haben verschoben, platziere an der alten Position
              new-x = target-x
            } else {
              // Position war frei, einfach dort platzieren
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
    height: total-height,
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


// ---------------------------------------------
// Unsere Haupt-Funktion "project"
// Enthält alle Einstellungen für unser Dokument

#let project(
   theTitle: "",
   authors: (),
   description: "",
   location: "",
   keywords: (),
   date: none,
   version: "",
   bib-path: none,  // Pfad zur bzw. Dateiname der .bib Datei
   abstract: none,
   doc              // das eigentliche Dokument
) = {
   // Ab hier alle Setups

   // set rules
   set text(lang: "de")

   // Metadata for PDF
   set document(
      title: theTitle,
      author: authors,
      description: description,
      keywords: keywords,
      date: date
   )

   // Font selection
   set text(
      // Generic Font that exists on Mac, Windows, Ubuntu (Github!)
      font: "Inter 18pt",
      size: config.document.font-size
   )

   // Page Setup
   set page(
      paper: "a4",
      margin: (x: config.distances.page.margin-x,
               y: config.distances.page.margin-y),
      numbering: "1/1",
      footer: context {
         set text(config.document.footer.font-size, fill: config.colors.footer.text)
         stack(
            dir: ttb,
            spacing: 8pt,
            line(length: 100%, stroke: 0.5pt + config.colors.footer.line),
            [Erste Schritte in Typst #sym.dot Stefan Wolfrum #sym.dot Version #version #sym.dot #date.display("[month repr:long] [year]") #sym.dot Typst-Version #sys.version #sym.dot License: #config.document.license #h(1fr) #counter(page).display()]
         )
      }
   )

   // Paragraph Style: Blocksatz
   set par(
      justify: true,
      leading: 0.52em
   )
   set heading(numbering: "1.", supplement: [Kapitel])
   set math.equation(numbering: "(1)")
//   set figure(gap: 55em)
   set quote(block: true)
   set list(indent: config.document.list-indent)
   set enum(indent: config.document.enum-indent)
   set terms(
      separator: [: ],
      spacing: 0.8em
   )

   // show rules
   //show link: underline
   show link: set text(fill: config.colors.link)
   show figure.caption: set text(size: config.document.figure.caption-font-size)
   // Abstände für unnummerierte Listen
   show list: set block(above: config.distances.list.above, below: config.distances.list.below)

   // Abstände für nummerierte Aufzählungen
   show enum: set block(above: config.distances.enum.above, below: config.distances.enum.below)

   // Show rule, um jede figure mit einem
   // dünnen, grauen Rahmen zu umrahmen.
   show figure: it => align(center)[
      #stack(
         dir: ttb,       // Top to Bottom
         spacing: 13pt,  // Abstand zw. Rahmen und Caption
         
         // Der Rahmen
         block(
            stroke: 0.5pt + config.colors.figure.frame,
            inset: 1em,
            radius: 3pt,
            it.body
         ),
         
         // Die Caption
         it.caption
      )
   ]

   // Abstand zwischen einer figure (inkl. caption) und
   // dem umgebenden Fließtext darüber (above) und
   // darunter (below):
   show figure: set block(above: config.distances.figure.above, below: config.distances.figure.below)

   show math.equation.where(block: true): set text(size: config.document.equation.font-size)
   show heading: it => [
      #v(config.distances.heading.above)
      #it
      #v(config.distances.heading.below)
   ]
   show title: set align(center)

   // Alle Literaturverzeichnis-Referenzen im Text in einer anderen Farbe:
   show cite: set text(fill: config.colors.citation)

   // Eine Funktion für das "echte" LaTeX-Logo-Feeling definieren
   let latex-logo = {
      [L]
      h(-0.36em)
      
      // Das A: Großbuchstabe, verkleinert und hochgestellt
      box(move(dy: -0.22em)[
         #text(size: 0.7em)[A]
      ])
      
      h(-0.15em)
      [T]
      h(-0.16em)
      
      // Das E: Tiefgestellt
      box(move(dy: 0.22em)[E])
      
      h(-0.125em)
      
      // Das X: Einfach ein X (steht für das große griechische Chi)
      [X] 
   }
   // Die Regel global aktivieren
   show "LaTeX": latex-logo

   // Globale Regel für alle Zitate im Dokument
   show quote.where(block: true): it => block(
      fill: config.colors.quote.fill,    // Leichter grauer Hintergrund
      stroke: (left: 4pt + config.colors.quote.stroke), // Der klassische Balken links
      inset: (x: 1.2em, y: 0.8em),  // Innenabstand
      outset: (y: 0.5em),         // Außenabstand
      radius: 4pt,                // Leicht abgerundet
      width: 100%,
      {
         place(
            top + left,
            dx: -1.0em,
            dy: -10.7em,
            text(
               size: 16em,
               fill: config.colors.quote.stroke.lighten(60%),
               font: "Playfair Display",
               weight: "bold"
            )["]
         )
         text(style: "italic")[#it]  // Der eigentliche Inhalt des Zitats
      }
   )

   // Hier wählen wir den Font, der für Codeblöcke (raw) genutzt werden soll:
   show raw: set text(font: "JetBrains Mono",
                      size: config.document.code-font-size) 

   // Styling für INLINE Code (in Backticks `...`)
   // Wir nutzen 'box', damit es im Textfluss bleibt.
   show raw.where(block: false): it => box(
      fill: config.colors.code.inline-fill,
      inset: (x: 3pt, y: 0pt),    // Etwas Luft links/rechts, oben/unten eng
      outset: (y: 3pt),           // Trick: Box optisch vergrößern ohne Zeilenabstand zu sprengen
      radius: 3pt,                // Leicht abgerundete Ecken
      it
   )


   // Codly Initialisierung
   show: codly-init.with()

   // Codly Konfiguration
   codly(
      languages: typst-icon,
      fill: config.colors.codly.fill,
      zebra-fill: config.colors.codly.zebra-fill,
      stroke: 0.5pt + config.colors.codly.stroke,
      radius: 4pt,                   // Ecken: Abgerundet
      inset: 0.32em,
      lang-inset: 0.5em,
      lang-outset: (x: 0.5em, y: 0.0em),
      display-icon: true,           
      display-name: true,            // Zeigt den Namen der Sprache an
      number-align: right,
      number-format: (n) => text(fill: config.colors.codly.line-numbers, size: 8pt, str(n)), // Nummer-Style
   )

   //show raw.where(block: true): it => pad(x: 1.5em, it)

   title[#theTitle]
   align(center)[
      #authors \
      #location
   ]

   v(1em) // Vertikaler Abstand

   // Abstract rendern (wenn vorhanden)
   if abstract != none {
      pad(x: config.distances.abstract-pad-x)[ // Seitliche Einrückung für den Abstract
         #align(center)[*Zusammenfassung*]
         #set text(style: "italic", size: config.document.abstract-font-size)
         #abstract
      ]
//      v(1em) // Abstand zum Haupttext
   }

   doc

   pagebreak(weak: true)
   bibliography(bib-path, style: config.document.citation.style, title: config.document.citation.title)
}