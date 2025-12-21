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
   date: datetime(year: 2025, month: 12, day: 18),
   version: "0.2.251218",
   abstract: [Typst ist ein Satzsystem, mit dem man vor allem PDF Dokumente sehr ordentlich setzen kann. Man kann Typst im einfachsten Fall ähnlich wie Markdown benutzen. Es bietet aber weit mehr Möglichkeiten und man kann extrem komplexe Dokumente damit schreiben. Von der Hausarbeit über die Masterarbeit bis zum Buch. Dabei kann es analog zu LaTeX den wissenschaftlichen Satz inklusive mathematischer Formeln perfekt abbilden und ist darüber hinaus über 3rd party Pakete erweiterbar. Typst ist sogar eine Programmiersprache und so kann man zum Beispiel Grafiken algorithmisch direkt innerhalb des Dokuments erstellen.
   
   Typst ist Open Source und kann daher frei und kostenlos benutzt werden. Es gibt einen Browser-basierten Editor mit Live-Preview#footnote[Abrufbar unter #link("https://typst.app/app")], aber man kann Typst auch lokal auf dem eigenen Rechner installieren und als Editor mit Live-Preview zum Beispiel VSCode mit der Erweiterung "Tinymist Typst" benutzen.
   ]
)


= Schrift & Formeln <formeln>

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

Wir werden in @programmierung noch dynamisch erzeugte (also in Typst programmierte) Diagramme dazu sehen.

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
== Statische Tabellen
_Kapitel muss noch massiv ausgebaut werden!_
#table(
   columns: (auto, auto, auto),
   [*Name*], [*Age*], [*Role*],
   [Alice], [28], [Developer],
   [Bob], [34], [Designer],
   [Charlie], [45], [Manager]
)

== Dynamisch erzeugte Tabellen

// Wir definieren eine Funktion, die Fibonacci-Zahlen errechnen kann:
#let fib(n) = (
  if n <= 2 { 1 }
  else { fib(n - 1) + fib(n - 2) }
)

#let count = 15

Ein gutes Beispiel für sowohl Tabellen, als auch dass man in Typst selbst dynamisch Inhalte erzeugen kann, ist diese Tabelle mit den ersten #count Fibonaccizahlen.

#let nums = range(1, count + 1)

#figure(
   table(
      columns: count,
      fill: (_, row) => if row == 0 { luma(230) } else { none },
      ..nums.map(n => $F_#n$),
      ..nums.map(n => text(maroon)[#str(fib(n))]),
   ),
   caption: [Die ersten #count Fibonnacizahlen]
)

Erzeugt wurde diese Tabelle dynamisch im Typst Quelldokument mittels dieses Codes:

#code-box[
```typ
#let count = 15
#let nums = range(1, count + 1)
#align(center,
   table(
      columns: count,
      fill: (_, row) => if row == 0 { luma(230) } else { none },
      ..nums.map(n => $F_#n$),
      ..nums.map(n => text(purple)[#str(fib(n))]),
   )
)
```
Die Funktion `fib()` wurde natürlich auch im Typst Dokument implementiert, ist hier aber nicht abgedruckt. Ein Blick in den Quellcode im Repository bringt Erhellung, falls gewünscht.
]

= Diagramme

== Lilaq <lilaq>
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
Die folgende *Koch'sche Schneeflocken-Kurve* wurde hier nicht als Bitmap und auch nicht als Vektorgrafik eingebaut, sondern wurde dynamisch durch Typst Code erzeugt.

#figure(
   lq.diagram(
      width: 7cm, height: 8cm,
      xaxis: (ticks: none, stroke: none),
      yaxis: (ticks: none, stroke: none),

      lq.path(
         ..koch-snowflake(4),
         fill: orange, closed: true
      )
   ),
   caption: [Koch'sche Schneeflocke (ein Fraktal)]
)

Um diese Grafik hier im Dokument selbst erzeugen zu können (und eben _nicht_ als Grafikdatei mit fixer Auflösung einzubetten), ist die Erzeugung als Funktion realisiert. Hier – für den interessierten Leser – der Typst Quellcode dazu:

#code-box[
```typ
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
```
]

Das tatsächliche Erzeugen der Grafik im Dokument erfolgt dann über diese Typst Syntax im Dokument:

#code-box[
```typ
#figure(
   lq.diagram(
      width: 4cm, height: 5cm,
      xaxis: (ticks: none, stroke: none),
      yaxis: (ticks: none, stroke: none),
      lq.path(
         ..koch-snowflake(4),
         fill: blue, closed: true
      )
   ),
   caption: [Koch'sche Schneeflocke (ein Fraktal)]
)
```
]
Dabei wurde wieder – wie schon bei den einfachen Diagramm-Beispielen in @lilaq das Paket _Lilaq_ benutzt.

