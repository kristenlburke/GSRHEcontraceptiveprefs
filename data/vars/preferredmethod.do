** Preferred method **

/*
Q38
"If you could use any contraceptive method that you wanted right now, what method(s) would you use? Select all that apply."
// The question about prefereneces was asked of those who...
// S3 (trypreg) - trying to become preg - no (2), 77 (don't know), 98 (no answer)
// S2 (preg)    - currently pregnant - no (2), 77 (don't know), 98 (no answer) 
// Q19 (sex30)  - sex in last 30 days - 1-4x (2), 5+ (3)

Raw variables:
ideal_current ideal_nomethod ideal_withdrawal ideal_condom ideal_pill ideal_patch ideal_implant ideal_fabm ideal_tubal ideal_vasectomy ideal_ec ideal_other ideal_fillin ideal_dk ideal_skp ideal_ref 


Q39.
What are your reasons for not currently using your preferred contraceptive method?
*/

**********************
** Preferred method **
**********************

** Question completion check
// NOTE: "I am satisfied not using a method" is presented only to those who reported not using a method

// indicate skipped whole question
gen skippedpm = 0
replace skippedpm = 1 if ideal_skp == 1 | ideal_ref == 1
replace skippedpm = 1 if ideal_current == .a  
// If ideal_current is missing (.a), so are all of the other ideal methods (I checked). 
// .a represents a "valid skip" because they weren't asked the question due to 
// skip patterns
tab skippedpm exclude 
// the two with skipped == 1 and exclude == 0 are the true skips for preferred method question
list trypreg preg sex30 coital30_fillin if exclude == 0 & skippedpm == 1
replace exclude = 1 if skippedpm == 1


** Generate dummy variables for each preferred method
// these are already exist except ideal none needs to be corrected so that
// it includes everyone in the 0 
gen ideal_none = ideal_nomethod
replace ideal_none = 0 if skippedpm == 0 & ideal_nomethod == .a


** CODE UP WRITE-INS
// gen a variable to store the others that can't get coded up in
gen ideal_othercodeup = 0
replace ideal_othercodeup = 1 if ideal_other == 1 & ideal_fillin == " "
// everyone who selected other included a write-in

*bro case_id ideal_fillin cpmethod if ideal_fillin != " "

// Interpreting those who say pm == hysterectomy w/o much context
// There are a few types of these...
// 1) Those who clearly say they have had a hysterectomy - easy, but Q on inclusion
//    - related to type #3 - many of these say they're not using a method.

replace exclude = 1 if case_id == 2679	// Hysterectomy cant get pregnant	None
replace hysterectomy = 1 if case_id == 2679
replace exclude = 1 if case_id == 5478	// Had a hysterectomy	Permanent (female)
replace hysterectomy = 1 if case_id == 5478
replace exclude = 1 if case_id == 6328	// Had a hysterectomy	None
replace hysterectomy = 1 if case_id == 6328
replace exclude = 1 if case_id == 6050	// I can't get pregnant any longer	None 
replace hysterectomy = 1 if case_id == 6050
replace exclude = 1 if case_id == 6120	// I've had a partial hysterectomy	None
replace hysterectomy = 1 if case_id == 6120
replace exclude = 1 if case_id == 4127	// I had tubal ligation 24 years ago and then histerectomy 8 years ago	None
replace hysterectomy = 1 if case_id == 4127

// 2) Those who say "hysterectomy" in other, write in on pm who also have permanent
//    method listed in current method.
//    - Interpret as their having had a hysterectomy & then potentially exclude

replace exclude = 1 if case_id == 2185	// Hysterectomy	Permanent (female)
replace hysterectomy = 1 if case_id == 2185
replace exclude = 1 if case_id == 3044	// Hysterectomy	Permanent (female)
replace hysterectomy = 1 if case_id == 3044
replace exclude = 1 if case_id == 4209	// Hsterectomy	Permanent (female)
replace hysterectomy = 1 if case_id == 4209

