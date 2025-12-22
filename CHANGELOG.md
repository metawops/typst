# Changelog

Releases sind momentan sehr willkürlich und können immer mal _zwischendurch_ stattfinden.

## [v0.3.0] – 2025-12-22
### Added
- Auslagerung von Einstellungen in neue `_config.typ`
- Damit einhergehend Umbau in `_lib.typ`, nämlich Verwendung der Werte aus dem Dictionary in `_config.typ` anstelle von hard-coded Werten
- Beispielhafte `literatur.bib` Datei
- Eigener CSL Zitierstil in Datei `journal-of-universal-computer-science.csl`
- Neues Kapitel über den Umgang mit Literaturverzeichnissen und dem Zitieren
### Changed
- Text in Kapitel 1 geändert/erweitert
### Removed
- n/a
### Fixed
- n/a

## [v0.2.1] – 2025-12-18

### Added
- Neue Funktion `nameref()`

### Changed
- Deutlicher Ausbau beim Text zum Collatz-Thema
- Mehr Text beim Kapitel mit dem Sankey Diagramm
- Auslagerung der Collatz-Funktionen und der Koch'schen Schneeflocke Funktion in die `_lib.typ`

### Removed
- nichts entfernt
   
### Fixed
- Kleinere Fixes bei `collatz_visualizer()` und `collatz_visualizer_horizontal()`
- Korrektur von Abständen
- weitere kleinere Fixes

## v0.1.0 – 2025-12-11

### Added
- Einführung des _codly_ Pakets für saubere Code-Blöcke.
- Verwendung des `Inter 18pt` Fonts für perfekte Reproduzierbarkeit.
- Verwendung des `JetPack Mono` Fonts für Code Blöcke.
- Saubere Auftrennung in zwei `.typ` Dateien: Hauptdokument und Setup (`_lib.typ`)

### Fixed
- Die Zeilennummerierung ist nun rechtsbündig ausgerichtet.
- Korrigierte Build-Pipeline, ignoriert nun `_*` Dateien, also auch `_lib.typ` und bezieht `CHANGELOG.md` als Release Notes ein.
- Release Workflow startet nur, wenn es Änderungen in der `CHANGELOG.md` gab.


[v0.2.1]: https://github.com/metawops/typst/compare/v0.1.0...v0.2.1
[v0.3.0]: https://github.com/metawops/typst/compare/v0.2.1...v0.3.0