// ------------------------------
// Demo-File für Typst
// Geschrieben von Stefan Wolfrum
// November/Dezember 2025
// ------------------------------

#import "_lib.typ": *

// Jetzt nutzen wir unsere "project" Funktion,
// die wir in _lib.typ definiert haben und die
// alle Setups für unser Dokument enthält:

#show: project.with(
   theTitle: "Erste Schritte in Typst",
   authors: ("Stefan Wolfrum"),
   description: [Ein kleines Demo-Dokument, was die Nutzung von Typst demonstrieren soll.],
   location: "Bonn, Germany",
   keywords: ("Typst", "Demonstration", "Sample", "Beispiel"),
   date: datetime(year: 2025, month: 12, day: 12),
   version: "0.1.251213",
   abstract: [Typst ist ein Satzsystem, mit dem man vor allem PDF Dokumente sehr ordentlich setzen kann. Man kann Typst im einfachsten Fall ähnlich wie Markdown benutzen. Es bietet aber weit mehr Möglichkeiten und man kann extrem komplexe Dokumente damit schreiben. Von der Hausarbeit über die Masterarbeit bis zum Buch. Dabei kann es analog zu LaTeX den wissenschaftlichen Satz inklusive mathematischer Formeln perfekt abbilden und ist darüber hinaus über 3rd party Pakete erweiterbar. Typst ist sogar eine Programmiersprache und so kann man zum Beispiel Grafiken algorithmisch direkt innerhalb des Dokuments erstellen.
   
   Typst ist Open Source und kann daher frei und kostenlos benutzt werden. Es gibt einen Browser-basierten Editor mit Live-Preview#footnote[Abrufbar unter #link("https://typst.app/app")], aber man kann Typst auch lokal auf dem eigenen Rechner installieren und als Editor mit Live-Preview zum Beispiel VSCode mit der Erweiterung "Tinymist Typst" benutzen.
   ]
)



= Schrift & Formeln

Hier kann man Text schreiben.

Auch *viel* Text. Gerne auch _relevanten_ Text.

Das Typesetting sieht wirklich wie bei LaTeX aus!

Natürlich gehen auch mathematische Formeln: $E=m c^2$, $(a+b)^2 = a^2 + 2a b + b^2$ oder auch $e^(i pi) + 1 = 0$ sind _inline_ Beispiele.

Hier ein Beispiel für eine eigenständig stehende Formel, die auch automatisch nummeriert wurde. Das Beispiel in @collatz zeigt die Definition der _Hailstone Numbers_ bzw. des sog. #link("https://de.wikipedia.org/wiki/Collatz-Problem")[_Collatz- oder auch 3n+1-Problems_], was immer noch ungelöst ist:

$
a_(n+1) := cases(
   a_n / 2 ","  & "wenn" a_n "gerade",
   3 a_n +1 "," & "wenn" a_n "ungerade"
)
$ <collatz>

Wir werden in @programmierung in @collatzdiagramm noch ein dynamisch erzeugtes (also in Typst programmiertes) Diagramm dazu sehen.

Wichtig für alleinstehende Block-Formeln wie diese ist, dass man nach dem einleitenden und vor dem abschließenden `$` Zeichen ein Leerzeichen oder einen Zeilenumbruch setzt!
#v(2em)

#let loremwords = 42

#grid(
   columns: 2,
   column-gutter: 2em,
   [Es gibt sogar eine Funktion namens `#lorem()`, mit der man sofort _Lorem ipsum_ Text erzeugen kann. Rechts stehen #loremwords Worte _Lorem ipsum_ Text, erzeugt mit der `#lorem()` Funktion.

   Ein spontanes, zweispaltiges Layout mitten im Text erreicht man mit der `#grid()` Funktion, die ich hier angewendet habe.
   ],
   [
      #box(
         inset: (left: 2em),
         text(fill: gray.darken(25%))[_#lorem(loremwords)_]
      )
   ],
   grid.vline(
      x: 1,
      stroke: 0.5pt + gray.darken(25%)
   )
)

#v(2em)

#pagebreak()
= Das Zeichen \# in Typst
Wir müssen kurz über das Zeichen \# sprechen. 

Solange man im "Textschreibmodus" ist (_markup mode_), muss man Funktionsaufrufe, wie z.B. `#image()` (siehe @bilder) mit dem \# Zeichen beginnen. Das sagt Typst "Achtung, jetzt kommt ein Funktionsaufruf".