// 3) Those who say "hysterectomy" in other, write in on pm who report that they are
//    using no method of contraception. They could want a hysterectomy or they could
//    be not reporting using a method bc they don't count their hysterectomy as a method.
//    This suspicion comes from type #1, where several have "none" as their current method
//    - take at face value and just code as pm = permanent

replace ideal_tubal = 1 if case_id == 1746	// Hysterectomy	
replace ideal_tubal = 1 if case_id == 2346	// Hysterectomy
replace ideal_tubal = 1 if case_id == 2606	// Hysterectomy	None
replace ideal_tubal = 1 if case_id == 3405	// hysterectomy	None
replace ideal_tubal = 1 if case_id == 4727	// hysterectomy	None
replace ideal_tubal = 1 if case_id == 5295	// Hysterectmy	    None
replace ideal_tubal = 1 if case_id == 5375	// Hysterectomy	None
replace ideal_tubal = 1 if case_id == 5651	// Hysterectomy	None
replace ideal_tubal = 1 if case_id == 5971	// hysterctomy	    None

// 4) Those who say "hysterectomy" in other, write in on pm who report that they are 
//    using another method of contraception.
//    - code as wanting a permanent method
replace ideal_tubal = 1 if case_id == 1824	// Hysterectomy	Pill
replace ideal_tubal = 1 if case_id == 3444	// Hysterectomy	Pill
replace ideal_tubal = 1 if case_id == 4625	// hysterectomy	Pill
replace ideal_tubal = 1 if case_id == 4731	// Hysterectomy	Ring


// ideal_none only asked of those not using a pm; code everyone else as 0
replace ideal_none = 0 if ideal_none == .



