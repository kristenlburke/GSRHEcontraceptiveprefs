// Guttmacher Survey of Repro Health Experiences
// Contraceptive Preferences Analysis
// Started Jan 2023
// Published 2024

// Burke, K. L., & Lindberg, L. D. (2024). Gender, Power, and Nonpreferred Contraceptive Use in the United States: Results from a National Survey. Socius, 10, 23780231241282641.

// NOTE: this file should be run from your main working directory for this project,
// which also contains setup_GSRHEconprefs.do and setup_<username>.do, modeled after
// setup_example.do

********************
** Run setup file **
********************

// Set up working environment, pointing to data location,
// output folders, etc.

do "setup_GSRHEconprefs.do"


***************
** Open data **
***************

use "$GSRHEraw/GSRHE 2021 Public Use.dta", clear


*************
** Recodes **
*************

do "data/vars.do"


**************
** Analyses **
**************

// Ns for describing sample
gen excludesample = 0
// included based on preg, trying, pvi
replace excludesample = 1 if pregdummy == 1
replace excludesample = 1 if tryingdummy == 1
replace excludesample = 1 if sexdummy == 0
// there are also 2 more who  report not having PVI in current method
replace excludesample = 1 if case_id == 813		// Anal
replace excludesample = 1 if case_id == 6483	// I don't have sex with men.
tab excludesample 

// hysterectomy
replace excludesample = 1 if hysterectomy == 1
tab excludesample
// listwise
replace excludesample = 1 if completemethoddata == 0 
replace excludesample = 1 if skippedpm == 1
replace excludesample = 1 if listwise == 1
tab excludesample

tab excludesample sample_source

do "analysis/analysis_final.do"

// Sensitivity analysis - alternative handling of multiple preferences
do "analysis/sensitivity.do"
