// Importe (Packages)

#import "@preview/codly:1.3.0": *
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/ribbony:0.1.0": *

// Funktionen

#let info-box(title: "INFO", body) = block(
  width: 100%,
  inset: 12pt,
  radius: 8pt,
  stroke: rgb("#3b82f6"),        // Rahmen blau
  fill: rgb("#e0f2ff"),          // hellblauer Hintergrund
)[
  // Titelzeile
  #text(
    weight: "bold",
    fill: rgb("#1d4ed8"),
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
  stroke: rgb("#f6953b"),        // Rahmen blau
  fill: rgb("#fff8e0"),          // hellblauer Hintergrund
)[
  // Titelzeile
  #text(
    weight: "bold",
    fill: rgb("#d87e1d"),
    size: 14pt,
  )[#title]

  #v(8pt)

  // Fließtext
  #text(
    size: 12pt,
  )[ #body ]
]

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
      size: 13pt
   )

   // Page Setup
   set page(
      paper: "a4",
      margin: (x: 1.5cm, y: 1.5cm),
      numbering: "1/1",
      footer: context[
         #set text(8pt, fill: luma(120))
         Erste Schritte in Typst, Stefan Wolfrum, Dezember 2025, Dokumentversion #version, Typst-Version #sys.version #h(1fr) #counter(page).display()
      ]
   )

   // Paragraph Style: Blocksatz
   set par(
      justify: true,
      leading: 0.52em,
   )
   set heading(numbering: "1.", supplement: [Kapitel])
   set math.equation(numbering: "(1)")
   set figure(gap: 0.1em)
   set quote(block: true)

   // show rules
   //show link: underline
   show link: set text(fill: blue)
   show figure.caption: set text(size: 11pt)
   show figure: set block(above: 2em, below: 4.5em)
   show math.equation.where(block: true): set text(size: 1.1em)
   show heading: it => [
      #v(0.2em)
      #it
      #v(0.8em)  // Abstand nach jeder Überschrift
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
      fill: gray.lighten(80%),    // Leichter grauer Hintergrund
      stroke: (left: 2pt + gray), // Der klassische Balken links
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
      fill: luma(240),          // Sehr helles Grau (255=Weiß, 0=Schwarz)
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
      fill: luma(240),             // Hintergrund: Hellgrau
      zebra-fill: luma(230),       // leicht gestreiften Zeilen
      stroke: 0.5pt + luma(160),   // Rahmen: Dünn, dunkelgrau
      radius: 4pt,                   // Ecken: Abgerundet
      inset: 0.32em,
      lang-inset: 0.5em,
      lang-outset: (x: 0.2em, y: 0.4em),
      display-icon: true,            // Icon aus (nur Text-Label, wie gewünscht)
      display-name: true,            // Zeigt den Namen der Sprache an
      number-align: right,
      number-format: (n) => text(fill: luma(120), size: 8pt, str(n)), // Nummer-Style
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
      v(2em) // Abstand zum Haupttext
   }
   doc
}