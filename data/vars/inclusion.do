** Inclusion criteria

// Given that this analysis is focused on contraceptive preferences, we only 
// want to include those who preferences were solicited from. 

// Q38 [SHOW IF S3=2,77,98 AND Q19=2,3 AND S2=2,77,98]]
// The question about prefereneces was asked of those who...
// S3 (trypreg) - trying to become preg - no (2), 77 (don't know), 98 (no answer)
// S2 (preg)    - currently pregnant - no (2), 77 (don't know), 98 (no answer) 
// Q19 (sex30)  - sex in last 30 days - 1-4x (2), 5+ (3)


** Sexual activity dummy
// Note: 11 missing, skipped the Q - skippers don't get follow-ups on this one
gen sexdummy = .
replace sexdummy = 0 if sex30 == 1 | sex30 == .s
replace sexdummy = 1 if sex30 == 2 | sex30 == 3

** Preg dummy 
// 137 don't know, 3 skipped
// Initiate to 0, which includes the dk and skips in the 0
gen pregdummy = 0
replace pregdummy = 1 if preg == 1

** trying dummy 
// 266 don't know, 3 skipped
// Initiate to 0, which includes the dk and skips in the 0
gen tryingdummy = 0
replace tryingdummy = 1 if trypreg == 1

** preg OR trying
gen pregortrying = 0 
replace pregortrying = 1 if pregdummy == 1 | trypreg == 1

** Inclusion/exclusion criteria
gen exclude = 0 
replace exclude = 1 if pregdummy == 1
replace exclude = 1 if tryingdummy == 1
replace exclude = 1 if sexdummy == 0
tab exclude
