**************************
** Sensitivity analysis **
**************************

// Randomly assigning for those who pref multiple methods

// Incorporating a randomly assigned preference for those who prefer more than 
// one method (rather than assigning them their most effective pm)

// load data
use "$GSRHEkeep/GSRHE_recoded.dta", clear


// svyset
svyset [pweight=weight_tn], strata(strata) psu(psu) singleunit(scaled)


// define vars I'll use to describe sample
global vars agecat3 racethn fplcat2 marstat lgb paritydummy insurancecat3 cpmethodcat9 educat3 
// same vars w/ agecat3 left off bc i'll use that var as an initializer for tabout spreadsheets.
global varstrunc racethn fplcat2 marstat lgb paritydummy insurancecat3 cpmethodcat9 educat3 		    



**************
** Figure 1 **
**************
svy, subpop(if exclude == 0): tab usingpm_r

svy, subpop(if exclude == 0): tab cpmethodcat9
svy, subpop(if exclude == 0): tab pmcat_r

svy, subpop(if exclude == 0 & usingpm_r == 0): tab cpmethodcat9
svy, subpop(if exclude == 0 & usingpm_r == 0): tab pmcat_r

************************************************************
** Table 2: Descriptives of not usingpm & logt notusingpm ** 
************************************************************

// OVERALL TAB OF % NOT USING PM
svy, subpop(if exclude == 0): tab usingpm_r, ci

** across usingpm - row %
tabout agecat3 usingpm_r  if exclude == 0 ///
	   using "$GSRHEresults/T2_usingpm_descriptive_sensitivity.xls", svy f(0) percent cells(row ci) replace
// append the rest of the vars
foreach var in $varstrunc {
	tabout `var' usingpm_r if exclude == 0  ///
		   using "$GSRHEresults/T2_usingpm_descriptive_sensitivity.xls", svy f(0) percent cells(row ci) append
}


svy, subpop(if exclude == 0 & usingpm_r == 0): mean coerce_score 
svy, subpop(if exclude == 0 & usingpm_r == 0): mean pregavoid_inverse



** usingpm - using most effective preferred method
// bivariate & multivariable

gen NOTusingpm = .
replace NOTusingpm = 1 if usingpm_r == 0
replace NOTusingpm = 0 if usingpm_r == 1

//export
// initialize sheet -
svy, subpop(if exclude == 0): logit NOTusingpm i.agecat3
outreg2 using "$GSRHEresults/T2_logitusingpm_sensitivity.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform replace

foreach var in i.racethn i.educat3 i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3 i.b4.cpmethodcat9 c.coerce_score c.pregavoid_inverse  {
		   	svy, subpop(if exclude == 0): logit NOTusingpm `var'
			outreg2 using "$GSRHEresults/T2_logitusingpm_sensitivity.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform append
		   }
svy, subpop(if exclude == 0): logit NOTusingpm i.agecat3 i.racethn i.educat3  i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3 i.b4.cpmethodcat9 c.coerce_score c.pregavoid_inverse
			outreg2 using "$GSRHEresults/T2_logitusingpm_sensitivity.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform append
			
			
***************************************************
** Table 3: Descriptive of reasons for nonpref use **
**   & bivariate regressions predicting reasons  **
***************************************************

// OVERALL TAB OF % NOT USING PM
svy, subpop(if exclude == 0): tab usingpm_r, ci

foreach reason in partner afford difficult provider sideeffects motivation {
	tab mosteff_notideal`reason' usingpm_r if exclude == 0 
	svy, subpop(if exclude == 0): tab mosteff_notideal`reason', ci
}


** reasons for not using most effective pm
// initalize w/ agecat3 and overall_notidealpertner
tabout agecat3 mosteff_r_notidealpartner  if exclude == 0 ///
	   using "$GSRHEresults/T3_desc_reasonsfornonpref_mosteff_sensititivy.xls", svy f(0) percent cells(row ci) replace
// append the rest of the vars w/in partner
foreach var in $varstrunc {
	tabout `var' mosteff_r_notidealpartner if exclude == 0  ///
		   using "$GSRHEresults/T3_desc_reasonsfornonpref_mosteff_sensititivy.xls", svy f(0) percent cells(row ci) append
}

// append the rest of the vars across all other combos
foreach reason in afford difficult provider sideeffects motivation {
	foreach var in $vars {
		tabout `var' mosteff_r_notideal`reason' if exclude == 0  ///
		   using "$GSRHEresults/T3_desc_reasonsfornonpref_mosteff_sensititivy.xls", svy f(0) percent cells(row ci) append
	}	
}


