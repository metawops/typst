// ------------------------------
// Demo-File für Typst
// Geschrieben von Stefan Wolfrum
// November/Dezember 2025
// ------------------------------

#import "_lib.typ": *

// Jetzt nutzen wir unsere "project" Funktion,
// die wir in _lib.typ definiert haben und die
// alle Setups für unser Dokument enthält:

#let raw-changelog = read("CHANGELOG.md")
#let version-pattern = regex("(?m)^##\s+\[?v?([\d\.]+)\]?")
#let match = raw-changelog.match(version-pattern)
#let doc-version = if match != none {
  match.captures.first()
} else {
  "0.0.0-draft"
}

#show: project.with(
   theTitle: "Erste Schritte in Typst",
   authors: ("Stefan Wolfrum"),
   description: [Ein kleines Beispiel-Dokument, was die Nutzung von Typst demonstrieren soll.],
   location: "Bonn, Germany",
   keywords: ("Typst", "Demonstration", "Sample", "Beispiel"),
   date: datetime(year: 2026, month: 1, day: 1),
   version: doc-version,
   bib-path: "literatur.bib",
   abstract: [Typst ist ein Satzsystem, mit dem man vor allem PDF Dokumente sehr ordentlich setzen kann. Man kann Typst im einfachsten Fall ähnlich wie Markdown benutzen. Es bietet aber weit mehr Möglichkeiten und man kann extrem komplexe Dokumente damit schreiben. Von der Hausarbeit über die Masterarbeit bis zum Buch. Dabei kann es analog zu LaTeX den wissenschaftlichen Satz inklusive mathematischer Formeln perfekt abbilden und ist darüber hinaus über 3rd party Pakete erweiterbar. Typst ist sogar eine Programmiersprache und so kann man zum Beispiel Grafiken algorithmisch direkt innerhalb des Dokuments erstellen.
   
   Typst ist Open Source und kann daher frei und kostenlos benutzt werden. Es gibt einen Browser-basierten Editor mit Live-Preview#footnote[Abrufbar unter #link("https://typst.app/app")], aber man kann Typst auch lokal auf dem eigenen Rechner installieren und als Editor mit Live-Preview zum Beispiel VSCode mit der Erweiterung "Tinymist Typst" benutzen.
   ]
)

= Schrift & Formeln <formeln>
Typst ist als Satzsystem natürlich vor allem dazu da, Text zu setzen. Beim Schreiben von Text gelten in Typst ähnliche Regeln wie bei der Nutzung von Markdown. Das bedeutet zum Beispiel:

- Kursiven Text umschließt man mit Unterstrichzeichen: `_kursiv_` #sym.arrow.r.bar _kursiv_
- Fetten Text umschließt man mit Sternchen: `*fett*` #sym.arrow.r.bar *fett*
- Beides: `*_fett-kursiv_*` oder `_*fett-kursiv*_` #sym.arrow.r.bar _*fett-kursiv*_

*Überschriften* sind eine Ausnahme zu Markdown: Sie werden in Typst mit dem `=` Zeichen eingeleitet. Je mehr `=` Zeichen, desto höher der Überschrift-Level. (Bei Markdown ist es das `#` Zeichen.)

Ich empfehle das kleine, offizielle #link("https://typst.app/docs/tutorial/writing-in-typst/")[Tutorial auf den Typst-Doku-Seiten] für weitere Stylings, wie z.B. Aufzählungen, Zitate, Code, Fußnoten etc.

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


#let loremwords = 34

#grid(
   columns: 2,
   column-gutter: 2em,
   [Es gibt sogar eine Funktion namens `#lorem()`, mit der man sofort _Lorem ipsum_ Text erzeugen kann. Rechts stehen #loremwords Worte _Lorem ipsum_ Text, erzeugt mit der `#lorem()` Funktion.

   Das zweispaltige Layout mitten im Text erreicht man mit der `#grid()` Funktion.
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

Das sieht im Typst Dokument dann so aus:

```typ
#let loremwords = 34
#grid(
   columns: 2,
   column-gutter: 2em,
   [Es gibt sogar eine Funktion namens `#lorem()`, mit der man sofort _Lorem ipsum_ Text erzeugen kann. Rechts stehen #loremwords Worte _Lorem ipsum_ Text, erzeugt mit der `#lorem()` Funktion.

   Das zweispaltige Layout mitten im Text erreicht man mit der `#grid()` Funktion.
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
```

= Dokument einrichten
Bevor wir jetzt schnell direkt im Dokument einige Einstellungen machen, sei auf ein wichtiges Paradigma hingewiesen, was sich für die meisten Typst Dokumente lohnt, umzusetzen: Das Auslagern von Settings.
== Kenngrößen auslagern
Bei sehr kurzen Dokumenten spielt das sicher keine Rolle, aber je größer die Typst Dokumente werden, desto mehr "Setup Daten" wird man haben: Farben, Abstände, Maße, Schriftgrößen etc. Diese kann man zwar alle auch direkt im Dokument hinterlegen – entweder direkt mit den Funktionsaufrufen oder als Variablen zusammengefasst an einer Stelle und diese dann in den Funktionsaufrufen. Aber die Erfahrung zeigt, dass das Herausziehen und an einer Stelle Zusammenfassen derlei Daten sinnvoll ist.

Auch ist zu empfehlen, dass alle selbst geschriebenen Funktionen aus der Haupt-Text-Datei herausgenommen und in eine andere `.typ` Datei ausgelagert werden.

Ziel ist es, am Ende in seiner Haupt-Text-Datei nur oben einmal einen Import einer weiteren `.typ` Datei zu haben. Zum Beispiel beginnt _dieses_ Dokument, was Du gerade liest, so:
```typ
// Unsere "Library" Datei mit allen Settings importieren
#import "_lib.typ": *
```
Und in dieser Datei `_lib.typ` stecken allerlei Funktionen, set-Regeln, show-Regeln und – ganz wichtig – die eine `project()` Funktion, die das ganze Setup des Dokuments regelt. Diese Typst-Datei hier geht nämlich nach dem `#import` Kommando so weiter (gekürzt):
```typ
#show: project.with(
   theTitle: "Erste Schritte in Typst",
   authors: ("Stefan Wolfrum"),
   description: [Ein kleines Beispiel-Dokument, was die Nutzung von Typst demonstrieren soll.],
   location: "Bonn, Germany",
   keywords: ("Typst", "Demonstration", "Sample", "Beispiel"),
   date: datetime(year: 2025, month: 12, day: 22),
   version: "0.2.251222",
   bib-path: "literatur.bib",
   abstract: [Typst ist ein Satzsystem, mit dem man ... zum Beispiel VSCode mit der Erweiterung "Tinymist Typst" benutzen.
   ]
)
```
Die in der `_lib.typ` definierte Funktion `project()` bekommt also allerlei Parameter als Input, führt alle Setups durch (Seitenformat einstellen, Schriftart einstellen, Abstände einstellen, Fußzeile definieren, Metadaten setzen, Literaturverzeichnis anhängen etc.), bekommt dann als letztes Argument noch all das, was hier im Haupt-Dokument nach ihrem Aufruf folgt (also quasi den gesamten Inhalt) und erzeugt als Output dann das gesamte, finale Dokument mit all seinen Einstellungen.

== Titel <dokument-titel>
Der Titel eines Dokuments ist _eine_ Eigenschaft des Dokuments. Die anderen sind _author, description, keywords_ und _date_. Man setzt diese Attribute über eine _set rule_, für den Titel geht das so:
```typ
// Die Titel-Eigenschaft des Dokuments festlegen:
#set document(title: [Mein Typst Dokument])
```

Damit erscheint aber der Titel noch nicht im PDF Dokument. Um den Titel auch _auszugeben_, schreiben wir im Dokument dann:
```typ
// Jetzt den Titel ausgeben:
#title()
```
Das gibt den zuvor gesetzten Titel aus.

Man kann aber unterscheiden zwischen den #nameref(<metadata>) eines Dokuments – die man nämlich über die `#set document` Regel setzt und die lediglich ins PDF eingebettet werden – und dem im PDF sichtbaren Titel.
Will man einen anderen Titel im Dokument haben, als in den #nameref(<metadata>), dann gibt man einfach einen anderen Titel aus:
```typ
// Die Titel-Eigenschaft des Dokuments festlegen:
#set document(title: [Mein Typst Dokument])

#title[Wir lernen Typst]
```

#info-box[
   *Ein Wort zu eckigen Klammern.*

   In Typst ist alles, was in eckigen Klammern steht, Content. Also Text. Inklusive Auszeichnungen wie fett oder kursiv. Immer dann, wenn eine Funktion (wie z.B. `title()`) Content als Parameter hat, kann man auch die runden Klammern des Funktionsaufrufs weglassen und den Content Block direkt hinter den Funktionsnamen schreiben.

   `#title[Mein Titel]` ist also eine Kurzschreibweise für `#title([Mein Titel])`.
]