Wenn man aber bereits in einer Funktion ist (_code mode_) und darin nochmal Funktionsaufrufe nutzt – das sehen wir bei `#figure()` in @abbildungen –, dann darf man das Zeichen \# _nicht_ vor den Funktionsnamen setzen!

Das gilt übrigens nicht nur für _Funktionen_, sondern auch für Keywords wie `set`, `show`, `let`, ...

#quote(attribution: "Alan Turing")[
  We can only see a short distance ahead, but we can see plenty there that needs to be done.
]

#pagebreak()
= Bilder mit `image()` <bilder>

Bilder können im einfachsten Fall über die Funktion `#image()` eingebettet werden. Dabei werden viele Formate unterstützt. Neben den Bitmap-Formaten *PNG*, *JPG*, *GIF*, *WebP* auch das Vektorformat *SVG* und sogar *PDF*. Hier ein auf 50% verkleinertes, eingebettetes JPG Foto des Raspberry Pi _Compute Module 5 (CM5)_:

#image("img/cm5.jpeg", width: 85%)

Die Funktion `image()` eignet sich für das schnelle Einbetten eines Bildes, hat aber zunächst ein paar Nachteile, allen voran: linksbündig, keine Bildunterschrift.

Da hilft uns die `figure()` Funktion aus @abbildungen.

#pagebreak(weak: true)
//--------------------

= Abbildungen mit `#figure()` <abbildungen>
Mächtiger als `#image()` ist die Funktion `#figure()`. Mit ihr kann man u.a. das Alignment steuern und auch Bildunterschriften realisieren, wie hier in @abb_hybrid:

#figure(
   image("img/output_plot-02.png", width: 100%),
   caption: [Gedämpfte Schwingung, errechnet auf dem Analogcomputer THAT]
) <abb_hybrid>

#pagebreak(weak: true)
//--------------------

= Info-Box

#info-box[
   Man kann auch hübsche Info-Boxen wie diese hier gestalten. Dabei gibt es prinzipiell zwei Möglichkeiten:

   + Man kann jede Info-Box neu mit Code schreiben.
   + Man definiert sich einmal eine neue Funktion inklusive Parametern und nutzt diese immer wieder, wenn man eine Info-Box einfügen will.

   So wie im zweiten Punkt wurde es hier gemacht. Dadurch reduziert sich das Erzeugen dieser Info-Box auf einen Aufruf der selbst definierten Funktion `#info-box` (siehe Quellcode dieses Dokuments).
]

#code-box[
Hier ist der Quellcode der Definition der eigenen `#info-box` Funktion:

```typ
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
    size: 12pt,
  )[#title]

  #v(8pt)

  // Fließtext
  #text(
    size: 11pt,
  )[ #body ]
]
```

Wie man sieht, kann man auch die Quellcode-Formatierung innerhalb einer Info-Box benutzen.

Und dies hier ist einfach eine zweite Art Info-Box, die ich `#code-box` genannt und genauso definiert habe, wie die `#info-box`, nur mit anderen Farben und der Überschrift *CODE*.
]

#pagebreak(weak: true)
//--------------------

= Tabellen

_Kapitel muss noch massiv ausgebaut werden!_
#table(
   columns: (auto, auto, auto),
   [*Name*], [*Age*], [*Role*],
   [Alice], [28], [Developer],
   [Bob], [34], [Designer],
   [Charlie], [45], [Manager]
)

// Wir definieren eine Funktion, die Fibonacci-Zahlen errechnen kann:
#let count = 18
#let nums = range(1, count + 1)
#let fib(n) = (
  if n <= 2 { 1 }
  else { fib(n - 1) + fib(n - 2) }
)

// Die Funktion collatz(n) liefert die Folgezahl zu n zurück
#let collatz_seq(start, count) = {
  let seq = (start,) // Wir starten ein Array mit dem Startwert
  let current = start
  
  // Solange das Array noch nicht die gewünschte Länge hat...
  while seq.len() < count {
    if calc.even(current) {
      current = int(current / 2) // Division für gerade Zahlen
    } else {
      current = current * 3 + 1  // 3n + 1 für ungerade Zahlen
    }
    seq.push(current) // Den neuen Wert an das Array anhängen
  }
  
  return seq
}

Ein gutes Beispiel für sowohl Tabellen, als auch dass man in Typst selbst dynamisch Inhalte erzeugen kann, ist diese Tabelle mit den ersten #count Fibonacci Zahlen.

