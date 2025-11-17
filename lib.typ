#import "@preview/chic-hdr:0.5.0": *

#let conf(
  title: none,
  affiliations: (),
  authors: (),
  date: none,
  accent: none,
  abstract: lorem(100),
  doc,
) = {
  // ---------------------------------------------------------------------------
  // Global layout & typography
  // ---------------------------------------------------------------------------
  // Document metadata (used for accessibility & title element)
  let names = authors.map(a => a.name)
  let author-string = if authors.len() == 2 {
    names.join(" y ")
  } else {
    names.join(", ", last: ", y ")
  }

  set document(
    title: title,
    author: if authors != none { authors.map(a => str(a.name)) } else { () },
  )

  // Page geometry
  set page(
    margin: 1in,
    paper: "a4",
  )

  let accent_color = {
    if type(accent) == "string" {
      rgb(accent)
    } else if type(accent) == "color" {
      accent
    } else {
      rgb("#DC143C")
    }
  }

  // Paragraph & justification (uses 0.14 character-level justification)
  set par(
    leading: 0.55em,
    first-line-indent: 1.8em,
    justify: true,
  )

  // Base fonts
  set text(
    font: "Libertinus Serif",
    size: 10pt,
  )

  // Use mono font in raw code
  show raw: set text(font: "NewComputerModern Mono")

  // Vertical spacing between paragraphs and headings
  set par(spacing: 0.55em)
  show heading: set block(above: 2em, below: 1.4em)

  // ---------------------------------------------------------------------------
  // Header / footer via chic-hdr
  // ---------------------------------------------------------------------------

  // Chic header with uppercase short title
  show: chic.with(
    skip: 1,
    chic-header(
      center-side: [
        #text(size: 8pt)[#upper(title)]
      ],
    ),
    chic-separator(1pt),
    chic-height(10em),
  )

  // ---------------------------------------------------------------------------
  // Authors, affiliations, abstract metadata
  // ---------------------------------------------------------------------------

  let emails = authors.map(a => link("mailto:" + a.email)[#a.email])
  let emails-string = emails.join(", ")

  // Footnotes
  show footnote: it => text(blue, it)

  // Citations / bibliography
  set cite(style: "chicago-author-date")
  set bibliography(style: "ieee", title: "References")

  // Tables
  set table(
    stroke: (_, y) => if y > 0 { (top: 0.8pt) } else { none },
  )
  show table.cell.where(y: 0): set text(weight: "bold")

  // Figures
  show figure.caption: it => [
    *#it.supplement #it.counter.display(it.numbering)*: #it.body
  ]

  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    set align(center)
    v(12.5pt, weak: true)
    if it.has("caption") {
      it.caption
      v(0.25em)
    }
    it.body
    v(1em)
  }

  show figure.where(kind: image): it => {
    set align(center)
    show: pad.with(x: 13pt)
    v(12.5pt, weak: true)
    it.body
    if it.has("caption") {
      it.caption
    }
    v(1em)
  }

  // ---------------------------------------------------------------------------
  // Headings
  // ---------------------------------------------------------------------------

  set heading(numbering: "1. ")

  show heading.where(level: 1): it => {
    set align(left)
    set text(size: 10pt, weight: "semibold")
    upper(it)
  }

  show heading.where(level: 2): it => {
    set align(left)
    set text(size: 10pt, weight: "semibold")
    upper(it)
  }

  // ---------------------------------------------------------------------------
  // Page numbering (odd/even in footer)
  // ---------------------------------------------------------------------------

  set text(size: 8pt)

  set page(
    footer: context {
      let page-counter = counter(page)
      let number = page-counter.get()
      if calc.odd(number.first()) {
        align(right, page-counter.display())
      } else {
        align(left, page-counter.display())
      }
    },
  )

  // ---------------------------------------------------------------------------
  // Title block & first-page layout
  // ---------------------------------------------------------------------------

  let footnote_non_numbered(body) = {
    footnote(numbering: _ => [], body)
    counter(footnote).update(n => if n > 0 { n - 1 } else { 0 })
  }

  // Collect author metadata once
  let corresponding_authors = if authors != none {
    authors.filter(a => (a.keys().contains("corresponding") and a.at("corresponding") == true))
  } else { () }

  let equal_authors = if authors != none {
    authors.filter(a => (
      a.keys().contains("equal-contributor") and a.at("equal-contributor") == true
    ))
  } else { () }

  // Find first author indices for each footnote type
  let first_corresponding_idx = if corresponding_authors.len() > 0 {
    authors.position(a => corresponding_authors.contains(a))
  } else { none }

  let first_equal_idx = if equal_authors.len() > 1 {
    authors.position(a => equal_authors.contains(a))
  } else { none }

  let author_display = if authors != none {
    authors
      .enumerate()
      .map(((idx, a)) => {
        // Start with the author name
        let parts = (a.name,)

        // If more than one author, append superscripted affiliation
        if authors.len() > 1 and a.keys().contains("affiliation") {
          parts.push(super(a.affiliation))
        }

        // Corresponding author marks (if used in your data)
        if corresponding_authors.contains(a) and idx == first_corresponding_idx {
          parts.push(footnote(numbering: _ => "*")[
            #corresponding-text
            #corresponding_authors
            .map(b => [#b.name, " <", #b.email, ">"])
            .join(", ", last: " & ")
            .
          ])
        } else if corresponding_authors.contains(a) {
          parts.push(super("*"))
        }

        // Equal contributor marks (if used in your data)
        if equal_authors.len() > 1 and equal_authors.contains(a) and idx == first_equal_idx {
          parts.push(footnote(numbering: _ => "†")[
            #equal_authors.map(b => b.name).join(", ", last: " & ")
            contributed equally to this work.
          ])
        } else if equal_authors.len() > 1 and equal_authors.contains(a) {
          parts.push(super("†"))
        }

        // ORCID icon/link (optional)
        if a.keys().contains("orcid") {
          parts.push(link(a.orcid, fa-orcid(fill: rgb("a6ce39"), size: 0.8em)))
        }

        parts.join()
      })
      .join(", ", last: " & ")
  } else { none }

  set align(center)

  place(center + top, scope: "parent", float: true, {
    pad(top: 15em, bottom: 2em)[
      #align(center)[
        #block(width: 65%, stroke: none)[
          #par(justify: false)[
            #text(size: 12pt, weight: "bold")[#upper(title)]
          ]

          #v(1em)
          #par(justify: false)[
            #set text(size: 10pt, weight: "semibold")
            #text(size: 10pt, weight: "semibold")[
              #author_display
            ]
            #super(size: 0.8em)[1]
          ]

          #for affiliation in affiliations {
            v(1em)
            text(size: 9pt)[
              #super(size: 0.8em)[1]
              #text(size: 8pt, style: "italic")[
                #affiliation.full
              ]
            ]
          }

          #v(1em)
          #text(size: 9pt)[
            E-mail:
            #show link: it => text(fill: black, it)
            #text(size: 8pt, style: "italic", fill: black)[#emails-string]
          ]
          #v(1em)


          #{
            if date != none {
              align(center, table(
                columns: (auto, auto),
                stroke: none,
                gutter: 0pt,
                align: (right, left),
                [#text(size: 11pt, "Publicado:")],
                [#text(
                    size: 11pt,
                    fill: accent_color,
                    weight: "semibold",
                    date.display("[month repr:long] [day padding:zero], [year repr:full]"),
                  )
                ],

                text(size: 11pt, "Ultima Actualización:"),
                text(
                  size: 11pt,
                  fill: accent_color,
                  weight: "semibold",
                  datetime.today().display("[month repr:long] [day padding:zero], [year repr:full]"),
                ),
              ))
            } else {
              align(
                center,
                text(size: 11pt)[Ultima Actualización:#h(5pt)]
                  + text(
                    size: 11pt,
                    weight: "semibold",
                    fill: accent_color,
                    datetime
                      .today()
                      .display(
                        "[month repr:long] [day padding:zero], [year repr:full]",
                      ),
                  ),
              )
            }
          }
        ]
      ]

      // ---------------------------------------------------------------------------
      // Abstract (kept ragged, uses metadata abstract)
      // ---------------------------------------------------------------------------

      #v(2em)

      #par(justify: true)[
        #text(size: 10pt, weight: "semibold")[
          Resumen
        ]
        #text(size: 10pt)[
          #abstract
        ]
      ]
    ]
  })


  v(2em)

  // ---------------------------------------------------------------------------
  // Main document content
  // ---------------------------------------------------------------------------

  set text(size: 10pt)
  set align(left)

  [
    #show link: it => text(blue, it)
    #doc
  ]
}
