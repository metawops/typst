## v0.2.0 (2025-12-18)

- Deutlicher Ausbei beim Text zum Collatz-Thema
- Mehr Text beim Kapitel mit dem Sankey Diagramm
- Auslagerung der Collatz-Funktionen und der Koch'schen Schneeflocke Funktion in die `_lib.typ`
- Kleinere Fixes bei `collatz_visualizer()` und `collatz_visualizer_horizontal()`
- Neue Funktion `nameref()`
- Korrektur von Abständen

## v0.1.0 (2025-12-11)

### New Features
- Einführung des _codly_ Pakets für saubere Code-Blöcke.
- Verwendung des `Inter 18pt` Fonts für perfekte Reproduzierbarkeit.
- Verwendung des `JetPack Mono` Fonts für Code Blöcke.
- Saubere Auftrennung in zwei `.typ` Dateien: Hauptdokument und Setup (`_lib.typ`)

### Fixes
- Die Zeilennummerierung ist nun rechtsbündig ausgerichtet.
- Korrigierte Build-Pipeline, ignoriert nun `_*` Dateien, also auch `_lib.typ` und bezieht `CHANGELOG.md` als Release Notes ein.
- Release Workflow startet nur, wenn es Änderungen in der `CHANGELOG.md` gab.