// --- 1. GLOBALE EINSTELLUNGEN ---
#set page(
  paper: "a4",
  margin: (left: 2.5cm, right: 2.5cm, top: 3cm, bottom: 2.5cm),
)

#set text(font: "Inria Serif", lang: "de", size: 11pt) 
#set heading(numbering: "1.1") 

#set par(justify: true)
#set par(first-line-indent: 0cm) // Einrückung deaktiviert, wie gewünscht

// --- FUSSZEILE DEFINITION (Seite X/Y) ---
#let mein_footer = context {
  set text(size: 10pt)
  line(length: 100%, stroke: 0.5pt)
  v(0.2em)
  let current = counter(page).display()
  let final = counter(page).final().at(0)
  align(center)[Seite #current/#final]
}

// --- INHALTSVERZEICHNIS STYLING ---
#show outline.entry.where(level: 1): it => {
  v(0.5em)
  strong(it)
}

// Fix für Abstände nach Überschriften
#show heading: it => {
  it
  par(text(size: 0pt, ""))
}

// --- 2. VARIABLEN ---
#let title = "  ExcuseMe - Self-Service-App \n für Schülerentschuldigungen"
#let authors = "Fabian Trummer, Jan Schubert"
#let class = "4AKIFT"
#let department = "Abteilung für Elektronik"
#let branch = "Ausbildungszweig Informatik"
#let supervisor = "Simon Gunacker" //gehört noch erweitert

// --- 3. DECKBLATT (Ohne Kopf- und Fußzeile) ---
#set page(header: none, footer: none)

#align(center)[
  #rect(stroke: 0.5pt, inset: 10pt)[
    #grid(columns: (1fr, 100pt), align: (left + horizon, right),
      [*HTBLuVA Graz-Gösting (BULME)* \ Ibererstraße 15-21 \ 8051 Graz],
      [#image("resources/bulme.png", width: 80%)] 
    )
  ]
  #v(2cm)
  #text(size: 14pt, weight: "bold", department) \
  #text(size: 12pt, weight: "bold", branch)
  #v(0.5cm) #line(length: 100%, stroke: 0.5pt) #v(1.5cm)
  #text(size: 22pt, weight: "bold", title)
  #v(1cm)
  #text(size: 12pt, weight: "bold", "Diplomarbeit")
  #v(4cm)
  #align(left)[
    #grid(columns: (150pt, 1fr), row-gutter: 1.5em,
      [Eingereicht von:], [#authors],
      [im Schuljahr:], [2025/2026],
      [der Klasse:], [#class],
      [bei:], [#supervisor],
      [am:], [#datetime.today().display("[day].[month].[year]")]
    )
  ]
]

#pagebreak()

// --- 4. VORSPANN (Inhaltsverzeichnis & Erklärung) ---
#set page(
  numbering: "1",
  footer: mein_footer
)
#counter(page).update(1) 

#include "chapters/declaration.typ"
#pagebreak()
#include "chapters/abstract.typ"
#pagebreak()

#outline(title: "Inhaltsverzeichnis", indent: auto)
#pagebreak()

// --- 5. HAUPTTEIL (Ab hier mit Kopfzeile) ---
#set page(
  header: context {
    set text(size: 9pt, style: "italic")
    grid(columns: (1fr, 1fr), [#title], [#align(right, authors)])
    v(0.5em)
    line(length: 100%, stroke: 0.5pt)
  },
  footer: mein_footer
)

#include "chapters/1_introduction.typ"
#pagebreak()
#include "chapters/2_grundlagen.typ"
#pagebreak()
#include "chapters/3_methodik.typ"
#pagebreak()
#include "chapters/4_implementierung.typ"
#pagebreak()
#include "chapters/5_ergebnisse.typ"
#pagebreak()


// Hier kannst du weitere Kapitel einfügen:
// #include "chapters/fundamentals.typ"
// #pagebreak()

// --- 6. ANHANG ---
#heading(level: 1, outlined: true)[Anhang]

#heading(level: 2, outlined: true)[Abbildungsverzeichnis]
#outline(title: none, target: figure.where(kind: image))
#pagebreak()

#heading(level: 2, outlined: true)[Tabellenverzeichnis]
#outline(title: none, target: figure.where(kind: table))
#pagebreak()

// --- 7. LITERATURVERZEICHNIS ---
// Falls du eine references.bib hast, wird sie hier ausgegeben
#heading(level: 2, outlined: true)[Literaturverzeichnis]
#bibliography("references.bib", title: none, style: "ieee")
