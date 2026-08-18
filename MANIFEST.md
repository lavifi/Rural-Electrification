# Exhibit provenance manifest

## Fully reproduced from the released dataset

The master Stata script regenerates article Tables 1–4; Appendix Tables A3–A5; article Figures 2–3; and Appendix Figures A3–A4. Intermediate `.gph` files are retained to make Stata graph editing possible.

## Supplied static outputs

- Article Figure 1 (`figures/main/figure1_study_area.jpg`) is a GIS study-area map assembled from settlement, road, municipal, and urban-hierarchy layers.
- Appendix Figure A2 (`figures/appendix/figureA2_grid_connection_map.jpg`) is the GIS interpolation map of connection timing.
- Appendix Figure A5 (`figures/appendix/figureA5_GDP_comparison.png`) is based on World Bank national accounts and OECD National Accounts data.
- Appendix Table A1 (`tables/t_des_census.tex`) uses IBGE SIDRA tables 200, 5938, 3939, 94, and 74; the manuscript notes substitutions of 1997 population and 1999 GDP where 1996 values were unavailable.
- Appendix Table A2 (`tables/t_interpolation.tex`) records GIS interpolation parameters assembled from INCRA records, program timing, and survey reports.

These exhibits are included for completeness but cannot be independently regenerated from the released `.dta` file alone. A future expanded archive should add the source GIS project/layers and the public-data download/processing scripts if redistribution terms allow.
