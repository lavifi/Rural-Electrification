version 19
clear all
set more off

args root
confirm file `"`root'/data/Villalobos_et_al_2026.dta"'
use `"`root'/data/Villalobos_et_al_2026.dta"', clear

quietly describe
assert r(k) == 37

* CODEBOOK.md is the authoritative schema for the released dataset.
local required_variables id year sett_year year_se incmilk incbeef inccrop ///
    incoff incgov incometot fridge fans washers microwaves milktanks tvs ///
    phones cell durelecwork durelecplay cattlelot cattlemilk tmilkharv ///
    milkyield price_milk cattle_ha dMBdefor elecyear ///
    electricity_year_round elecyear2_dum electricity_year_round_dum ///
    gvar_lu gvar_lu_imp gvar_se s_socio sluilap sluilsr
foreach variable of local required_variables {
    confirm numeric variable `variable'
}

isid id year
assert !missing(id, year, sett_year)
assert inrange(year, 1985, 2020)
assert inlist(elecyear2_dum, 0, 1, .)
assert inlist(electricity_year_round_dum, 0, 1, .)
assert inlist(s_socio, 1, .)
assert inlist(sluilap, 1, .)
assert inlist(sluilsr, 1, .)

* Electricity timing variables added to the public-use dataset.
assert elecyear == floor(elecyear) if !missing(elecyear)
assert inrange(elecyear, 1979, 2009) if !missing(elecyear)
assert inlist(year, 1996, 2000, 2005, 2009) if !missing(elecyear)
assert electricity_year_round == floor(electricity_year_round) if !missing(electricity_year_round)
assert inrange(electricity_year_round, 1984, 2009) if !missing(electricity_year_round)
assert electricity_year_round == gvar_lu_imp if !missing(electricity_year_round) | !missing(gvar_lu_imp)

* Regular four-unit time scale used for the socioeconomic csdid2 analysis.
assert inlist(year_se, 1996, 2000, 2004, 2008, .)
assert year_se == 1996 if year == 1996
assert year_se == 2000 if year == 2000
assert year_se == 2004 if year == 2005
assert year_se == 2008 if year == 2009
assert missing(year_se) if !inlist(year, 1996, 2000, 2005, 2009)
assert inlist(gvar_se, 1996, 2000, 2004, 2008, 2012, .)

* Documented construction identities.
assert abs(incometot - (incmilk + incbeef + inccrop + incoff + incgov)) <= ///
    1e-6 * max(1, abs(incometot)) ///
    if !missing(incometot, incmilk, incbeef, inccrop, incoff, incgov)
assert durelecwork == fridge + fans + washers + microwaves + milktanks ///
    if s_socio == 1 & ///
    !missing(durelecwork, fridge, fans, washers, microwaves, milktanks)
assert durelecplay == tvs + phones + cell ///
    if s_socio == 1 & !missing(durelecplay, tvs, phones, cell)

* Treatment begins in the calendar year after the recorded connection year.
assert elecyear2_dum == (year > gvar_lu) if !missing(gvar_lu)
assert electricity_year_round_dum == (year > electricity_year_round) ///
    if !missing(electricity_year_round)

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
