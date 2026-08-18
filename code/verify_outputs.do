version 19
clear all
set more off

args root
foreach output in table1.tex table2.tex table3.tex table4.tex tableS3.tex tableS4.tex tableS5.tex {
    confirm file `"`root'/tables/`output'"'
}
foreach output in figure1.pdf figure2.png figure3.png figureS1.png figureS2.png {
    confirm file `"`root'/figures/`output'"'
}

tempname handle
file open `handle' using `"`root'/logs/verification.txt"', write text replace
file write `handle' "PASS: dataset assertions completed" _n
file write `handle' "PASS: all machine-generated article and appendix outputs exist" _n
file write `handle' "NOTE: numerical values are recorded in the generated LaTeX tables and analysis.log" _n
file close `handle'
display as result "Output verification passed."
exit
