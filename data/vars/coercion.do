// coercion.do

// to do - check skp paterns & missingness

gen answeredcoercion = 0
foreach var in coerce_stopped coerce_messed coerce_use coerce_would coerce_pressure coerce_knowledge {
	replace answeredcoercion = 1 if `var' > 0 & `var' < . 
}

fre coerce_stopped coerce_messed coerce_use coerce_would coerce_pressure coerce_knowledge

sum coerce_stopped coerce_messed coerce_use coerce_would coerce_pressure coerce_knowledge

alpha coerce_stopped coerce_messed coerce_use coerce_would coerce_pressure coerce_knowledge

// mean of non-missings
egen coerce_score = rowmean(coerce_stopped coerce_messed coerce_use coerce_would coerce_pressure coerce_knowledge)
