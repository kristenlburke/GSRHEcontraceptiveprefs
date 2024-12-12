// demographics.do

** age
gen agecat6 = .
replace agecat6 = 1 if age >= 15 & age < 20
replace agecat6 = 2 if age >= 20 & age < 25
replace agecat6 = 3 if age >= 25 & age < 30
replace agecat6 = 4 if age >= 30 & age < 35
replace agecat6 = 5 if age >= 35 & age < 40
replace agecat6 = 6 if age >= 40 & age < .
label define agecat6 1 "18-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40+"
label values agecat6 agecat6

gen agecat3 = .
replace agecat3 = 1 if age >= 18 & age < 25
replace agecat3 = 2 if age >= 25 & age < 35
replace agecat3 = 3 if age >= 35 & age < . 
label define agecat3 1 "18-24" 2 "25-34" 3 "35-49"
label values agecat3 agecat3

** educ
gen educat3 = .
replace educat3 = 1 if educ5 == 1 | educ5 == 2
replace educat3 = 2 if educ5 == 3
replace educat3 = 3 if educ5 == 4 | educ5 == 5
label define educat3 1 "HS or less" 2 "Some college" 3 "BA+"
label values educat3 educat3


** race/ethnicity
gen racethn = .
replace racethn = 1 if racethnicity == 1
replace racethn = 2 if racethnicity == 2
replace racethn = 3 if racethnicity == 4
replace racethn = 4 if racethnicity == 3 | racethnicity == 5 | racethnicity == 6
label define racethn 1 "NH White" 2 "NH Black" 3 "Hispanic" 4 "Other, incl multiracial"
label values racethn racethn

** fpl
gen fplcat4 = faminc
label define fplcat4 1 "< 100%" 2 "100-199%" 3 "200-299%" 4 "300% +"
label values fplcat4 fplcat4
gen fplcat2 = 1 	if faminc == 1 | faminc == 2
replace fplcat2 = 2 if faminc == 3 | faminc == 4


** marstat
gen marstat = .
replace marstat = 1 if marital == 1
replace marstat = 2 if marital == 6
replace marstat = 3 if marital >= 2 & marital <= 5
label define marstat 1 "Married" 2 "Cohabiting" 3 "Single/sep/div/wid"
label values marstat marstat


** sexual orientation
gen straight = .
replace straight = 0 if hetero == 0
replace straight = 1 if hetero == 1

gen lgb = .
replace lgb = 1 if straight == 0 
replace lgb = 0 if straight == 1


** cis
gen cis = .
replace cis = 0 if woman == 0
replace cis = 1 if woman == 1


** parity dummy
// this survey asked a lot of different Qs re: pregnancies bc the purpose was
// testing abortion Qs. WE'll just have a dummy var for ever had a birth, as
// that's the most complex that we can universally achieve based on data structure

foreach var in f1a2a_live f1a2b_live f1a2c_live f1a2d_live f1a2e_live f1a2f_live f1b2a_live f1b2b_live f1b2c_live f1b2d_live f1b2e_live f1b2f_live {
	fre `var'
}

gen paritydummy = .
foreach var in f1a2a_live f1a2b_live  f1a2d_live f1a2e_live f1a2f_live f1b2a_live f1b2b_live  f1b2d_live f1b2e_live f1b2f_live {
	replace paritydummy = 0 if `var' == 0 			 & paritydummy == .
	replace paritydummy = 1 if `var' > 0 & `var' < . & paritydummy == .
}
// two yes/no questions
foreach var in f1a2c_live f1b2c_live {
	replace paritydummy = 0 if `var' == 2 & paritydummy == .
	replace paritydummy = 1 if `var' == 1 & paritydummy == .
}


