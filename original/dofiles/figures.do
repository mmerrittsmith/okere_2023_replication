
*******************************************************************************************************

** This file generates the main figures

*******************************************************************************************************

clear
set more off
// set scheme s1network

/*-------------------------------------------------------------------------
	Figure 1. Experimental design
--------------------------------------------------------------------------*/

* Figure was manually constructed using Powerpoint


/*-------------------------------------------------------------------------
	Figure 2. Effect of the intervention on supply
--------------------------------------------------------------------------*/

use "$data/staffing", clear

	collapse (mean) staff doctor, by(clinictreat visit)
	local x visit
	
* Panel A: Number of health providers

	#delimit;
		twoway (connected staff `x' if clinictreat==2, mc(red) lcolor(red) lp(dash))
		(connected staff `x' if clinictreat==1, mc(blue) lcolor(blue))
		(connected staff `x' if clinictreat==0, mc(gs10) lcolor(gs10)),
		ytitle("Number of providers") xtitle("") xlabel(1(1)3, valuelabel) xscale(range(1 3)) 
		yscale(range(4 7)) ylabel(4(1)7, valuelabel)
		legend(order(3 "Control" 2 "MLP" 1 "Doctor") 
		rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
		gr export "$out/fig2a.eps", as(eps) preview(off) replace;
	#delimit cr

* Panel B: Doctor on staff
	#delimit;
		twoway (connected doctor `x' if clinictreat==2, mc(red) lcolor(red) lp(dash))
		(connected doctor `x' if clinictreat==1, mc(blue) lcolor(blue))
		(connected doctor `x' if clinictreat==0, mc(gs10) lcolor(gs10)),
		ytitle("Probability") xtitle("") xlabel(1(1)3, valuelabel) xscale(range(1 3))
		legend(order(3 "Control" 2 "MLP" 1 "Doctor") 
		rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
		gr export "$out/fig2b.eps", as(eps) preview(off) replace;
	#delimit cr


/*----------------------------------------------------------------------------
	Figure 3. Trends in 7-day mortality by experimental arm
-----------------------------------------------------------------------------*/

use "$data/child", clear

	#delimit;
		foreach y in mort7 {;
			local x qtr;
			collapse (mean) `y' (count) n=`y', by(clinictreat `x');
			drop if n<150;	// for stability
			twoway (connected `y' `x' if clinictreat==2, mc(red) lcolor(red) lp(dash))
			(connected `y' `x' if clinictreat==1, mc(blue) lcolor(blue))
			(connected `y' `x' if clinictreat==0, mc(gs10) lcolor(gs10)),
			title("") ytitle("Probability") xtitle("")
			yscale(range(0.01 .05)) ylabel(0.01(.01).05) tlabel(2017q3(1)2018q1)
			legend(order(3 "Control" 2 "MLP" 1 "Doctor") 
			rows(1) position(12) ring(0) symxsize(4) size(small) region(lw(none)));
		};
	#delimit cr
	gr export "$out/fig3.eps", as(eps) preview(off) replace
	

/*----------------------------------------------------------------------------
	Figure 4. Dose-Response Effects
-----------------------------------------------------------------------------*/

* Panel A: Received care from a doctor

use "$data/woman", clear

	#delimit;
		local x dosage;
		local y doctorcare1;
		replace `x'=0 if `x'<0;
		bys clinict `x': egen `y'_m=mean(`y');
		twoway (scatter `y'_m `x' if clinictreat==2, mc(red) lcolor(red) lp(dash))
		(scatter `y'_m `x' if clinictreat==1, mc(blue) lcolor(blue))
		(lpolyci `y' `x' if clinictreat==2, lcolor(red) lp(dash) epanechnikov degree(1) ciplot(rline) bw(1) blpattern(dot))
		(lpolyci `y' `x' if clinictreat==1, mc(blue) lcolor(blue) epanechnikov degree(1) ciplot(rline) bw(1) blpattern(dot)),
		title("") ytitle("Probability") xtitle("Months of exposure")
		yscale(range(0 .3)) ylabel(0(.1).3) xlabel(0(2)10)
		legend(order(1 "Doctor" 2 "MLP") 
		rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
		gr export "$out/fig4a.eps", as(eps) preview(off) replace;	
	#delimit cr

* Panel B: 7-day mortality
	
use "$data/child", clear
	
	#delimit;
		local x dosage;
		local y mort7;
		replace `x'=0 if `x'<0;
		collapse (mean) `y' (count) n=`y', by(clinictreat `x');
		keep if `x'<10; 		// Exclude Month 10 because too few obs 
		twoway (connected `y' `x' if clinictreat==2, mc(red) lcolor(red) lp(dash))
		(connected `y' `x' if clinictreat==1, mc(blue) lcolor(blue) lwidth(vthin)),
		ytitle("Probability") xtitle("Months of exposure")
		yscale(range(0 .08)) ylabel(0(.02).08) legend(order(1 "Doctor" 2 "MLP") 
		rows(1) position(12) ring(0) symxsize(3) size(small) region(lw(none)));
		gr export "$out/fig4b.eps", as(eps) preview(off) replace;
	#delimit cr

	
/*--------------------------------------------------------------------------
	Figure 5. Differences in proficiency by provider type
---------------------------------------------------------------------------*/

use "$data/provider", clear
	
	label var qscore "Overall performance (%)"
	foreach y in mscore cscore vscore qscore {
		local a : variable label `y'
		#delimit;
			twoway 
			(kdensity `y' if provider==2, lcolor(red) lp(dash))
			(kdensity `y' if provider==1, lcolor(blue))
			(kdensity `y' if provider==0, lcolor(gs10)),
			ytitle(Density) xtitle("`a'") saving("$out/`y'", replace)
			legend(order(3 "Existing MLP" 2 "New MLP" 1 "Doctor") 
			rows(1) position(12) ring(1) symxsize(4) size(small));
		#delimit cr
	}

	cd "$out"
	grc1leg2 mscore.gph cscore.gph vscore.gph qscore.gph, col(2) iscale(.7) legend(mscore.gph) span
	gr export "$out/fig5.eps", as(eps) preview(off) replace

