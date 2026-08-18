# Replication package: Rural Electrification in the Brazilian Amazon

This repository reproduces the quantitative results in Laura Villalobos, Jill Caviglia-Harris, Daniel Harris, and Elaine Frey, “Rural Electrification in the Brazilian Amazon: No Environment-Development Tradeoff,” *Land Economics* (2026), https://doi.org/10.3368/le.103.1.020926-0023.

## Contents

- `data/Villalobos_et_al_2026.dta`: analysis-ready, de-identified property-year panel.
- `code/run.do`: portable entry point for the complete Stata workflow.
- `code/Villalobos et al. 2026.do`: analysis that produces the reported tables and figures.
- `tables/`: machine-generated LaTeX tables plus two documented, externally sourced descriptive tables.
- `figures/`: machine-generated figures and three documented externally produced figures.
- `CODEBOOK.md`: variable definitions, samples, units, and missingness conventions.
- `REPLICATION.md`: software requirements, runtime instructions, and exhibit mapping.
- `MANIFEST.md`: provenance and reproducibility status of each reported exhibit.

## Quick start

Stata 19 is recommended. From a terminal, replace the path below with the absolute path to this repository:

```text
StataSE-64.exe /e do "<replication-root>/code/run.do" "<replication-root>"
```

The entry point accepts paths containing spaces. It reads the released dataset, overwrites generated tables and figures in place, and writes `logs/analysis.log`. No code edits are required.

## Reproducibility scope

The released Stata file reproduces Tables 1–4, Appendix Tables A3–A5, main Figures 2–3, and Appendix Figures A3–A4. Main Figure 1, Appendix Figure A2, Appendix Figure A5, and Appendix Tables A1–A2 use GIS or public-source inputs that are not contained in the analysis dataset; their provenance is documented in `MANIFEST.md`. The package includes their final static files where available.

## Data protection

The released data contain anonymous lot identifiers and no names, addresses, coordinates, or contact information. The identifiers are stable over time so that users can reproduce the panel estimators.

## Contact

Laura Villalobos, Salisbury University: lxvillalobos@salisbury.edu.
