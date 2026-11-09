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

* Generate outputs away from the released final filenames. A failed analysis
* can therefore leave only staged files, not a partial file that looks final.
local staging `"`root'/logs/output_staging"'
capture mkdir `"`staging'"'
capture mkdir `"`staging'/tables"'
capture mkdir `"`staging'/figures"'
capture mkdir `"`staging'/figures/main"'
capture mkdir `"`staging'/figures/appendix"'

local generated_tables table1.tex table2.tex table3.tex table4.tex ///
    tableS3.tex tableS4.tex tableS5.tex
local generated_main figure2_deforestation_event_study.pdf ///
    figure3_socioeconomic_event_studies.png
local generated_appendix figureA1_summary_ATT.png ///
    figureA3_deforestation_sensitivity.png ///
    figureA4_socioeconomic_sensitivity.png

foreach output of local generated_tables {
    capture erase `"`staging'/tables/`output'"'
}
foreach output of local generated_main {
    capture erase `"`staging'/figures/main/`output'"'
}
foreach output of local generated_appendix {
    capture erase `"`staging'/figures/appendix/`output'"'
}

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
do `"`root'/code/Villalobos et al. 2026.do"' `"`root'"' `"`staging'"'

* Confirm that this run created every generated artifact before replacing any
* released output. The final verification below also checks supplied exhibits.
do `"`root'/code/verify_outputs.do"' `"`root'"' `"`staging'"' 0

foreach output of local generated_tables {
    copy `"`staging'/tables/`output'"' `"`root'/tables/`output'"', replace
}
foreach output of local generated_main {
    copy `"`staging'/figures/main/`output'"' ///
        `"`root'/figures/main/`output'"', replace
}
foreach output of local generated_appendix {
    copy `"`staging'/figures/appendix/`output'"' ///
        `"`root'/figures/appendix/`output'"', replace
}

do `"`root'/code/verify_outputs.do"' `"`root'"' `"`root'"' 1
exit
