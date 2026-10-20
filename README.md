Database of IEA Task XXIV Process Integration for Industry Decarbonization
(IETS IEA Task XXIV).

Documentation of the models contributed by the Task participants, built with
[Quarto](https://quarto.org) as a book project.

## Structure

Each top-level folder is a part of the book, and each model has its own folder:

    1-EnergyTechnologies/
      CoolingTower/
        index.qmd        documentation page of the model
        JSON/            model description (Task XXIV JSON format)
        Osmoses/         OSMOSE (Lua) implementation
        Excel/  Documents/  Figures/  Literature/   supplementary material

Pages are listed explicitly in `_quarto.yml` under `book: chapters:`. To add a
model, create its folder with an `index.qmd` and add that file to the chapters.

On a model page, `{{< model-viewer JSON/Model.json view="..." >}}` renders one
view of the model from its JSON description: `card`, `summary`, `flows`,
`equations`, `variables`, `unit`, `streams`, `cc`, `gcc` or `references`
(without `view`, a compact tabbed overview). Variables named in the text as
inline code are linked to their definitions. See
`1-EnergyTechnologies/CoolingTower/index.qmd` for a complete example.

## Building

    ./compileAll.sh            # HTML book, output in _book/

`quarto preview` serves the book locally and reloads on every change.