// order of vars: case_id	ideal_fillin	cpmethod
replace ideal_none = 1 			if case_id == 157 		//	None	None
replace ideal_othercodeup = 1 	if case_id == 162 		//	Spermicide	Shot
replace ideal_tubal = 1 		if case_id == 165 		//	Sterilization	Permanent (female)
replace ideal_othercodeup = 1 	if case_id == 597		// strips	Pill
replace ideal_tubal = 1 		if case_id == 733		// Tubal	None
replace ideal_none = 1 			if case_id == 869		// none because my partner really wants a baby	Permanent (female)
replace ideal_none = 1 			if case_id == 905		// None	Implant
replace ideal_othercodeup = 1 	if case_id == 906		// Abstinence	Ring
replace ideal_none = 1 			if case_id == 949		// Don't use	None
replace ideal_implant = 1 		if case_id == 1005		// Implant	Implant
replace ideal_none = 1 			if case_id == 1341		// None	None
replace ideal_patch = 1 		if case_id == 1442 		// Depo-Provera	Shot
replace ideal_none = 1 			if case_id == 1485		// None	None
replace ideal_none = 1 			if case_id == 1494		// None	None
replace ideal_none = 1 			if case_id == 1499		// None	None
replace ideal_none = 1 			if case_id == 1577		// None	Withdrawal
replace ideal_none = 1 			if case_id == 2188		// Nothing nothing	Withdrawal
replace ideal_othercodeup = 1 	if case_id == 2294		// Dissolving  Spermicidal Contraception	Condom
replace ideal_tubal = 1 		if case_id == 2298		// Tubes tied	IUD
replace ideal_othercodeup = 1 	if case_id == 2362		// NAnS	Shot 
replace ideal_patch = 1 		if case_id == 2811		// Depo shot	Permanent (female)
replace ideal_none = 1 			if case_id == 2918		// None	Withdrawal
replace ideal_none = 1 			if case_id ==3024		// None	Permanent (female)
replace ideal_none = 1 			if case_id ==3121		// None	None
replace ideal_tubal = 1 		if case_id == 3290		// Tubes are tied	
replace ideal_none = 1 			if case_id == 3400		// None	None
replace ideal_othercodeup = 1 	if case_id == 3423		// Spermicide	Fertility awareness
replace ideal_patch = 1 		if case_id == 3826		// Nuvaring	Withdrawal
replace ideal_othercodeup = 1 	if case_id == 3921		// The sponge	Condom
replace ideal_none = 1 			if case_id == 3989		// none	Permanent (male partner)
replace ideal_othercodeup = 1 	if case_id == 4010		// Male equivalent to the pill	Pill
replace ideal_tubal = 1 		if case_id == 4096		// Tubaligation	None
replace ideal_none = 1 			if case_id == 4113		// None	None
replace ideal_tubal = 1 		if case_id == 4245		// Removal of uterus-- suspect endometriosis or problems with uterus, but x-rays not available or affordable without insurance	Condom
replace ideal_none = 1 			if case_id == 4342		//none	None
replace ideal_none = 1 			if case_id == 4450		// None	Permanent (female)
replace ideal_none = 1 			if case_id == 4605		// No contraceptive	None
replace ideal_tubal = 1 		if case_id == 4822		// Tubal	Shot
replace ideal_othercodeup = 1 	if case_id == 4847		// Phexxi	Pill
replace ideal_othercodeup = 1 	if case_id == 4895		// Ideally I'd like an as needed birth control for women. Like how men take Viagra.	IUD
replace ideal_othercodeup = 1 	if case_id == 4928		// Some sort of male form of easily reversible contraception	IUD
replace ideal_othercodeup = 1 	if case_id == 4956		// Diaphragm	Condom
replace ideal_tubal = 1 		if case_id == 4962		// I want a full hysterectomy	IUD
replace ideal_patch = 1 		if case_id == 4985		// Shot	Pill
replace ideal_tubal = 1 		if case_id == 5336		// i don't need it	Permanent (female)
replace ideal_none = 1 			if case_id == 5409		// None	None
replace ideal_none = 1 			if case_id == 5430		// None its not necessary	None
replace ideal_none = 1 			if case_id == 5488		// None	Permanent (male partner)
replace ideal_vasectomy = 1 	if case_id == 5620		// my husband already had a vasectomy	None
replace ideal_othercodeup = 1 	if case_id == 5698		// Cervical cap	None
replace ideal_none = 1 			if case_id == 5909		// None	None
replace ideal_none = 1 			if case_id == 6072		// Dont use	None	
replace ideal_tubal = 1 		if case_id == 6161		// None tubes are to	Permanent (female)
replace ideal_implant = 1 		if case_id == 6271		// Copper IUD	Condom
replace ideal_none = 1 			if case_id == 6512		// Nothing	None



** Generate categorical that classifies by most effective method
// pm = that method if they say that it's their pm OR
// if it's their current method and they say current == pm
// Aligning #s to match with cp method. Not a perfect alignment
// bc pm has some collapsed method (e.g. patch, ring, shot)
gen pm = .
replace pm = 1  if ideal_tubal == 1 		          					& pm == . // fem ster
replace pm = 1  if ideal_current == 1 & cpmethod == 1 					& pm == .
replace pm = 2  if ideal_vasectomy == 1 		      					& pm == . // male ster
replace pm = 2  if ideal_current == 1 & cpmethod == 2 					& pm == .
replace pm = 3  if ideal_implant == 1 		         					& pm == . // implant or iud
replace pm = 3  if ideal_current == 1 & (cpmethod == 3 | cpmethod == 4) & pm == .
replace pm = 6  if ideal_pill == 1 										& pm == . // pill
replace pm = 6  if ideal_current == 1 & cpmethod == 6 					& pm == .
replace pm = 5  if ideal_patch == 1 									& pm == . // patch ring shot
replace pm = 5  if ideal_current == 1 & inlist(cpmethod, 5, 7, 8) 		& pm == .
replace pm = 9  if ideal_condom == 1 									& pm == . // condom
replace pm = 9  if ideal_current == 1 & cpmethod == 9 					& pm == .
replace pm = 10 if ideal_fabm == 1 										& pm == . // fabm
replace pm = 10 if ideal_current == 1 & cpmethod == 10 					& pm == .
replace pm = 12 if ideal_withdrawal == 1 								& pm == . // withdrawl
replace pm = 12 if ideal_current == 1 & cpmethod == 12 					& pm == .
replace pm = 13 if ideal_ec == 1 										& pm == . // ec 
replace pm = 13 if ideal_current == 1 & cpmethod == 13 					& pm == .
replace pm = 14 if ideal_othercodeup == 1 								& pm == .  // other - includes diaphragm in current method
replace pm = 14 if ideal_current == 1 & inlist(cpmethod, 11, 14)		& pm == . 
replace pm = 15 if ideal_none == 1 										& pm == . // none
replace pm = 15 if ideal_current == 1 & cpmethod == 15 					& pm == .
replace pm = 16 if ideal_dk == 1 										& pm == . // don't know