Einen Hinweis zur Verwendung des \# Zeichens gibt es in @hash-character.

== Zusammenfassung
Die Zusammenfassung (oder auch der _Abstract_) taucht oft bei wissenschaftlichen Arbeiten unter dem Titel und den Autoren auf, so wie auch in diesem Dokument. 

Der Zusammenfassungstext ist bei mir ein Parameter der `project()` Funktion und wird als _content block_ in eckigen Klammern übergeben. In der `_lib.typ` wird er dann wie folgt ausgegeben (gerendert):

// Ligaturen für den folgenden Code Block ausschalten:
#text(features: (calt: 0))[
```typ
// Abstract rendern (wenn vorhanden)
if #abstract != none {
   #pad(x: config.distances.abstract-pad-x)[        // Seitliche Einrückung
      #align(center)[*Zusammenfassung*]
      #set text(style: "italic", size: config.document.abstract-font-size)
      #abstract
   ]
}
```
]
Ich habe manuell ein paar \# Zeichen eingefügt, damit das Syntax Highlighting besser funktioniert. In der `_lib.typ` steht es also nicht genau 1:1 so wie hier, denn dort ist es Teil eines _code blocks_ und das `#abstract` direkt zu Beginn nach dem `if` meint den an die `project()` Funktion übergebenen Parameter mit diesem Namen.

== PDF Metadaten <metadata>
Über PDF Metadaten haben wir schon etwas im @dokument-titel ("#nameref(<dokument-titel>)") gelernt. Um also ins PDF Metadaten einzubetten, geht man so vor:
```typ
// Metadata for PDF
#set document(
   title: "Mein tolles Dokument",
   author: ("Stefan Wolfrum"),
   description: "In diesem Dokument geht es um Typst.",
   keywords: ("Typst", "Demonstration", "Sample", "Beispiel"),
   date: datetime(year: 2025, month: 12, day: 22)
)
```
Dazu ein paar Anmerkungen:

- _title_ und _description_ sind einfach Strings
- _author_ ist ein Array und kann mehrere Einträge enthalten, daher die Klammern
- _keywords_ genauso
- _date_ ist ein Datumsobjekt, was man in der gezeigten Weise erzeugt
Hier sieht man ein Beispiel für das (verpflichtende) _Weglassen_ des \# Zeichens: da die Funktion `datetime()` innerhalb der mit runden Klammern umschlossenen Parameterliste von `document()` erscheint, sind wir schon im _code mode_ und nicht im _content/markup mode_. Daher muss das \# entfallen.

== Sprache, Dokumentformat, Blocksatz und mehr
Die Sprache des Dokuments festzulegen, das ist eine gute Idee. Denn dann funktioniert z.B. auch eine Silbentrennung automatisch. Deutsch als Sprache festlegen geht über eine sogenannte _set rule_ (weil eben `#set` benutzt wird) so:
```typ
// Deutsch als Sprache des Dokuments
#set text(lang: "de")
```

Die Größe des zu erzeugenden PDF Dokuments – z.B. DIN A4 – legt man auch über eine _set rule_ fest. und wo wir gerade schon an der "page" fummeln, legen wir noch ein paar Dinge mehr fest: Die Ränder und die Seitennummerierung:

```typ
// Page Setup
#set page(
   paper: "a4",
   margin: (x: 1.5cm, y: 1.5cm),
   numbering: "1/1"
)
```

