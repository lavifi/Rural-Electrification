 
version 19
clear all
set more off
capture log close _all

args folder
if `"`folder'"' == "" {
	display as error "Replication root not supplied. Run: do code/run.do <replication-root>"
	exit 198
}

global folder `"`folder'"'
global data $folder/data
global figures $folder/figures
global tables $folder/tables

capture mkdir "$folder/logs"
log using "$folder/logs/analysis.log", text replace name(analysis)

/*
ssc install mdesc
ssc install unique
ssc install estout
ssc install distinct
net install csdid2, from("https://friosavila.github.io/stpackages")
ssc install honestdid
ssc install coefplot
ssc install pretrends
net install grc1leg, from(http://www.stata.com/users/vwiggins/)
ssc install reghdfe, replace
ssc install boottest, replace
*/

capture log close
global opts2  a f plain coll(none) nodep nomti c(b(star fmt(%9.2f)) se(abs par fmt(%9.2f))) star(* .10 ** .05 *** .01) noobs 

// ANALYSIS
//------------------------------------------------------------------------------	
	use "$data\Villalobos_et_al_2026.dta"  , replace
//------------------------------------------------------------------------------	
// GLOBALS
//------------------------------------------------------------------------------			
	global control_vars i.sett_year
	global se_outcomes incometot incmilk incbeef inccrop incoff incgov durelecwork durelecplay
	global se_descstats elecyear2_dum $se_outcomes sett_year
	
	global lu_outcomes dMBdefor 
	global lu_descstats gvar_lu $lu_outcomes sett_year

	global appliances fridge milktanks fans washers microwaves cell tvs phones 
	global method dripw 

	global milk tmilkharv cattlemilk milkyield price_milk

//------------------------------------------------------------------------------	
// In-text stats
//------------------------------------------------------------------------------			
	// Baseline number of cows per hectare of pasture
	sum cattle_ha if s_socio==1 & year==1996 & cattlelot!=0
 		
	*There are 110 households (330 observations) interviewed at least twice during 1996, 2000, 2005 that are not yet treated by 1996.
	unique id if s_socio==1 & gvar_se!=1996

//------------------------------------------------------------------------------
// LAND USE ANALYSIS - DEFORESTATION
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------ 
// TABLE 1 - DESCRIPTIVE STATS: LAND USE ANALYSIS
//------------------------------------------------------------------------------

	// --- All plots ---
	eststo desc1: estpost summarize $lu_descstats if  sluilap==1

	distinct id if sluilap==1
	local n_id1 = r(ndistinct)

	distinct year if sluilap==1
	local n_year1 = r(ndistinct)

	estadd scalar N_id = `n_id1'
	estadd scalar N_year = `n_year1'


	// --- Plots with self-reported connection year ---
	eststo desc3: estpost summarize $lu_descstats if  sluilsr==1

	distinct id if sluilsr==1 
	local n_id3 = r(ndistinct)

	distinct year if sluilsr==1 
	local n_year3 = r(ndistinct)

	estadd scalar N_id = `n_id3'
	estadd scalar N_year = `n_year3'

	* --- Export the table ---
	esttab desc1 using "$tables/table1.tex", replace ///
		stats(N N_id N_year, fmt(0) labels("Observations" "Number of properties" "Number of years")) ///
		cells(mean(fmt(2)) sd(par)) nonumber compress noobs gap label booktabs ///
		collabels(none) mtitle("(1)" "(2)" "(3)") ///
		refcat(gvar_lu "{\addstackgap[6]A. Treatment}" ///
			   dMBdefor "{\addstackgap[6]B. Outcome}" ///
			   sett_year "{\addstackgap[6]C. Control variables}", nolabel) ///
		mgroups("\shortstack{All properties}"   , pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span)

		
	