#align(center,
   table(
      columns: count,
      fill: (_, row) => if row == 0 { luma(230) } else { none },
      ..nums.map(n => $F_#n$),
      ..nums.map(n => text(orange)[#str(fib(n))]),
   )
)

= Diagramme

Für Typst gibt es viele importierbare Pakete, die die Möglichkeiten von Typst erweitern. Ein Paket, mit dem man gut Diagramme zeichnen kann, heißt _Lilaq_. Die folgenden Diagramme sind mit Hilfe von _Lilaq_ entstanden.

//#import "@preview/lilaq:0.5.0" as lq

#let xs = (0, 1, 2, 3, 4)

#lq.diagram(
  lq.plot(xs, (3, 5, 4, 2, 3))
)
#lq.diagram(
  title: [Precious data],
  xlabel: $x$, 
  ylabel: $y$,

  lq.plot(xs, (3, 5, 4, 2, 3), mark: "s", label: [A]),
  lq.plot(
    xs, x => 2*calc.cos(x) + 3, 
    mark: "o", label: [B]
  )
)

Ein bisschen anspruchsvoller geht es auch, man beachte z.B. die x-Achsen-Beschriftung im folgenden Diagramm.

#let xs = lq.linspace(-2*calc.pi, 2*calc.pi, num: 40)
#let ys1 = xs.map(x => calc.sin(x))
#let ys2 = xs.map(x => calc.cos(x))

#figure(
   lq.diagram(
      width: 14cm,
      height: 5cm,
      title: [Trigonometrische Funktionen],
      xlim: (-2*calc.pi, 2*calc.pi),
      xaxis: (
         locate-ticks: lq.tick-locate.linear.with(unit: calc.pi),
         format-ticks: lq.tick-format.linear.with(suffix: $pi$)
      ),
      xlabel: $x$,
      ylabel: $y$,
      lq.plot(xs, ys1, color: blue, label: $sin (x)$),
      lq.plot(xs, ys2, mark: "star", label: $cos(x)$, color: orange),
   ),
   caption: "Ein Diagramm, erzeugt mit Hilfe des Lilaq Pakets"
)

#pagebreak()
== Programmierte Grafiken <programmierung>

=== Ein Fraktal
Die folgende *Koch'sche Schneeflocken-Kurve* ist keine Bitmap und auch keine Vektorgrafik, sondern wurde im Dokument dynamisch durch Typst Code erzeugt.

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

#figure(
   lq.diagram(
   width: 4cm, height: 5cm,
   xaxis: (ticks: none),
   yaxis: (ticks: none),

   lq.path(
      ..koch-snowflake(4),
      fill: blue, closed: true
   )
   ),
   caption: [Koch'sche Schneeflocke (ein Fraktal)]
)

=== Die Collatz Zahlenfolge

// --- Konfiguration ---
#let arrow-color = rgb(0, 110, 220)
//#let circle-fill = rgb(235, 248, 255)
#let circle-fill = rgb(235, 248, 255)
#let text-color = black

