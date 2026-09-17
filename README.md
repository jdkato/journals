# Journals

[Vale](https://vale.sh) styles for scientific manuscripts: a shared core of
conventions, the IMRaD section structure, the author guidelines of
[Nature](https://www.nature.com/nature/for-authors/formatting-guide) and
[PLOS ONE](https://journals.plos.org/plosone/s/submission-guidelines), and the
[CONSORT 2025](https://doi.org/10.1371/journal.pmed.1004587),
[STROBE](https://doi.org/10.1371/journal.pmed.0040296), and
[PRISMA 2020](https://doi.org/10.1136/bmj.n71) reporting checklists.

Works on [Markdown](https://docs.vale.sh/formats/markdown),
[Quarto](https://docs.vale.sh/formats/quarto),
[R Markdown](https://docs.vale.sh/formats/rmarkdown),
[MyST](https://docs.vale.sh/formats/myst),
[Typst](https://docs.vale.sh/formats/typst), and
[Jupyter notebooks](https://docs.vale.sh/formats/jupyter).

## Install

Requires Vale 3.22.0 or later. The package depends on
[Std](https://github.com/vale-cli/Std), which `vale sync` fetches for you.

```ini
StylesPath = styles
Packages = Journals
Vocab = Journals

[*.{md,qmd,Rmd}]
BasedOnStyles = Journals, IMRaD, PLOS
```

```console
$ vale sync
```

`Journals` is in the [package library](https://vale.sh/explorer), so the
name is enough. To pin a version, give a release URL instead:
`https://github.com/jdkato/journals/releases/download/v0.1.0/Journals.zip`.

`Journals` is also the core style and is always on. Add a structure, a
journal, or a checklist next to it.

| Style | What it checks |
| ----- | -------------- |
| `Journals` | Units, numbers, statistics, figure references, citations, and filler words. See below. |
| `IMRaD` | That the standard sections exist, the abstract is within budget and has no citations or abbreviations, and the Discussion mentions limitations. |
| `Nature` | Title, summary paragraph, subheading, legend, Methods, and reference limits. Superscript citations, `Fig. 1`, `Extended Data Fig. 1`, `1,000`, `37 °C`. |
| `PLOS` | Title and abstract limits, `[1]` citations, `Fig 1`, `S1 Fig`, no footnotes, exact p-values, Vancouver references, a named ethics committee, and required Methods content. |
| `CONSORT` | 17 items from the checklist for randomized trials. |
| `STROBE` | 15 items from the checklist for observational studies. |
| `PRISMA` | 20 items from the checklist for systematic reviews. |

Checklist rules look for the things a regex can find, such as a registry
number, a mention of blinding in Methods, or a limitations paragraph in the
Discussion. Each message cites the item number.

### Core rules

| Group | Rules | Examples flagged |
| ----- | ----- | ---------------- |
| Units | `UnitSpacing`, `UnitSymbols` | `10mm`, `5 ml`, `37 degrees C`, `3 hrs` |
| Numbers | `Ranges`, `Symbols`, `SentenceNumeral` | `18-65`, `+/-`, `3 x 4`, `>=`, a sentence starting with a digit |
| Statistics | `PValueSpacing`, `PValueZero`, `PValueCase`, `Significant`, `DataPlural` | `p=0.03`, `p = 0.000`, mixed `p`/`P`, `significant` with no test, `data was` |
| Figures | `LabelCase`, `FigureAbbreviation`, `Positional` | `figure 2`, `Fig. 1` and `Figure 2` in one paper, `the figure below` |
| Citations | `EtAl`, `Acronyms`, `Species`, `Placeholder` | `et. al.`, undefined acronyms, `E. coli` not italic, `[ref]`, `TODO`, `??` |
| Words | `Hype`, `Intensifiers`, `Prove`, `DoubleHedge`, `Wordy` | `novel`, `very`, `proves`, `may possibly`, `utilize` |

Every rule file starts with a comment explaining what it checks and links to
the guideline it comes from.

## Configuration

```ini
# Randomized trial for PLOS ONE
[*.md]
BasedOnStyles = Journals, IMRaD, PLOS, CONSORT
IMRaD.AbstractLength[max] = 300
IMRaD.AbstractCitations = error

# Cohort study
[*.myst]
BasedOnStyles = Journals, IMRaD, STROBE

# Systematic review
[*.qmd]
BasedOnStyles = Journals, IMRaD, PRISMA

# Nature article. Nature has no Abstract heading, so leave IMRaD off.
[*.Rmd]
BasedOnStyles = Journals, Nature

# Notebook. The View joins the Markdown cells into one document.
[*.ipynb]
BasedOnStyles = Journals, IMRaD
View = Notebook
```

Limits are parameters, so you can change them without editing the rule:

```ini
IMRaD.AbstractLength[max] = 150
Nature.References[max] = 30
Journals.Hype = NO
```

## Notes

**Sections.** A section starts at a level-one or level-two heading. Methods
rules match any heading containing `ethod`, so `Materials and methods`
works. Abstract, Results, Discussion, and References are matched by name.

**Titles.** Title rules read the level-one heading. Quarto and R Markdown
front-matter titles are not headings, so add one if you want those rules.
Typst titles live in code mode and are skipped, and Typst sections are
level-one headings, so the package disables title rules for `.typ`. Do the
same for Markdown files where sections are level-one headings:

```ini
PLOS.Title = NO
PLOS.TitleCase = NO
PLOS.TitleAbbreviations = NO
```

**Notebooks.** Cell lines are joined as they appear in the file, so a
paragraph wrapped across lines is treated as several paragraphs.

**Spelling.** `Vocab = Journals` adds the terms Vale's dictionary lacks:
units like `mmHg`, statisticians' names, model organisms, databases,
software, and lab methods. All-caps words and registry numbers are already
skipped. Add your own terms in a second vocabulary.

**Species.** `Journals.Species` knows the common model organisms. Extend it
with your own list if you need more.

## Tests

```console
$ ./test.sh
```

Each rule has test cases in a `tests:` block, run by `vale test`. Each format
also has a fixture in `fixtures/` with a golden file in `testdata/`, and a
clean version in `fixtures/clean/` that must produce no alerts. A rule with no
test that expects an alert fails the run. Use `./test.sh -u` to regenerate
goldens. The Typst fixture needs `cargo install --locked typst2vast`.

## License

MIT. Sources for the paraphrased checklists are listed in [NOTICE](NOTICE).
