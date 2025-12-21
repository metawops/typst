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

   #v(8pt)

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

  #v(8pt)

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
   abstract: none,
   doc            // das eigentliche Dokument
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
            [Erste Schritte in Typst, Stefan Wolfrum, Dezember 2025, Dokumentversion #version, Typst-Version #sys.version #h(1fr) #counter(page).display()]
         )
      }
   )

   // Paragraph Style: Blocksatz
   set par(
      justify: true,
      leading: 0.52em,
   )
   set heading(numbering: "1.", supplement: [Kapitel])
   set math.equation(numbering: "(1)")
//   set figure(gap: 55em)
   set quote(block: true)

   // show rules
   //show link: underline
   show link: set text(fill: config.colors.link)
   show figure.caption: set text(size: config.document.figure.caption-font-size)

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
      stroke: (left: 2pt + config.colors.quote.stroke), // Der klassische Balken links
      inset: (x: 1em, y: 0.5em),  // Innenabstand
      outset: (y: 0.5em),         // Außenabstand
      radius: 2pt,                // Leicht abgerundet
      it                          // Der eigentliche Inhalt des Zitats
   )

   // Hier wählen wir den Font, der für Codeblöcke (raw) genutzt werden soll:
   show raw: set text(font: "JetBrains Mono", size: 0.95em) 

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
      lang-outset: (x: 0.2em, y: 0.4em),
      display-icon: true,           
      display-name: true,            // Zeigt den Namen der Sprache an
      number-align: right,
      number-format: (n) => text(fill: config.colors.codly.line-numbers, size: 8pt, str(n)), // Nummer-Style
   )

   title[#theTitle]
   align(center)[
      #authors \
      #location
   ]

   v(1em) // Vertikaler Abstand

   // Abstract rendern (wenn vorhanden)
   if abstract != none {
      pad(x: 3em)[ // Seitliche Einrückung für den Abstract
         #align(center)[*Zusammenfassung*]
         #set text(style: "italic", size: 11pt)
         #abstract
      ]
      v(1em) // Abstand zum Haupttext
   }
   doc
}