Blocksatz ("Justification") stellt man ebenfalls über eine _set rule_ ein. Und wo wir schonmal bei Paragraph Einstellungen sind, legen wir auch gleich noch den Zeilenabstand über `leading` fest (der Default ist übrigens `0.65em`):
```typ
// Paragraph Style: Blocksatz & 0.52em Zeilenabstand
#set par(
   justify: true,
   leading: 0.52em
)
```
Für Paragraphs, also Absätze, gibt es noch allerlei mehr Einstellungen. Auch da sei wieder die gute #link("https://typst.app/docs/reference/model/par/")[Original-Doku] empfohlen. Man kann z.B. das Blocksatzverhalten sehr differenziert feintunen.

== Noch mehr Abstraktion
Das Auslagern des Aussehens des Dokuments in die `_lib.typ` ist ja schonmal gut. Aber wenn dann auch diese _Library-_ (oder _Template-_) Datei langsam wächst, wird es immer schwieriger, hin und wieder mal die Abstände, Schriftgrößen und Farben anzupassen. Die stecken halt als konkrete Werte irgendwo verstreut in der Datei.

Das ist dann der Zeitpunkt, all diese Zahlen mit ihren Einheiten auch nochmal auszulagern: in eine Art _Theme-_ oder _Config-_Datei.

Das habe ich so gemacht. Neben meiner Haupt-Typst-Datei, die möglichst nur noch den eigentlich Dokument-Text enthalten soll (plus oben ein `#include` und dann einen Aufruf der `project()` Funktion) und der _Library-_Datei `_lib.typ`, habe ich noch eine weitere Typst-Datei namens `_config.typ` erstellt.

In dieser sammle ich dann in einem sogenannten Dictionary alle möglichen Konfigurationsdaten, wie z.B. Farbwerte, Abstände und mehr. _Wie_ man diese Daten strukturiert, welche Taxonomie man da aufsetzt, darüber kann man sich streiten. Ich habe einfach mal _einen_ Ansatz gewählt, mit dem ich ganz gut zurecht komme.

Das bedeutet dann im zweiten Schritt auch, dass diese `_config.typ` oben als erstes in der `_lib.typ` importiert wird und dass dann alle Werte, die dort bisher hard-coded als Zahlen standen jetzt durch ihren Bezeichner aus der `_config.typ` ersetzt werden müssen.

So wird zum Beispiel aus dem bisherigen Page Setup von oben ...
```typ
// Page Setup
#set page(
   paper: "a4",
   margin: (x: 1.5cm, y: 1.5cm),
   numbering: "1/1"
)
```

... jetzt dieses:
```typ
// Page Setup
#set page(
   paper: "a4",
   margin: (x: config.distances.page.margin-x,
            y: config.distances.page.margin-y),
   numbering: "1/1"
)
```
Denn in der `_config.typ` findet sich im _Theme Dictionary_ dies:
```typ
#set config = (
   distances: (
      page: (
         margin-x: 1.5cm,
         margin-y: 1.5cm
      )
)
```
Das mag zunächst umständlich aussehen, ist aber schnell praktisch, weil man dann weiß, dass man nie mehr in der `_lib.typ` die Stelle im Code finden muss, wo man seine Seitenränder eingestellt hat. Stattdessen weiß man, dass man alle das Dokument beschreibenden Einstellungen zentral in der `_config.typ` hinterlegt hat und auch nur ändern braucht.

Dass diese Zusatzdateien übrigens alle mit einem `_` Zeichen beginnen, das hat mit den automatischen Build- und Release-Workflows zu tun, die ich für #link("https://github.com/metawops/typst")[mein GitHub Repository] eingerichtet habe. Denn diese Dateien enthalten ja keinen zu setzenden Text, sondern nur Funktionen und Variablen. Da würde also ein leeres PDF Dokument entstehen, wenn man sie mit Typst kompilieren würde. Daher werden alle Dateien, die mit einem `_` beginnen beim Build-Prozess ignoriert.

#pagebreak(weak: true)
= Das Zeichen \# in Typst <hash-character>
Wir müssen kurz über das Zeichen \# sprechen. 

Solange man im "Textschreibmodus" ist (_markup mode_ oder auch _content mode_), muss man Funktionsaufrufe, wie z.B. `#image()` (siehe @bilder) mit dem \# Zeichen beginnen. Das sagt Typst "Achtung, jetzt kommt ein Funktionsaufruf".

Wenn man aber bereits in einer Funktion ist (_code mode_) und darin nochmal Funktionsaufrufe nutzt – das sehen wir bei `#figure()` in @abbildungen –, dann darf man das Zeichen \# _nicht_ vor den Funktionsnamen setzen!

Das gilt übrigens nicht nur für _Funktionen_, sondern auch für Keywords wie `set`, `show`, `let`, ...

#quote(attribution: "Oscar Wilde")[
  Ich habe den ganzen Vormittag damit verbracht, ein Komma aus einem meiner Gedichte zu streichen, und am Nachmittag habe ich es wieder hineingesetzt.
]

So ein Zitat fügt man übrigens über die Funktion `#quote()` ein. Dass es hier aber so aussieht, wie es aussieht, liegt daran, dass ich mir in meiner `_lib.typ` Datei eine sehr spezielle _show rule_ für derlei Zitatboxen gemacht habe:
```typ
// Globale Regel für alle Zitate im Dokument
#show quote.where(block: true): it => block(
   fill: config.colors.quote.fill,                 // Leichter grauer Hintergrund
   stroke: (left: 4pt+config.colors.quote.stroke), // Balken links
   inset: (x: 1.2em, y: 0.8em),                    // Innenabstand
   outset: (y: 0.5em),                             // Außenabstand
   radius: 2pt,                                    // Leicht abgerundet
   width: 100%,                                    // ganze Breite
   {  // Das stilisierte Anführungszeichen:
      place(top + left,
            dx: -1.0em,
            dy: -10.7em,
            text(size: 16em,
                 fill: config.colors.quote.stroke.lighten(60%),
                 font: "Playfair Display",         // Freier Google Font
                 weight: "bold")["]                // Das eine Anführungszeichen
      )
      text(style: "italic")[#it]  // Der eigentliche Inhalt des Zitats
   }
)
```

#pagebreak(weak: true)
= Bilder mit `image()` <bilder>
Natürlich kann man in sein Typst Dokument auch Bilder einbetten. Im einfachsten Fall sind es Bilder, die aus Dateien kommen. Aber es geht auch anders, wie @images-raw zeigt.

