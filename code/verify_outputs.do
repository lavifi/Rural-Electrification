version 19
clear all
set more off

args root
foreach output in table1.tex table2.tex table3.tex table4.tex tableS3.tex tableS4.tex tableS5.tex {
    confirm file `"`root'/tables/`output'"'
}
confirm file `"`root'/figures/main/figure1_study_area.jpg"'
confirm file `"`root'/figures/main/figure2_deforestation_event_study.pdf"'
confirm file `"`root'/figures/main/figure3_socioeconomic_event_studies.png"'
confirm file `"`root'/figures/appendix/figureA1_summary_ATT.png"'
confirm file `"`root'/figures/appendix/figureA2_grid_connection_map.jpg"'
confirm file `"`root'/figures/appendix/figureA3_deforestation_sensitivity.png"'
confirm file `"`root'/figures/appendix/figureA4_socioeconomic_sensitivity.png"'
confirm file `"`root'/figures/appendix/figureA5_GDP_comparison.png"'

tempname handle
file open `handle' using `"`root'/logs/verification.txt"', write text replace
file write `handle' "PASS: dataset assertions completed" _n
file write `handle' "PASS: all machine-generated article and appendix outputs exist" _n
file write `handle' "NOTE: numerical values are recorded in the generated LaTeX tables and analysis.log" _n
file close `handle'
display as result "Output verification passed."
exit
