# Codebook

## Dataset overview

`data/Villalobos_et_al_2026.dta` is an unbalanced property-year panel for rural properties in Greater Ouro Preto do Oeste, Rondônia, Brazil (`studycode == 2` in the source survey panel). It contains 343,332 observations for 9,537 anonymous lots over 1985–2020. The unit of observation is a lot-year.

The source construction retains years 1985–2020 and excludes lots occupied by renters (`type == 3` in any observed wave). The released data contain no names, addresses, coordinates, or contact details.

## Coding and missing values

- A dot (`.`) is Stata numeric missing.
- Electricity indicators use `0 = not connected` and `1 = connected`.
- Sample indicators use `1 = included`; observations outside the indicated sample are missing, not zero.
- Survey variables are structurally missing outside survey observations.
- For interviewed households in 1996, 2000, 2005, 2009, or 2019, missing activity-income values were coded as zero because they indicate no income from that activity.
- Appliances not included in early questionnaires were coded as zero for interviewed households. These are assumed zeros because survey design and piloting indicated that the appliances were not present or materially relevant, rather than directly observed zeros.
- The released `.dta` contains no Stata value-label definitions.

## Monetary variables

All released income variables are annual gross revenue in thousands of 2019 Brazilian reais (R$); production costs are not deducted. Milk and beef revenue and crop revenue are derived from on-property activities. Off-property revenue is labor income from activities such as hourly or part-time work on another property, retail work, commercial sales, or other professions.

The historical income variables used in the paper's 1996, 2000, and 2005 socioeconomic analysis were reported in real values and treated by the historical construction workflow as constant year-2000 reais. The construction code converts them to constant year-2019 reais using the Brazilian consumer price index (`FP.CPI.TOTL`, World Development Indicators), multiplying by `CPI_2019 / CPI_2000`, and then divides by 1,000. The 2019 survey wave is not part of the paper's socioeconomic analysis.

Government payments combine pensions/social-security income, Bolsa Escola, and Bolsa Família. The paper describes the latter programs collectively as Brazilian cash transfers.

## Variable definitions

### Identifiers and time

| Variable | Definition and coding |
|---|---|
| `id` | Anonymous lot identifier, stable across years. Household-lot matches across survey waves were based on the same identifier and manually checked. |
| `year` | Calendar year, 1985–2020. |
| `sett_year` | Year in which the settlement was established. |
| `year_se` | Equally spaced socioeconomic-analysis time index used with `csdid2`: survey years 1996, 2000, 2005, and 2009 are coded 1996, 2000, 2004, and 2008, respectively. The original survey years have irregular four- and five-year gaps, which prevented the command from identifying the appropriate pre-treatment comparison periods for the dynamic-effects analysis. Following guidance from the command's author, the recoding makes every transition between successive survey waves one regular four-unit interval and aligns the time index with the cohort codes in `gvar_se`. |

### Income outcomes

| Variable | Definition and construction |
|---|---|
| `incmilk` | Annual income from on-property milk production, thousands of 2019 R$. |
| `incbeef` | Annual income from on-property beef production, thousands of 2019 R$. Beef income was not collected in the earliest survey and is coded zero for interviewed households when missing. |
| `inccrop` | Annual crop income, thousands of 2019 R$: annual-crop income plus perennial-crop income. |
| `incoff` | Annual off-property labor income, thousands of 2019 R$. |
| `incgov` | Annual government payments, thousands of 2019 R$: pensions/social security plus Bolsa Escola and Bolsa Família. |
| `incometot` | Total annual income, thousands of 2019 R$: `incmilk + incbeef + inccrop + incoff + incgov`. |

The component-sum identity for `incometot` holds up to floating-point rounding in the released data.

### Appliances

| Variable | Definition and coding |
|---|---|
| `fridge` | Number of refrigerators and freezers owned by the household. |
| `fans` | Number of fans owned by the household. |
| `washers` | Number of washing machines owned by the household. Not included in some early questionnaires; assumed zero for interviewed households when unrecorded. |
| `microwaves` | Number of microwaves owned by the household. Not included in some early questionnaires; assumed zero for interviewed households when unrecorded. |
| `milktanks` | Number of milk tanks owned by the household. Not included in some early questionnaires; assumed zero for interviewed households when unrecorded. |
| `tvs` | Number of televisions owned by the household. |
| `phones` | Number of landline telephones owned by the household. |
| `cell` | Number of cell phones owned by the household. Not included in early questionnaires; assumed zero for interviewed households when unrecorded. |
| `durelecwork` | Work-appliance count: `fridge + fans + washers + microwaves + milktanks`. |
| `durelecplay` | Leisure-appliance count: `tvs + phones + cell`. |

