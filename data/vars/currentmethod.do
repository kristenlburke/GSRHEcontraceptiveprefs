** Current method **
// Current method defined as the one used in the last 30 days.


/* QUESTION TEXT AND RAW VARIABLES

Q19. Sexual activity (starts skip pattern)
In the past 30 days, about how many times have you had penile-vaginal sex?

raw variable: sex30


*IF HAD SEX IN LAST 30 DAYS*

Q21.
In the past 30 days, which of the following contraceptive methods have you used, even if you used them for reasons other than pregnancy prevention?

raw variables: pill30_pvi patch30_pvi ring30_pvi shot30_pvi implant30_pvi iud30_pvi tubal30_pvi none30_pvi dk30_pvi skp30_pvi ref30_pvi


Q27. 
In the past 30 days when you had sex, did you or your partner(s) use any of the following at least once? Select all that apply.
raw vars: withdrawal30 condom30 fabm30 diaphragm30 ec30 vasectomy30 other30 coital30_fillin none30_coital dk30_coital skp30_coital ref30_coital


*IF NO SEX IN LAST 30 DAYS*
// Given that preferred method is only asked of those who have recently been sexually active,
// we won't use these.

Q40.
In the past 30 days, which of the following contraceptive methods have you used, even if you used them for reasons other than pregnancy prevention?
*/



** Question completion check
// indicate skipped whole question
gen skippedrxmethod = 0
replace skippedrxmethod = 1 if 		pill30_pvi == .a    | pill30_pvi == .s    | ///
									patch30_pvi == .a   | patch30_pvi == .s   | ///
									ring30_pvi == .a    | ring30_pvi == .s    | ///
									shot30_pvi == .a    | shot30_pvi == .s    | ///
									implant30_pvi == .a | implant30_pvi == .s | ///
									iud30_pvi == .a     | iud30_pvi == .s | ///
									tubal30_pvi == .a   | tubal30_pvi == .s   | ///
									none30_pvi == .a    | none30_pvi == .s    | ///
									dk30_pvi == .a      | dk30_pvi == .s 

gen skippedcoitalmethod = 0
replace skippedcoitalmethod = 1 if 	withdrawal30 == .a  | withdrawal30 == .s  | ///
									condom30 == .a      | condom30 == .s      | ///
									fabm30 == .a        | fabm30 == .s        | ///
									diaphragm30 == .a   | diaphragm30 == .s   | ///
									ec30 == .a          | ec30 == .s          | ///
									vasectomy30 == .a   | vasectomy30 == .s   | ///
									other30 == .a       | other30 == .s       | ///
									none30_coital == .a | none30_coital == .s | ///
									dk30_coital == .a   | dk30_coital == .s 
									
gen completemethoddata = 0
replace completemethoddata = 1 if skippedrxmethod == 0 & skippedcoitalmethod == 0
tab completemethoddata if exclude == 0
replace exclude = 1 if completemethoddata == 0 
// 23 people who skipped one or the other of the current method questions who would
// otherwise be included in the analysis.
									

***********************
** CODE UP WRITE-INS **
***********************

// In the coital methods question, there is an open-ended response question.
// Browse those and code up where possible.
count if coital30_fillin != " " & exclude == 0
list case_id coital30_fillin if coital30_fillin != " "
*bro case_id coital30_fillin if coital30_fillin != " "

// Generate a *true* other cateogry to put those that can't be coded up into
gen other30_codedup = 0

// Also generate a hysterectomy category - we might want to exclude those
// who are unable to become pregnant for non-contraceptive reasons
gen hysterectomy = 0

// Exclude those who indicate that they're not having PVI
replace exclude = 1 if case_id == 813	// Anal
replace exclude = 1 if case_id == 6483	// I don't have sex with men.


