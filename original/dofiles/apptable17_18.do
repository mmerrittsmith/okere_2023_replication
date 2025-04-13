

/*-----------------------------------------------------------------------------
	Table A.17. Effect on average provider quality (First stage)
------------------------------------------------------------------------------*/

use "$data/provider", clear

* Keep one obs per facility
	duplicates drop fid, force
	
* Regression

	quietly {
		eststo clear
		foreach y in avgqscore avgqindex {
			eststo: reghdfe `y' i.clinict, abs(strata)
			sum `y' if e(sample) & clinict==0
			estadd r(mean)
		}
	}
	
	#delimit ;
		esttab using "$out/apptab17", keep(1.clinictreat 2.clinictreat) replace b(%9.3f) se(%9.3f)
		noconstant nonotes label nostar eqlabels(" " " ")
		coeflabels(1.clinictreat "MLP Village" 2.clinictreat "Doctor Village")
		mtitles("Proficiency score \%" "Standardized Proficiency")
		booktabs width(\hsize) 
		scalars("mean Control group mean");
	#delimit cr	
	

/*-----------------------------------------------------------------------------
	Table A.18. (New) Provider quality and infant mortality
------------------------------------------------------------------------------*/

use "$data/provider", clear

* Average proficiency using only new provider
	
	foreach v in qscore qindex {
		g _`v'=`v' if provider>0
		bys fid: egen avg`v'1=total(_`v')
		replace avg`v'1=avg`v' if avg`v'1==0
		drop _`v'
	}

* Merge with outcomes data 

	duplicates drop fid, force
	keep fid avg* 
	merge 1:m fid using "$data/child", nogen

* Regressions
	
	replace avgqscore1=avgqscore1/10
	quietly {
		eststo clear
		foreach y of varlist mort7 {
			foreach x in avgqscore1 avgqindex1 {				
				eststo: reghdfe `y' `x' $cont_hc $cont_base, abs(strata qtr) cl(fid)
				sum `y' if e(sample) & control==1
				estadd r(mean)
			}
		}
	}
		
	#delimit ;
		esttab using "$out/apptab18", replace keep(avg*) b(%9.4f) se(%9.4f) 
		noconstant nomtitles nonotes nostar eqlabels(" " " ")	
		coeflabel(avgqscore1 "Proficiency score (\%)" 
		avgqindex1 "Standardized proficiency") booktabs width(\hsize) 
		scalars("mean Control group mean");
	#delimit cr






	