label define pm 1 "Permanent (female)" 2 "Permanent (male partner)" 3 "Implant" 4 "IUD" ///
				5 "Shot" 6 "Pill" 7 "Patch" 8 "Ring" 9 "Condom" 10 "Fertility awareness" ///
				11 "Diaphragm" 12 "Withdrawal" 13 "Emergency contraception" 14 "Other" ///
				15 "None" 16 "Don't know" .a "Current ideal, missing current"
label values pm pm

// Does everyone have their pm assigned?
tab pm if exclude == 0 & skippedpm == 0, m
// those who say their ideal method is their current method but have missing data
// on currnt method are a special classificaiton of missing, just to sift through
// the data.
tab cpmethod    if pm == . & exclude == 0 & skippedpm == 0 , m
replace pm = .a if pm == . & cpmethod == . & ideal_current == 1
// these are all hysterectomies
tab pm if exclude == 0 & skippedpm == 0, m
tab pm hysterectomy if exclude == 0 & skippedpm == 0, m
replace exclude = 1 if hysterectomy == 1


** collapse categories
gen pmcat = .
replace pmcat = pm if pm < 5
replace pmcat = 5 if pm == 6
replace pmcat = 6 if pm == 5
replace pmcat = 7 if pm == 9
replace pmcat = 8 if pm == 12
replace pmcat = 9 if pm == 10 | pm == 13 | pm == 14
replace pmcat = 10 if pm == 15
label define pmcat 1 "Ster" 2 "Vas" 3 "LARC" 5 "Pill" 6 "Shot, patch, ring" 7 "Condom" 8 "Withdrawal" 9 "Fertility awareness and other" 10 "None"
label values pmcat pmcat


** Preferred method - select all
// generate dummies for each preference & fill in with current method if ideal_current == 1
* ideal_nomethod ideal_withdrawal ideal_condom ideal_pill ideal_patch ideal_implant ideal_fabm ideal_tubal ideal_vasectomy ideal_ec ideal_other

gen pref_none = 0
replace pref_none = 1 if ideal_none == 1 | (ideal_current == 1 & cpmethod == 15)

gen pref_withdr = 0
replace pref_withdr = 1 if ideal_withdrawal == 1 | (ideal_current == 1 & cpmethod == 12)

gen pref_condom = 0
replace pref_condom = 1 if ideal_condom == 1 | (ideal_current == 1 & cpmethod == 9)

gen pref_pill = 0
replace pref_pill = 1 if ideal_pill == 1 | (ideal_current == 1 & cpmethod == 6)

gen pref_pprs = 0
replace pref_pprs = 1 if ideal_patch == 1 | (ideal_current == 1 & inlist(cpmethod, 5, 7, 8) )

gen pref_larc = 0
replace pref_larc = 1 if ideal_implant == 1 | (ideal_current == 1 & (cpmethod == 3 | cpmethod == 4))

