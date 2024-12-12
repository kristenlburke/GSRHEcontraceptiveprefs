// analysis.do
// Outputs all tables used in manuscript 

// Table 1  - describe sample
// Figure 1 - describe pm/cm overall and among those not using pm
// Table 2  - describe not using pm & logit p(not using pm)
// Table 3  - describe reasons for not using pm & logit reasons
// Table 4  - describe reasons by pm among those not using pm 

// This analysis focuses on whether people are using their *most effective*
// preferred method. A sensitivity analysis focused on using *any* pm was also
// conducted.
// We also conducted a sensitivity analysis that randomized people who preferred
// more than 1 method into a pm category, rather than just assigning most effective.

**************************
** Prepare for analysis **
**************************

// load data
use "$GSRHEkeep/GSRHE_recoded.dta", clear


// svyset
svyset [pweight=weight_tn], strata(strata) psu(psu) singleunit(scaled)


// define vars I'll use to describe sample
global vars agecat3 racethn fplcat2 marstat lgb paritydummy insurancecat3 cpmethodcat9 educat3 
// same vars w/ agecat3 left off bc i'll use that var as an initializer for tabout spreadsheets.
global varstrunc racethn fplcat2 marstat lgb paritydummy insurancecat3 cpmethodcat9 educat3 		    


***********************************
** Table 1: Descriptives overall **
***********************************

** one way - proportion of sample in each category
// unweighted counts
tabout $vars usingpm contraceptingdummy if exclude == 0 ///
	   using "$GSRHEresults/T1_descriptives_oneway_unweighted.xls", oneway replace	  
	   
/// weighted percents
tabout 	$vars usingpm contraceptingdummy if exclude == 0 ///
	   using "$GSRHEresults/T1_descriptives_oneway_weighted.xls", cells(col ci) percent oneway svy f(0) replace


// calculate means for coercion & pregnancy avoidance
// unweighted
mean coerce_score if exclude == 0 
mean pregavoid_inverse if exclude == 0 

// weighted
svy, subpop(if exclude == 0): mean coerce_score
svy, subpop(if exclude == 0): mean pregavoid_inverse


// weighted. - usingpm
svy, subpop(if exclude == 0 & usingpm == 0): mean coerce_score 
svy, subpop(if exclude == 0 & usingpm == 0): mean pregavoid_inverse


**************
** Figure 1 **
**************

svy, subpop(if exclude == 0): tab cpmethodcat9
svy, subpop(if exclude == 0): tab pmcat

svy, subpop(if exclude == 0 & usingpm == 0): tab cpmethodcat9
svy, subpop(if exclude == 0 & usingpm == 0): tab pmcat

tabout cpmethodcat9 pmcat if exclude == 0 ///
	   using "$GSRHEresults/F1_cpuse_stats.xls", cells(col ci) percent oneway svy f(0) replace
tabout cpmethodcat9 pmcat if exclude == 0 & usingpm == 0 ///
	   using "$GSRHEresults/F1_cpuse_stats_notusingpm.xls", cells(col ci) percent oneway svy f(0) replace 


************************************************************
** Table 2: Descriptives of not usingpm & logt notusingpm ** 
************************************************************

// OVERALL TAB OF % NOT USING PM
svy, subpop(if exclude == 0): tab usingpm, ci

** across usingpm - row %
tabout agecat3 usingpm  if exclude == 0 ///
	   using "$GSRHEresults/T2_usingpm_descriptive.xls", svy f(0) percent cells(row ci) replace
// append the rest of the vars
foreach var in $varstrunc {
	tabout `var' usingpm if exclude == 0  ///
		   using "$GSRHEresults/T2_usingpm_descriptive.xls", svy f(0) percent cells(row ci) append
}


svy, subpop(if exclude == 0 & usingpm == 0): mean coerce_score 
svy, subpop(if exclude == 0 & usingpm == 0): mean pregavoid_inverse

// chi2
foreach var in $vars {
	svy, subpop(if exclude == 0): tab `var' usingpm, row pearson
}


** usingpm - using most effective preferred method
// bivariate & multivariable

gen NOTusingpm = .
replace NOTusingpm = 1 if usingpm == 0
replace NOTusingpm = 0 if usingpm == 1

//export
// initialize sheet -
svy, subpop(if exclude == 0): logit NOTusingpm i.agecat3
outreg2 using "$GSRHEresults/T2_logitusingpm.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform replace