=== Die Collatz Zahlenfolge

Die mathematische Definition der Collatz-Zahlenfolge haben wir schon in @formeln in @collatz gesehen. Sie sei hier noch einmal wiederholt:

$
a_(n+1) := cases(
   a_n / 2 ","  & "wenn" a_n "gerade",
   3 a_n +1 "," & "wenn" a_n "ungerade"
)
$

==== Collatz Diagramme

Zu der Zahlenfolge wurde schon viel geforscht und veröffentlicht. Es gibt unzählige Visualisierungsmöglichkeiten, wir zeigen hier nur die naheliegendste, nämlich die Abfolge der Zahlen nach einer gegebenen Startzahl.

Kommen wir bei der Zahl 1 an, hören wir auf, denn würden wir die Bildungsgesetze weiter anwenden, landen wir in der Endlosschleife $1 #sym.arrow 4 #sym.arrow 2 #sym.arrow 1$.

#let startzahl = 5
#let periodenlaenge = collatz_all(startzahl).len()

Beginnen wir mit der Startzahl #startzahl, ergibt sich diese, aus #periodenlaenge Zahlen bestehende Folge:

#figure(
   collatz_visualizer_horizontal(startzahl, scale: 1),
   caption: [$3n+1$ Folgenglieder für die Startzahl #startzahl mit Periodenlänge #periodenlaenge]
) <collatzdiagramm1>

#let startzahl = 14
#let diagrammZeilen = 5
#let periodenlaenge = collatz_all(startzahl).len()

Für die nur geringfügig höhere Startzahl #startzahl ergibt sich schon eine Folge mit #periodenlaenge Zahlen:

#figure(
   collatz_visualizer(startzahl, diagrammZeilen, scale: 1.1),
   caption: [$3n+1$ Folgenglieder für die Startzahl #startzahl mit Periodenlänge #periodenlaenge]
) <collatzdiagramm2>

#let startzahl = 27
#let diagrammZeilen = 10
#let periodenlaenge = collatz_all(startzahl).len()
Aber so richtig krass wird's, wenn wir die kaum größere Startzahl #startzahl wählen. Denn auf einmal eskaliert alles, die Folge hat nun satte #periodenlaenge Glieder und unser Diagramm müssen wir extra verkleinern, sonst passt es hier nicht hin.

#figure(
   collatz_visualizer(startzahl, diagrammZeilen, scale: 0.57),
   caption: [$3n+1$ Folgenglieder für die Startzahl #startzahl mit Periodenlänge #periodenlaenge]
) <collatzdiagramm3>

==== Collatz in Typst

Und wie erzeugt man nun solche Diagramme in/mit Typst? Nun, das Kapitel heißt ja "#nameref(<programmierung>)" und natürlich gibt es in Typst keine fertige Funktion, die so einen Spezialfall wie diese Collatz-Diagramme zeichnet. Diese Funktionen habe ich – übrigens mit Hilfe von K.I. – programmiert.