== Bilddateien
Bilder können im einfachsten Fall über die Funktion `#image()` eingebettet werden. Dabei werden viele Formate unterstützt. Neben den Bitmap-Formaten *PNG*, *JPG*, *GIF*, *WebP* auch das Vektorformat *SVG* und sogar *PDF*. Hier ein auf 50% verkleinertes, eingebettetes JPG Foto des Raspberry Pi _Compute Module 5 (CM5)_:

#image("img/cm5.jpeg", width: 85%)

Die Funktion `#image()` eignet sich für das schnelle Einbetten eines Bildes, hat aber zunächst ein paar Nachteile, allen voran: linksbündig, keine Bildunterschrift.

Da hilft uns die `#figure()` Funktion, die im folgenden @abbildungen beschrieben wird.

== Dynamisch erzeugte Bitmaps <images-raw>
Aber man kann auch Bilder über raw bytes erzeugen und einbinden. Dazu ein cooles, kleines Beispiel #link("https://typst.app/docs/reference/visualize/image/#parameters-format")[aus der Doku]:

// Ligaturen für den folgenden Code Block ausschalten:
#text(features: (calt: 0))[
```typ
#image(
   bytes(range(16).map(x => x * 16)),
   format: (
      encoding: "luma8",
      width: 4, height: 4,
   ),
   width: 2cm,
   scaling: "pixelated"
)
```]

Dieser Code erzeugt dieses Bild:

#align(center)[
   #image(
      bytes(range(16).map(x => x * 16)),
      format: (
         encoding: "luma8",
         width: 4,
         height: 4,
      ),
      width: 2cm,
      scaling: "pixelated"
   )
]

Was geht da genau vor?


/ Zeile 2: Die Funktion `range(16)` erzeugt ein Array mit den 16 Zahlen $(0, 1, 2, dots.h, 15)$.
/ Zeile 2: Auf jede Zahl $x$ in diesem Array wird die Funktion $x*16$ angewendet. Das ergibt also dieses Array mit 16 Zahlen: $(0, 16, 32, 48, dots.h, 224, 240)$.
/ Zeile 2: Die Funktion `bytes()` (streng genommen ist es nur der _Constructor_) verpackt diese 16 Zahlen in 16 Bytes am Stück. In einem normalen _Array_ Datentyp wären es nämlich _Integers_, die können wir für raw Daten eines Bildes aber nicht gebrauchen.
/ Zeilen 3–7: Jetzt sagen wir Typst, in welchem Format unser "Bild" vorliegt: Die 16 Bytes sollen in einem Quadrat von 4x4 (`width` x `height`) angeordnet sein und jedes Byte soll einem 8-bit-Helligkeitswert (`luma8`) entsprechen. Die Anordnung geschieht dabei so, dass die Bytes der Reihe nach von links oben nach rechts unten positioniert werden. Also in dieser Art:

#let data = range(16).map(x => x * 16)

#align(center)[
  #grid(
    columns: (20pt, 20pt, 20pt, 20pt), // 4 feste Spalten
    rows: 20pt,                       // Feste Zeilenhöhe
    gutter: 2pt,                      // Abstand zwischen den Zellen
    
    // Wir mappen die Zahlen direkt auf gestaltete Boxen
    ..data.map(val => {
      // Grauwert definieren (luma akzeptiert 0-255)
      let bg-color = luma(val)
      
      // Lesbarkeit: Weißer Text auf dunklem Grund, schwarzer auf hellem
      let text-color = if val < 128 { white } else { black }
      
      rect(
        width: 100%,
        height: 100%,
        fill: bg-color,
        stroke: 0.5pt + gray.darken(20%),
        radius: 2pt,
        align(center + horizon, 
          text(fill: text-color, size: 9pt, weight: "bold", [#val])
        )
      )
    })
  )
]

/ Zeile 8: Das Bild soll 2~cm breit werden. Und da es quadratisch ist, wird es auch 2~cm hoch werden.
/ Zeile 9: Dank des Werts `pixelated` dieses Parameters `scaling` sehen wir tatsächlich 16 Kästchen unterschiedlicher Graustufen. Würden wir den Parameter `scaling` weglassen oder auf seinen anderen, möglichen Wert `smooth` setzen, würden die Graustufenwerte interpoliert werden, was dann so aussieht:
#align(center)[
   #image(
      bytes(range(16).map(x => x * 16)),
      format: (
         encoding: "luma8",
         width: 4,
         height: 4,
      ),
      width: 2cm
   )
]

#line(length: 100%, stroke: 0.5pt + gray)

Ein Experiment mit Farbe gefällig? Gern. Wir fangen mit leichter Kost an: 
#align(center)[
   #image(
      bytes((255,0,0, 0,255,0, 0,0,255)),
      format: (encoding: "rgb8", width: 3, height: 1),
      width: 3cm,
      scaling: "pixelated"
   )
]

Dazu der Code:
```typ
#image(
   bytes((255,0,0, 0,255,0, 0,0,255)),
   format: (encoding: "rgb8", width: 3, height: 1),
   width: 3cm,
   scaling: "pixelated"
)
```
/ Zeile 2: Wir erzeugen zunächst mit den neun Zahlen in den _inneren_ Klammern die Werte für drei "Pixel": Erst ein rotes über die ersten drei Zahlen $255, 0, 0$, denn die Zahlen geben der Reihenfolge nach jeweils den rot-, grün- und blau-Anteil des Pixels an. Dabei kann jeder dieser Werte zwischen $0$ und $255$ (8 bit eben) liegen.

   So stehen also die ersten drei Zahlen für das erste, rote "Pixel", da sie voll ($255$) rot, aber gar kein ($0$) blau und grün enthalten.

   So geht es weiter: Die nächsten drei Zahlen, $0, 255, 0$ repräsentieren das zweite "Pixel" in unserer obigen Grafik: ein rein grünes Pixel, da rot und blau $0$ sind.

   Schließlich noch ein blaues Pixel, ihr wisst schon, warum es blau ($0,0,255$) ist.

   Aus dem neun Zahlen _Integer_ Array machen wir mit `bytes()` drumherum ein neun Zahlen _Bytes_ Array.

/ Zeile 3: Jetzt brauchen wir als `encoding` auch `rgb8`. Und die `width`-Angabe $3$ sorgt für die Organisation / Zusammenfassung von jeweils drei Zahlen zu einem "Pixel".

Der Rest ist bekannt.

#line(length: 100%, stroke: 0.5pt + gray)

