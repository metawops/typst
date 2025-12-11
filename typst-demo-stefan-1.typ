// ------------------------------
// Demo-File für Typst
// Geschrieben von Stefan Wolfrum
// November/Dezember 2025
// ------------------------------

#let version = "0.1.251211"

// set rules
#set text(lang: "de")

// Metadaten fürs PDF
#set document(
   title: [Erste Schritte in Typst],
   author: "Stefan Wolfrum",
   description: [Ein kleines Demo-Dokument, was die Nutzung von Typst demonstrieren soll.],
   keywords: ("Typst", "Demonstration", "Sample", "Beispiel"),
   date: datetime(year: 2025, month: 12, day: 6)
)
#set text(
// macOS Fonts:
// ------------
//  font: "SF Pro Text",
//  font: "Bodoni 72",
//  font: "Crimson Pro",
//  font: "Charter",
//  font: "Didot",
//  font: "Helvetica Neue",
//   font: "Monaspace Radon",

// Windows Fonts:
// --------------
//   font: "Book Antiqua",

// Generic Font that exists on Mac, Windows, Ubuntu (Github!)
   font: "Inter",
   size: 13pt
)
#set page(
   paper: "a4",
   margin: (x: 1.5cm, y: 1.5cm),
   numbering: "1/1",
   footer: context[
      #set text(8pt)
      Erste Schritte in Typst, Stefan Wolfrum, Dezember 2025, Version #version #h(1fr) #counter(page).display()
   ]
)
#set par(
  justify: true,
  leading: 0.52em,
)
#set heading(numbering: "1.", supplement: [Kapitel])
#set math.equation(numbering: "(1)")
#set quote(block: true)

// show rules
#show link: underline
#show figure.caption: set text(size: 9pt)
#show heading: it => [
   #v(0.2em)
   #it
   #v(0.8em)  // Abstand nach jeder Überschrift
]
#show title: set align(center)
// Globale Regel für alle Zitate im Dokument
#show quote.where(block: true): it => block(
  fill: gray.lighten(80%), // Leichter grauer Hintergrund
  stroke: (left: 2pt + gray), // Der klassische Balken links
  inset: (x: 1em, y: 0.5em),  // Innenabstand
  outset: (y: 0.5em),         // Außenabstand
  radius: 2pt,                // Leicht abgerundet
  it // Der eigentliche Inhalt des Zitats
)

// END OF SETTINGS
// ---------------

#title[Erste Schritte in Typst]
#align(center)[
   Stefan Wolfrum \
   Bonn, Germany
]

= Schrift & Formeln

Hier kann man Text schreiben.

Auch *viel* Text. Gerne auch _relevanten_ Text.

Das Typesetting sieht wirklich wie bei LaTe#sym.chi aus!

Natürlich gehen auch mathematische Formeln: $E=m c^2$. $(a+b)^2 = a^2 + 2a b + b^2$.

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
//         text(fill: luma(10))[_#lorem(loremwords)_]
      )
   ],
   grid.vline(
      x: 1,
      stroke: 0.5pt + gray.darken(25%)
   )
)

#v(2em)

= Das Zeichen \# in Typst
Wir müssen kurz über das Zeichen \# sprechen. Solange man im "Textschreibmodus" ist (_markup mode_), muss man Funktionsaufrufe, wie z.B. `#image()` (siehe @bilder) mit dem \# Zeichen beginnen. Das sagt Typst "Achtung, jetzt kommt ein Funktionsaufruf".

Wenn man aber bereits ein einer Funktion ist (_code mode_) und darin nochmal Funktionsaufrufe nutzt – das sehen wir bei `#figure()` in @abbildungen –, dann darf man das Zeichen \# _nicht_ vor den Funktionsnamen setzen!

Das gilt übrigens nicht nur für _Funktionen_, sondern auch für Keywords wie `set`, `show`, `let`, ...



#quote(attribution: "Alan Turing")[
  We can only see a short distance ahead, but we can see plenty there that needs to be done.
]

#pagebreak()
= Bilder mit `image()` <bilder>

