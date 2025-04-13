

/*=============================================================================================
		Table A.16. Mean characteristics of health care users by experimental arm
==============================================================================================*/


capture erase "apptab16.tex"
	file open fh using "$out/apptab16.tex", write replace
		file write fh ///
		"\small" ///
		"\begin{tabular}{lccccccc} "_n ///
		"\toprule "_n ///
		" & Control & MLP & Doctor & MLP = C & D = C & D = MLP & Joint \\"_n 
		
file write fh "\multicolumn{8}{p{0.99\textwidth}}{\textbf{Variables}} \\" 
	
* Read in dataset
	use "$data/woman", clear
	keep if consent==1
	
* Restrict to women who used medical care
	keep if usedcare==1

* Post pvalues to separate dataset
	tempname results
	tempfile pval
	postfile `results' str20 (p1 p2 p3) using `pval', replace
	
* Prepare variable labels for LaTeX
	label var cct "Offered conditional incentive"
	label var priorb "Number of prior births"
	label var hhsize "Household size"
	label var card "Health card available"
	
* Balance tests

	egen pregprob=rowtotal(pregprob? pregprob??)
	label var pregprob "Number of health problems during pregnancy"
	
	global b age hausa moslem mschool1 notread autonomy priorb ///
	pastdeath last cct asset hhsize pregprob card 
	
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
	
	postclose `results'

* Sample sizes
	foreach i of numlist 0/2 {
		count if clinict == `i'
		local n`i' = string(r(N), "%10.0f")
		}
	
	file write fh " Sample size & `n0' & `n1'  & `n2' &  &  &  &  \\"_n ///
	"\midrule "_n 
	
/*---------------------------------------------------------------
	End preamble
----------------------------------------------------------------*/

file write fh " \bottomrule "_n ///
"\end{tabular} "_n

file close fh
macro drop fh 










