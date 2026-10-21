Database of IEA Task XXIV Process Integration for Industry Decarbonization
(IETS IEA Task XXIV).

Documentation of the models contributed by the Task participants, built with
[Quarto](https://quarto.org) as a website project.

## Structure

Each top-level folder is a section of the site, and each model has its own
folder. A model sits directly in a section, or in a sector within it:

    1-EnergyTechnologies/
      CoolingTower/
        index.qmd        documentation page of the model
        JSON/            model description (Task XXIV JSON format)
        Osmoses/         OSMOSE (Lua) implementation
        Excel/  Documents/  Figures/  Literature/   supplementary material
    3-IndustrialProcesses/
      ChemicalSector/
        index.qmd        landing page of the sector
        MethanolToOlefins/
          index.qmd      documentation page of the model

Pages are listed explicitly in `_quarto.yml` under `website: sidebar:
contents:`, as nested `section:` entries. To add a model, create its folder
with an `index.qmd` and add that file to the contents of its section (or
sector). A section's name in the sidebar is written in `_quarto.yml`, not
taken from its page.

On a model page, `{{< model-viewer JSON/Model.json view="..." >}}` renders one
view of the model from its JSON description: `card`, `summary`, `flows`,
`equations`, `variables`, `unit`, `streams`, `cc`, `gcc` or `references`
(without `view`, a compact tabbed overview). Variables named in the text as
inline code are linked to their definitions. See
`1-EnergyTechnologies/CoolingTower/index.qmd` for a complete example.

## Building

    ./compileAll.sh            # HTML site, output in _book/

`quarto preview` serves the site locally and reloads on every change.

## Publishing

Every push to `main` runs `.github/workflows/publish.yml`, which renders the
site with Quarto and publishes `_book/` on GitHub Pages. The workflow can also
be run by hand from the repository's Actions tab. Pages must be enabled once,
under Settings > Pages > Build and deployment > Source: GitHub Actions.