Bilder können im einfachsten Fall über die Funktion `#image()` eingebettet werden. Dabei werden viele Formate unterstützt. Neben den Bitmap-Formaten *PNG*, *JPG*, *GIF*, *WebP* auch das Vektorformat *SVG* und sogar *PDF*. Hier ein auf 50% verkleinertes, eingebettetes JPG Foto des Raspberry Pi _Compute Module 5 (CM5)_:

#image("cm5.jpeg", width: 85%)

Die Funktion `image()` eignet sich für das schnelle Einbetten eines Bildes, hat aber zunächst ein paar Nachteile, allen voran: linksbündig, keine Bildunterschrift.

Da hilft uns die `figure()` Funktion aus @abbildungen.

#pagebreak(weak: true)
//--------------------

= Abbildungen mit `#figure()` <abbildungen>
Mächtiger als `#image()` ist die Funktion `#figure()`. Mit ihr kann man u.a. das Alignment steuern und auch Bildunterschriften realisieren, wie hier in @abb_hybrid:

#figure(
   image("output_plot-02.png", width: 100%),
   caption: [Gedämpfte Schwingung, errechnet auf dem Analogcomputer THAT]
) <abb_hybrid>

#pagebreak(weak: true)
//--------------------

= Info-Box

#let infoboxtitlesize = 14pt
#let infoboxtextsize = 12pt

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
    size: infoboxtitlesize,
  )[#title]

  #v(8pt)

  // Fließtext
  #text(
    size: infoboxtextsize,
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
    size: infoboxtitlesize,
  )[#title]

  #v(8pt)

  // Fließtext
  #text(
    size: infoboxtextsize,
  )[ #body ]
]

#info-box[
   Man kann auch hübsche Info-Boxen wie diese hier gestalten. Dabei gibt es prinzipiell zwei Möglichkeiten:

   + Man kann jede Info-Box neu mit Code schreiben.
   + Man definiert sich einmal eine neue Funktion inklusive Parametern und nutzt diese immer wieder, wenn man eine Info-Box einfügen will.

   So wie im zweiten Punkt wurde es hier gemacht. Dadurch reduziert sich das Erzeugen dieser Info-Box auf einen Aufruf der selbst definierten Funktion `#info-box` (siehe Quellcode dieses Dokuments).

   Offen ist für mich noch, wo die Definition meiner Funktion `#info-box` stehen kann im Dokument. Denn mitten im Text stört es vielleicht etwas. Ob sie auch z.B. am Ende oder am Anfang des Dokuments stehen kann, muss ich noch ausprobieren.
]

#code-box[
Hier ist der Quellcode der Definition der eigenen `#info-box` Funktion:

```
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

#table(
   columns: (auto, auto, auto),
   [*Name*], [*Age*], [*Role*],
   [Alice], [28], [Developer],
   [Bob], [34], [Designer],
   [Charlie], [45], [Manager]
)

= Diagramme

Für Typst gibt es viele importierbare Pakete, die die Möglichkeiten von Typst erweitern. Ein Paket, mit dem man gut Diagramme zeichnen kann, heißt _Lilaq_. Die folgenden Diagramme sind mit Hilfe von _Lilaq_ entstanden.

#import "@preview/lilaq:0.5.0" as lq

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
== Programmierte Grafiken
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

== Diagramme mit Zusatzpaketen
Hier folgt ein sogenanntes _Sankey Diagramm_, was mit dem #link("https://github.com/solstice23/typst-ribbony")[Paket _Ribbony_] erzeugt wurde:

#import "@preview/ribbony:0.1.0": *

#sankey-diagram((
   "Clients": ("Company": 70),
   "Investors": ("Company": 20),
   "Partners": ("Company": 10),
   "Company": ("HR": 20, "IT": 30, "Sales": 50),
   "IT": ("Infra": 20, "Support": 10),
   "Sales": ("Marketing": 30, "Operations": 20)
))

Der Input dafür im Typst Dokument ist recht übersichtlich und verständlich:

#code-box(
```
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
)