gen pref_fabm = 0
replace pref_fabm = 1 if ideal_fabm == 1 | (ideal_current == 1 & cpmethod == 10)

gen pref_tubal = 0
replace pref_tubal = 1 if ideal_tubal == 1 | (ideal_current == 1 & cpmethod == 1)

gen pref_vas = 0
replace pref_vas = 1 if ideal_vasectomy == 1 | (ideal_current == 1 & cpmethod == 2)

/*
gen pref_ec = 0
replace pref_ec = 1 if ideal_ec == 1 | (ideal_current == 1 & cpmethod == 13)
*/

// collapse ec into other bc there are so few
gen pref_other = 0
replace pref_other = 1 if ideal_othercodeup == 1 | ideal_ec == 1 | (ideal_current == 1 & inlist(cpmethod, 11, 13, 14))



** USING PREFERRED METHOD **
// This configuration identifies whether someone's most effective current method
// matches their most efective preferred method.
gen usingpm = 0
replace usingpm = 1 if pm == cpmethod
replace usingpm = 1 if pm == 3 & (cpmethod == 3 | cpmethod == 4) 				 // implant or IUD collapsed in PM
replace usingpm = 1 if pm == 5 & (cpmethod == 5 | cpmethod == 7 | cpmethod == 8) // patch, ring, shot
replace usingpm = 1 if pm == 14 & (cpmethod == 11 | cpmethod == 14)  			 // other incl diaphragm


forvalues i = 1/15 {
	di "tab for method `i'"
	tab pm if cpmethod == `i' & exclude == 0, m
	tab pm if cpmethod == `i' & usingpm == 0 & exclude == 0, m
}

// Using ANY pm
/*
withdrawal30 condom30 fabm30 diaphragm30 ec30 vasectomy30 other30 coital30_fillin none30_coital dk30_coital skp30_coital ref30_coital
pill30_pvi patch30_pvi ring30_pvi shot30_pvi implant30_pvi iud30_pvi tubal30_pvi none30_pvi dk30_pvi skp30_pvi ref30_pvi

ideal_current ideal_nomethod ideal_withdrawal ideal_condom ideal_pill ideal_patch ideal_implant ideal_fabm ideal_tubal ideal_vasectomy ideal_ec ideal_other ideal_fillin ideal_dk ideal_skp ideal_ref
*/

gen usinganypm = 0
replace usinganypm = 1 if ideal_current == 1
replace usinganypm = 1 if ideal_none == 1 & (none30_coital == 1 | none30_pvi == 1)
replace usinganypm = 1 if ideal_withdrawal == 1 & withdrawal30 == 1
replace usinganypm = 1 if ideal_condom == 1 & condom30 == 1
replace usinganypm = 1 if ideal_pill == 1 & pill30_pvi == 1
replace usinganypm = 1 if ideal_patch == 1 & (patch30_pvi == 1 | ring30_pvi == 1 | shot30_pvi == 1)
replace usinganypm = 1 if ideal_implant == 1 & (implant30_pvi == 1 | iud30_pvi == 1)
replace usinganypm = 1 if ideal_fabm == 1 & fabm30 == 1
replace usinganypm = 1 if ideal_tubal == 1 & tubal30_pvi == 1
replace usinganypm = 1 if ideal_vasectomy == 1 & vasectomy30 == 1 
replace usinganypm = 1 if ideal_ec == 1 & ec30 == 1
replace usinganypm = 1 if ideal_othercodeup == 1 & (other30_codedup == 1 | diaphragm30 == 1)


// gen inverse var - not using anypm
gen notusinganypm = .
replace notusinganypm = 1 if usinganypm == 0
replace notusinganypm = 0 if usinganypm == 1

** Generate categorical that has a category for multiple preferred methods