Will man das Diagramm der @collatzdiagramm1 erzeugen, muss man im Typst Quelldokument schreiben:

```typ
#let startzahl = 5
#let periodenlaenge = collatz_all(startzahl).len()
#figure(
   collatz_visualizer_horizontal(startzahl, scale: 0.9),
   caption: [$3n+1$ Folgenglieder für die Startzahl #startzahl mit Periodenlänge #periodenlaenge]
)
```

Es gibt also eine Funktion `collatz_visualizer_horizontal()` und eine Funktion `collatz_all()`. Letztere erzeugt zur übergebenen Startzahl alle Glieder der Zahlenfolge als Array. Somit weiß man mit dem Anhängsel `.len()`, wieviele Folgeglieder es gibt.

Die Visualisierungsfunktion `collatz_visualizer_horizontal()` erzeugt dann tatsächlich die Grafik und benutzt intern auch nochmal die Funktion `collatz_all()`. Sie hat als zweiten Parameter einen Skalierungsfaktor, so kann man auch nochmal nachjustieren, damit die eine horizontale Zahlenkette gut von der Breite her passt.

Unsere horizontale Visualizer Funktion kann auch nur das: _eine_ Reihe horizontal.

Sollten es mehr Folgeglieder werden – wie in den Beispielen der @collatzdiagramm2 und @collatzdiagramm3 – brauchen wir eine andere Strategie. Und da fiel mir diese vertikale Kette ein, die aber eine begrenzte Anzahl von Zeilen haben soll und dann soll ein Pfeil von unten wieder hoch führen auf die Höhe der ersten Zeile und es soll vertikal wieder weiter nach unten gehen und so weiter.

Das erledigt die Funktion `collatz_visualizer()` und das Beispiel aus @collatzdiagramm3 sieht im Typst Quelldokument so aus:

```typ
#let startzahl = 27
#let diagrammZeilen = 10
#let periodenlaenge = collatz_all(startzahl).len()
#figure(
   collatz_visualizer(startzahl, diagrammZeilen, scale: 0.5),
   caption: [$3n+1$ Folgenglieder für die Startzahl #startzahl mit Periodenlänge #periodenlaenge]
)
```

Da hier sehr viele Folgeglieder zusammenkommen, musste ich den Skalierungsfaktor auf $0.5$ setzen.

Alle drei Funktionen sind ebenfalls im Typst Quelldokument implementiert, aber zu umfangreich, um sie hier aufzulisten. 

Aber dieses Typst Quelldokument ist ja Open Source und #link("https://github.com/metawops/typst")[liegt auf Github], so dass man jederzeit reinschauen kann, wenn man sich für die Implementierungsdetails interessiert. Die Funktionen habe ich übrigens in die Hilfs-/Library-Typst-Datei `_lib.typ` ausgelagert, damit sie das eigentliche Quelldokument nicht zu unübersichtlich werden lassen.

== Diagramme mit Zusatzpaketen
Es gibt nahezu 500 #link("https://typst.app/universe/search/?kind=packages")[Zusatzpakete für Typst], darunter zahlreiche, die beim Erzeugen von Diagrammen helfen.

Ich habe mal beispielhaft das Paket #link("https://github.com/solstice23/typst-ribbony")[_Ribbony_] herausgepickt. Damit kann man u.a. ein sogenanntes _Sankey Diagramm_ erzeugen:

//#import "@preview/ribbony:0.1.0": *

#figure(
   sankey-diagram((
      "Clients": ("Company": 70),
      "Investors": ("Company": 20),
      "Partners": ("Company": 10),
      "Company": ("HR": 20, "IT": 30, "Sales": 50),
      "IT": ("Infra": 20, "Support": 10),
      "Sales": ("Marketing": 30, "Operations": 20)
   )),
   caption: [Ein beispielhaftes Sankey Diagramm, erzeugt mit Hilfe des Pakets "Ribbony"]
)

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