Das nächste Beispiel spielt mit der Transparenz:

#align(center)[
   #image(
      bytes(range(16).map(a => (0,0,255,16*a+15)).flatten()),
      format: (
         encoding: "rgba8",
         width: 16,
         height: 1,
      ),
      height: 1cm,
      scaling: "pixelated"
   )
]

Der Code dazu bringt uns zwei Neuerungen: eine neue Funktion und ein neues `encoding`:

```typ
#image(
   bytes(range(16).map(a => (0,0,255,16*a+15)).flatten()),
   format: (encoding: "rgba8", width: 16, height: 1),
   height: 1cm,
   scaling: "pixelated"
)
```

/ Zeile 2: Diesmal nutzen wir wieder die von oben bekannten Funktionen `range()` und `map()`. Wir wollen Farben mit rot-, grün-, blau- und Transparenz-Anteil benutzen und zwar 16 davon.

   In der `map()` Funktion bauen wir uns solche 4-Tupel und das Ergebnis _vor_ dem darauf angewendeten `flatten()` ist ein Array von 16 Arrays à vier Elemente:

   #range(16).map(a => (0,0,255,16*a+15))

   Daraus macht uns die `flatten()` Funktion ein "flaches" Array von $16*4$ Zahlen hintereinander – genau, wie wir sie für die `image()` Funktion brauchen:

   #raw(
      range(16).map(a => (0,0,255,16*a+15)).flatten().map(str).join(", "),
      lang: "txt"
   )

/ Zeile 3: Jetzt benutzen wir das Encoding `rgba8`, es steht für rot, grün, blau und alpha, jeweils 8 bit. Und wir wollen 16 "Pixel" nebeneinander, daher ist unsere `heigth` diesmal $1$.

#line(length: 100%, stroke: 0.5pt + gray)

Unser nächstes Beispiel wird etwas komplexer – und ein wenig mathematischer:

#let w-pix = 51
#let h-pix = 21

#let pixel-data = range(w-pix * h-pix).map(i => {
   let x = calc.rem(i, w-pix)
   let y = calc.div-euclid(i, w-pix)
   let g = calc.gcd(x+1, y+1)
   
   // --- 1. Strukturgebende Schicht (gcd = 1) ---
   if g == 1 {
      return (80, 80, 80, 255)
      //return (196, 128, 96, 255)
   }
   
   // --- 2. Mathematische Schichten (für g > 1) ---
   
   // ROT: Modulo 2
   let is-mod2 = calc.rem(g, 2) == 0
   let r-chan = if is-mod2 { 255 } else { 0 }
   let a-r = r-chan
   
   // GRÜN: Modulo 3 (Mapping ohne explizite Fälle)
   let m3 = calc.rem(g, 3)
   let g-chan = int(m3 * 255 / 2) 
   let a-g = g-chan
   
   // BLAU: Modulo 5 (Mapping ohne explizite Fälle)
   let m5 = calc.rem(g, 5)
   let b-chan = int(m5 * 255 / 4)
   let a-b = b-chan
   
   // Alpha-Blending (Summe gedeckelt bei 255)
   //let a-final = calc.min(255, a-r + a-g + a-b)
   //let a-final = calc.max(a-r, a-g, a-b) // Maximum
   //let a-final = int(255 - ( (255 - a-r) * (255 - a-g) * (255 - a-b) / calc.pow(255, 2) )) // "Screen" Blending
   let a-final = int(calc.sqrt((calc.pow(a-r, 2) + calc.pow(a-g, 2) + calc.pow(a-b, 2)) / 3)) // Euklidisch (RMS, Root-Mean-Square)
   //let a-final = int(a-r * 0.1 + a-g * 0.1 + a-b * 0.8) // Gewichtung (Summer der Faktoren = 1)

   (r-chan, g-chan, b-chan, a-final)
}).flatten()

#figure(
   image(
      bytes(pixel-data), 
      format: (encoding: "rgba8", width: w-pix, height: h-pix), 
      height: 6cm,
      scaling: "pixelated"
   ),
   caption: "ggT-modulo-Grafik"
) <ggt-modulo>

Jede Pixelspalte und -zeile steht hier für eine natürliche Zahl, beginnend mit jeweils $1$ in der Ecke links oben. Wenn der $gcd(x,y)$#footnote[#link("https://de.wikipedia.org/wiki/Größter_gemeinsamer_Teiler")[größter gemeinsamer Teiler]] $1$ ist, wird das Pixel dunkelgrau gemalt.

Ist er das nicht, schauen wir, was bei der Division des ggT durch 2, 3, 5 als Rest rauskommt und färben die Pixel mehr oder weniger rot ($gcd(x,y) mod 2$), grün ($gcd(x,y) mod 3$) oder blau ($gcd(x,y) mod 5$). Die Transparenz der Farben verrechnen wir und achten darauf, dass der finale Transparenzwert nicht größer als 255 wird. Hier ist der Quellcode für das Erzeugen des _raw bytes Arrays_:

// Ligaturen für den folgenden Code Block ausschalten:
#text(features: (calt: 0))[
```typ
#let w = 51  // Anzahl der Kacheln horizontal
#let h = 21  // Anzahl der Kacheln vertikal

#let pixel-data = range(w * h).map(i => {
   // x und y aus unserer einen Laufvariablen i ermitteln:
   let x = calc.rem(i, w)
   let y = calc.div-euclid(i, w)
   let g = calc.gcd(x+1, y+1)  // ggT von x und y errechnen
   
   // --- 1. Strukturgebende Schicht (gcd = 1) ---
   if g == 1 {
      return (80, 80, 80, 255)
   }
   
   // --- 2. Mathematische Schichten (für g > 1) ---
   // ROT: Modulo 2
   let is-mod2 = calc.rem(g, 2) == 0
   let r-chan = if is-mod2 { 255 } else { 0 }
   let a-r = r-chan
   
   // GRÜN: Modulo 3
   let m3 = calc.rem(g, 3)
   let g-chan = int(m3 * 255 / 2) 
   let a-g = g-chan
   
   // BLAU: Modulo 5
   let m5 = calc.rem(g, 5)
   let b-chan = int(m5 * 255 / 4)
   let a-b = b-chan
   
   // Alpha-Blending: Euklidisch (RMS, Root-Mean-Square)
   let a-final = int(calc.sqrt((calc.pow(a-r, 2) + calc.pow(a-g, 2) + calc.pow(a-b, 2)) / 3))

   (r-chan, g-chan, b-chan, a-final)
}).flatten()
```
]

