# Codebook

The dataset is an unbalanced property-year panel. A dot (`.`) is Stata numeric missing. Survey-only variables are missing outside survey observations by design. Monetary variables are annual thousands of 2019 Brazilian reais unless otherwise noted.

| Variable | Definition |
|---|---|
| `id` | Anonymous lot identifier; stable over time. |
| `year` | Calendar year, 1985–2020. |
| `sett_year` | Settlement establishment year. |
| `cattlelot` | Number of cattle owned on the property. |
| `cattlemilk` | Number of milk cows. |
| `incmilk` | Milk income. |
| `incbeef` | Beef income. |
| `incoff` | Off-property income. |
| `incometot` | Total income: milk, beef, crop, off-property, and government-payment income. |
| `inccrop` | Crop income. |
| `incgov` | Government payments. |
| `tvs` | Televisions owned. |
| `phones` | Landline phones owned. |
| `cell` | Cell phones owned; collected in 2009. |
| `microwaves` | Microwaves owned; collected in 2005 and later. |
| `fridge` | Refrigerators and freezers owned. |
| `milktanks` | Milk tanks owned. |
| `washers` | Washing machines owned; collected in 2005 and later. |
| `fans` | Fans owned. |
| `durelecwork` | Count of work-related electrical appliances. |
| `durelecplay` | Count of leisure electrical appliances. |
| `tmilkharv` | Milk harvested, liters per day. |
| `milkyield` | Milk yield, liters per day per cow. |
| `price_milk` | Milk price, reais per liter. |
| `dMBdefor` | Annual deforestation, hectares. Negative values can arise from year-to-year land-cover classification changes. |
| `cattle_ha` | Cattle per hectare of pasture. |
| `elecyear2_dum` | Indicator for connection to the electricity grid under the combined timing measure. |
| `electricity_year_round_dum` | Indicator for grid connection under the interpolated timing measure. |
| `gvar_lu` | First grid-connection year for the combined land-use treatment definition. |
| `gvar_lu_imp` | First grid-connection year under the interpolated land-use treatment definition. |
| `gvar_se` | First grid-connection year used for the socioeconomic analysis. |
| `year_se` | Survey year recoded for the socioeconomic event-study spacing. |
| `s_socio` | Indicator for the socioeconomic analysis sample. |
| `sluilap` | Indicator for the main land-use sample. |
| `sluilsr` | Indicator for the self-reported-treatment-year robustness sample. |

The dataset contains no names, addresses, coordinates, or contact details.
