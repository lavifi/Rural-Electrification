version 19
clear all
set more off

*------------------------------------------------------------------------------*
* REPLICATION INSTRUCTIONS
*
* 1. On the repository's main GitHub page, click the green Code button and
*    select Download ZIP. Extract the ZIP before running any files.
*
* 2. Identify the root directory. This is the extracted folder containing the
*    README.md file and the code, data, figures, and tables subfolders.
*
* 3. Open Stata's Command window. Replace both instances of FULL-PATH below
*    with your own root directory, and enter the entire command on one line:
*
*    do "FULL-PATH/code/run.do" "FULL-PATH"
*
*    Example (Windows):
*    do "C:/Users/YourName/Downloads/Rural-Electrification-main/code/run.do" "C:/Users/YourName/Downloads/Rural-Electrification-main"
*
* 4. Do not run this file directly with the Do button in Stata's Do-file
*    Editor. The root directory must be passed as the second quoted path.
*------------------------------------------------------------------------------*

args root
if `"`root'"' == "" {
    display as error "Replication root not supplied."
    display as error "Run this file from Stata's Command window as:"
    display as error `"do "FULL-PATH/code/run.do" "FULL-PATH""'
    display as error "Replace FULL-PATH with the extracted folder containing README.md, code, and data."
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
