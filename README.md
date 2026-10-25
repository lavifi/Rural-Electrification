# Replication package: Rural Electrification in the Brazilian Amazon

This repository reproduces the quantitative results in Laura Villalobos, Jill Caviglia-Harris, Daniel Harris, and Elaine Frey, “Rural Electrification in the Brazilian Amazon: No Environment-Development Tradeoff,” *Land Economics* (2026), https://doi.org/10.3368/le.103.1.020926-0023.

## Contents

- `data/Villalobos_et_al_2026.dta`: analysis-ready, de-identified property-year panel containing 37 documented variables.
- `code/run.do`: portable entry point for the complete Stata workflow.
- `code/Villalobos et al. 2026.do`: analysis that produces the reported tables and figures.
- `tables/`: machine-generated LaTeX tables plus two documented, externally sourced descriptive tables.
- `figures/main/`: final Figures 1–3, named to match the published paper.
- `figures/appendix/`: final Appendix Figures A1–A5, named to match the published appendix.
- `CODEBOOK.md`: variable definitions, samples, units, and missingness conventions.
- `REPLICATION.md`: software requirements, runtime instructions, and exhibit mapping.
- `MANIFEST.md`: provenance and reproducibility status of each reported exhibit.
- `output/pdf/Replication_Documentation.pdf`: PDF copy of the README, reproduction instructions, codebook, manifest, and known-issues notes.

## Quick start

Stata 19 is recommended.

1. Open the repository's [main GitHub page](https://github.com/lavifi/Rural-Electrification).
2. Above the repository file list, click the green **Code** button, then select **Download ZIP**. This is the green GitHub button, not the folder named `code` in the repository.
3. Right-click the downloaded ZIP and select **Extract All**. Do not open or run `run.do` from inside the compressed ZIP folder, because Windows may use a temporary path that Stata cannot find later.
4. Open Stata.
5. Identify the full path to the extracted root folder. The root is the folder containing `README.md` and the `code`, `data`, `figures`, and `tables` subfolders. You must replace `FULL-PATH` in the commands below with this folder path.
6. If this is the first run, enter the following in Stata's **Command** window:

```stata
do "FULL-PATH/code/install_stata_packages.do"
```

7. Enter the following as one command in Stata's **Command** window:

```stata
do "FULL-PATH/code/run.do" "FULL-PATH"
```

For example:

```stata
do "C:/Users/username/Downloads/Rural-Electrification-main/code/run.do" "C:/Users/username/Downloads/Rural-Electrification-main"
```

`FULL-PATH` is a placeholder that the user must replace; it is not a literal folder name. The first path identifies the do-file. The second path is not another do-file: it passes the user-supplied root folder to the script. Opening `run.do` and clicking Stata's Run button without supplying the second path is not sufficient.

The entry point accepts paths containing spaces. It reads the released dataset, overwrites generated tables and figures in place, and writes `logs/analysis.log`. No code edits are required. All analysis is written in Stata; the `.md` files are documentation, not R Markdown programs.

## Reproducibility scope

The released Stata file reproduces Tables 1–4, Appendix Tables A3–A5, main Figures 2–3, and Appendix Figures A1, A3, and A4. Main Figure 1, Appendix Figure A2, Appendix Figure A5, and Appendix Tables A1–A2 use GIS or public-source inputs that are not contained in the analysis dataset; their provenance is documented in `MANIFEST.md`. The package includes their final static files.

## Data protection

The released data contain anonymous lot identifiers and no names, addresses, coordinates, or contact information. The identifiers are stable over time so that users can reproduce the panel estimators.

## Contact

Laura Villalobos, Salisbury University: lxvillalobos@salisbury.edu.
