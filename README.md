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

On a model page, `{{< model-viewer JSON/Model.json >}}` renders an interactive
overview from the model's JSON: flows, heat streams, composite curves and grand
composite curve (HTML output only).

## Building

    ./compileAll.sh            # HTML book, output in _book/

`quarto preview` serves the book locally and reloads on every change.