estimates clear 
//------------------------------------------------------------------------------
//  TABLE 3 - ATT OF ELECTRICITY ON DEFORESTATION (HA)
//------------------------------------------------------------------------------

	foreach s in sluilap sluilsr {
		preserve
		keep if  `s'==1
		local revent -10/10
		
		foreach var of varlist $lu_outcomes {
		local label `: variable label `var''
		local label_sample `: variable label `s''
		di as txt "s=`s'  label_sample=|`label_sample'|"

		
		//outcome mean at baseline
		sum `var' if  elecyear2_dum==0
		scalar baseline`var'_`s'=r(mean) 
		
		//ATT
		csdid2 `var' $control_vars, ivar(id) time(year) gvar(gvar_lu) notyet method($method)
		estat event, revent(`revent') estore(evt`var'_`s') 
		estat simple,  revent(`revent')  estore(simple`var'_`s') 

		estimates restore simple`var'_`s'
		
		estadd scalar Mean  = baseline`var'_`s'
		estadd scalar LCI  = 100*((_b[SimpleATT]) -1.96*_se[SimpleATT])	/(baseline`var'_`s')
		estadd scalar UCI  = 100*((_b[SimpleATT]) +1.96*_se[SimpleATT])	/(baseline`var'_`s')

		
		estimates restore evt`var'_`s'

		estat event, revent(`revent')

		csdid2_plot, ///
			graphregion(color(white)) ///
			title("", size(medium)) ///
			ytitle("") ///
			legend(off) ///
			name(evt_`var'_`s', replace)

	graph save "$figures\plotwb_`var'_`s'_covs.gph", replace	
		}	
		restore
	}


//------------------------------------------------------------------------------
// ROBUSTNESS SAMPLE - PREDICTED (IMPUTATION) VARIABLE
//------------------------------------------------------------------------------
	foreach s in sluilap {
		preserve
		keep if  `s'==1
		keep if sett_year<2000
		local revent -10/10
		
		foreach var of varlist $lu_outcomes {
		local label `: variable label `var''
		local label_sample `: variable label `s''
		di as txt "s=`s'  label_sample=|`label_sample'|"

		
		//Mean outcome at baseline
		sum `var' if  electricity_year_round_dum==0
		scalar baseline`var'_`s'=r(mean) 
		
		//ATT
		csdid2 `var' $control_vars, ivar(id) time(year) gvar(gvar_lu_imp) notyet method($method)
		estat event, revent(`revent') estore(evt`var'_`s'imp) 
		estat simple,  revent(`revent')  estore(simple`var'_`s'imp) 

		estimates restore simple`var'_`s'imp
		
		estadd scalar Mean  = baseline`var'_`s'
		estadd scalar LCI  = 100*((_b[SimpleATT]) -1.96*_se[SimpleATT])	/(baseline`var'_`s')
		estadd scalar UCI  = 100*((_b[SimpleATT]) +1.96*_se[SimpleATT])	/(baseline`var'_`s')

		
		estimates restore evt`var'_`s'imp
		
		estat event, revent(`revent')

		csdid2_plot, ///
			graphregion(color(white)) ///
			title("5-year window", size(medium)) ///
			ytitle("") ///
			legend(off) ///
			name(evt_`var'_`s'5, replace)

		graph save "$figures\plotwb_`var'_`s'_covsimp.gph", replace
		}	
		restore
	}

//------------------------------------------------------------------------------	 
	cd "$tables"
	file open t using table3.tex, replace write
	file write t "\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}l*{3}{c}}" _n ///
		"\toprule" _n ///
		"& \multicolumn{1}{c}{\shortstack{All properties}}" ///
		"& \multicolumn{1}{c}{\shortstack{Robustness sample}}" ///	
		"& \multicolumn{1}{c}{\shortstack{Robustness treatment}} \\" _n ///
		"& (1) & (2) & (3) \\" _n ///
		"\midrule" _n
	file close t

	esttab  ///
		simpledMBdefor_sluilap ///
		simpledMBdefor_sluilsr  ///
		simpledMBdefor_sluilapimp  ///
		using table3.tex, ///
		coeflabels(SimpleATT "ATT") l  s(, lay(`""'))  $opts2 

	esttab  ///
		evtdMBdefor_sluilap ///
		evtdMBdefor_sluilsr ///
		evtdMBdefor_sluilapimp ///
		using table3.tex, ///
		keep(Pre_avg) coeflabels(Pre_avg "Pre-trend")  l  $opts2 	
		
	esttab ///
		simpledMBdefor_sluilap ///
		simpledMBdefor_sluilsr ///
		simpledMBdefor_sluilapimp  ///
		using table3.tex, ///
		drop(SimpleATT) l  stats(Mean UCI LCI,labels("Outcome mean" "Upper CI (\%)" "Lower CI (\%)") fmt(%9.2f %9.2f %9.2f))  $opts2 	
	
	file open t using table3.tex, append write
	file write t "\midrule" _n "\end{tabular*}" 
	file close t

//------------------------------------------------------------------------------	
// FIGURE 1 - EVENT-STUDY PLOT OF THE ATT OF ELECTRICITY ON DEFORESTATION (HA)
//------------------------------------------------------------------------------		
	graph use "$figures\plotwb_dMBdefor_sluilap_covs.gph" 
	graph export "$figures\plotwb_dMBdefor_sluilap_covs.pdf", replace

	graph combine "$figures\plotwb_dMBdefor_sluilap_covs.gph" , ///
	graphregion(color(white))  col(1)   ycommon
	graph save "$figures\figure1.gph", replace
	graph export "$figures\figure1.pdf", replace


//------------------------------------------------------------------------------	
// +-5 time window
//------------------------------------------------------------------------------	
foreach s in sluilap {
	preserve
	keep if  `s'==1
	local revent -5/5
	
	foreach var of varlist $lu_outcomes {
    local label `: variable label `var''
    local label_sample `: variable label `s''
	di as txt "s=`s'  label_sample=|`label_sample'|"
	
	//mean outcome at baseline
	sum `var' if  elecyear2_dum==0
	scalar baseline`var'_`s'=r(mean) 
	
	// ATT
	csdid2 `var' $control_vars, ivar(id) time(year) gvar(gvar_lu) notyet method($method) 
	estat event, revent(`revent') estore(evt`var'_`s'5) 
	estat simple,  revent(`revent')  estore(simple`var'_`s'5) 

	estimates restore simple`var'_`s'5
	
    estadd scalar Mean  = baseline`var'_`s'
    estadd scalar LCI  = 100*((_b[SimpleATT]) -1.96*_se[SimpleATT])	/(baseline`var'_`s')
    estadd scalar UCI  = 100*((_b[SimpleATT]) +1.96*_se[SimpleATT])	/(baseline`var'_`s')

	
	estimates restore evt`var'_`s'5

	estat event, revent(`revent')

	csdid2_plot, ///
		graphregion(color(white)) ///
		title("5-year window", size(medium)) ///
		ytitle("") ///
		legend(off) ///
		name(evt_`var'_`s'5, replace)

	graph save "$figures\plotwb_`var'_`s'_covs5.gph", replace

	matrix l_vec = J(6,1,1/6)

	pretrends power 0.8, pre(3/6) post(7/12)
	scalar power`var'_`s' = r(slope)

	pretrends, pre(3/6) post(7/12) slope(`r(slope)') ///
    coefplot graphregion(color(white)) title("", size(medium)) ///
    ytitle("Marginal Effect") xtitle("Periods to treatment")
	graph save "$figures\power_`var'_`s'5.gph", replace	
	}	
	restore
}

//------------------------------------------------------------------------------	
// FIGURE S1 - DEFORESTATION ANALYIS: EVENT-STUDY ESTIMATES AND SENSTIVITY
//------------------------------------------------------------------------------
	grc1leg ///
	"$figures\power_dMBdefor_sluilap5.gph" , ///
	graphregion(color(white)) xsize(6) ysize(8) iscale(.7) col(4)  ///
	legendfrom("$figures\power_dMBdefor_sluilap5.gph") 
	graph save "$figures\figureS1.gph",  replace
	graph export "$figures\figureS1.png", width(1200) height(900) replace	

		
//------------------------------------------------------------------------------
// SOCIOECONOMIC ANALYSIS 
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------	
// TABLE 2 - DESCRIPTIVE STATS: SOCIOECONOMIC ANALYSIS
//------------------------------------------------------------------------------	

	eststo grp1: estpost summarize  $se_descstats if s_socio==1
	eststo grp2: estpost summarize  $se_descstats if s_socio==1 & year==1996
	eststo grp3: estpost summarize  $se_descstats if s_socio==1 & year==2000
	eststo grp4: estpost summarize  $se_descstats if s_socio==1 & year==2005

	*Number of observations
	local vlist $se_descstats 

	// ---------- Full sample ----------
	preserve
	keep if s_socio==1
	egen _nmiss = rowmiss(incometot)            // # of missings across ALL vars per row
	count if _nmiss==0                          // complete cases (no missings on any var)
	local N_complete = r(N)


	egen _tag = tag(id)                         // tag one obs per id
	count if _tag & _nmiss==0    
	local N_plots = r(N)
	restore

	eststo grp1: estpost summarize `vlist' if s_socio==1
	estadd scalar N_complete = `N_complete', replace
	estadd scalar N_plots    = `N_plots',    replace

	// ---------- 1996 ----------
	preserve
	keep if s_socio==1 & year==1996
	egen _nmiss = rowmiss(incometot)
	count if _nmiss==0 
	local N_complete = r(N)


	egen _tag = tag(id)
	count if _tag & _nmiss==0
	local N_plots = r(N)
	restore

	eststo grp2: estpost summarize `vlist' if s_socio==1 & year==1996
	estadd scalar N_complete = `N_complete', replace
	estadd scalar N_plots    = `N_plots',    replace

	// ---------- 2000 ----------
	preserve
	keep if s_socio==1 & year==2000
	egen _nmiss = rowmiss(incometot)
	count if _nmiss==0 
	local N_complete = r(N)


	egen _tag = tag(id)
	count if _tag & _nmiss==0
	local N_plots = r(N)
	restore

	eststo grp3: estpost summarize `vlist' if s_socio==1 & year==2000
	estadd scalar N_complete = `N_complete', replace
	estadd scalar N_plots    = `N_plots',    replace

	// ---------- 2005 ----------
	preserve
	keep if s_socio==1 & year==2005
	egen _nmiss = rowmiss(incometot)
	count if _nmiss==0
	local N_complete = r(N)

	egen _tag = tag(id)
	count if _tag & _nmiss==0
	local N_plots = r(N)
	restore

	eststo grp4: estpost summarize `vlist' if s_socio==1 & year==2005
	estadd scalar N_complete = `N_complete', replace
	estadd scalar N_plots    = `N_plots',    replace

	esttab grp1 grp2 grp3 grp4 using "$tables/table2.tex", replace 		 ///
		cells(mean(fmt(2)) sd(par))                                              ///
		stats(N_complete N_plots, fmt(0 0)                                       ///
			 labels("Observations" "Number of properties"))    					 ///
		nonumber compress nonote noobs gap label booktabs                        ///
		collabels(none) mtitle("(1)" "(2)" "(3)" "(4)")                          ///
		refcat(elecyear2_dum "{\addstackgap[6]A. Treatment}"                     ///
			   incometot      "{\addstackgap[6]B. Outcomes}"					 ///
			   sett_year      "{\addstackgap[6]C. Control variables}", nolabel)  ///
		mgroups("All years" "1996" "2000" "2005", pattern(1 1 1 1)               ///
				prefix(\multicolumn{@span}{c}{) suffix(}) span)

estimates clear

//------------------------------------------------------------------------------	
// TABLE 4 - ATT SOCIOECONOMIC MAIN ANALYSIS
//------------------------------------------------------------------------------	

foreach s in s_socio{
	preserve
	keep if  `s'==1
	foreach var of varlist $se_outcomes {
    local label `: variable label `var''
	local revent -10/10
	
	//outcome mean at baseline
	sum `var' if  elecyear2_dum==0 
	scalar baseline`var'_`s'=r(mean)
	
	//ATT 
	csdid2 `var' $control_vars, ivar(id) time(year_se) gvar(gvar_se) notyet method($method)  
	estat simple,  wboot reps(999) rseed(123456789) revent(`revent')  estore(simple`var'_`s')  wbtype(mammen)
	
	estadd scalar Mean  = baseline`var'_`s'
    estadd scalar LCI  = 100*((_b[SimpleATT]) -1.96*_se[SimpleATT])	/(baseline`var'_`s')
    estadd scalar UCI  = 100*((_b[SimpleATT]) +1.96*_se[SimpleATT])	/(baseline`var'_`s')

    estat event, wboot reps(999) rseed(123456789) revent(`revent') wbtype(mammen)
	estimates store evt_`var'_`s'	
	
	csdid2_plot, ///
    title(`"`label'"') ///
    graphregion(color(white)) ///
    legend(off) ///
    ylabel(, nogrid) ///
    ytitle("") ///
    ymtick(#4) ///
    name(evt_`var'_`s', replace)
	
	graph save "$figures\plotwb_`var'_`s'_covs.gph" ,  replace
	

	//Roth bounds & power analysis
	
	//the average over the two post-treatment periods. 
	//pre(3) means the third coefficient in the event output. 
	//post(4/5) means the fourth and fifth coefficients. 

	pretrends power 0.8, pre(3) post(4/5) 
	scalar power`var'_`s'=r(slope)

	pretrends, pre(3) post(4/5) slope(`r(slope)') coefplot graphregion(color(white))  title(`label', size(medium))  ytitle("Marginal Effect") xtitle("Periods to treatment")
	graph save $figures\power_`var'_`s'.gph,  replace
	
	}	
	restore
}


//------------------------------------------------------------------------------    
	cd "$tables"
	file open t using "table4.tex", replace write

	file write t "\setlength{\tabcolsep}{2pt}" _n ///
				 "\begin{tabular*}{1.1\textwidth}{@{\extracolsep{\fill}}l*{8}{c}}" _n ///
				 "\midrule" _n ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Total \\ Income}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Milk \\ Income}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Beef \\ Income}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Crop \\ Income}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Off-Property \\ Income}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Gov. \\ Payments}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Work \\ App.}" ///
				 "&\multicolumn{1}{p{1.5cm}}{\centering Leisure \\ App.}\\\\" _n ///
				 "&(1)&(2)&(3)&(4)&(5)&(6)&(7)&(8)\\\\" _n ///
				 "\midrule" _n

	file close t

	esttab ///
	simpleincometot_s_socio ///
	simpleincmilk_s_socio ///
	simpleincbeef_s_socio ///
	simpleinccrop_s_socio ///
	simpleincoff_s_socio ///
	simpleincgov_s_socio ///
	simpledurelecwork_s_socio ///
	simpledurelecplay_s_socio ///
	using table4.tex, coeflabels(SimpleATT "ATT") l  $opts2 
	
	esttab evt_incometot_s_socio ///
	evt_incmilk_s_socio ///
	evt_incbeef_s_socio ///
	evt_inccrop_s_socio ///
	evt_incoff_s_socio ///
	evt_incgov_s_socio ///
	evt_durelecwork_s_socio ///
	evt_durelecplay_s_socio ///
	using table4.tex, keep(Pre_avg) coeflabels(Pre_avg "Pre-trend")  l  $opts2 
	
	
	esttab simpleincometot_s_socio ///
	simpleincmilk_s_socio ///
	simpleincbeef_s_socio ///
	simpleinccrop_s_socio ///
	simpleincoff_s_socio ///
	simpleincgov_s_socio ///
	simpledurelecwork_s_socio ///
	simpledurelecplay_s_socio ///
	using table4.tex, drop(SimpleATT) l  ///
	stats(Mean LCI UCI,labels("Outcome mean" "Lower CI (\%)" "Upper CI (\%)" ) fmt(%9.2f %9.2f %9.2f))  $opts2 
	
		
	file open  t 	using table4.tex, append write
	file write t 	"\midrule" _n "\end{tabular*}" 
	file close t 
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------		
// TABLE S5 - ATT ON PRODUCTION OUTCOMES
//------------------------------------------------------------------------------	
	sum $milk if s_socio==1 & tmilkharv!=. & tmilkharv>0

	foreach s in s_socio{
		preserve
		keep if  `s'==1 & tmilkharv!=. & tmilkharv>0
		foreach var of varlist  $milk{
		local label `: variable label `var''
		
		//outcome mean at baseline
		sum `var' if  elecyear2_dum==0 
		scalar baseline`var'_`s'=r(mean)
		
		//ATT  
		csdid2 `var' $control_vars, ivar(id) time(year_se) gvar(gvar_se) notyet method($method)  
		estat simple,  wboot reps(999) rseed(123456789) revent(`revent')  estore(milk_`var'_`s')  wbtype(mammen)
		
		estadd scalar Mean  = baseline`var'_`s'
		estadd scalar LCI  = 100*((_b[SimpleATT]) -1.96*_se[SimpleATT])	/(baseline`var'_`s')
		estadd scalar UCI  = 100*((_b[SimpleATT]) +1.96*_se[SimpleATT])	/(baseline`var'_`s')
	}
	restore
	}

//------------------------------------------------------------------------------
    cd "$tables"
	file open  t	using tableS5.tex, replace write
	file write t	"\setlength{\tabcolsep}{3pt}" _n "\begin{tabular*}{1\textwidth}{@{\extracolsep{\fill}}l*{4}{c}}" _n "\midrule" _n ///
					"&\multicolumn{1}{p{2.5cm}}{\centering Milk harvest \\ (L/day)}" ///
					"&\multicolumn{1}{p{2cm}}{\centering Milk cows \\ (No.)}" ///
					"&\multicolumn{1}{p{2cm}}{\centering Milk yield \\ \centering (L/day/cow)}" ///
					"&\multicolumn{1}{p{2cm}}{\centering Milk price \\ (Reais/L)}\\" _n ///
					"&(1)&(2)&(3)&(4)\\" _n ///
					"\midrule" _n 

	file close t	

	esttab milk* using tableS5.tex, coeflabels(SimpleATT "ATT") l  $opts2 
		
	esttab milk* using tableS5.tex, drop(SimpleATT) l  stats(Mean LCI UCI,labels("Outcome mean" "Lower CI (\%)" "Upper CI (\%)" ) fmt(%9.2f %9.2f %9.2f))  $opts2 
		
	file open  t 	using tableS5.tex, append write
	file write t 	"\midrule" _n "\end{tabular*}" 
	file close t
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------	
// FIGURE 2 - ATT OF ELECTRICITY ON SOCIOECONOMIC OUTCOMES
//------------------------------------------------------------------------------	
	coefplot ///      
    (simpleincometot_s_socio, rename(SimpleATT  = "Total Income") color(navy))    ///
    (simpleincmilk_s_socio, rename(SimpleATT  = "Milk Income") color(navy))   ///
    (simpleincbeef_s_socio, rename(SimpleATT  = "Beef Income") color(navy))    ///
    (simpleinccrop_s_socio, rename(SimpleATT  = "Crop Income") color(navy))   ///
    (simpleincoff_s_socio, rename(SimpleATT  = "Off-Prop. Income") color(navy))   ///
    (simpleincgov_s_socio, rename(SimpleATT  = "Gov. Payments") color(navy))   ///
    (simpledurelecwork_s_socio, rename(SimpleATT  = "Work App.") color(navy))   ///
    (simpledurelecplay_s_socio, rename(SimpleATT  = "Leisure App.") color(navy))  ,   ///
    drop(_cons) xline(0) legend(off)        ///
    offset(0)                               ///
	xtitle("Average Treatment Effect on the Treated (ATT)")	///
	graphregion(color(white)) ciopts(lwidth(*3) lcolor(navy%30))
	
	graph save $figures\figure2.gph,  replace
	graph export $figures\figure2.png, width(1200) height(900) replace

	
//------------------------------------------------------------------------------	
// FIGURE 3 - EVENT STUDY PLOT OF THE ATT OF ELECTRICITY ON SOCIOECONOMIC OUTCOMES
//------------------------------------------------------------------------------	
	graph combine  ///
	"$figures\plotwb_incometot_s_socio_covs.gph" ///
	"$figures\plotwb_incmilk_s_socio_covs.gph" ///
	"$figures\plotwb_incbeef_s_socio_covs.gph" ///
	"$figures\plotwb_inccrop_s_socio_covs.gph" ///
	"$figures\plotwb_incoff_s_socio_covs.gph" ///
	"$figures\plotwb_incgov_s_socio_covs.gph" ///
	"$figures\plotwb_durelecwork_s_socio_covs.gph" ///
	"$figures\plotwb_durelecplay_s_socio_covs.gph", ///
	graphregion(color(white)) xsize(6) ysize(8) iscale(.7) col(4)  xcommon 
	graph save "$figures\figure3.gph",  replace
	graph export "$figures\figure3.png", width(1200) height(900) replace

//------------------------------------------------------------------------------	
// FIGURE S2 - SOCIOECONOMIC ANALYSIS: EVENT-STUDY ESTIMATES AND SENSTIVITY 
//------------------------------------------------------------------------------	
	grc1leg ///
	"$figures\power_incometot_s_socio.gph" ///
	"$figures\power_incmilk_s_socio.gph" ///
	"$figures\power_incbeef_s_socio.gph" ///
	"$figures\power_inccrop_s_socio.gph" ///
	"$figures\power_incoff_s_socio.gph" ///
	"$figures\power_incgov_s_socio.gph" ///
	"$figures\power_durelecwork_s_socio.gph" ///
	"$figures\power_durelecplay_s_socio.gph", ///
	graphregion(color(white)) xsize(6) ysize(8) iscale(.7) col(4)  ///
	legendfrom("$figures\power_incometot_s_socio.gph") xcommon 
	graph save "$figures\figureS2.gph",  replace
	graph export "$figures\figureS2.png", width(1200) height(900) replace	
	
		
estimates clear	
		
//------------------------------------------------------------------------------	
// TABLE S4 - ATT OF ELECTRICITY ON APPLIANCES
//------------------------------------------------------------------------------
	 estimates clear 
	foreach s in s_socio {
		preserve
		keep if  `s'==1
		foreach var of varlist $appliances {
		local label `: variable label `var''
		local revent -10/10
		
		//baseline
		sum `var' if  elecyear2_dum==0 
		scalar baseline`var'_`s'=r(mean)

		csdid2 `var' $control_vars, ivar(id) time(year_se) gvar(gvar_se) notyet method($method)  
		estat simple,  wboot reps(999) rseed(123456789) revent(`revent')  estore(app`var'_`s')  wbtype(mammen)
		}	
		restore
	}
	 

    cd "$tables"
	file open  t	using tableS4.tex, replace write
	file write t	"\setlength{\tabcolsep}{2pt}" _n "\begin{tabular*}{1.1\textwidth}{@{\extracolsep{\fill}}l*{8}{c}}" _n "\midrule" _n ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Fridges}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Milk Tanks}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Fans}" ///
					"&\multicolumn{1}{p{1.8cm}}{\centering Wash machines}" ///
					"&\multicolumn{1}{p{1.8cm}}{\centering Microwaves}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Cell phones}" ///
					"&\multicolumn{1}{p{1.8cm}}{\centering Televisions}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Land phones}\\" _n ///
					"&(1)&(2)&(3)&(4)&(5)&(6)&(7)&(8)\\" _n ///
					"\midrule" _n 

	file close t	
		
	esttab app*   using tableS4.tex, coeflabels(SimpleATT "ATT") l   $opts2 	
		
	file open  t 	using tableS4.tex, append write
	file write t 	"\midrule" _n "\end{tabular*}" 
	file close t	
	
	
//------------------------------------------------------------------------------
// TABLE S3 - TWO-WAY FIXED-EFFECT MODEL BENCHMARK RESULTS
//------------------------------------------------------------------------------
	
	foreach var of varlist $se_outcomes {
	   reghdfe `var' elecyear2_dum if s_socio==1, a(id year) cluster(id) 
	   eststo bsxtreg_`var': wildbootstrap xtreg `var' elecyear2_dum i.year if s_socio==1, fe cluster(id) ///
			reps(999) rseed(123456789) errorweight(mammen)
	}

    cd "$tables"
	file open  t	using tableS3.tex, replace write
	file write t	"\setlength{\tabcolsep}{2pt}" _n "\begin{tabular*}{1.1\textwidth}{@{\extracolsep{\fill}}l*{10}{c}}" _n "\midrule" _n ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Total \\ Income}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Milk \\ Income}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Beef \\ Income}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Crop \\ Income}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Off-Property \\ Income}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Gov. \\ Payments}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Work \\ App.}" ///
					"&\multicolumn{1}{p{1.5cm}}{\centering Leisure \\ App.}\\" _n ///
					"&(1)&(2)&(3)&(4)&(5)&(6)&(7)&(8)\\" _n ///
					"\midrule" _n 

	file close t	
		
	esttab bsxtreg_*    using tableS3.tex,  keep(elecyear2_dum) l coeflabels(elecyear2_dum "ATT") stats(N,labels("N" ) fmt(%9.0f))  $opts2
		
	file open  t 	using tableS3.tex, append write
	file write t 	"\midrule" _n "\end{tabular*}" 
	file close t	
	
	
	

log close analysis
