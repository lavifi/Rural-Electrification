version 19
clear all
set more off

args root
if `"`root'"' == "" {
    display as error "Usage: do code/00_build_public_data.do <replication-root>"
    exit 198
}

confirm file `"`root'/source_data/Villalobos_et_al_2026_original.dta"'
use `"`root'/source_data/Villalobos_et_al_2026_original.dta"', clear
isid id year

tempfile id_map
preserve
keep id
duplicates drop
set seed 20260818
generate double random_order = runiform()
sort random_order id
generate double public_id = _n
drop random_order
isid id
save `id_map'
restore

merge m:1 id using `id_map', assert(match) nogen
drop id
rename public_id id
label variable id "Randomly assigned public property identifier"
order id year
sort id year
isid id year
compress
save `"`root'/data/Villalobos_et_al_2026.dta"', replace
exit