Das Einbauen als Bild ins Dokument erfolgt dann über die schon gelernte `image()` Syntax:

```typ
#figure(
   image(
      bytes(pixel-data), 
      format: (encoding: "rgba8", width: w, height: h), 
      height: 6cm,
      scaling: "pixelated"
   ),
   caption: "ggT-modulo-Grafik"
)
```

Und fertig ist die Laube.

Natürlich kann man dies alles auch durch das Zeichnen von Rechtecken in einem Block machen und diese Art der Grafik-Erzeugung sehen wir im @typst-grafik ("#nameref(<typst-grafik>)").

#pagebreak(weak: true)
//--------------------

= Abbildungen mit `#figure()` <abbildungen>
Mächtiger als `#image()` ist die Funktion `#figure()`. Mit ihr kann man u.a. das Alignment steuern und auch Bildunterschriften realisieren, wie hier in @abb_hybrid:

#figure(
   image("img/output_plot-02.png", width: 90%),
   caption: [Gedämpfte Schwingung, errechnet auf dem Analogcomputer THAT]
) <abb_hybrid>

Im Bild sieht man übrigens eine gedämpfte Schwingung, wie sie vom Analogrechner THAT errechnet wurde. Das Auslesen der Werte erfolgte mittels eines Arduino, wie es in @ulmann2021github vorgeschlagen wurde.

#figure(
   image("img/that_arduino.jpeg", width: 30%),
   caption: [Setup mit THAT und Arduino]
)

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
== Typsts eigene Methoden <typst-grafik>

Man kann in Typst auch direkt zeichnen und somit (einfache) Illustrationen wie z.B. die in @hue-kreis-quadrate erstellen.

#let n = 18
#let radius = 2.5cm
#let sq-size = 0.7cm
// Wir berechnen die benötigte Gesamtgröße (Durchmesser + Quadratgröße)
#let total-size = 2 * radius + sq-size 

#figure(
  block(width: total-size, height: total-size)[
    #for i in range(n) {
      let angle = i * (360deg / n)
      let dx = calc.cos(angle) * radius
      let dy = calc.sin(angle) * radius
      
      place(center + horizon, dx: dx, dy: dy)[
        #rotate(angle)[
          #rect(
            width: sq-size,
            height: sq-size,
            fill: color.hsv(angle, 100%, 100%),
            stroke: 1.5pt + black.lighten(0%),
            radius: 4pt
          )
        ]
      ]
    }
  ],
  caption: [#n Quadrate, im Kreis rotiert]
) <hue-kreis-quadrate>

Das ist hier gelöst mit einem `block()` als Zeichenfläche, der `place()`- und der `rect()`-Funktion. Der Quellcode dazu sieht so aus:

```typ
#let n = 18
#let radius = 2.5cm
#let sq-size = 0.7cm
#let total-size = 2 * radius + sq-size

#figure(
  block(width: total-size, height: total-size)[
    #for i in range(n) {
      let angle = i * (360deg / n)
      let dx = calc.cos(angle) * radius
      let dy = calc.sin(angle) * radius
      
      place(center + horizon, dx: dx, dy: dy)[
        #rotate(angle)[
          #rect(
            width: sq-size,
            height: sq-size,
            fill: color.hsv(angle, 100%, 100%),
            stroke: 1.5pt + black.lighten(0%),
            radius: 4pt
          )
        ]
      ]
    }
  ],
  caption: [#n Quadrate, im Kreis rotiert]
)
```
Dazu ein paar Erläuterungen.
/ Zeile 13: Der erste Parameter der `place()` Funktion ist das _alignment_. Mit `center + horizon` sagen wir, dass unser Mittelpunkt relativ zum umschließenden Container (der `block()` aus Zeile 7) sowohl horizontal (`center`), als auch vertikal (`horizon`) in der Mitte liegen soll. Anders ausgedrückt: Unser Koordinatensystem-Ursprung liegt jetzt genau in der Mitte des Blocks.

   Da wir mit Sinus und Cosinus rechnen und diese Werte zwischen $-1$ und $1$ liefern, müssen wir zur Skalierung lediglich mit dem Radius unseres gedachten Kreises multiplizieren. Wir müssen nicht mehr herumrechnen, wie wir den Kreis auch schön in die Mitte des Blocks bekommen.

#line(length: 100%, stroke: 0.5pt + gray)

Wie wär's mit einem ebenfalls mit Typst Code selbst hier im Dokument erzeugten Farbspektrum? Bittesehr:

#let wavelength-to-color(lambda) = {
  // Initialisierung der RGB-Werte
  let r = 0.0
  let g = 0.0
  let b = 0.0

  // 1. Spektrale Verteilung berechnen
  if lambda >= 380 and lambda < 440 {
    r = -(lambda - 440) / (440 - 380)
    g = 0.0
    b = 1.0
  } else if lambda >= 440 and lambda < 490 {
    r = 0.0
    g = (lambda - 440) / (490 - 440)
    b = 1.0
  } else if lambda >= 490 and lambda < 510 {
    r = 0.0
    g = 1.0
    b = -(lambda - 510) / (510 - 490)
  } else if lambda >= 510 and lambda < 580 {
    r = (lambda - 510) / (580 - 510)
    g = 1.0
    b = 0.0
  } else if lambda >= 580 and lambda < 645 {
    r = 1.0
    g = -(lambda - 645) / (645 - 580)
    b = 0.0
  } else if lambda >= 645 and lambda <= 780 {
    r = 1.0
    g = 0.0
    b = 0.0
  }

  // 2. Intensitäts-Faktor (Dämpfung an den Rändern)
  let factor = 0.0
  if lambda >= 380 and lambda < 420 {
    factor = 0.3 + 0.7 * (lambda - 380) / (420 - 380)
  } else if lambda >= 420 and lambda < 701 {
    factor = 1.0
  } else if lambda >= 701 and lambda <= 780 {
    factor = 0.3 + 0.7 * (780 - lambda) / (780 - 700)
  } else {
    factor = 0.0
  }

  // 3. Gamma-Korrektur (typischerweise 0.8 für Monitore)
  let gamma = 0.8
  let adjust(val, f) = {
    if val == 0 { return 0% }
    // Anwendung von Intensität und Gamma-Kurve
    return calc.pow(val * f, gamma) * 100%
  }

  return rgb(adjust(r, factor), adjust(g, factor), adjust(b, factor))
}