// Other write-ins
replace tubal30_pvi = 1 	if case_id == 292 // Fixes
replace none30_coital = 1 	if case_id == 313 // He comes inside of me.
replace tubal30_pvi = 1 	if case_id == 317 // Tubes tied
replace pill30_pvi = 1 		if case_id == 397 // Pills
replace tubal30_pvi = 1 	if case_id == 553 // Tubes tied
replace iud30_pvi = 1 		if case_id == 559 // IUD
replace hysterectomy = 1 	if case_id == 591 // Hysterectomy
replace other30_codedup = 1 if case_id == 592 // Spermacide
replace none30_coital = 1 	if case_id == 603 // Did not pull out
replace tubal30_pvi = 1 	if case_id == 726 // I had a tubal
replace iud30_pvi = 1 		if case_id == 807 //	iud
replace other30_codedup = 1 if case_id == 909 // Spermicide gel
replace tubal30_pvi = 1 	if case_id == 958 // Essure implant
replace iud30_pvi = 1 		if case_id == 1122 // IUD
replace iud30_pvi = 1 		if case_id == 1158 // Iud
replace iud30_pvi = 1 		if case_id == 1230 // IUD
replace hysterectomy = 1 	if case_id == 1316 //	Partial hysterectomy
replace hysterectomy = 1 	if case_id == 1321 // Hysterectomy
replace tubal30_pvi = 1 	if case_id == 1461 // Tubes tied
replace hysterectomy = 1 	if case_id == 1519 // partial hysterectomy
replace pill30_pvi = 1 		if case_id == 1688 // The pill
replace hysterectomy = 1 	if case_id == 1746 // hysterectomy
replace tubal30_pvi = 1	 	if case_id == 1753 // My tubes have been tied.
replace hysterectomy = 1 	if case_id == 1772 //	Hysterectomy
replace hysterectomy = 1 	if case_id == 1870 //	Hysterectomy
replace other30_codedup = 1 if case_id == 1901 //	Toys
replace ring30_pvi = 1 		if case_id == 1935 // Nuvaring
replace hysterectomy = 1 	if case_id == 1946 // Hysterectomy
replace hysterectomy = 1 	if case_id == 1995 // hysterectomy
replace tubal30_pvi = 1 	if case_id == 2000 // Having tubes tied
replace tubal30_pvi = 1 	if case_id == 2084 // C ction
replace tubal30_pvi = 1 	if case_id == 2098 // My tubes tided
replace hysterectomy = 1 	if case_id == 2183 //	Hysterectomy
replace iud30_pvi = 1 		if case_id == 2218 // IUD mirena
replace iud30_pvi = 1 		if case_id == 2298 // Iud
replace tubal30_pvi = 1 	if case_id == 2327 // Tubal ligation
replace hysterectomy = 1 	if case_id == 2346 // Hysterectomy
replace none30_coital = 1 	if case_id == 2353 //	Nothing
replace tubal30_pvi = 1 	if case_id == 2594 // I am fixed
replace withdrawal30 = 1 	if case_id == 2788 //	Pills and withdrawal method
replace vasectomy30 = 1 	if case_id == 3199 // Partner has Bilateral Chryptorchidism
replace hysterectomy = 1 	if case_id == 3287 //	Hysterectomy
replace other30_codedup = 1 if case_id == 3423 // Spermicide
replace other30_codedup = 1 if case_id == 3455 // Vcf film
replace iud30_pvi = 1 		if case_id == 3607 // Iud
replace condom30 = 1 		if case_id == 3608 // Spermicidal condoms
replace other30_codedup = 1 if case_id == 3612 // Phexxi
replace other30_codedup = 1 if case_id == 3640 // Exclusively breastfeeding 2 month old infant
replace hysterectomy = 1 	if case_id == 3662 // Hysterectomy
replace other30_codedup = 1 if case_id == 3891 // Partner's feminizing hormone replacement therapy
replace other30_codedup = 1 if case_id == 3901 // 	Birth control
replace tubal30_pvi = 1 	if case_id == 4111 // Tubal ligation
replace tubal30_pvi = 1 	if case_id == 4188 // I've had a tubal ligation surgery
replace hysterectomy = 1 	if case_id == 4193 // I had a hysterectomy
replace other30_codedup = 1 if case_id == 4251 // Lactational Amenorrhea Method
replace none30_coital = 1 	if case_id == 4278 // None
replace other30_codedup = 1 if case_id == 4385 //	spermacide
replace hysterectomy = 1 	if case_id == 4531 // Hysterectomy
replace fabm30 = 1 			if case_id == 4579 //	Natural family planning
replace iud30_pvi = 1 		if case_id == 4695 // IUD
replace other30_codedup = 1 if case_id == 4837 // Currently breastfeeding
replace other30_codedup = 1 if case_id == 4864 // Phexxi non hormonal birth control
replace other30_codedup = 1 if case_id == 4877 // contraceptive film
replace vasectomy30 = 1 	if case_id == 5103 // Vasectomy
replace hysterectomy = 1 	if case_id == 5276 // 	hysterectomy
replace tubal30_pvi = 1 	if case_id == 5387 // Tubal
replace none30_coital = 1 	if case_id == 5441 // No need
replace hysterectomy = 1 	if case_id == 5477 //	oophorectomy
replace hysterectomy = 1 	if case_id == 5556 // hysterectomy
replace hysterectomy = 1 	if case_id == 5570 // Hysterectomy
replace hysterectomy = 1 	if case_id == 5590 // Hysterectomy
replace tubal30_pvi = 1 	if case_id == 5591 // Tubes tied
replace iud30_pvi = 1 		if case_id == 5603 // IUD
replace tubal30_pvi = 1 	if case_id == 5626 // Tubes tied
replace hysterectomy = 1 	if case_id == 5713 // Hysterectomy
replace pill30_pvi = 1 		if case_id == 5732 // the pill
replace iud30_pvi = 1 		if case_id == 5746 // IUD
replace iud30_pvi = 1 		if case_id == 5805 // Mariana
replace tubal30_pvi = 1 	if case_id == 5871 // Essure
replace other30_codedup = 1 if case_id == 5891 // Vaginal contraceptive film
replace hysterectomy = 1 	if case_id == 5893 //	hysterectomy
replace tubal30_pvi = 1 	if case_id == 5959 // 	Essure
replace hysterectomy = 1 	if case_id == 5960 // Hysterectomy
replace hysterectomy = 1 	if case_id == 5968 // Hysterectomy
replace none30_coital = 1 	if case_id == 6089 // Uses nothing
replace other30_codedup = 1 if case_id == 6110 // Spermicide
replace hysterectomy = 1 	if case_id == 6157 // Hysterectomy
replace tubal30_pvi = 1 	if case_id == 6346 // Tubal ligation
replace hysterectomy = 1 	if case_id == 6519 // 	Hysterectomy
replace hysterectomy = 1 	if case_id == 6529 // Hysterectomy


