version 19
clear all
set more off

args root
if `"`root'"' == "" {
    display as error "Usage: do code/run.do <absolute-path-to-replication-root>"
    exit 198
}

foreach directory in data code tables figures logs {
    capture confirm file `"`root'/`directory'"'
    if "`directory'" != "data" & "`directory'" != "code" {
        capture mkdir `"`root'/`directory'"'
    }
}
capture mkdir `"`root'/figures/main"'
capture mkdir `"`root'/figures/appendix"'

confirm file `"`root'/data/Villalobos_et_al_2026.dta"'
foreach command in csdid2 csdid2_plot esttab estpost eststo estadd distinct ///
    unique coefplot pretrends grc1leg reghdfe wildbootstrap boottest honestdid {
    capture which `command'
    if _rc {
        display as error "Required Stata command not installed: `command'"
        exit 199
    }
}

do `"`root'/code/validate_data.do"' `"`root'"'
do `"`root'/code/Villalobos et al. 2026.do"' `"`root'"'
do `"`root'/code/verify_outputs.do"' `"`root'"'
exit
