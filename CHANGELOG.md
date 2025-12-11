## v0.1.0 (2025-12-11)

### New Features
- Einführung des _codly_ Pakets für saubere Code-Blöcke.
- Verwendung der Inter 18pt statischen Schrift für perfekte Reproduzierbarkeit.
- Saubere Auftrennung in zwei `.typ` Dateien: Hauptdokument und Setup (`_lib.typ`)

### Fixes
- Die Zeilennummerierung ist nun rechtsbündig ausgerichtet.
- Korrigierte Build-Pipeline, ignoriert nun `_*` Dateien, also auch `_lib.typ` und bezieht `CHANGELOG.md` als Release Notes ein.
- Release Workflow startet nur, wenn es Änderungen in der `CHANGELOG.md` gab.