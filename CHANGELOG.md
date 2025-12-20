# Changelog

Releases sind momentan sehr willkürlich und können immer mal _zwischendurch_ stattfinden.

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