#let spectrum-visualization(width: 100%) = {
  let start-l = 380
  let end-l = 780
  let range-nm = end-l - start-l
  
  // Wir definieren einen Seitenabstand für die Labels (ca. die halbe Breite der Zahl "380")
  let label-margin = 15pt 

  block(width: width, {
    // Das Padding sorgt dafür, dass die zentrierten Randzahlen nicht überstehen
    pad(x: label-margin, {
      stack(
        spacing: 0pt, // Entfernt den Abstand zwischen Balken und Ticks komplett
        
        // 1. Der Farbbalken
        rect(
          width: 100%,
          height: 30pt,
          fill: gradient.linear(
            ..range(start-l, end-l, step: 1).map(l => wavelength-to-color(l))
          ),
          //stroke: 0.5pt + gray,
          // Unten keine Abrundung, damit die Ticks sauber anliegen
          //radius: (top: 2pt, bottom: 0pt) 
        ),

        // 2. Die Achse (Ticks und Labels)
        box(width: 100%, height: 25pt, {
          let labels = (380, 440, 490, 510, 580, 645, 700, 750, 780)
          
          for l in labels {
            // Position relativ zur Breite des Balkens (0% bis 100%)
            let rel-pos = (l - start-l) / range-nm * 100%
            
            place(
              left,
              dx: rel-pos - label-margin/2,
              // align(center) sorgt dafür, dass der Tick und die Zahl 
              // exakt auf der Position zentriert werden
              align(center, stack(
                dir: ttb,
                spacing: 3pt,
                // Die Tick-Linie
                line(angle: 90deg, length: 5pt, stroke: 0.5pt),
                // Die Zahl
                text(size: 8pt)[#l]
              ))
            )
          }
        })
      )
    })
    
    // Einheit (ganz rechts außen, unabhängig vom Padding des Balkens)
    place(bottom + right, dy: 5pt, text(size: 7pt, style: "italic", fill: gray)[Wellenlänge in nm])
  })
}

// Anwendung in deinem DIN A4 Dokument
#spectrum-visualization()

Der Typst-Code dazu ist etwas umfangreich und wird daher hier nicht wiedergegeben, kann aber natürlich im Repository eingesehen werden. Die beiden Funktionen lauten `wavelength-to-color()` und `spectrum-visualization()`.

Interesant ist übrigens, dass der Zusammenhang zwischen der Wellenlänge und der Farbtemperatur (in Kelvin) _umgekehrt_ proportional ist. Da gibt es das #link("https://de.wikipedia.org/wiki/Wiensches_Verschiebungsgesetz")[_Wiensche Verschiebungsgesetz_]:
$
   lambda_upright(max) = (2898 mu "m" dot "K")/T
$
Das $max$ am $lambda$ bedeutet, dass hier die Wellenlänge gemeint ist, bei der die Wärmestrahlung am größten – eben maximal – ist.

Umgestellt nach der Temperatur bedeutet das:
$
   T = (2898 mu "m" dot "K")/lambda_upright(max)
$

Je gelblicher ein Licht ist, desto "wärmer" empfinden wir es. "Warme" Lichter müssten also gegenüber kälteren eine höhere Temperatur haben. Denn wenn die Temperatur steigt, wird es ja wärmer.

De facto (in der Physik) ist es hier aber _umgekehrt_: Ein vermeintlich warmes, orangenes Licht mit z.B. $600 "nm" (=0.6 mu "m")$ Wellenlänge entspricht einer Temperatur von $(2898 mu "m" dot "K")/(0.6 mu "m") = 4830 "K"$. 

Wohingegen ein Licht, das wir als "kühl" (weil bläulicher) bezeichnen würden – im Spektrum also eher bei ca. $450 "nm" (=0.45 mu "m")$ angesiedelt –, einer Temperatur von $(2898 mu "m" dot "K")/(0.45 mu "m") = 6440 "K"$ entspricht, also einer _höheren_ Temperatur.


== Lilaq <lilaq>
Für Typst gibt es viele importierbare Pakete, die die Möglichkeiten von Typst erweitern. Ein Paket, mit dem man gut Diagramme zeichnen kann, heißt _Lilaq_. Die folgenden Diagramme sind mit Hilfe von _Lilaq_ entstanden. Dazu muss das Paket zu Beginn einmal importiert werden:
```typ
#import "@preview/lilaq:0.5.0" as lq
```

#let xs = (0, 1, 2, 3, 4)

#grid(
   columns: (1fr, 1fr),
   align: center + horizon,
   stroke: 0.0pt + gray,
   move(dy: -1.5pt)[#lq.diagram(
      lq.plot(xs, (3, 5, 4, 2, 3))
   )],
   [#lq.diagram(
      title: [Precious data],
      xlabel: $x$, ylabel: $y$,
      lq.plot(xs, (3, 5, 4, 2, 3), mark: "s", label: [A]),
      lq.plot(xs, x => 2*calc.cos(x)+3, mark: "o", label: [B])
   )]
)
Dazu jeweils der Typst-Code (natürlich wurde die Variable `xs` nur _einmal_ definiert):

#grid(
   columns: (1fr, 1fr),
   stroke: 0.0pt + gray,
   inset: (x: 5pt),
   [
      ```typ
   #let xs = (0, 1, 2, 3, 4)
   #lq.diagram(
      lq.plot(xs, (3, 5, 4, 2, 3))
   )
      ```
   ],
   [
      ```typ
   #let xs = (0, 1, 2, 3, 4)
   #lq.diagram(
      title: [Precious data],
      xlabel: $x$, ylabel: $y$,
      lq.plot(xs, (3, 5, 4, 2, 3),
         mark: "s", label: [A]),
      lq.plot(xs, x => 2*calc.cos(x)+3,
         mark: "o", label: [B])
   )
      ```
   ]
)

#v(0.5cm)

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

Hier wurde wieder die Typst Funktion `figure()` – bekannt aus @abbildungen – um das Lilaq-Diagramm angewendet, damit wir eine Bildunterschrift und die automatische Nummerierung haben. Der Quellcode ist nicht besonders kompliziert:
```typ
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
```


