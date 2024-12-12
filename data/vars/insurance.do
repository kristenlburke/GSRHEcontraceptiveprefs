// insurance status
*ins_priv ins_med ins_oth ins_fillin ins_dk ins_none ins_skp ins_ref

gen insurancecat3 = .
replace insurancecat3 = 3 if ins_none == 1
replace insurancecat3 = 2 if ins_med == 1 
replace insurancecat3 = 1 if ins_priv == 1
label define insurancecat3 1 "Private" 2 "Public" 3 "None (incl dk & other)"
label values insurancecat3 insurancecat3 

* bro case_id ins_fillin if ins_oth == 1
// code up insurance
replace insurancecat3 = 1 if case_id == 15	 // Progressive
replace insurancecat3 = 3 if case_id == 108	 // Life insurance
replace insurancecat3 = 2 if case_id == 220	 // Veteran�s health benefits
replace insurancecat3 = 2 if case_id == 315	 // ChampVA
replace insurancecat3 = 1 if case_id == 388	 // Work
replace insurancecat3 = 2 if case_id == 676	 // Medicare
replace insurancecat3 = 2 if case_id == 772	 // military insurance (tricare)
replace insurancecat3 = 1 if case_id == 865	 // Health insurance through spouse job
replace insurancecat3 = 1 if case_id == 875	 // Bluecross
replace insurancecat3 = 2 if case_id == 888	 // Medicare
replace insurancecat3 = 3 if case_id == 890	 // Travel Health Insurance
replace insurancecat3 = 1 if case_id == 900	 // On my parents still
replace insurancecat3 = 2 if case_id == 914	 // Medicare
replace insurancecat3 = 3 if case_id == 982	 // Other
replace insurancecat3 = 1 if case_id == 1005 //	Worker insurance
replace insurancecat3 = 2 if case_id == 1107 //	medical managed care
replace insurancecat3 = 2 if case_id == 1201 //	Medicare
replace insurancecat3 = 2 if case_id == 1207 //Tricare
replace insurancecat3 = 2 if case_id == 1344 //	VA
replace insurancecat3 = 3 if case_id == 1586 //	Health Insurance
replace insurancecat3 = 1 if case_id == 1630 //	Florida Blue
replace insurancecat3 = 2 if case_id == 1658 //	military, tricare
replace insurancecat3 = 2 if case_id == 1877 //	Medicare
replace insurancecat3 = 2 if case_id == 2032 //	Tribal
replace insurancecat3 = 2 if case_id == 2165 //	TennCare
replace insurancecat3 = 2 if case_id == 2290 //	Medicare
replace insurancecat3 = 1 if case_id == 2436 //	Work
replace insurancecat3 = 1 if case_id == 2473 //	Blue cross blue shield
replace insurancecat3 = 2 if case_id == 2666 //	Tricare
replace insurancecat3 = 3 if case_id == 3038 //	preventive & wellness plan
replace insurancecat3 = 1 if case_id == 3047 //	Husbands insurance
replace insurancecat3 = 2 if case_id == 3067 //	Tricare
replace insurancecat3 = 2 if case_id == 3083 //	Medi-cal
replace insurancecat3 = 2 if case_id == 3137 //	Tribal Health
replace insurancecat3 = 2 if case_id == 3148 //	Fallon
replace insurancecat3 = 2 if case_id == 3226 //	Indian Health Services
replace insurancecat3 = 3 if case_id == 3481 //	Health sharing
replace insurancecat3 = 2 if case_id == 3492 //	Indian health services
replace insurancecat3 = 3 if case_id == 3606 //	healthshare
replace insurancecat3 = 2 if case_id == 3645 //	Tricare (military) through my spouse
replace insurancecat3 = 2 if case_id == 3663 //	Tricare
replace insurancecat3 = 3 if case_id == 3687 //	Christian Healthcare
replace insurancecat3 = 2 if case_id == 3853 //	Medical
replace insurancecat3 = 2 if case_id == 4024 //	Medicare
replace insurancecat3 = 2 if case_id == 4180 //	medicare
replace insurancecat3 = 2 if case_id == 4187 //	Tricare
replace insurancecat3 = 2 if case_id == 4204 //	Medicare
replace insurancecat3 = 1 if case_id == 4220 //	meridian health
replace insurancecat3 = 2 if case_id == 4268 //	Covered California
replace insurancecat3 = 3 if case_id == 4390 //	Christian Medical Bill Sharing Company
replace insurancecat3 = 2 if case_id == 4608 //	Tricare
replace insurancecat3 = 2 if case_id == 4674 //	Tricare
replace insurancecat3 = 3 if case_id == 4676 //	Christian sharing ministry
replace insurancecat3 = 1 if case_id == 4793 //	oscar inssurance
replace insurancecat3 = 3 if case_id == 4893 //	Health sharing organization
replace insurancecat3 = 3 if case_id == 4951 //	Local hospital
replace insurancecat3 = 2 if case_id == 5183 //	Tricare
replace insurancecat3 = 2 if case_id == 5369 //	medical
replace insurancecat3 = 2 if case_id == 5441 //	Medicare
replace insurancecat3 = 2 if case_id == 5444 //	Military
replace insurancecat3 = 3 if case_id == 5446 //	Christian Share Group
replace insurancecat3 = 2 if case_id == 5473 //	Medicare
replace insurancecat3 = 2 if case_id == 5486 //	Tricare
replace insurancecat3 = 2 if case_id == 5573 //	medical
replace insurancecat3 = 2 if case_id == 5711 //	Tricare
replace insurancecat3 = 2 if case_id == 5966 //	Obamacare
replace insurancecat3 = 2 if case_id == 6147 //	VA
replace insurancecat3 = 2 if case_id == 6174 //	state insurance
replace insurancecat3 = 1 if case_id == 6246 //	United health insurance
replace insurancecat3 = 1 if case_id == 6487 //	Stat farm
replace insurancecat3 = 2 if case_id == 6520 //	hap


// if there are "others" w/o write-in, put them in other/none
replace insurancecat3 = 3 if ins_oth == 1 & insurancecat3 == .


gen insurancedummy = .
replace insurancedummy = 0 if insurancecat3 == 3
replace insurancedummy = 1 if insurancecat3 > 0 & insurancecat3 < 3