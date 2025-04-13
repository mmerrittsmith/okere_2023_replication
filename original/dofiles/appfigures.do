
*******************************************************************************************************

** This file generates the Appendix figures

*******************************************************************************************************

clear
set more off
// set scheme s1network
	

/*-----------------------------------------------------------------------------
	Figures in Appendix A 
------------------------------------------------------------------------------*/

use "$data/woman", clear

	g lapse=blmth-startdate
	label var lapse "Enrollment month relative to provider start month"
	
	foreach x in blmth lapse { 
		local a : variable label `x'
		#delimit;
			twoway (histogram `x' if clinict==1, disc percent color(khaki))
			(histogram `x' if clinict==2, disc percent fcolor(none) lcolor(black)),
			xtitle("`a'") 
			ytitle(Percent)
			saving("$out/`x'", replace)
			legend(order(1 "MLP" 2 "Doctor") 
			rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
		#delimit cr
		}
	gr combine blmth.gph lapse.gph, col(1) ysize(4) xsize(3)
	gr export "$out/appA.eps", as(eps) preview(off) replace


/*-----------------------------------------------------------------------------
	Figures in Appendix B
------------------------------------------------------------------------------*/

use "$data/woman", clear

	g place=3 if delplace1==0
	replace place=1 if delplace3==1
	replace place=2 if delplace2==1
	label define place 1 "Health center" 2 "Government hospital" 3 "Other facility"
	label values place place
	
	#delimit;
		cibar cardrec2, over1(clinict) over2(place)
		level(95) bargap(5) barcol(gs10 blue red) ciopt()	
		graphopts(ytitle("Probability") xlabel(, labgap(3) valuelabel)
		yscale(range(0 1)) ylabel(0(.2)1) scale(0.9) 
		legend(order(1 "Control" 2 "MLP" 3 "Doctor") 
		rows(1) position(12) ring(1) symxsize(4) region(lw(none))));
		gr export "$out/appB.eps", as(eps) preview(off) replace;
	#delimit cr
	

/*-----------------------------------------------------------------------------
	Figure A.1. Map of Nigeria
------------------------------------------------------------------------------*/

* Map is plotted using Nigeria Demographic and Health Survey GPS shapefiles

// use "$data/map1", clear
// 	ge state=0
// 	replace state=1 if NAME_1=="Akwa Ibom" | NAME_1=="Bauchi" |NAME_1=="Gombe" | NAME_1=="Kano" | NAME_1=="Jigawa"
// 	spmap state using "$data/map2", id(id) legenda(off) clnumber(2) fcolor(white ebg)
// 	gr export "$out/appfig1.eps", as(eps) preview(off) replace


/*-----------------------------------------------------------------------------
	Figure A.2. Health care worker deployment (start month)
------------------------------------------------------------------------------*/

use "$raw/dates", clear
	#delimit;
		twoway (histogram startdate if clinict==1, disc freq color(khaki))
		(histogram startdate if clinict==2, disc freq fcolor(none) lcolor(black)),
		xtitle("Start month") ytitle(Number) legend(order(1 "MLP" 2 "Doctor") 
		rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
// 		gr export "$out/appfig2.eps", as(eps) preview(off) replace;
	#delimit cr
			
	
/*-----------------------------------------------------------------------------
	Figure A.3. Probability that the new health provider was present
------------------------------------------------------------------------------*/

use "$data/audit", clear
	foreach y in present_prov {
		local x auditwhen
		bys clinict `x': egen `y'_m=mean(`y')
		#delimit;
			twoway 
			(scatter `y'_m `x' if clinictreat==2, mc(red) msize(medsmall) lcolor(red))
			(scatter `y'_m `x' if clinictreat==1, mc(blue) msize(medsmall) lcolor(blue))
			(lpolyci `y' `x' if clinictreat==2, lcolor(red) lp(dash) epanechnikov degree(0) ciplot(rline) bw(1) blpattern(dot))
			(lpolyci `y' `x' if clinictreat==1, mc(blue) lcolor(blue) lwidth(vthin) epanechnikov degree(0) ciplot(rline) blwidth(vvthin) bw(1) blpattern(shortdash_dot)),
			title("") ytitle("Probability") xtitle("Months into provider tenure")
			ylabel(0(.2)1, valuelabel) xlabel(0(2)10, valuelabel) 
			legend(order(2 "MLP" 1 "Doctor") 
			rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
			gr export "$out/appfig3.eps", as(eps) preview(off) replace;	
		#delimit cr
	}

/*-----------------------------------------------------------------------------
	Figure A.4. Rates of correct diagnosis and treatment by provider type
------------------------------------------------------------------------------*/

use "$data/provider", clear
	
	label var v1diag1 "Made correct diagnosis"
	label var v1treat_tb "Prescribed correct treatment"
	
	#delimit;
		foreach y of varlist v1diag1 v1treat_tb {;
			local a : variable label `y';
			cibar `y', over1(provider) 
			level(95) bargap(5) barcol(gs10 blue red) ciopt()	
			graphopts(title("`a'") ytitle("Probability")
			xlabel(, labgap(3)) scale(0.9) 
			yscale(range(.2 1)) ylabel(.2(.2)1)
			saving("$out/`y'", replace)
			legend(order(1 "Existing MLP" 2 "New MLP" 3 "Doctor") 
			rows(1) position(6) ring(1) symxsize(4) region(lw(none))));
		};
	#delimit cr
	
	cd "$out"
	grc1leg2 v1diag1.gph v1treat_tb.gph, col(2) iscale(.7) legend(v1treat_tb.gph)
	gr export "$out/appfig4.eps", as(eps) preview(off) replace


/*-----------------------------------------------------------------------------
	Figure A.5. Dosage of treatment: Number of pregnancy months of exposure
------------------------------------------------------------------------------*/

use "$data/woman", clear
	
	#delimit;
		local x dosage;
		qui sum `x', det;
		local med=r(p50);
		replace `x'=-1 if `x'<-1;
		twoway (histogram `x' if clinict==1, disc color(khaki))
		(histogram `x' if clinict==2, disc fcolor(none) lcolor(black))
		(scatteri 0 `med' .15 `med', c(l) m(i) lcolor(black) lpat(dash)),
		xtitle("Months of exposure") ytitle(Density) xline(`med')
		xlabel(0(2)10) legend(order(1 "MLP" 2 "Doctor") 
		rows(2) position(1) ring(0) symxsize(4) size(small) region(lw(none)));
		gr export "$out/appfig5.eps", as(eps) preview(off) replace;
	 #delimit cr


/*-----------------------------------------------------------------------------
	Figure A.6. Probability that health care was received from a doctor
------------------------------------------------------------------------------*/

use "$data/woman", clear

	replace dosage=0 if dosage<0
	foreach y in doctorcare2 {
		local x dosage
		bys clinict `x': egen `y'_m=mean(`y')
	
		#delimit;
			twoway (scatter `y'_m `x' if clinictreat==2, mc(red) lcolor(red) lp(dash))
			(scatter `y'_m `x' if clinictreat==1, mc(blue) lcolor(blue))
			(lpolyci `y' `x' if clinictreat==2, lcolor(red) lp(dash) epanechnikov degree(1) ciplot(rline) bw(1) blpattern(dot))
			(lpolyci `y' `x' if clinictreat==1, mc(blue) lcolor(blue) epanechnikov degree(1) ciplot(rline) bw(1) blpattern(dot)),
			title("") ytitle("Probability") xtitle("Months of exposure")
			yscale(range(0 .3)) ylabel(0(.1).3) xlabel(0(2)10)
			legend(order(1 "Doctor" 2 "MLP") 
			rows(1) position(12) ring(1) symxsize(4) size(small) region(lw(none)));
			gr export "$out/appfig6.eps", as(eps) preview(off) replace;	
		#delimit cr
	}

	
/*-----------------------------------------------------------------------------
	Figure A.7. Differences in clinical ability by provider type
------------------------------------------------------------------------------*/

use "$data/provider", clear

	#delimit;
		local cond inlist(cadre,5,6); 
		foreach y in mscore cscore vscore qscore {;
			local a : variable label `y';
			twoway (kdensity `y' if provider==2, lcolor(red) lp(dash))
			(kdensity `y' if provider==1 & `cond', lcolor(blue))
			(kdensity `y' if provider==0 & `cond', lcolor(gs10)),
			ytitle(Density) xtitle("`a'") saving("$out/`y'2", replace)
			legend(order(3 "Existing MLP" 2 "New MLP" 1 "Doctor") 
			rows(1) position(12) ring(1) symxsize(4) size(small));	
		};
	#delimit cr

	cd "$out"
	grc1leg2 mscore2.gph cscore2.gph vscore2.gph qscore2.gph, col(2) iscale(.7) legend(mscore2.gph) 
	gr export "$out/appfig7.eps", as(eps) preview(off) replace
	

/*-----------------------------------------------------------------------------
	Figure A.8. Was there differential monitoring by experimental arm
------------------------------------------------------------------------------*/

use "$data/audit", clear

	#delimit;
		duplicates drop fid, force;
		local y visits;
		cibar `y', over1(clinict) 
		level(95) bargap(5) barcol(gs10 blue red) ciopt()	
		graphopts(ytitle("Number of visits") xlabel(, labgap(3) valuelabel)
		 yscale(range(0 5)) ylabel(1(1)5) scale(0.9) saving(`y', replace)
		legend(order(1 "Control" 2 "MLP" 3 "Doctor") 
		rows(1) position(6) ring(1) symxsize(4) region(lw(none))));
		gr export "$out/appfig8.eps", as(eps) preview(off) replace;
	#delimit cr


/*-----------------------------------------------------------------------------
	Figure A.9. Was there differential provision of human or capital resources
------------------------------------------------------------------------------*/

use "$raw/facility_el", clear

	label var assess1 "A. Condition of building"
	label var assess2 "B. Condition of other infrastructure"
	label var new "C. Received additional worker"
	label var newstaff "D. Number of additional workers"

	#delimit;
		foreach y in assess1 assess2 {;
			local a : variable label `y';
			cibar `y', over1(clinict) 
			level(95) bargap(5) barcol(gs10 blue red) ciopt()	
			graphopts(title("`a'") ytitle("Rating (1-4)")
			xlabel(, labgap(3)) scale(0.9) 	yscale(range(0 4)) 
			ylabel(1(1)4) saving("$out/`y'", replace) legend(off));
		};
	
		foreach y of varlist new {;
			local a : variable label `y';
			cibar `y', over1(clinict) 
			level(95) bargap(5) barcol(gs10 blue red) ciopt()	
			graphopts(title("`a'") ytitle("Proportion") xlabel(, labgap(3))
			scale(0.9) yscale(range(0 .5)) ylabel(.1(.1).5)
			saving("$out/`y'", replace) legend(off));
		};
	
		foreach y of varlist newst {;
			local a : variable label `y';
			cibar `y', over1(clinict) 
			level(95) bargap(5) barcol(gs10 blue red) ciopt()	
			graphopts(title("`a'") ytitle("Number") xlabel(, labgap(3))
			scale(0.9) yscale(range(0 1)) ylabel(.1(.2)1)
			saving("$out/`y'", replace) legend(off))
			/* legend(order(1 "Control" 2 "MLP" 3 "Doctor") 
			rows(1) position(6) ring(1) symxsize(4) region(lw(none)))) */
			;
		};
	#delimit cr
	
	cd "$out"
	grc1leg2 assess1.gph assess2.gph new.gph newstaff.gph, legend(newstaff.gph) span
	gr export "$out/appfig9.eps", as(eps) preview(off) replace
	

/*-----------------------------------------------------------------------------
	Figure A.10. Distribution of quality by health provider qualifications
------------------------------------------------------------------------------*/

use "$data/provider", clear

	recode cadre (1=1 "Doctor") (2/4=2 "Nurse")(5=3 "CHO")(6/7=4 "CHEW")(else=.), g(cadre2)
	twoway (scatter qscore qindex),  by(cadre2, note("")) yti("Percentage score") xti("Standardized quality index")
	gr export "$out/appfig10.eps", as(eps) preview(off) replace




	
