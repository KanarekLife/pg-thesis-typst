# Changelog

All notable changes to this project are documented here. The project follows
[Semantic Versioning](https://semver.org).

## [1.0.1] - 2026-10-23

### Changed

- Renamed the package from `pg-thesis` to `pg-unofficial-thesis`: Typst
  Universe reserves the bare university abbreviation for official templates.
  `pg-thesis` 1.0.0 was never published, so this is the first release.

- `make check` and CI run the same checks as typst/packages (its bundler and
  `typst-package-check` on the exact submission), and `make publish` refuses
  to submit unless they pass.

## [1.0.0] - 2026-10-17

### Added

- `thesis` template implementing the PG editorial rules (Regulamin procesu
  dyplomowania 2026, ZR 53/2022, official PG LaTeX template layout).
- Polish and English theses; bachelor's, engineering and master's kinds.
- Title page from Moja PG (PDF) or a generated draft look-alike; optional
  statement page.
- Streszczenie/Abstract pages, table of contents, list of abbreviations,
  bibliography in a PN-ISO 690 numeric style, lists of figures, tables and
  listings, appendices.
- `written-by` for chapter authors in team theses and `ang` for English terms.
- Starter template and a port of the official PG example thesis.

[1.0.1]: https://github.com/KanarekLife/pg-thesis-typst/releases/tag/v1.0.1
[1.0.0]: https://github.com/KanarekLife/pg-thesis-typst/releases/tag/v1.0.0
