// Vars of interest:
// current use
// preferred method use
// reason for non-preferred use

// Important filter questions
// S2 -  currently pregnant
// S3 -  trying to become pregnant
// Q19 - sexual activity

** Inclusion criteria **
// Preferred method question not asked of those who are pregnant, trying to 
// become pregnant, or those who haven't had sex in last 30 days
// vars: exclude
do "data/vars/inclusion.do"

** Current method **
// vars: cpmethod cpmethod_othcol
do "data/vars/currentmethod.do"

** Preferred method **
// vars: usingpm usinganypm pm
do "data/vars/preferredmethod.do"

** Reason for discordance **
do "data/vars/reasonsfornonuse.do"

** Insurance **
// vars: insurancecat3 insurancedummy
do "data/vars/insurance.do"

** Demographics & covariates
// vars: racethn fplcat4 educ3 marstat straight cis paritydummy
do "data/vars/demographics.do"

** Coercion **
do "data/vars/coercion.do"

** Pregnancy avoidance **
do "data/vars/pregavoid.do"



** Listwise deletion
gen listwise = .
foreach var in agecat3 racethn fplcat2 marstat straight paritydummy insurancecat3 cpmethodcat10 pm educat3 coerce_score pregavoid_inverse {
	di "`var'"
	cou if `var' == . & exclude == 0 
	replace listwise = 1 if `var' == . & exclude == 0
}

replace exclude = 1 if listwise == 1 


** Save recoded data
save "$GSRHEkeep/GSRHE_recoded.dta", replace