** Dummy vars for each method
// These are basically already created bc all method vars are coded 0/1
// but I need to recode the "none" to collapse the rx and coital "none"s because
// these questions are asked separately.
gen none30 = .
replace none30 = 1 if completemethoddata == 1
// if respondent said yes to anything in the rx or coital methods and they 
// completed the methods data, then they were not using "none"
foreach method in pill30_pvi patch30_pvi ring30_pvi shot30_pvi implant30_pvi ///
				  iud30_pvi tubal30_pvi withdrawal30 condom30 fabm30 diaphragm30 ///
				  ec30 vasectomy30 hysterectomy other30_codedup {
	replace none30 = 0 if `method' == 1 & none30 != .			  	
}

									
** Categorical - most effective method
gen cpmethod = .
replace cpmethod = 1  if tubal30_pvi == 1 		& cpmethod == .						// fem ster
replace cpmethod = 2  if vasectomy30 == 1 		& cpmethod == .						// male ster
replace cpmethod = 3  if implant30_pvi == 1 	& cpmethod == .						// implant
replace cpmethod = 4  if iud30_pvi == 1 		& cpmethod == .						// IUD
replace cpmethod = 5  if shot30_pvi == 1 		& cpmethod == .						// shot
replace cpmethod = 6  if pill30_pvi == 1 		& cpmethod == .						// pill 
replace cpmethod = 7  if patch30_pvi == 1 		& cpmethod == .						// patch
replace cpmethod = 8  if ring30_pvi == 1 		& cpmethod == .						// patch 
replace cpmethod = 9  if condom30 == 1			& cpmethod == .						// Condom
replace cpmethod = 10 if fabm30 == 1 			& cpmethod == .						// natural
replace cpmethod = 11 if diaphragm30 == 1 		& cpmethod == .						// diaphragm
replace cpmethod = 12 if withdrawal30 == 1 		& cpmethod == .						// withdrawal
replace cpmethod = 13 if ec30 == 1 				& cpmethod == .						// ec
replace cpmethod = 14 if other30_codedup == 1 	& cpmethod == .						// other
replace cpmethod = 15 if none30 == 1 			& cpmethod == .						// none

label define cpmethod 1 "Permanent (female)" 2 "Permanent (male partner)" 3 "Implant" 4 "IUD" ///
					  5 "Shot " 6 "Pill" 7 "Patch" 8 "Ring" 9 "Condom" 10 "Fertility awareness" ///
					  11 "Diaphragm" 12 " Withdrawal" 13 "Emergency contraception" 14 "Other" ///
					  15 "None"
label values cpmethod cpmethod					  
					
// is everyone sorted?
tab cpmethod if completemethoddata == 1 & exclude == 0, m
// who are these 20 missings? hysterectomies
tab cpmethod hysterectomy if completemethoddata == 1 & exclude == 0, m



****************************************
****************************************
* ADDRESSING TUBAL LIGATION UNDERCOUNT *
****************************************
****************************************

// GSRHE has lower prevalence of tubals than in NFSG
// A few more reports of tubals arenhiding in different Qs that I've dug up 
// to try to more correctly identify those w/ tubal ligations & exclude those
// who had hysterectomies.

// baseline
tab cpmethod, m
svy: tab cpmethod if sex30 != 1


clonevar cpmethod_missing = cpmethod
// who is RIGHTFULLY missing- skipped Q21&27 bc no sex in 30 days
replace cpmethod_missing  = .a if sex30 == 1 & cpmethod_missing == .
// who skipped coital method questions
replace cpmethod_missing = .c if (skippedcoitalmethod == 1) & (cpmethod_missing == .)
// who skipped rx method questions
replace cpmethod_missing = .r if (skippedrxmethod == 1) & (cpmethod_missing == .)
// who had a hysterectomy 
replace cpmethod_missing = .h if hysterectomy == 1     

tab cpmethod_missing, m
tab cpmethod_missing
svy: tab cpmethod_missing if sex30 != 1

// fill in for those who are cpmethod == .a - missing because they didn't have sex
// in the last 30 days and therefore don't report on coital methods but are asked
// about methods not involved in pvi (_npvi)
clonevar cpmethod_gt30 = cpmethod 

replace cpmethod_gt30 = 1  if tubal30_npvi == 1 	& cpmethod_gt30 == .						// fem ster*
replace cpmethod_gt30 = 3  if implant30_npvi == 1 	& cpmethod_gt30 == .						// implant *
replace cpmethod_gt30 = 4  if iud30_npvi == 1 		& cpmethod_gt30 == .						// IUD
replace cpmethod_gt30 = 5  if shot30_npvi == 1 		& cpmethod_gt30 == .						// shot *
replace cpmethod_gt30 = 6  if pill30_npvi == 1 		& cpmethod_gt30 == .						// pill *
replace cpmethod_gt30 = 7  if patch30_npvi == 1 	& cpmethod_gt30 == .						// patch*
replace cpmethod_gt30 = 8  if ring30_npvi == 1 		& cpmethod_gt30 == .						// ring * 
replace cpmethod_gt30 = 15 if none30_npvi == 1 		& cpmethod_gt30 == .						// none

// who skipped npvi who should have answered?
gen skippedsex30 = 0
replace skippedsex30 = 1 if sex30 == .s
gen skippednpvi = 0
replace skippednpvi = 1 if sex30 == 1 & (tubal30_npvi == .a | ///
										 implant30_npvi == .a | ///
										 iud30_npvi == .a | ///
										 shot30_npvi == .a | ///
										 pill30_npvi == .a | ///
										 patch30_npvi == .a | ///
										 ring30_npvi == .a | ///
										 none30_npvi == .a )
replace cpmethod_gt30 = .a if skippedsex30 == 1
replace cpmethod_gt30 = .c if (skippedcoitalmethod == 1) & (cpmethod_gt30 == .)
replace cpmethod_gt30 = .h if hysterectomy == 1

// how many more tubal surfaced among those w/o sex in last 30 days?
tab cpmethod_gt30
svy: tab cpmethod_gt30 
tab cpmethod_missing cpmethod_gt30, m


// 6 months -- among those who reported no sex in last 30 days and no method
// use in the last 30 days, regardless of sexual activity
tab cpmethod_gt30 tubal6mo
replace cpmethod_gt30 = 1 if tubal6mo == 1
tab cpmethod_missing tubal6mo 
replace cpmethod_missing = 1 if tubal6mo == 1

svy: tab cpmethod_gt30 
svy: tab cpmethod_missing if sex30 != 1


***********************
** LIKELY INFERTILTY **
***********************

// there are a couple of qs (12, 13) about likely infertility, which include a q of why
// respondents might think that they're infertile-- a potential place to 
// pick up more tubals. 

tab infert_likely
// export the reasons for infertility among those who said "other"
// (listed reasons were provider told me i might be, i've had sex w/o getting preg)
outsheet case_id infert_other infert_fillin using "$GSRHEresults/handrecodes/infertfillin.xls", replace

// recode these in excel
preserve
clear all
import excel using "$GSRHEresults/handrecodes/infertfillin_recoded.xls", firstrow

destring case_id, replace

save "$GSRHEresults/handrecodes/infertfillin_recoded.dta", replace

restore

// merge back into main data
merge 1:1 case_id using "$GSRHEresults/handrecodes/infertfillin_recoded.dta", force
drop _merge

tab cpmethod_gt30 infert_tubal, m
replace cpmethod_gt30 = 1 if infert_tubal == 1
replace cpmethod_missing = 1 if infert_tubal == 1 & sex30 != 1


*****************************************
** Reasons for not using contraception **
*****************************************

// export reasons for no contraceptive use into excel - another potential place
// for reporting tubals
sort whynocp_other whynocp_fillin
outsheet case_id whynocp_other whynocp_fillin using "$GSRHEresults/handrecodes/whynocpfillin.xls", replace

// recode in excel and import back in
preserve
clear all
import excel using "$GSRHEresults/handrecodes/whynocpfillin_recoded.xlsx", firstrow

destring case_id, replace

save "$GSRHEresults/handrecodes/whynocpfillin_recoded.dta", replace

restore

merge 1:1 case_id using "$GSRHEresults/handrecodes/whynocpfillin_recoded.dta", force
drop _merge
tab cpmethod_gt30 nocp_tubal, m
replace cpmethod_gt30 = 1 if nocp_tubal == 1
replace cpmethod_missing = 1 if nocp_tubal == 1 & sex30 != 1


**************************
** reasons for stopping ** 
**************************
bro case_id stopped_fillin if stopped_fillin != " "
gen stopped_tubal = .
gen stopped_hysterectomy = .


replace stopped_tubal = 1 if case_id == 4030 //	You can�t not use tubal ligation
replace stopped_hysterectomy = 1 if case_id == 5405	// hysterectomy


bro case_id stopped_fillin_coital if stopped_fillin_coital != " "

replace stopped_tubal = 1 if case_id == 664	// We are both permintly starol
replace stopped_hysterectomy = 1 if case_id == 2375 //	Hysterectomy


replace cpmethod_gt30 = 1 if stopped_tubal == 1
replace cpmethod_missing = 1 if stopped_tubal == 1 & sex30 != 1

********************************
** other method last 6 months ** 
********************************
bro case_id coital6_fillin if coital6_fillin != " "

gen other6_hysterectomy = .
gen other6_tubal = .


replace other6_hysterectomy = 1 if case_id == 1782	// Hysterectomy
replace other6_hysterectomy = 1 if case_id == 2375	// I had a hysterectomy due to a cancer scare
replace other6_hysterectomy = 1 if case_id == 3401	// Hysterectomy
replace other6_tubal = 1 if case_id == 5267			// Tubes tied
replace other6_hysterectomy = 1 if case_id == 5787	// Hysterectomy
replace other6_tubal = 1 if case_id == 5914			// e-sure

replace cpmethod_gt30 = 1 if other6_tubal == 1
replace cpmethod_missing = 1 if other6_tubal == 1 & sex30 != 1

**************************************
** reasons for not seeking services **
**************************************

sort whynoserv_fillin
outsheet case_id whynoserv_fillin using "$GSRHEresults/handrecodes/whynoservfillin.xls", replace

// recode in excel and import back in
preserve
clear all
import excel using "$GSRHEresults/handrecodes/whynoservfillin_recoded.xlsx", firstrow

destring case_id, replace

save "$GSRHEresults/handrecodes/whynoservfillin_recoded.dta", replace

restore

merge 1:1 case_id using "$GSRHEresults/handrecodes/whynoservfillin_recoded.dta", force
drop _merge

replace cpmethod_gt30 = 1 if noserv_tubal == 1
replace cpmethod_missing = 1 if noserv_tubal == 1 & sex30 != 1


********************
** HYSTERECTOMIES **
********************

tab hysterectomy
replace hysterectomy = 1 if infert_hysterectomy == 1
replace hysterectomy = 1 if nocp_hysterectomy == 1
replace hysterectomy = 1 if stopped_hysterectomy == 1
replace hysterectomy = 1 if other6_hysterectomy == 1
replace hysterectomy = 1 if noserv_hysterectomy == 1
replace cpmethod_missing = .h if hysterectomy == 1
replace cpmethod_gt30 = .h if hysterectomy == 1

tab cpmethod_gt30
svy: tab cpmethod_gt30, ci
tab cpmethod_missing if sex30 != 1
svy: tab cpmethod_missing  if sex30 != 1, ci


*********************
** RESET CP METHOD **
*********************

// set cpmethod = cpmethod_missing to pull in those
// additional tubals and other corrections based on this fact-finding expedition
replace cpmethod = cpmethod_missing





**********************************************
**********************************************
** RETURN TO CATEGORICAL VARIABLES cpmethod **
********************************************** 
**********************************************


// Collapse "others"
gen cpmethod_othcol = .
replace cpmethod_othcol = 1 if cpmethod == 1 // F permanetn 
replace cpmethod_othcol = 2 if cpmethod == 2 // M permanent
replace cpmethod_othcol = 3 if cpmethod == 3 // Implant
replace cpmethod_othcol = 4 if cpmethod == 4 // IUD
replace cpmethod_othcol = 5 if cpmethod == 5 // Shot
replace cpmethod_othcol = 6 if cpmethod == 6 // Pill 
replace cpmethod_othcol = 7 if cpmethod == 7 // Patch
replace cpmethod_othcol = 8 if cpmethod == 8 // Ring
replace cpmethod_othcol = 9 if cpmethod == 9 // Condom
replace cpmethod_othcol = 10 if cpmethod == 10 // FAM
replace cpmethod_othcol = 11 if cpmethod == 12 // Withdrawal
replace cpmethod_othcol = 12 if cpmethod == 11 | cpmethod == 13 | cpmethod == 14 // Other (incl diaphragm and EC)
replace cpmethod_othcol = 13 if cpmethod == 15 // None
label define cpmethod_othcol 1 "Permanent (female)" 2 "Permanent (male partner)" 3 "Implant" 4 "IUD" ///
					  5 "Shot" 6 "Pill" 7 "Patch" 8 "Ring" 9 "Condom" 10 "Fertility awareness" ///
					  11 " Withdrawal" 12 "Other" 13 "None"
label values cpmethod_othcol cpmethod_othcol	
					  
					  
gen cpmethodcat10 = .
replace cpmethodcat10 = 1 if cpmethod == 1 									  // F permanent 
replace cpmethodcat10 = 2 if cpmethod == 2 									  // M permanent
replace cpmethodcat10 = 3 if cpmethod == 3 | cpmethod == 4 					  // Implant or IUD
replace cpmethodcat10 = 4 if cpmethod == 6 									  // Pill 
replace cpmethodcat10 = 5 if cpmethod == 5 | cpmethod == 7 | cpmethod == 8 	  // Shot, patch, ring
replace cpmethodcat10 = 6 if cpmethod == 9 									  // Condom
replace cpmethodcat10 = 7 if cpmethod == 12 								  // Withdrawal
replace cpmethodcat10 = 8 if cpmethod == 10 								  // FABM
replace cpmethodcat10 = 9 if cpmethod == 11 | cpmethod == 13 | cpmethod == 14 // Other (incl diaphragm and EC)
replace cpmethodcat10 = 10 if cpmethod == 15 								  // None
label define cpmethodcat10 1 "Permanent (female)" 2 "Permanent (male partner)" 3 "LARC" 4 "Pill" ///
					  5 "Shot, patch, ring" 6 "Condom" 7 "Withdrawal" 8 "Fertility Awareness" 9 "Other" 10 "None"
label values cpmethodcat10 cpmethodcat10	


gen cpmethodcat9 = cpmethodcat10
replace cpmethodcat9 = 8 if cpmethodcat9 == 9
label define cpmethodcat9 1 "Permanent (female)" 2 "Permanent (male partner)" 3 "LARC" 4 "Pill" ///
					  5 "Shot, patch, ring" 6 "Condom" 7 "Withdrawal" 8 "Fertility awareness and other" 10 "None"
label values cpmethodcat9 cpmethodcat9	


// dummy var coding of these 10 methods 
gen usingster = 0
replace usingster = 1 if tubal30_pvi == 1
gen usingvase = 0
replace usingvase = 1 if vasectomy30 == 1
gen usinglarc = 0
replace usinglarc = 1 if implant30_pvi == 1 | iud30_pvi == 1
gen usingpill = 0
replace usingpill = 1 if pill30_pvi == 1
gen usingshot = 0 // includes shot, patch, ring
replace usingshot = 1 if shot30_pvi == 1 | patch30_pvi == 1 | ring30_pvi == 1
gen usingcond = 0
replace usingcond = 1 if condom30 == 1
gen usingwthd = 0
replace usingwthd = 1 if withdrawal30 == 1
gen usingfabm = 0
replace usingfabm = 1 if fabm30 == 1
gen usingothr = 0
replace usingothr = 1 if other30_codedup == 1
gen usingnone = 0
replace usingnone = 1 if none30 == 1

foreach method in ster vase larc pill shot cond wthd fabm othr none {
	tab cpmethodcat10 using`method', col
}

					  
** Categorical - force into one category, including "multiple methods"