foreach var in i.racethn i.educat3 i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3 i.b4.cpmethodcat9 c.coerce_score c.pregavoid_inverse  {
		   	svy, subpop(if exclude == 0): logit NOTusingpm `var'
			outreg2 using "$GSRHEresults/T2_logitusingpm.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform append
		   }
svy, subpop(if exclude == 0): logit NOTusingpm i.agecat3 i.racethn i.educat3  i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3 i.b4.cpmethodcat9 c.coerce_score c.pregavoid_inverse i.sample_source
			outreg2 using "$GSRHEresults/T2_logitusingpm.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform append
			
			
***************************************************
** Table 3: Descriptive of reasons for nonpref use **
**   & bivariate regressions predicting reasons  **
***************************************************

// OVERALL TAB OF % NOT USING PM
svy, subpop(if exclude == 0): tab usingpm, ci

foreach reason in partner afford difficult provider sideeffects motivation {
	tab mosteff_notideal`reason' usingpm if exclude == 0 
	svy, subpop(if exclude == 0): tab mosteff_notideal`reason', ci
}


** DESCRIBE reasons for not using most effective pm
// initalize w/ agecat3 and overall_notidealpertner
tabout agecat3 mosteff_notidealpartner  if exclude == 0 & usingpm == 0 ///
	   using "$GSRHEresults/T3_desc_reasonsfornonpref_mosteff_notusingpm.xls", svy f(0) percent cells(row ci) replace
// append the rest of the vars w/in partner
foreach var in $varstrunc {
	tabout `var' mosteff_notidealpartner if exclude == 0 & usingpm == 0 ///
		   using "$GSRHEresults/T3_desc_reasonsfornonpref_mosteff_notusingpm.xls", svy f(0) percent cells(row ci) append
}

// append the rest of the vars across all other combos
foreach reason in afford difficult provider sideeffects motivation {
	foreach var in $vars {
		tabout `var' mosteff_notideal`reason' if exclude == 0 & usingpm == 0 ///
		   using "$GSRHEresults/T3_desc_reasonsfornonpref_mosteff_notusingpm.xls", svy f(0) percent cells(row ci) append
	}	
}

// estimate coercion and pregavoid scores separately (continuous vars)
foreach reason in partner afford difficult provider sideeffects motivation {
	di as error "`reason'"
	svy, subpop(if exclude == 0 & mosteff_notideal`reason' == 1 & usingpm == 0): mean coerce_score
	svy, subpop(if exclude == 0 & mosteff_notideal`reason' == 1 & usingpm == 0): mean pregavoid_inverse
}


** Multivariable estimates of reasons for nonpreferred use CONDITIONAL ON NOT USING PM **
foreach reason in partner afford difficult provider sideeffects motivation {
	svy, subpop(if exclude == 0 & usingpm == 0): logit mosteff_notideal`reason' i.agecat3 i.racethn i.educat3 i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3  c.coerce_score c.pregavoid_inverse i.sample_source
			outreg2 using "$GSRHEresults/T3_logitreasons_mosteff_`reason'_multivariable.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform replace
}



*************************************************
** T4 - reasons by pm among those not using pm **
*************************************************
foreach reason in partner afford difficult provider sideeffects motivation  {
	svy, subpop(if exclude == 0 & usingpm == 0): tab mosteff_notideal`reason' , ci
}



** among those who aren't using most effective pm - excluding those who ARE usingpm
// initalize w/ agecat3 and overall_notidealpertner
tabout pmcat mosteff_notidealpartner  if exclude == 0 & usingpm == 0 ///
	   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff.xls", svy f(0) percent cells(row ci) replace
foreach reason in afford difficult provider sideeffects motivation  {
	tabout pmcat mosteff_notideal`reason'  if exclude == 0 & usingpm == 0 ///
	   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff.xls", svy f(0) percent cells(row ci) append
}


**************
** Appendix **
**************


// preferences
foreach pref in pref_none pref_withdr pref_condom pref_pill pref_pprs pref_larc pref_fabm pref_tubal pref_vas pref_other {
	svy, subpop(if exclude == 0): tab `pref'
}


// current method
foreach method in usingster usingvase usinglarc usingpill usingshot usingcond usingwthd usingfabm usingothr usingnone {
	svy, subpop(if exclude == 0): tab `method'
}
