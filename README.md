# Journals: Vale styles for a manuscript

A manuscript has a title, an abstract, the sections a reader expects, and a
set of conventions for how a number, a unit, a p-value, and a figure are
written. Each journal adds its own limits, and a reporting guideline adds a
checklist. This package is those rules, written as [Vale](https://vale.sh)
rules: a shared core, the [IMRaD](https://en.wikipedia.org/wiki/IMRAD)
structure, [Nature](https://www.nature.com/nature/for-authors/formatting-guide)'s
formatting guide, [PLOS ONE](https://journals.plos.org/plosone/s/submission-guidelines)'s
submission guidelines, and the [CONSORT 2025](https://doi.org/10.1371/journal.pmed.1004587)
and [PRISMA 2020](https://doi.org/10.1136/bmj.n71) checklists.

The linter that checks the docs checks the paper: in the editor, in CI, or
on a pull request, for Markdown, Quarto, R Markdown, MyST, Typst, and the
Markdown cells of a Jupyter notebook.

## Install

> Journals requires Vale v3.22.0 or later, for the `doc(...)` scopes that
> read a manuscript's sections and the rule inheritance the acronym rule
> uses. It builds on [Std](https://github.com/vale-cli/Std), which sync
> pulls in; Std stays present without being enabled.

```ini
StylesPath = styles
Packages = https://github.com/jdkato/journals/releases/latest/download/Journals.zip

[*.{md,qmd,Rmd}]
BasedOnStyles = Journals, IMRaD, PLOS
IMRaD.AbstractLength[max] = 300
IMRaD.AbstractCitations = error
```

```console
$ vale sync
```

`Journals` is the core and is always on. Name the structure, the journal,
and the guideline beside it.

| Style | Enforces |
| ----- | -------- |
| `Journals` | The core: a space before a unit and the SI symbol for it, an en dash in a range, `±` and `×`, no numeral opening a sentence, `p = 0.03` spaced and never `p = 0.000`, one case for `p`, `significant` beside its test, `data are`, `et al.`, `Figure 2` capitalized and cited by number rather than position, an acronym spelled out on first use, no `[ref]` or `TODO` left behind, and the words a result does not need: `novel`, `prove`, `very`, `utilize` |
| `IMRaD` | Abstract, Introduction, Methods, Results, Discussion, and References sections; an abstract within a word budget, without citations or abbreviations; a Discussion that names its limitations |
| `Nature` | The [formatting guide](https://www.nature.com/nature/for-authors/formatting-guide): a 75-character title without numbers or acronyms, a 200-word summary paragraph with `Here we show`, 40-character subheadings, 50 references cited as superscripts, 300-word legends, 3,000 words of Methods, Data and Code Availability statements, `Fig. 1`, `Extended Data Fig. 1`, `1,000`, `37 °C` |
| `PLOS` | The [submission guidelines](https://journals.plos.org/plosone/s/submission-guidelines): a 250-character title in sentence case, citations as `[1]`, `Fig 1` and `Table 1`, `S1 Fig`, no footnotes, three heading levels, exact p-values at or above 0.001, a Data Availability Statement, and Methods that give alpha, the software version, and the sample size |
| `CONSORT` | Seventeen items of the [CONSORT 2025](https://doi.org/10.1371/journal.pmed.1004587) checklist a linter can see: `randomized` in the title, a registry number, protocol, funding, competing interests, eligibility, randomization, concealment, blinding, harms, sample size, the primary outcome, baseline, the number analyzed, limitations |
| `PRISMA` | Twenty items of the [PRISMA 2020](https://doi.org/10.1136/bmj.n71) checklist: `systematic review` in the title, registration, protocol, eligibility, sources, the search strategy, screening, extraction, risk of bias, effect measures, synthesis, heterogeneity, reporting bias, certainty, the flow diagram, exclusions, limitations, funding, competing interests, availability |

Each rule file in [`Journals/styles`](Journals/styles) opens with what it
reports, carries its level, and links the passage or checklist item it
enforces. A checklist item is paraphrased; the item number is in the message.

### A trial for PLOS ONE

```ini
[*.md]
BasedOnStyles = Journals, IMRaD, PLOS, CONSORT
IMRaD.AbstractLength[max] = 300
IMRaD.AbstractCitations = error
```

### A systematic review

```ini
[*.qmd]
BasedOnStyles = Journals, IMRaD, PRISMA
```

### An Article for Nature

```ini
[*.Rmd]
BasedOnStyles = Journals, Nature
```

Nature has no Abstract heading: the summary paragraph is the one after the
title, and `IMRaD` stays off.

## How a rule reads a manuscript

A section is a level-one or level-two heading and what follows it, up to
the next heading of that level. The Methods rules read the section whose
heading contains `ethod`, so `Materials and methods` and `Methods` both
count; Results, Discussion, Abstract, and References are matched by name.

A title is the level-one heading. A Quarto or R Markdown title in the front
matter is not a heading, so give the manuscript a level-one heading too when
a title rule should see it. A Typst title is set in code mode, which the
parser skips, and a Typst paper's sections are level-one headings; the
package turns the title rules off for `.typ`, and a Markdown paper whose
sections are level-one headings wants the same:

```ini
[*.md]
BasedOnStyles = Journals, IMRaD, PLOS
PLOS.Title = NO
PLOS.TitleCase = NO
PLOS.TitleAbbreviations = NO
```

A Jupyter notebook is read through the package's `Notebook` View, which
joins the Markdown cells into one manuscript, so a section found in one cell
satisfies a rule reading another:

```ini
[*.ipynb]
BasedOnStyles = Journals, IMRaD
View = Notebook
```

The join keeps each cell's lines as they are in the file, so a paragraph
wrapped across lines reads as one paragraph per line.

## Tune a rule

Levels and toggles from your config, as for any Vale rule; a limit is a
parameter:

```ini
IMRaD.AbstractLength[max] = 150
Nature.References[max] = 30
Journals.Hype = NO
Journals.Prove = error
```

## Not carried

What a linter cannot see stays with the reader: an ethics statement's
committee name, a species name in italics, a reference list's punctuation,
an abbreviation used fewer than three times, and whether a limitation named
is the one that matters. STROBE is not here; its checklist carries no
license that allows a paraphrase.

## Tests

```console
$ ./test.sh
```

Each rule carries its cases in a `tests:` block, run in isolation by `vale
test`. One manuscript per format in [`fixtures`](fixtures) is checked under
the config above and compared to a golden file in `testdata`, and its
rewrite in [`fixtures/clean`](fixtures/clean) is required to produce no
alerts at all. A rule with no case that expects an alert fails the run.
`./test.sh -u` rewrites the golden files. The Typst fixture needs
`typst2vast`, which Vale calls but does not ship: `cargo install --locked
typst2vast`.

## License

MIT. The paraphrased checklists and the guides each rule cites are credited
in [NOTICE](NOTICE).