// logit reasons if usingpm == 0

foreach reason in partner afford difficult provider sideeffects motivation {
	svy, subpop(if exclude == 0): logit mosteff_r_notideal`reason' i.agecat3
			outreg2 using "$GSRHEresults/T3_logitreasons_mosteff_`reason'_sensitivity.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform replace

	foreach var in i.racethn i.educat3 i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3 i.b4.cpmethodcat10 c.coerce_score c.pregavoid_inverse {
		   	svy, subpop(if exclude == 0): logit mosteff_r_notideal`reason' `var'
			outreg2 using "$GSRHEresults/T3_logitreasons_mosteff_`reason'_sensitivity.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform append
		   }
}

foreach reason in partner afford difficult provider sideeffects motivation {
	svy, subpop(if exclude == 0): logit mosteff_r_notideal`reason' i.agecat3 i.racethn i.educat3 i.fplcat2 i.marstat i.lgb i.paritydummy i.insurancecat3  c.coerce_score c.pregavoid_inverse
			outreg2 using "$GSRHEresults/T3_logitreasons_mosteff_`reason'_sensitivity.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +) dec(2) label eform append
}

	   
	   
// chi2
foreach var in $vars {
	svy, subpop(if exclude == 0): tab `var' usinpm_r, row pearson
}

// calculate means for coercion & pregnancy avoidance
// unweighted
mean coerce_score
mean pregavoid_inverse

// weighted
svy, subpop(if exclude == 0): mean coerce_score
svy, subpop(if exclude == 0): mean pregavoid_inverse


// weighted. - usinganypm
svy, subpop(if exclude == 0 & usinpm_r == 0): mean coerce_score 
svy, subpop(if exclude == 0 & usinpm_r == 0): mean pregavoid_inverse

// weighted. - usingpm
svy, subpop(if exclude == 0 & usinpm_r == 0): mean coerce_score 
svy, subpop(if exclude == 0 & usinpm_r == 0): mean pregavoid_inverse



*************************************************
** T4 - reasons by pm among those not using pm **
*************************************************
foreach reason in partner afford difficult provider sideeffects motivation  {
	svy, subpop(if exclude == 0 & usingpm_r == 0): tab mosteff_notideal`reason' , ci
}



** among those who aren't using most effective pm - excluding those who ARE usingpm
// initalize w/ agecat3 and overall_notidealpertner
tabout pmcat mosteff_r_notidealpartner  if exclude == 0 & usingpm_r == 0 ///
	   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff_sensitivity.xls", svy f(0) percent cells(row ci) replace
foreach reason in afford difficult provider sideeffects motivation  {
	tabout pmcat mosteff_r_notideal`reason'  if exclude == 0 & usingpm_r == 0 ///
	   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff_sensitivity.xls", svy f(0) percent cells(row ci) append
}

** by cp method
tabout cpmethodcat9 mosteff_r_notidealpartner  if exclude == 0 & usingpm_r == 0 ///
	   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff_current_sensitivity.xls", svy f(0) percent cells(row ci) replace
foreach reason in afford difficult provider sideeffects motivation  {
	tabout cpmethodcat9 mosteff_r_notideal`reason'  if exclude == 0 & usingpm_r == 0 ///
	   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff_current_sensitivity.xls", svy f(0) percent cells(row ci) append
}


// append the rest of the vars w/in partner
foreach var in $varstrunc {
	tabout `var' mosteff_r_notidealpartner if exclude == 0 & usingpm_r == 0 ///
		   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff_sensitivity.xls", svy f(0) percent cells(row ci) append
}

// append the rest of the vars across all other combos
foreach reason in afford difficult provider sideeffects motivation {
	foreach var in $vars {
		tabout `var' mosteff_r_notideal`reason' if exclude == 0 & usingpm_r == 0 ///
		   using "$GSRHEresults/T4_desc_reasonsfornonpref_amongnonusers_mosteff_sensitivity.xls", svy f(0) percent cells(row ci) append
	}	
}
