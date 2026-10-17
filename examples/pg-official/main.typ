// The example thesis shipped with the official PG LaTeX template
// (git.pg.edu.pl/p1252239/latex_template_for_diploma), ported to Typst.
//
// Build from the repository root with `make example`.

#import "@preview/pg-thesis:1.0.0": *

#show: thesis.with(
  kind: "master",
  title-pl: [Przykładowa praca dyplomowa],
  title-en: [Sample diploma thesis],
  authors: ("Imię Nazwisko",),
  // Placeholder pages from the official template; in a real thesis use the
  // title page and the statement downloaded from Moja PG.
  title-page: image("pdf/strona-tytulowa.pdf"),
  statement: image("pdf/oswiadczenie.pdf"),

  abstract-pl: include "abstract-pl.typ",
  keywords-pl: [],
  oecd-pl: [_dziedzina, technika, …_],
  abstract-en: include "abstract-en.typ",
  keywords-en: [],

  abbreviations: (
    ([e], [niepewność pomiaru]),
    ([f], [częstotliwość [Hz]]),
    ([CDM], [Context Driven Model]),
    ([SOA], [Service Oriented Architecture]),
  ),

  bibliography: bibliography("bibliography.bib"),
  appendices: include "appendix.typ",
)

#include "chapters/01-wstep.typ"
#include "chapters/02-dokument-elektroniczny.typ"
#include "chapters/03-super-rozdzial.typ"
#include "chapters/04-podsumowanie.typ"
