version 19
clear all
set more off

args root
confirm file `"`root'/data/Villalobos_et_al_2026.dta"'
use `"`root'/data/Villalobos_et_al_2026.dta"', clear

isid id year
assert !missing(id, year, sett_year)
assert inrange(year, 1985, 2020)
assert inlist(elecyear2_dum, 0, 1, .)
assert inlist(electricity_year_round_dum, 0, 1, .)
assert inlist(s_socio, 1, .)
assert inlist(sluilap, 1, .)
assert inlist(sluilsr, 1, .)

count
assert r(N) == 343332
quietly distinct id
assert r(ndistinct) == 9537
quietly distinct year
assert r(ndistinct) == 36

count if sluilap == 1
assert r(N) == 304920
quietly distinct id if sluilap == 1
assert r(ndistinct) == 8470

count if s_socio == 1
assert r(N) == 468
quietly distinct id if s_socio == 1
assert r(ndistinct) == 156
count if s_socio == 1 & !missing(incometot)
assert r(N) == 458
quietly distinct id if s_socio == 1 & gvar_se != 1996
assert r(ndistinct) == 110
count if s_socio == 1 & gvar_se != 1996
assert r(N) == 330

display as result "Dataset validation passed."
exit
