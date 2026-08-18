# Known issues and interpretation notes

## Table 2 property count

The released panel has 156 distinct properties in the socioeconomic sample (`s_socio == 1`) and 468 property-year rows. Total income is observed in 458 rows: 151 in 1996, 156 in 2000, and 151 in 2005.

The published Table 2 reports 151 under “Number of properties” in its “All years” column. This is reproduced by the historical analysis code, which tags the first observation for each property and then requires nonmissing total income on that tagged row. Since the first row is the 1996 observation, the statistic equals the number with nonmissing 1996 income, not the number of distinct properties represented over all survey years. The correct distinct-property count across the socioeconomic sample is 156. This discrepancy affects only the descriptive count; it does not alter any estimate or analysis sample.

## Static exhibits

The original packet does not include the raw GIS layers/project or public-data acquisition scripts needed to regenerate article Figure 1, Appendix Figure A2, Appendix Figure A5, or Appendix Tables A1–A2. The final static exhibits and their source notes are supplied. See `MANIFEST.md`.

## Historical filenames

The final article inserted the study-area map as Figure 1. Several existing filenames retain earlier numbering: `figure1.pdf` is article Figure 2, `figure3.png` is article Figure 3, and `figure4.jpg` is article Figure 1. `REPLICATION.md` provides the authoritative mapping.
