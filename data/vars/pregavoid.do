// pregavoid.do

gen wantmore = .
replace wantmore = 1 if futurechild == 1 | futurechild == 2 | futurechild == 3
replace wantmore = 2 if futurechild == 4
replace wantmore = 3 if futurechild == 5
label define wantmore 1 "Yes" 2 "No" 3 "Unsure"
label values wantmore wantmore


// pregnancy avoidance
// 1- very important to avoid; 5 - very unimportant to avoid
fre pregavoid

gen pregavoid_inverse = .
replace pregavoid_inverse = 5 if pregavoid == 1
replace pregavoid_inverse = 4 if pregavoid == 2
replace pregavoid_inverse = 3 if pregavoid == 3
replace pregavoid_inverse = 2 if pregavoid == 4
replace pregavoid_inverse = 1 if pregavoid == 5
