# Reproduction instructions

## Software

- Stata 19 (tested with Stata/SE 19.5 on Windows).
- User-written Stata commands: `csdid2` (including `csdid2_plot`), `estout`, `distinct`, `unique`, `coefplot`, `pretrends`, `grc1leg`, `reghdfe`, `wildbootstrap`, `boottest`, and `honestdid`.
- A LaTeX distribution is optional and is needed only to typeset the generated `.tex` tables in a separate document.

The analysis stops with a readable error if the dataset or a required command is unavailable. Internet access is not required after the listed Stata packages have been installed.

For a first-time setup, inspect and run `code/install_stata_packages.do` while connected to the internet. The successful verification run used `estout` 3.31, `unique` 1.2.4, `coefplot` 1.8.8, `pretrends` 0.5.1, `grc1leg` 1.0.5, `reghdfe` 6.12.5, and `honestdid` 1.3.0.

## Run

If the repository was downloaded as a ZIP file, first right-click the ZIP and select **Extract All**. Do not run the code from inside the compressed ZIP folder: Windows may open it from a temporary location that Stata cannot find later.

Open Stata and enter the following as one command in the **Command** window:

```stata
do "FULL-PATH/code/run.do" "FULL-PATH"
```

Replace both instances of `FULL-PATH` with the absolute path to the extracted replication folder. For example:

```stata
do "C:/Users/username/Downloads/Rural-Electrification-main/code/run.do" "C:/Users/username/Downloads/Rural-Electrification-main"
```

The first quoted path identifies `run.do`. The second quoted path is the script's root-directory argument, not another do-file. It must identify the folder containing `README.md`, `code`, `data`, `figures`, and `tables`. Opening `run.do` in the Do-file Editor and clicking Run without passing that argument will produce an error.

The master script uses a fixed bootstrap seed (`123456789`) and overwrites generated outputs. A text log is written to `logs/analysis.log`.

Expected runtime depends on hardware. The land-use panel contains 343,332 property-year observations, and repeated bootstrap inference is the slowest stage.

## Expected samples

- Full released panel: 343,332 observations, 9,537 properties, 1985–2020.
- Main land-use sample: 304,920 observations, 8,470 properties, 36 years.
- Socioeconomic panel sample: 468 observations from 156 properties across the 1996, 2000, and 2005 survey waves; total income is nonmissing for the 458 rows used in Table 2.
- Socioeconomic estimation sample: 330 household-year observations from 110 households not treated in 1996 and observed at least twice.

## Output mapping

Final figure filenames follow the numbering in the published paper:

| Article exhibit | Generated or supplied file |
|---|---|
| Table 1 | `tables/table1.tex` |
| Table 2 | `tables/table2.tex` |
| Table 3 | `tables/table3.tex` |
| Table 4 | `tables/table4.tex` |
| Figure 1 | `figures/main/figure1_study_area.jpg` (supplied GIS output) |
| Figure 2 | `figures/main/figure2_deforestation_event_study.pdf` |
| Figure 3 | `figures/main/figure3_socioeconomic_event_studies.png` |
| Appendix Table A1 | `tables/t_des_census.tex` (supplied public-source table) |
| Appendix Table A2 | `tables/t_interpolation.tex` (supplied GIS-method table) |
| Appendix Table A3 | `tables/tableS3.tex` |
| Appendix Table A4 | `tables/tableS4.tex` |
| Appendix Table A5 | `tables/tableS5.tex` |
| Appendix Figure A1 | `figures/appendix/figureA1_summary_ATT.png` |
| Appendix Figure A2 | `figures/appendix/figureA2_grid_connection_map.jpg` (supplied GIS output) |
| Appendix Figure A3 | `figures/appendix/figureA3_deforestation_sensitivity.png` |
| Appendix Figure A4 | `figures/appendix/figureA4_socioeconomic_sensitivity.png` |
| Appendix Figure A5 | `figures/appendix/figureA5_GDP_comparison.png` (supplied World Bank/OECD chart) |
