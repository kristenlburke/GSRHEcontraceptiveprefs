// reasonsfornonuse.do

/*
notideal_afford notideal_difficult notideal_partner notideal_provider notideal_other notideal_fillin notideal_dk notideal_skp notideal_ref
*/

gen shouldhavereasons = 0
foreach pref in ideal_nomethod ideal_withdrawal ideal_condom ideal_pill ideal_patch ideal_implant ideal_fabm ideal_tubal ideal_vasectomy ideal_ec ideal_other {
	replace shouldhavereasons = 1 if `pref' == 1
}

gen hasreasons = 0
foreach var in notideal_afford notideal_difficult notideal_partner notideal_provider notideal_other {
	replace hasreasons = 1 if `var' == 1 | `var' == 0
}
replace hasreasons = 0 if notideal_skp == 1

gen skippedreasons = 0
replace skippedreasons = 1 if notideal_skp == 1

// who has reasons for non-preferred use among those not using their pm?
tab hasreasons usingpm if exclude == 0, m // 29 who aren't using pm don't have reasons
tab hasreasons usinganypm if exclude == 0 , m // 21 who aren't using ANY pm dont' have reasons
// also, a ton of people who ARE using their preferred method so they were prompted w the Q



tab skippedreasons exclude, m
tab skippedreasons if usinganypm == 0 & exclude == 0, m

foreach var in notideal_afford notideal_difficult notideal_partner notideal_provider notideal_other notideal_fillin notideal_dk {
	tab `var' if usinganypm == 0 & exclude == 0  
}

**********************************
** Merge in the other write-ins **
**********************************

// temporarily store current data
preserve

// import spreadsheet used to code
import excel "$GSRHEraw/for merge - GSRHE Other write-ins reasons nonpreferred coded.xlsx", firstrow clear

keep ID codea codeb
tab codea, m
tab codeb, m
drop if ID == .
rename ID case_id

save "$GSRHEraw/for merge-GSRHE other write-ins.dta", replace

// restore main analytic data
restore 

// execute merge
merge 1:1 case_id using "$GSRHEraw/for merge-GSRHE other write-ins.dta"

// codes from spreadsheet
// a = access *
// c = cost *
// current = using preferred method; it's their current method
// e = efficacy * 
// h = hysterectomy
// i = percieved infecundity *
// n = not interested *
// p = provider *
// pa = partner *
// s = side effects *
// skip = no answer
// t = tubal

// use the merged recodes to recode raw vars
// survey-based reasons: afford difficult partner provider

replace notideal_afford = 1 if codea == "C" | codeb == "C"
replace notideal_other  = 0 if codea == "C" | codeb == "C"

replace notideal_difficult = 1 if codea == "A" | codeb == "A"
replace notideal_other     = 0 if codea == "A" | codeb == "A"

replace notideal_partner = 1 if codea == "PA" | codeb == "PA"
replace notideal_other   = 0 if codea == "PA" | codeb == "PA"

replace notideal_provider = 1 if codea == "P" | codeb == "P"
replace notideal_other    = 0 if codea == "P" | codeb == "P"


// Generate new reasons
// side effects - including efficacy and side effects
gen notideal_sideeffects = .
replace notideal_sideeffects = 0 if skippedreasons != 1
replace notideal_sideeffects = 1 if codea == "S" | codeb == "S"
replace notideal_sideeffects = 1 if codea == "E" | codeb == "E"
replace notideal_other = 0 if notideal_sideeffects == 1

// percieved infecundity
gen notideal_infecund = .
replace notideal_infecund = 0 if skippedreasons != 1
replace notideal_infecund = 1 if codea == "I" | codeb == "I"
replace notideal_other = 0 if notideal_infecund == 1

// interest
gen notideal_interest = .
replace notideal_interest = 0 if skippedreasons != 1
replace notideal_interest = 1 if codea == "N" | codeb == "N"
replace notideal_other = 0 if notideal_interest == 1


// CURRENT - people who are currently using their preferred method
// make sure the usingpm dummy variable is coded as 1
replace usingpm = 1 if codea == "CURRENT"
replace notideal_other = 0 if codea == "CURRENT"

// also make sure their reported pm == their current method
list case_id ideal_* notideal_fillin cpmethod if codea == "CURRENT", abbreviate(15)

// 906 - using the ring, says they're using abstinence in pm. leave as is.
// 2032 - ideal is tubal, but current method listed as withdrawal.
replace cpmethod = 1 if case_id == 2032
replace usingster = 1 if case_id == 2032
// 4068 - current method is none, but ideal is vasectomy & they're using
replace cpmethod = 2 if case_id == 4068
replace usingvase = 1 if case_id == 4068
// 5425 - current method FAM, ideal is vasectomy & they're using
replace cpmethod = 2 if case_id == 5425
replace usingvase = 1 if case_id == 5425
// 5781 - current method is none, but ideal is vasectomy & they're using
replace cpmethod = 2 if case_id == 5781
replace usingvase = 1 if case_id == 5781


// what's going on with hysterectomy/tubal people in skip patterns?
tab cpmethod if codea == "H"

// exclude hysterectomies
replace hysterectomy = 1 if codea == "H"
replace exclude = 1 if hysterectomy == 1

// recode the tubals
tab cpmethod if codea == "T"
list cpmethod ideal_* notideal_fillin if codea == "T", abbreviate(15)
list notideal_fillin if cpmethod == 15 & codea == "T"
// recode current method to tubal
replace cpmethod = 1 if codea == "T"
replace cpmethodcat10 = 1 if codea == "T"
replace usingster = 1 if codea == "T"
// recode usingpm if it is tubal in some fashion
replace usingpm = 1 if ideal_tubal == 1 & codea == "T"
replace usinganypm = 1 if ideal_tubal == 1 & codea == "T"
replace notideal_other = 0 if usingpm == 1 & codea == "T"
// if not using anypm and reason for it is tubal, recode to percieved infecundity
replace notideal_infecund = 1 if usinganypm == 0 & codea == "T"
replace notideal_other = 0 if notideal_infecund == 1 
tab notideal_other if codea == "T"

// collapse infecund + interest 
gen notideal_motivation = .
replace notideal_motivation = 0 if hasreasons == 1
replace notideal_motivation = 1 if notideal_infecund == 1 | notideal_interest == 1


// gen dummy for overall % of sample not using ideal bc of each reason
foreach var in afford difficult partner provider sideeffects infecund interest motivation {
	gen overall_notideal`var' = 0
	replace overall_notideal`var' = 1 if notideal_`var' == 1 & usinganypm == 0
}

// this dummy var is the same except it  counts those who aren't using their *most effective*
// preferred method
foreach var in afford difficult partner provider sideeffects infecund interest motivation {
	gen mosteff_notideal`var' = 0
	replace mosteff_notideal`var' = 1 if notideal_`var' == 1 & usingpm == 0
}

egen mosteffreasons = rowtotal(mosteff_notidealafford mosteff_notidealdifficult mosteff_notidealpartner mosteff_notidealprovider mosteff_notidealsideeffects mosteff_notidealmotivation)

tab mosteffreasons usingpm if exclude == 0
*bro case_id notideal* codea if usingpm == 0 & mosteffreasons == 0 & exclude == 0

// re-make the mosteff_* vars using the randomized usingpm_r
// this dummy var is the same except it  counts those who aren't using their *most effective*
// preferred method
foreach var in afford difficult partner provider sideeffects infecund interest motivation {
	gen mosteff_r_notideal`var' = 0
	replace mosteff_r_notideal`var' = 1 if notideal_`var' == 1 & usingpm_r == 0
}


