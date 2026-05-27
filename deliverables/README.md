# Topology textbook - source bundle

LaTeX sources for the Armenian topology textbook (Հ. Հ. Օհնիկյան, "Տոպոլոգիա"). `main.pdf` is the prebuilt output (176 pages).

## Build

Requires TeX Live (or MiKTeX) with XeLaTeX + biber. XeLaTeX is mandatory because Armenian text is rendered via `fontspec` against the TTFs in `fonts/`.

From this folder:

```
xelatex  main.tex
biber    main
xelatex  main.tex
xelatex  main.tex
```

Each `Թեմա N.tex` (chapter) and `Թեմա N_Խնդիրներ.tex` (problem set) can also be compiled standalone via the `subfiles` package, e.g. `xelatex "Թեմա 5.tex"`.

## Layout

- `main.tex` - master document
- `packages.tex` - shared preamble (loaded by master and standalone chapters)
- `Թեմա N.tex`, `Թեմա N_Խնդիրներ.tex` - chapters and problem sets
- `grqer.bib` - bibliography (biblatex + biber)
- `fonts/` - CMU Serif TTFs used by `fontspec`
- `images_for_internal_reference/` - raster figures
- `tikz/` - TikZ snippets pulled in by chapter files
- `intro_not_used_anymore.tex` - kept for reference, not included in `main.tex`

## Notes

- A few harmless warnings appear on build (undefined `\ref{թեորեմ N}` hyperlinks, missing bold-italic CMU Serif shape because no `BoldItalicFont` is configured). They exist in the source, not the bundle. PDF renders fine.
