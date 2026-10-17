# Changelog

All notable changes to this project are documented here. The project follows
[Semantic Versioning](https://semver.org).

## [Unreleased]

### Changed

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

[1.0.0]: https://github.com/KanarekLife/pg-thesis-typst/releases/tag/v1.0.0
