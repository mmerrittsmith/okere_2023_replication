
/*=============================================================================================
		Table A.2. Were attriters different from non-attriters
==============================================================================================*/

capture erase apptab2.tex
	file open fh using "$out/apptab2.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccc} "_n ///
		"\toprule "_n ///
		" & Non-attriters & Attriters & p-value \\"_n 
		
***********************************************************************************************

* Read in dataset
	use "$data/woman", clear
	
* Prepare variable labels for LaTeX
	label var cct "Offered conditional incentive"
	label var priorb "Number of prior births"
	label var hhsize "Household size"
	
* Balance tests
	
	global b age hausa moslem mschool1 notread autonomy priorb ///
	pastdeath last cct asset hhsize 
	
	file write fh "\multicolumn{4}{p{0.99\textwidth}}{\textbf{Mother variables}} \\" 
	
	foreach var of varlist $b  {
		foreach i of numlist 0/1 {
			su `var' if attrit == `i'
			local `var'_`i' = string(r(mean), "%10.3f")
			}
		reghdfe `var' attrit, cl(fid) abs(strata)
		test attrit							
		local p1=string(`r(p)', "%10.2f")

	file write fh "`: variable label `var'' & ``var'_0' & ``var'_1' & `p1' \\"_n 
	}
	
* Sample sizes
	foreach i of numlist 0/1 {
		count if attrit == `i'
		local n`i' = string(r(N), "%10.0f")
		}
	file write fh " Sample size & `n0' & `n1' &  \\"_n ///
	
* Omnibus test
	foreach v in attrit {
		reghdfe `v' $b, abs(strata) vce(cluster fid)
		test $b
		local omni=string(`r(p)', "%10.2f")
		}
	
	file write fh " Omnibus test (p-value) &   &   &  `omni'  \\"_n ///
	
***********************************************************************************************
* End preamble

file write fh " \bottomrule "_n ///
"\end{tabular} "_n

file close fh
macro drop fh 
***********************************************************************************************



/*=============================================================================================
		Table A.3. Was there differential attrition
==============================================================================================*/

capture erase "apptab3.tex"
	file open fh using "$out/apptab3.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccccccc} "_n ///
		"\toprule "_n ///
		" & Control & MLP & Doctor & MLP = C & D = C & D = MLP & Joint \\"_n
		
***********************************************************************************************

* Balance tests

	keep if attrit==1

	file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{Mother variables}} \\" 
	
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
	}
	
	* Sample sizes

	foreach i of numlist 0/2 {
		count if clinict == `i'
		local n`i' = string(r(N), "%10.0f")
		}
	file write fh " Sample size & `n0' & `n1'  & `n2' &  &  &  &  \\"_n

	* Omnibus test

	foreach v in control mlp doctor {
		reg `v' $b, abs(strata)
		est store `v'
		}
	suest control mlp doctor, vce(cluster fid)
	test $b
	local omni=string(`r(p)', "%10.2f")
	est drop control mlp doctor
	
	file write fh " Omnibus test (p-value) &   &   &  &  &  &  & `omni'  \\"_n ///

***********************************************************************************************
* End preamble

file write fh " \bottomrule "_n ///
"\end{tabular} "_n

file close fh
macro drop fh 
***********************************************************************************************
