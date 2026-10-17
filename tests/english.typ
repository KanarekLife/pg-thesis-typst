// English thesis: Abstract first, English labels and supplements.
#import "/lib.typ": *
#show: thesis.with(
  lang: "en",
  kind: "master",
  title-pl: [Tytuł po polsku],
  title-en: [English title],
  authors: ("John Smith",),
  supervisor: "prof. dr hab. inż. Jan Nowak",
  abstract-en: [English abstract.],
  keywords-en: ("first", "second"),
  abstract-pl: [Polskie streszczenie.],
  keywords-pl: ("pierwsze",),
  two-sided: false,
  bibliography: bibliography("/examples/pg-official/bibliography.bib"),
  appendices: [= Extra],
)

= Introduction and objectives of thesis
See @f, @t, @intro and @techterms.
#figure(rect(), caption: [Box]) <f>
#figure(table(columns: 2, [a], [b]), caption: [Table]) <t>
== Subchapter <intro>