// generate a row total variable that sums up how many methods one reports using
egen npms = rowtotal(ideal_current ideal_withdrawal ideal_condom ///
					 ideal_pill ideal_patch ideal_implant ideal_fabm ///
					 ideal_tubal ideal_vasectomy ideal_ec ideal_othercodeup ideal_none)

egen pms = rowtotal(pref_none pref_other pref_withdr pref_fabm pref_condom pref_pill pref_pprs pref_larc  pref_vas pref_tubal )
** Identify nonpreferred use
// Check agains current method to see if people are using the method they want
// Ideal Q outright asks if their current method is preferred, but also want to double
// check on classification in case some people didn't tick that box even though it's true

************************************************************************
** Random selection of preferred method among those with multiple PMs **
************************************************************************
// I think the easiest way to randomly select per observation is to make the data
// long so that each ID has n number of observations, where n = the number of methods
// they expressed a preference for.
preserve 

keep case_id pref_* pms
reshape long pref_, i(case_id) j(method) string
keep if pref_ == 1
// data are reshaped such that there is one row per preferred method that each
// person has - those with 3 preferences have 3 rows, 1 preference has 1 row

// then generate a variable with a random value for each observation
gen random = uniform()
// because this variable is randomly generated, if we sort by this variable within
// each person's preferences, it is random which observation will have the lowest
// value and therefore will get selected when you run the subsequent command
bysort case_id (random) : gen byte select = _n == 1
// we'll keep only if select == 1
keep if select == 1
keep case_id method
rename method preferredmethod_r // _r for randomized
count // should equal the number of observations

save "$GSRHEtmp/randomprefs.dta", replace

restore

// merge this method data back into the main data file
merge 1:1 case_id using "$GSRHEtmp/randomprefs.dta"

tab _merge exclude // those who weren't in the merge ( == 1) aren't in the sample
// i.e. don't have preferred methods (this wasn't asked of everyone)

drop _merge

// recode variable to be the same order as other preferred method variable -
// also make it align with current method coding (even tho preferred method 
// is asked in fewer cateogries e.g. collapsed larc) so that we can gen a usingpm_r
gen pm_r = .
replace pm_r = 1  if preferredmethod_r == "tubal"
replace pm_r = 2  if preferredmethod_r == "vas"
replace pm_r = 3  if preferredmethod_r == "larc"
replace pm_r = 6  if preferredmethod_r == "pill"
replace pm_r = 5  if preferredmethod_r == "pprs"
replace pm_r = 9  if preferredmethod_r == "condom"
replace pm_r = 12 if preferredmethod_r == "withdr"
replace pm_r = 10 if preferredmethod_r == "fabm"  
replace pm_r = 14 if preferredmethod_r == "other"
replace pm_r = 15 if preferredmethod_r == "none"

label values pm_r pm

tab pm_r pm if pms == 1
tab pm_r pmcat if pms == 1

gen pmcat_r = .
replace pmcat_r = pm_r if pm_r < 5
replace pmcat_r = pm_r if pm_r < 5
replace pmcat_r = 5 if pm_r == 6
replace pmcat_r = 6 if pm_r == 5
replace pmcat_r = 7 if pm_r == 9
replace pmcat_r = 8 if pm_r == 12
replace pmcat_r = 9 if pm_r == 10 | pm_r == 13 | pm_r == 14
replace pmcat_r = 10 if pm_r == 15
label values pmcat_r pmcat


gen usingpm_r = 0
replace usingpm_r = 1 if pm_r == cpmethod
replace usingpm_r = 1 if pm_r == 3 & (cpmethod == 3 | cpmethod == 4) // implant or IUD collapsed
replace usingpm_r = 1 if pm_r == 5 & (cpmethod == 5 | cpmethod == 7 | cpmethod == 8) // patch, ring, shot
replace usingpm_r = 1 if pm_r == 14 & (cpmethod == 11 | cpmethod == 14)  // other incl diaphragm
