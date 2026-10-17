// Polish thesis exercising every feature of the template.
#import "/lib.typ": *
#show: thesis.with(
  kind: "engineering",
  title-pl: [Tytuł pracy],
  title-en: [Thesis title],
  authors: ((name: "Jan Kowalski", album: "123456"), (name: "Anna Nowak", album: "654321")),
  supervisor: "dr inż. Jan Nowak",
  faculty: "Wydział Elektroniki, Telekomunikacji i Informatyki",
  field: "Informatyka",
  specialization: "Algorytmy i modelowanie systemów",
  abstract-pl: [Streszczenie. #lorem(60)],
  keywords-pl: ("pierwsze", "drugie"),
  oecd-pl: [inżynieria informatyczna],
  abstract-en: [Abstract. #lorem(60)],
  keywords-en: ("first", "second"),
  oecd-en: [information engineering],
  abbreviations: (CD: [Continuous Delivery], SOA: [Service Oriented Architecture #lorem(20)]),
  bibliography: bibliography("/examples/pg-official/bibliography.bib"),
  list-of-listings: true,
  appendices: [
    = Dodatek
    #figure(rect(), caption: [Rysunek w dodatku]) <fa>
    Rys. @fa.
  ],
)

= Wstęp i cel pracy #written-by[Jan Kowalski] <wstep>
Akapit z literą w tekście i kotem. #lorem(80) @techterms

Drugi akapit @SMTP_RFC @mime-format @PDFRef[s. 5]. Rysunek @fig1, tabela @tab1, wzór @eq1, rozdział @wstep.
- element listy, #lorem(20)
  - zagnieżdżony
+ numerowany
/ Termin: opis terminu
Tekst po liście.

== Podrozdział z długim tytułem, który zawija się na drugą linię, aby sprawdzić wcięcie wiszące #written-by[Anna Nowak]
#lorem(50)
=== Punkt podrozdziału
#figure(rect(width: 5cm, height: 3cm), caption: [Przykładowy rysunek]) <fig1>
#figure(table(columns: (auto, 1fr), table.header[*A*][*B*], [1], [2]), caption: [Tabela]) <tab1>
Akapit po tabeli. `inline a i w`
$ E = m c^2 $ <eq1>
#figure(```js
const a = 1; // w i z
```, caption: [Kod])

= Podsumowanie
#lorem(40)#footnote[Przypis.]
