

/*================================================================================
	Table 1. Baseline covariate balance
================================================================================*/

capture erase "table1.tex"
	file open fh using "$out/table1.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccccccc} "_n ///
		"\toprule "_n ///
		" & Control & MLP & Doctor & MLP = C & D = C & D = MLP & Joint \\"_n 


/*---------------------------------------------------------------
	Panel A: health services variables
---------------------------------------------------------------*/

file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{A: Health center variables}} \\" 

* Read in dataset
	use "$data/woman", clear
	keep if consent==1
	
* Preserve dataset
	preserve
	
* Keep relevant variables
	duplicates drop fid, force
	keep fid strata clinict hc_* control mlp doctor
	ren hc_* *

* Prepare variable labels for LaTeX
	label var water  "Has running water"
	label var lab  "Has a laboratory"
	label var drugs "Has a pharmacy"
	label var open24hrs "24-hour service"
	label var travel_time "Travel time to referral hospital"
	label var cesarean "Does caesarean"
	label var transfusion "Does blood transfusion"
	label var equipment "Essential equipment (\% available)"
	label var deliveries "Deliveries per month"
	label var cond "General condition (1-4)"
	label var clean "Cleanliness (1-4)"
	label var vent "Delivery room has fan or A/C"

* Post pvalues to separate dataset
	tempname results
	tempfile pval
	postfile `results' str20 (p1 p2 p3) using `pval', replace

* Balance tests
	global a water nopower beds workers lab drugs open24hrs travel_time ///
	cesarean transfusion equipment deliveries cond clean vent
	
	foreach var of varlist $a  {
		foreach i of numlist 0/2 {
			su `var' if clinict == `i'
			local `var'_`i' = string(r(mean), "%10.3f")
		}
		reghdfe `var' mlp doctor, cl(fid) abs(strata)
		test (mlp=0)							// mlp = control
		local p1=string(`r(p)', "%10.2f")
		test (doctor=0) 						// doctor = control
		local p2=string(`r(p)', "%10.2f")
		test (mlp=doctor) 						// mlp = doctor
		local p3=string(`r(p)', "%10.2f")	
		test (mlp=0) (doctor=0) 				// joint test
		local p_all=string(`r(p)', "%10.2f")
	file write fh "`: variable label `var'' & ``var'_0' & ``var'_1'  & ``var'_2' & `p1' & `p2' & `p3' & `p_all'\\"_n
	post `results' ("`p1'") ("`p2'") ("`p3'")
	}

* Sample sizes
	foreach i of numlist 0/2 {
		count if clinict == `i'
		local n`i' = string(r(N), "%10.0f")
	}
	file write fh " Sample size & `n0' & `n1'  & `n2' &  &  &  &  \\"_n ///

* Omnibus test		
	est clear
	foreach v in control mlp doctor {
		qui reg `v' $a, abs(strata)
		est store `v'
		}
	qui suest mlp doctor, vce(cluster fid)
	test $a
	
	local omni=string(`r(p)', "%10.2f")
	est drop control mlp doctor
	
	file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
	 "\midrule "_n 

* Restore dataset
	restore

/*---------------------------------------------------------------
	Panel B: Participant characteristics
----------------------------------------------------------------*/

file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{B: Mother and Household variables}} \\" 

* Balance tests

	global b age hausa moslem mschool1 notread autonomy priorb ///
	pastdeath last cct asset hhsize 
	
* Prepare variable labels for LaTeX
	label var cct "Offered conditional incentive"
	label var priorb "Number of prior births"
	label var hhsize "Household size"
	
	foreach var of varlist $b  {
		foreach i of numlist 0/2 {
			su `var' if clinict == `i'
			local `var'_`i' = string(r(mean), "%10.3f")
			}
		reghdfe `var' mlp doctor, cl(fid) abs(strata)
		test (mlp=0)							// mlp = control
		local p1=string(`r(p)', "%10.2f")
		test (doctor=0) 						// doctor = control
		local p2=string(`r(p)', "%10.2f")
		test (mlp=doctor) 						// mlp = doctor
		local p3=string(`r(p)', "%10.2f")	
		test (mlp=0) (doctor=0) 				// joint test
		local p_all=string(`r(p)', "%10.2f")
	file write fh "`: variable label `var'' & ``var'_0' & ``var'_1'  & ``var'_2' & `p1' & `p2' & `p3' & `p_all'\\"_n
	post `results' ("`p1'") ("`p2'") ("`p3'")
	}
	
* Sample sizes
	foreach i of numlist 0/2 {
		count if clinict == `i'
		local n`i' = string(r(N), "%10.0f")
		}
	
	file write fh " Sample size & `n0' & `n1'  & `n2' &  &  &  &  \\"_n ///

* Omnibus test
	est clear
	foreach v in control mlp doctor {
		qui reg `v' $b, abs(strata)
		est store `v'
		}
	qui suest mlp doctor, vce(cluster fid)
	test $b
	local omni=string(`r(p)', "%10.2f")
	est drop control mlp doctor
	
	file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///
	 "\midrule "_n 


/*---------------------------------------------------------------
	Panel C: Child characteristics
----------------------------------------------------------------*/

file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{C: Child variables}} \\" 

* Read in dataset
	use "$data/child", clear

* Prepare variable labels for LaTeX
	label var card "Health card available"
	
* Balance tests

	global c male multiple csection card 
	foreach var of varlist $c  {
		foreach i of numlist 0/2 {
			su `var' if clinict == `i'
			local `var'_`i' = string(r(mean), "%10.3f")
			}
		reghdfe `var' mlp doctor, cl(fid) abs(strata)
		test (mlp=0)							// mlp = control
		local p1=string(`r(p)', "%10.2f")
		test (doctor=0) 						// doctor = control
		local p2=string(`r(p)', "%10.2f")
		test (mlp=doctor) 						// mlp = doctor
		local p3=string(`r(p)', "%10.2f")	
		test (mlp=0) (doctor=0) 				// joint test
		local p_all=string(`r(p)', "%10.2f")
	file write fh "`: variable label `var'' & ``var'_0' & ``var'_1'  & ``var'_2' & `p1' & `p2' & `p3' & `p_all'\\"_n
	post `results' ("`p1'") ("`p2'") ("`p3'")
	}
	postclose `results'
	
* Sample sizes
	foreach i of numlist 0/2 {
		count if clinict == `i'
		local n`i' = string(r(N), "%10.0f")
		}
	file write fh "Sample size  & `n0' & `n1'  & `n2' &  &  &  &  \\"_n

* Omnibus test
	est clear
	foreach v in control mlp doctor {
		qui reg `v' $c, abs(strata)
		est store `v'
		}
	qui suest mlp doctor, vce(cluster fid)
	test $c
	local omni=string(`r(p)', "%10.2f")
	est drop control mlp doctor
	
	file write fh " Omnibus test (p-value) &   &   &  &  &  & & `omni'  \\"_n 

	
/*---------------------------------------------------------------
	End preamble
----------------------------------------------------------------*/

file write fh " \bottomrule "_n ///
"\end{tabular} "_n

file close fh
macro drop fh 