The two appliance-index identities hold exactly in the released data.

### Livestock and milk production

| Variable | Definition and construction |
|---|---|
| `cattlelot` | Total number of cattle owned on the lot. |
| `cattlemilk` | Number of milk cows. |
| `tmilkharv` | Sum of dry-season and wet-season daily milk harvest, liters/day. An observed seasonal value is retained when the other seasonal value is missing; the result is missing only when both seasonal values are missing. In `s_socio`, both seasonal values are missing for 10 observations (5 in 1996 and 5 in 2005). |
| `milkyield` | Total daily milk harvest divided by the number of milk cows, liters/day/cow. A zero denominator produces missing. |
| `price_milk` | Simple, unweighted mean of the dry- and wet-season milk prices, expressed in 2019 R$/liter. Both seasonal prices were asked in the survey. Following the paper's analysis code, each seasonal input price is multiplied by the common `CPI_2019 / CPI_2000` factor before the mean is calculated. |
| `cattle_ha` | Total cattle (`cattlelot`) divided by household-reported pasture area in hectares. A zero pasture denominator produces missing. |

### Land use

The land-cover source is **MapBiomas Version 6: SDSU Filtered Product - OPO lots**. It provides annual 30-meter land-cover measurements for the study properties over 1985–2020.

| Variable | Definition and construction |
|---|---|
| `dMBdefor` | Annual change in MapBiomas forest area, hectares: forest area in year `t-1` minus forest area in year `t`. Positive values represent measured forest loss; negative values represent measured forest gain or year-to-year classification variability. The value is missing for the first observed year of each lot or when years are not consecutive. |

The MapBiomas lot-area check sums forest, savanna, wetland, grassland, pasture, urban, water, soybean, other, and cloud classes. Lots whose calculated area exceeds 600 hectares are excluded from the land-use analysis.

### Electricity treatment

| Variable | Definition and coding |
|---|---|
| `elecyear` | Raw self-reported calendar year in which the household was connected to the electricity grid. It is recorded only on the relevant survey observation and is otherwise missing; it is not repeated across all annual records for a lot. |
| `electricity_year_round` | Rounded interpolated grid-connection year, repeated across the annual records for a lot when available. Interpolated values are rounded to the nearest integer using `floor(value + 0.5)`. This released field is identical to `gvar_lu_imp` wherever observed. |
| `elecyear2_dum` | Combined grid-treatment indicator. Equals one beginning in the calendar year after the combined connection year. |
| `electricity_year_round_dum` | Interpolation-only grid-treatment indicator. Equals one beginning in the calendar year after the rounded interpolated connection year. |
| `gvar_lu` | Combined grid-connection year for the preferred land-use specification. The self-reported connection year is used when available; otherwise the rounded interpolated year is used. |
| `gvar_lu_imp` | Rounded interpolated grid-connection year used for the interpolation-only robustness specification. Interpolated years are rounded to the nearest integer using `floor(value + 0.5)`. |
| `gvar_se` | Socioeconomic treatment cohort on the equally spaced survey index: connection before 1996 → 1996; 1996–1999 → 2000; 2000–2004 → 2004; 2005–2008 → 2008; 2009 or later → 2012. |

Because outcomes are annual and connection may occur at any point within a year, treatment begins in the year after the recorded connection year.

### Analysis samples

| Variable | Definition and coding |
|---|---|
| `s_socio` | Equals one for observations in 1996, 2000, or 2005 belonging to households interviewed in at least two of those waves. The panel matches use the same anonymous lot identifier and were manually checked. The 2009 wave is omitted because about 96% of properties had electricity by then, leaving too few untreated observations for a credible control group. |
| `sluilap` | Equals one for the preferred land-use sample: private properties with MapBiomas-calculated lot area no greater than 600 hectares in settlements established before 2000. |
| `sluilsr` | Equals one for the self-reported-treatment-year robustness sample: properties satisfying `sluilap` that also have a self-reported connection year. |
