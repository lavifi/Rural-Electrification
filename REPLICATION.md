# Reproduction instructions

## Software

- Stata 19 (tested with Stata/SE 19.5 on Windows).
- User-written Stata commands: `csdid2`, `estout`, `distinct`, `unique`, `coefplot`, `pretrends`, `grc1leg`, `reghdfe`, `wildbootstrap`, `boottest`, and `honestdid`.
- A LaTeX distribution is optional and is needed only to rebuild the tables-and-figures PDF.

The analysis stops with a readable error if the dataset or a required command is unavailable. Internet access is not required after the listed Stata packages have been installed.

For a first-time setup, inspect and run `code/install_stata_packages.do` while connected to the internet. The successful verification run used `estout` 3.31, `unique` 1.2.4, `coefplot` 1.8.8, `pretrends` 0.5.1, `grc1leg` 1.0.5, `reghdfe` 6.12.5, and `honestdid` 1.3.0; the analysis log records the Stata environment used for the release.

## Run

Execute `code/run.do` and pass the absolute replication-root path as its only argument. The master script uses a fixed bootstrap seed (`123456789`) and overwrites generated outputs. A text log is written to `logs/analysis.log`.

Expected runtime depends on hardware. The land-use panel contains 343,332 property-year observations, and repeated bootstrap inference is the slowest stage.

## Expected samples

- Full released panel: 343,332 observations, 9,537 properties, 1985–2020.
- Main land-use sample: 304,920 observations, 8,470 properties, 36 years.
- Socioeconomic descriptive sample: 458 observations across the 1996, 2000, and 2005 survey waves.
- Socioeconomic estimation sample: 330 household-year observations from 110 households not treated in 1996 and observed at least twice.

## Output mapping

The journal pre-print numbers the study-area map as Figure 1. Accordingly, the code’s historical filenames do not always equal the article number:

| Article exhibit | Generated or supplied file |
|---|---|
| Table 1 | `tables/table1.tex` |
| Table 2 | `tables/table2.tex` |
| Table 3 | `tables/table3.tex` |
| Table 4 | `tables/table4.tex` |
| Figure 1 | `figures/figure4.jpg` (supplied GIS output) |
| Figure 2 | `figures/figure1.pdf` |
| Figure 3 | `figures/figure3.png` |
| Appendix Table A1 | `tables/t_des_census.tex` (supplied public-source table) |
| Appendix Table A2 | `tables/t_interpolation.tex` (supplied GIS-method table) |
| Appendix Table A3 | `tables/tableS3.tex` |
| Appendix Table A4 | `tables/tableS4.tex` |
| Appendix Table A5 | `tables/tableS5.tex` |
| Appendix Figure A2 | `figures/figure5.jpg` (supplied GIS output) |
| Appendix Figure A3 | `figures/figureS1.png` |
| Appendix Figure A4 | `figures/figureS2.png` |
| Appendix Figure A5 | `figures/figureS3.png` (supplied World Bank/OECD chart) |

`figures/figure2.png` is an additional compact ATT plot used in the appendix compilation but not assigned a main-text number in the final pre-print.