// generate a row total variable that sums up how many methods one reports using
egen nmethods = rowtotal(tubal30_pvi vasectomy30 implant30_pvi iud30_pvi shot30_pvi ///
						 pill30_pvi patch30_pvi ring30_pvi condom30 fabm30 diaphragm30 ///
						 withdrawal30 ec30 other30_codedup)
						
gen nmethodscat = .
replace nmethodscat = 0 if none30 == 1
replace nmethodscat = 1 if nmethods == 1
replace nmethodscat = 2 if nmethods >= 2 & nmethods < .

gen cpmethod_mult = cpmethod
replace cpmethod_mult = 16 if nmethodscat == 2
label define cpmethod_mult 1 "Permanent (female)" 2 "Permanent (male partner)" 3 "Implant" 4 "IUD" ///
					  5 "Shot " 6 "Pill" 7 "Patch" 8 "Ring" 9 "Condom" 10 "Fertility awareness" ///
					  11 "Diaphragm" 12 " Withdrawal" 13 "Emergency contraception" 14 "Other" ///
					  15 "None" 16 "Multiple methods"
label values cpmethod_mult cpmethod_mult	

gen contraceptingdummy = .
replace contraceptingdummy = 0 if cpmethod == 15
replace contraceptingdummy = 1 if cpmethod < 15 & cpmethod != .