#pagebreak()
== Programmierte Grafiken <programmierung>

=== Ein Fraktal
Die folgende *#link("https://de.wikipedia.org/wiki/Koch-Kurve")[Koch'sche Schneeflocken-Kurve]* wurde hier nicht als Bitmap und auch nicht als Vektorgrafik eingebaut, sondern wurde dynamisch durch Typst Code erzeugt.

#figure(
   lq.diagram(
      width: 7cm, height: 8cm,
      xaxis: (ticks: none, stroke: none),
      yaxis: (ticks: none, stroke: none),

      lq.path(
         ..koch-snowflake(5),
         fill: orange, closed: true
      )
   ),
   caption: [Koch'sche Schneeflocke (ein Fraktal)]
)

Um diese Grafik hier im Dokument selbst erzeugen zu können (und eben _nicht_ als Grafikdatei mit fixer Auflösung einzubetten), ist die Erzeugung als Funktion realisiert. Hier – für den interessierten Leser – der Typst Quellcode dazu:

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

Das tatsächliche Erzeugen der Grafik im Dokument erfolgt dann über diese Typst Syntax im Dokument:

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
   collatz_visualizer(startzahl, diagrammZeilen, scale: 0.58),
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

==== Collatz Baum
Eine weitere Art der Darstellung für die Collatz-Zahlenfolge ist eine Baum-Form.

Wir wissen bereits, dass die Folge immer zur $1$ kommt, das ist quasi unsere Wurzel, die ganz unten steht. Nun gehen wir rückwärts vor: Welche Zahl kann vor der $1$ kommen? Nur die $2$. Vor der $2$ kann nur die $4$ stehen und vor der $4$ nur die $8$, denn es gibt keine natürlich Zahl, die mit $3$ multipliziert und mit $1$ addiert wird, $4$ ergibt – außer der $1$, aber _diese_ Schleife blenden wir ja aus.

Vor der $8$ kann nur die $16$ kommen, denn $8-1=7$, was nicht glatt durch $3$ teilbar ist.

Aber vor der $16$ kann neben der $32$ auch die $5$ kommen, denn $3*5+1$ ist $15$.

#let level = 5

So bauen wir rückwärts denkend einen Baum auf, in dem wir Vorgängerzahlen sehen. Das beginnt also so für einen Baum der Höhe #level:

#figure(
   collatz_tree(level, scale: 0.9),
   caption: [Collatz Baum mit den ersten #level Ebenen]
)

#let level = 10

Nun denken wir das weiter und vervollständigen den Baum nach oben. Exemplarisch – und aus Platzgründen – sei hier der Baum der Ebene #level dargestellt:

#figure(
   collatz_tree(10, scale: 0.55),
   caption: [Collatz Baum der Ebene #level]
)

Wollte man nun beweisen, dass _jede_ Startzahl auf die $1$ führt, müsste man "nur noch" zeigen, dass in diesem Baum, jede natürlich Zahl vorkommt. Aber natürlich hat das bisher auch noch nicht geklappt.

Bei der Implementierung der Funktion, die diese Baum-Grafik erzeugt, hat mir die K.I. _Claude_ geholfen. Das Code-Ergebnis kann sich der geneigte Leser gern im Repository im File `_lib.typ` anschauen. Vermutlich ist es – wie bei von K.I. erzeugtem Code üblich – unnötig kompliziert. Aber immerhin: Claude hat einigermaßen verstanden, worum es ging.

== Diagramme mit Zusatzpaketen
Es gibt nahezu 500 #link("https://typst.app/universe/search/?kind=packages")[Zusatzpakete für Typst], darunter zahlreiche, die beim Erzeugen von Diagrammen helfen. In @lilaq haben wir bereits eins kennengelernt: Lilaq.

Ein weiteres Beispiel ist das Paket #link("https://github.com/solstice23/typst-ribbony")[_Ribbony_]. Damit kann man u.a. ein sogenanntes _Sankey Diagramm_ erzeugen:

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

#pagebreak(weak: true)
= Literaturverzeichnis & das Zitieren

In wissenschaftlichen Arbeiten ist es unerlässlich, aus anderen Quellen – korrekt – zu zitieren. Dazu hat es sich als Vorgehensweise durchgesetzt, in einer Datei alle seine Quellen strukturiert aufzulisten. Dazu bietet sich vor allem das von LaTeX her bekannte _bibtex_ Format an. Hier im Repository liegt die beispielhafte Datei `literatur.bib` in diesem Format. 

Diese Datei wird dann dem Satzsystem – in unserem Falle also Typst – bekannt gemacht und es wird der *Zitierstil* festgelegt. Davon gibt es in Typst eine große Anzahl zur Auswahl. Aufgelistet sind sie alle #link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[hier] (ggfs. auf "View options" klicken).

Dann kann man in seinem Dokument sehr leicht eine Quelle, wie z.B. diese #text(fill:purple)[@vaswani2017attention] angeben. Was im vorherigen Satz zwischen "diese" und "angeben" erzeugt wird – ich habe es farblich hervorgehoben –, hängt vom gewählten Zitierstil ab. Sollte keiner der aktuell 89 in Typst vorhandenen Zitierstile passen (z.B. weil die Uni ihren ganz eigenen definiert hat), so kann man auch selbst #link("https://citationstyles.org/")[neue Zitierstile definieren] und nutzen. Dazu gibt es sogar einen #link("https://editor.citationstyles.org/visualEditor/")[visuellen CSL Editor].

Es gibt aber im Internet große Menge von CSL Dateien, so dass man dort ggfs. fündig wird oder eine zu 95% passende Variante findet und noch anpassen kann. Zwei guten Quellen sind:

+ #link("https://github.com/citation-style-language/styles")[Das offizielle CSL Verzeichnis auf GitHub]
+ #link("https://www.zotero.org/styles")[Das Zotero Style Repository] – aktuell 10.741 Styles, unter anderem filterbar nach Fachgebieten

Der gewählte Zitierstil beeinflusst nicht nur das Zitat im Text, sondern auch die Gestaltung des Literaturverzeichnisses.

Im Literaturverzeichnis werden standardmäßig nur die Quellen aufgelistet, die man in seinem Dokument auch tatsächlich verwendet hat. Das kann man optional ändern und _immer alle_ Quellen auflisten lassen.