// --- Hilfsfunktion: Pfeilspitze (Skalierbar) ---
#let arrow-head(pos, angle, scale, col: arrow-color) = {
  // Wir skalieren auch die Pfeilspitze, damit sie nicht klobig wirkt
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
// Neuer Parameter: scale (Standard 1.0 = 100%)
#let collatz_visualizer(start_val, max_rows, scale: 1.0) = {
  let sequence = collatz_all(start_val)
  
  // Alle Maße werden mit dem Faktor multipliziert
  let r-circle = 17pt * scale        
  let cell-w = 1.5cm * scale         
  let cell-h = 2.0cm * scale         
  let col-gap = 1.0cm * scale
  let top-offset = 2.5cm * scale     
  let text-size = 11pt * scale
  
  // Auch die Strichstärke sollte skalieren
  let stroke-w = 1.5pt * scale
  let circle-stroke = stroke-w + black
  
  // Bezier-Konstante (Kappa)
  let kappa = 0.55228 

  let total-cols = int(calc.ceil(sequence.len() / max_rows))
  let total-width = total-cols * (cell-w + col-gap)
  let total-height = max_rows * cell-h + top-offset + 1.5cm * scale
  
  align(center)[
    #block(width: total-width, height: total-height, {
      
      for (i, num) in sequence.enumerate() {
        let c = int(i / max_rows)
        let r = calc.rem(i, max_rows)
        
        // Mittelpunkt des aktuellen Kreises
        let cx = c * (cell-w + col-gap) + cell-w/2
        let cy = r * cell-h + top-offset
        
        // 1. Der Kreis
        place(top + left, dx: cx - cell-w/2, dy: cy - cell-h/2, 
          box(width: cell-w, height: cell-h, align(center + horizon)[
            #circle(radius: r-circle, stroke: circle-stroke, fill: circle-fill)[
              #set align(center + horizon)
              #text(size: text-size, weight: "bold", fill: text-color)[#num]
            ]
          ])
        )
        
        // 2. Die Verbindungen
        if i < sequence.len() - 1 {
          
          if r < max_rows - 1 {
              // === FALL A: Vertikaler Pfeil ===
              let start-y = cy + r-circle + (4pt * scale)
              let end-y   = cy + cell-h - r-circle - (4pt * scale)
              
              place(curve(
                stroke: stroke-w + arrow-color,
                curve.move((cx, start-y)),
                curve.line((cx, end-y))
              ))
              arrow-head((cx, end-y), 0deg, scale, col: arrow-color)
          } 
          else {
              // === FALL B: "Snake"-Pfeil ===
              let next-cx = cx + cell-w + col-gap
              let mx      = (cx + next-cx) / 2  
              
              let width = mx - cx      
              let radius = width / 2   
              let k = radius * kappa   

              // Y-Koordinaten
              let start-y = cy + r-circle + (4pt * scale)
              let dest-y  = top-offset - r-circle - (4pt * scale)
              
              let turn-bottom-y = start-y + (20pt * scale)
              let turn-top-y    = dest-y - (20pt * scale)
              
              let arc-bottom = turn-bottom-y + radius
              let arc-top    = turn-top-y - radius

              place(curve(
                stroke: stroke-w + arrow-color,
                
                curve.move((cx, start-y)),
                curve.line((cx, turn-bottom-y)),
                
                // Unterer Bogen
                curve.cubic(
                  (cx, turn-bottom-y + k),          
                  (cx + radius - k, arc-bottom),    
                  (cx + radius, arc-bottom)         
                ),
                curve.cubic(
                  (cx + radius + k, arc-bottom),    
                  (mx, turn-bottom-y + k),          
                  (mx, turn-bottom-y)               
                ),
                
                curve.line((mx, turn-top-y)),
                
                // Oberer Bogen
                curve.cubic(
                  (mx, turn-top-y - k),             
                  (mx + radius - k, arc-top),       
                  (mx + radius, arc-top)            
                ),
                curve.cubic(
                  (mx + radius + k, arc-top),       
                  (next-cx, turn-top-y - k),        
                  (next-cx, turn-top-y)             
                ),
                
                curve.line((next-cx, dest-y))
              ))
              
              arrow-head((next-cx, dest-y), 0deg, scale, col: arrow-color)
          }
        }
      }
    })
  ]
}

#let startzahl = 27
#let diagrammZeilen = 10
#let periodenlaenge = collatz_all(startzahl).len()
#figure(
   collatz_visualizer(startzahl, diagrammZeilen, scale: 0.5),
   caption: [$3n+1$ Folgenglieder für die Startzahl #startzahl mit Periodenlänge #periodenlaenge]
) <collatzdiagramm>



== Diagramme mit Zusatzpaketen
Hier folgt ein sogenanntes _Sankey Diagramm_, was mit dem #link("https://github.com/solstice23/typst-ribbony")[Paket _Ribbony_] erzeugt wurde:

//#import "@preview/ribbony:0.1.0": *

#sankey-diagram((
   "Clients": ("Company": 70),
   "Investors": ("Company": 20),
   "Partners": ("Company": 10),
   "Company": ("HR": 20, "IT": 30, "Sales": 50),
   "IT": ("Infra": 20, "Support": 10),
   "Sales": ("Marketing": 30, "Operations": 20)
))

Der Input dafür im Typst Dokument ist recht übersichtlich und verständlich:

```typ
#import "@preview/ribbony:0.1.0": *

#sankey-diagram((
   "Clients": ("Company": 70),
   "Investors": ("Company": 20),
   "Partners": ("Company": 10),
   "Company": ("HR": 20, "IT": 30, "Sales": 50),
   "IT": ("Infra": 20, "Support": 10),
   "Sales": ("Marketing": 30, "Operations": 20)
))
```