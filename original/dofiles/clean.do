*******************************************************************************************************

** This file processes the raw data files  

*******************************************************************************************************


/*=============================================================================
		Woman Baseline data
=============================================================================*/

use "$raw/woman_bl.dta", clear

* Label variables

ren	state	state
ren	sid	sid
ren	strata	strata
ren	fid	fid
ren	eaid	eaid
ren	wid	wid
ren	blmth	blmth
ren	monthspreg	gest
ren	age	age
ren	cct	cct
ren	bl_havenumber	phonenum
ren	bl_b1	mob
ren	bl_b2	estage
ren	bl_b3	marital
ren	bl_b4	ethnicity
ren	bl_b5	religion
ren	bl_b6	reside
ren	bl_b7	reside_yr
ren	bl_b8	education
ren	bl_b9	schooling
ren	bl_b10	read
ren	bl_b11	occup
ren	bl_b12	work
ren	bl_b13	husbage
ren	bl_b14	polygamy
ren	bl_b15	wives
ren	bl_b16	husbeduc
ren	bl_b17	husbschool
ren	bl_b18	husboccup
ren	bl_b19	husbwork
ren	bl_b20	decide1
ren	bl_b21	decide2
ren	bl_c1	hhsize
ren	bl_c2	own
ren	bl_c3	dwelling
ren	bl_c4	floor
ren	bl_c5	walls
ren	bl_c6	roof
ren	bl_c7	water
ren	bl_c8	electric
ren	bl_c9	fuel
ren	bl_c10	toilet
ren	bl_c11	share
ren	bl_c12	kitchen
ren	bl_c13	rooms
ren	bl_c14a	radio
ren	bl_c14b	tv
ren	bl_c14c	bicycle
ren	bl_c14d	motorbike
ren	bl_c14e	generator
ren	bl_c14f	phone
ren	bl_c14g	computer
ren	bl_c14h	cart
ren	bl_c14i	car
ren	bl_c14j	boat
ren	bl_c14k	fridge
ren	bl_c15	bank
ren	priorb	priorb
ren	lastbfac	lastbfac
ren	pastdeath	pastdeath
ren	clinictreat	clinictreat

* Label variables

label var	state	"	State	"
label var	sid	"	State ID	"
label var	strata	"	Strata ID	"
label var	fid	"	Clinic ID	"
label var	eaid	"	Enumeration area ID	"
label var	wid	"	Woman ID	"
label var	blmth	"	Month of enrollment	"
label var	gest	"	Months pregnant at enrollment	"
label var	age	"	Age at enrollment	"
label var	cct	"	Offered incentive	"
label var	phonenum	"	Does repondent have a phone 	"
label var	mob	"	Do you know  your date of birth	"
label var	estage	"	If unknown: estimated age	"
label var	marital	"	What is your current marital status	"
label var	ethnicity	"	What is your ethnic group or tribe	"
label var	religion	"	What religion do you practice?	"
label var	reside	"	Have you always lived in this community	"
label var	reside_yr	"	In what year did you start living in this community	"
label var	education	"	Have you ever attended school (western or Islamic)	"
label var	schooling	"	What is the highest level of school you attended	"
label var	read	"	I would like you to read this sentence to me: The man goes to his farm every day	"
label var	occup	"	What is the your main occupation	"
label var	work	"	Have you worked in the last 12 months	"
label var	husbage	"	How old was your husband or partner on his last birthday	"
label var	polygamy	"	Are you his only wife or does he have other wives	"
label var	wives	"	How many other wives does he have	"
label var	husbeduc	"	Did he ever attend school (western or Islamic)	"
label var	husbschool	"	What is the highest level of school he attended	"
label var	husboccup	"	What is his main occupation	"
label var	husbwork	"	Has your husband/partner worked in the last 12 months	"
label var	decide1	"	Who usually decides how the money you earn will be used in the family	"
label var	decide2	"	Who usually makes decisions about health care for yourself	"
label var	hhsize	"	How many people live in your household (including yourself)	"
label var	own	"	Who owns the dwelling the household occupies	"
label var	dwelling	"	What is main type of dwelling of the household	"
label var	floor	"	What is the main material of the floor	"
label var	walls	"	What is the main material of the exterior wall	"
label var	roof	"	What is the main material of the roof	"
label var	water	"	What is the main source of drinking water for the household	"
label var	electric	"	Is the household connected to electricity i.e., PHCN/NEPA	"
label var	fuel	"	What is the main source of cooking fuel	"
label var	toilet	"	What type of toilet facility does the household use	"
label var	share	"	Is this toilet shared with other households?	"
label var	kitchen	"	Do you have a separate room that is used as a kitchen	"
label var	rooms	"	How many rooms in this household are used for sleeping	"
label var	radio	"	Does the household own - radio	"
label var	tv	"	Does the household own - tv	"
label var	bicycle	"	Does the household own - bike	"
label var	motorbike	"	Does the household own - motorbike	"
label var	generator	"	Does the household own - generator	"
label var	phone	"	Does the household own - mobile phone	"
label var	computer	"	Does the household own - computer	"
label var	cart	"	Does the household own - animal drawn cart	"
label var	car	"	Does the household own - car/truck	"
label var	boat	"	Does the household own - boat with motor	"
label var	fridge	"	Does the household own - refridgerator	"
label var	bank	"	Does any member of this household have a bank account	"
label var	priorb	"	Number  of previous births	"
label var	lastbfac	"	Last birth was in a health facility	"
label var	pastdeath	"	Prior stillbirth or newborn death	"
label var	clinictreat	"	Clinic treatment	"

* Remove leading blanks in labels

foreach v of varlist _all {
	local a : variable label `v'
	label var `v' "`a'"
	label var `v' "`=strltrim("`: var lab `v''")'" 	
}

* Define value labels

#delimit;
label define yesno
	   0 No
	   1 Yes
	   2 No
	   ;
label define yesno1
	   1        Yes     
	   2        No      
	   3        "Dont know/remember" 
	   ;
label define wife
	   1 "Only wife"
	   2 "Other wives"
	   ;
label define decision
	   1 Respondent
	   2 "Husband/partner"
	   3 "Respondent and husband/partner"
	   4 Other
	   ;
label define occup
	   1 "Agricultural worker, own field"
	   2 "Agricultural wage-labor, for cash or in kind"
	   3 "Salaried employee (private sector)"
	   4 "Salaried employee (government)"
	   5 "Has a trade e.g., carpenter"
	   6 "Business/trader"
	   7 "Petty trader/kiosk"
	   8 Laborer
	   9 Homemaker
	  10 Retired
	  11 Student
	  12 "Never worked, seeking work"
	  13 "Never worked, not seeking work"
	  99 "Dont know"
	  ;
label define educ
	   1 Kindergarten
	   2 "Primary 1"
	   3 "Primary 2"
	   4 "Primary 3"
	   5 "Primary 4"
	   6 "Primary 5"
	   7 "Primary 6"
	   8 JS1
	   9 JS2
	  10 JS3
	  11 SS1
	  12 SS2
	  13 SS3
	  14 "College of educ/polytechnic"
	  15 "University (bachelors)"
	  16 "University (masters or up)"
	  17 "Koranic school"
	  99 "Dont know"
	  ;
label define m_status
	   1 "never married"
	   2 married
	   3 "partner-living together, not married"
	   4 divorced
	   5 separated
	   6 widowed
	   ;
label define dateknown
	   1 "Respondent knows"
	   2 "Respondent does not know"
	   ;
label define toilet
	   1 "flush toilet"
	   2 "traditional pit latrine"
	   3 "ventilated improved pit lat."
	   4 "bucket latrine"
	   5 "no facility/bush/field"
	   6 other
	   ;
label define water
	   1 "piped-dwelling"
	   2 "piped-yard/plot"
	   3 "piped to neighbor"
	   4 "public tap"
	   5 "tube well or borehole"
	   6 "protected well"
	   7 "unprotected well"
	   8 "protected spring"
	   9 "unprotected spring"
	  10 rainwater
	  11 "tanker truck"
	  12 "cart with small tank"
	  13 "surface water"
	  14 "bottled water"
	  15 other
	  ;
label define fuel
	   1 electricity
	   2 gas
	   3 kerosene
	   4 "coal,lignite"
	   5 charcoal
	   6 wood
	   7 solar
	   8 "straw/shrubs/grass"
	   9 "agricultural crop"
	  10 "animal dung"
	  11 "no food cooked in household"
	  12 other
	  ;
label define roof
	   1 "natural roof"
	   2 "rudimentary roof"
	   3 "finished roof"
	   ;
label define exterior
	   1 "natural walls"
	   2 "rudimentary walls"
	   3 "finished walls"
	   ;
label define floor
	   1 "natural floor"
	   2 "rudimentary floor"
	   3 "finished floor"
	   ;
label define owner
	   1 "Owned by family or one of its members"
	   2 rented
	   3 "occupied without payment"
	   4 other
	   ;
label define dwelling_type
	   1 "permanent buildling"
	   2 "semi permanent"
	   3 temporary
	   ;
label define read
	   1 "Cannot read at all"
	   2 "Able to read only parts of sentence"
	   3 "Able to read whole sentence"
	   4 "Blind/visually impaired"
	   ;
label define ethnic
	   1 Fulani
	   2 Hausa
	   3 Tangale
	   4 Tera
	   5 Waja
	   6 Igbo
	   7 Yoruba
	   8 Ibibio
	   9 Efik
	  10 Oron
	  11 Annang
	  12 Other
	  ;
label define religion
	   1 catholic
	   2 anglican
	   3 pentecostal
	   4 "other christian"
	   5 muslim
	   6 traditionalist
	   7 atheist
	   8 other
	   ;
label define treatment 
		0 Control 
		1 MLP 
		2 Doctor
;
#delimit cr

* Apply value labels

label values	cct	yesno
label values	phonenum	yesno
label values	mob	dateknown
label values	marital	m_status
label values	ethnicity	ethnic
label values	religion	religion
label values	reside	yesno
label values	education	yesno
label values	schooling	educ
label values	read	read
label values	occup	occup
label values	work	yesno
label values	polygamy	wife
label values	husbeduc	yesno
label values	husbschool	educ
label values	husboccup	occup
label values	husbwork	yesno
label values	decide1	decision
label values	decide2	decision
label values	own	owner
label values	dwelling	dwelling_type
label values	floor	floor
label values	walls	exterior
label values	roof	roof
label values	water	water
label values	electric	yesno
label values	fuel	fuel
label values	toilet	toilet
label values	share	yesno
label values	kitchen	yesno
label values	radio	yesno
label values	tv	yesno
label values	bicycle	yesno
label values	motorbike	yesno
label values	generator	yesno
label values	phone	yesno
label values	computer	yesno
label values	cart	yesno
label values	car	yesno
label values	boat	yesno
label values	fridge	yesno
label values	bank	yesno
label values	clinictreat	treatment1

* Format variables

loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

foreach v in blmth { 
	local a : variable label `v'
	g double _`v'=monthly(`v',"MY")
	format _`v' %tm
	label var _`v' "`a'"
	order _`v', after(`v')
	drop `v' 
	ren _`v' `v'
}

foreach v of varlist phonenum reside education work husbeduc husbwork electric share kitchen radio tv bicycle motorbike generator phone computer cart car boat fridge bank { 
	replace `v'=0 if `v'==2
	label values `v' yesno
}

local var reside_yr
replace `var'=year(blmth)-`var' if `var'<1900
replace `var'=2005 if `var'==20005
replace `var'=2016 if `var'==20016

* Save
save "$proc/woman_bl", replace

/*=============================================================================
		Woman Endline data
=============================================================================*/

use "$raw/woman_el.dta", clear

* Rename variables

ren	state	state
ren	sid	sid
ren	strata	strata
ren	fid	fid
ren	eaid	eaid
ren	wid	wid
ren	date	intmth
ren	followup	followup
ren	dead	dead
ren	consent	consent
ren	cct	cct
ren	b1	wanted
ren	b2	anc
ren	b3	ancprov
ren	b3_other	ancprov_oth
ren	b4	ancplace
ren	b4_other	ancplace_oth
ren	b5	anctime
ren	b6	ancvisits
ren	b7	anccare1
ren	b8	anccare2
ren	b9	anccare3
ren	b10	anccare4
ren	b11	anccare5
ren	b12	anccare6
ren	b13	anccare7
ren	b14	anccare8
ren	b15	anccare9
ren	b16	anccare10
ren	b17	tetanus
ren	b18	iron
ren	b19	malaria
ren	b20	pregprob1
ren	b21	pregprob2
ren	b22	pregprob3
ren	b23	pregprob4
ren	b24	pregprob5
ren	b25	pregprob6
ren	b26	pregprob7
ren	b27	pregprob8
ren	b28	pregprob9
ren	b29	pregprob10
ren	b30	pregprob11
ren	b31	pregprob12
ren	b32	pregprob13
ren	b33	pregprob_oth
ren	b34	pregtreat
ren	b35	treatwhere
ren	c1	outcome
ren	c2	month
ren	c3a	pregweeks
ren	c3b	pregmths
ren	c4	early
ren	c5	delplace
ren	c6	delnights
ren	c7	reason1
ren	c8	reason2
ren	c9	delprov
ren	c9_other	delprov_oth
ren	c10	laborpain
ren	c11	delprob1
ren	c12	delprob2
ren	c13	delprob3
ren	c14	delprob4
ren	c15	delprob5
ren	c16	delprob6
ren	c17	delprob7
ren	c18	delprob_oth
ren	c19	referral
ren	c20	refwhere
ren	c21	babypart
ren	c22	cesarean
ren	c23	cs_why
ren	c24	augment
ren	c25	augwhat
ren	c26	assist
ren	c27	painmed
ren	c28	episio
ren	c29	push
ren	c30	injmed
ren	c31	tabmed
ren	c32	ivmed
ren	c33	cord
ren	c34	massage
ren	c35	turned
ren	c36	mistreat1
ren	c37	mistreat2
ren	c38	satisf
ren	c39	pay1
ren	c40	cost1
ren	c41	pay2
ren	c42	cost2
ren	c43	pay3
ren	c44	cost3
ren	c45	pay4
ren	c46	cost4
ren	c47	pay5
ren	c48	cost5
ren	c49	pay6
ren	c50	cost6
ren	d1	pnc
ren	d2	pncwhen
ren	d3	pncplace
ren	d4	pncprov
ren	d4_other	pncprov_oth
ren	d5	pncwhat
ren	d6	pnc2
ren	d7	pncwhen2
ren	d8	pncvisits
ren	d9	vitamin
ren	d10	postpart1
ren	d11	postpart2
ren	d12	postpart3
ren	d13	postpart4
ren	d14	postpart5
ren	d15	postpart6
ren	d16	postpart7
ren	d17	postpart_oth
ren	d18	posttreat
ren	d19	postwhere
ren	d20	night
ren	d21	los
ren	e1	multip
ren	e2	multipnum
ren	e3	alive
ren	e4	sex
ren	e6	size
ren	e7	weighed
ren	e8	birthwt
ren	e9	status
ren	e10	diedwhen
ren	e11	diedage
ren	e12	diarrhea
ren	e13	diarrhea1
ren	e14	diarrhea2
ren	e15	diarrhea3
ren	e16	diarrtreat
ren	e17	diarrwhere
ren	e18	treators
ren	e19	treatsalt
ren	e20	treatother
ren	e21	treatelse
ren	e22	fever
ren	e23	fevertreat
ren	e24	feverwhere
ren	e25	cough
ren	e26	cough1
ren	e27	cough2
ren	e28	coughtreat
ren	e29	coughwhere
ren	e30	vacrecord
ren	e31	bcg
ren	e32	opv
ren	e33	hep
ren	e34	weight
ren	e35	length
ren	card	card
ren	card_anc	cardrec1
ren	card_anc_doc	carddoc1
ren	card_del	cardrec2
ren	card_del_doc	carddoc2
ren	card_pnc	cardrec3
ren	clinictreat	clinictreat

* Label variables

label var	state	"	State	"
label var	sid	"	State ID	"
label var	strata	"	Strata ID	"
label var	fid	"	Clinic ID	"
label var	eaid	"	Enumeration area ID	"
label var	wid	"	Woman ID	"
label var	intmth	"	Month of follow-up	"
label var	followup	"	Participant found at followup	"
label var	dead	"	Participant is deceased	"
label var	consent	"	Gave consent for followup	"
label var	cct	"	Offered incentive	"
label var	wanted	"	When you got pregnant did you want to get pregnant at the time	"
label var	anc	"	Did you see anyone for antenatal care for this pregnancy	"
label var	ancprov	"	Whom did you see	"
label var	ancprov_oth	"	Other provider	"
label var	ancplace	"	Where did you receive antenatal care for this pregnancy	"
label var	ancplace_oth	"	Other location	"
label var	anctime	"	How many months pregnant when first received antenatal care	"
label var	ancvisits	"	How many times in total did you receive antenatal care 	"
label var	anccare1	"	Were you weighed	"
label var	anccare2	"	Was your height measured	"
label var	anccare3	"	Was your blood pressure measured	"
label var	anccare4	"	Did you give a urine sample	"
label var	anccare5	"	Did you give a blood sample	"
label var	anccare6	"	Did the provider press on your tummy	"
label var	anccare7	"	Was your uterine height measured	"
label var	anccare8	"	Did the provider ask for your blood type	"
label var	anccare9	"	Were you told about danger signs	"
label var	anccare10	"	Were you counseled and tested for HIV	"
label var	tetanus	"	During this pregnancy were you given an injection to prevent tetanus	"
label var	iron	"	During this pregnancy did you take any iron tablets or iron syrup	"
label var	malaria	"	During this pregnancy did you take drugs to keep you from getting malaria	"
label var	pregprob1	"	Experienced swelling of hands, feet and face during pregnancy	"
label var	pregprob2	"	Experienced paleness, giddiness, weakness during pregnancy	"
label var	pregprob3	"	Experienced blurred vision or other visual disturbance during pregnancy	"
label var	pregprob4	"	Experienced weak or no movement of the fetus during pregnancy	"
label var	pregprob5	"	Experienced excessive fatigue/tiredness during pregnancy	"
label var	pregprob6	"	Experienced convulsions (not from fever) during pregnancy	"
label var	pregprob7	"	Experienced high blood pressure during pregnancy	"
label var	pregprob8	"	Experienced vaginal bleeding during pregnancy	"
label var	pregprob9	"	Experienced excessive vomiting during pregnancy	"
label var	pregprob10	"	Experienced abnormal position of the fetus during pregnancy	"
label var	pregprob11	"	Experienced high fever during pregnancy	"
label var	pregprob12	"	Experienced jaundice during pregnancy	"
label var	pregprob13	"	Experienced water break without labour during pregnancy	"
label var	pregprob_oth	"	Any other problem not mentioned	"
label var	pregtreat	"	Did you seek treatment for these problems	"
label var	treatwhere	"	Where did you seek treatment	"
label var	outcome	"	Pregnancy outcome	"
label var	month	"	When did this happen	"
label var	pregweeks	"	How many weeks pregnant was she	"
label var	pregmths	"	How many months pregnant was she	"
label var	early	"	Was baby born at the expected time	"
label var	delplace	"	Where did you give birth	"
label var	delnights	"	How many nights did you spend in this place	"
label var	reason1	"	Most important reason for chosing delivery location	"
label var	reason2	"	Next most important reason for chosing delivery location	"
label var	delprov	"	Who assisted with the delivery of this pregnancy	"
label var	delprov_oth	"	Other birth attendant	"
label var	laborpain	"	How did your labour pain start	"
label var	delprob1	"	Delivery problems: Convulsions	"
label var	delprob2	"	Delivery problems: Prolonged labour	"
label var	delprob3	"	Delivery problems: Obstructed labour	"
label var	delprob4	"	Delivery problems: Severe vaginal bleeding	"
label var	delprob5	"	Was it serious enough to warrant a blood transfusion	"
label var	delprob6	"	Delivery problems: Loss of consciousness	"
label var	delprob7	"	Delivery problems: Vaginal tear	"
label var	delprob_oth	"	Any other problem not mentioned	"
label var	referral	"	Were you referred to a different place for treatment	"
label var	refwhere	"	Where were you referred to	"
label var	babypart	"	Which part of the baby came out first	"
label var	cesarean	"	Was the baby delivered by Caesarean section	"
label var	cs_why	"	What was the main reason for Caesarean section	"
label var	augment	"	Was anything done to speed up or to strengthen your pain	"
label var	augwhat	"	What was done	"
label var	assist	"	Baby delivered using forceps or suction	"
label var	painmed	"	Did you receive pain medication	"
label var	episio	"	Did anyone do an episiotomy shortly before delivery	"
label var	push	"	Did someone push on your stomach	"
label var	injmed	"	Did you receive an injection in the first few minutes after delivery	"
label var	tabmed	"	Did you receive tablets in the first few minutes after delivery	"
label var	ivmed	"	Did you receive IV medication in the first few minutes after delivery	"
label var	cord	"	Did you receive cord traction	"
label var	massage	"	Was your abdomen massaged to help your womb contract	"
label var	turned	"	Was the baby held upside down	"
label var	mistreat1	"	Did anyone physically mistreat you during delivery	"
label var	mistreat2	"	Did anyone verbally mistreat you during delivery	"
label var	satisf	"	Satisfaction with care	"
label var	pay1	"	Did you make any payment for your delivery	"
label var	cost1	"	How much	"
label var	pay2	"	Did you pay any money for registration/card	"
label var	cost2	"	How much	"
label var	pay3	"	Did you pay any money for lab tests	"
label var	cost3	"	How much	"
label var	pay4	"	Did you pay any money for transportation	"
label var	cost4	"	How much total (to and fro) include the cost for any companions	"
label var	pay5	"	Did you make any other payments for this delivery	"
label var	cost5	"	How much did you pay	"
label var	pay6	"	Did you make any other payments for this delivery	"
label var	cost6	"	How much did you pay	"
label var	pnc	"	Postnatal checkup	"
label var	pncwhen	"	How many days after delivery	"
label var	pncplace	"	Where did this check take place	"
label var	pncprov	"	Who did the checkup	"
label var	pncprov_oth	"	Other provider	"
label var	pncwhat	"	What was done by the health worker during the health check	"
label var	pnc2	"	Did you receive another postnatal check	"
label var	pncwhen2	"	How many days after delivery	"
label var	pncvisits	"	Total number of postnatal checks	"
label var	vitamin	"	Since birth, have you received a Vitamin A dose	"
label var	postpart1	"	Did you experience convulsions in the first 6 weeks after delivery	"
label var	postpart2	"	Did you experience high fever in the first 6 weeks after delivery	"
label var	postpart3	"	Did you experience headache in the first 6 weeks after delivery	"
label var	postpart4	"	Did you experience bleeding in the first 6 weeks after delivery	"
label var	postpart5	"	Did you experience discharge in the first 6 weeks after delivery	"
label var	postpart6	"	Did you experience loss of consciousness in the first 6 weeks after delivery	"
label var	postpart7	"	Did you experience lower abdominal pain in the first 6 weeks after delivery	"
label var	postpart_oth	"	Did you experience any other problems	"
label var	posttreat	"	Did you go to a health facility for assistance	"
label var	postwhere	"	Where did you receive care	"
label var	night	"	Did you stay overnight in the health facility	"
label var	los	"	How many nights in total	"
label var	multip	"	Single or multiple birth	"
label var	multipnum	"	How many babies	"
label var	alive	"	Was the baby born alive	"
label var	sex	"	Sex of baby	"
label var	size	"	Size of baby when born	"
label var	weighed	"	Was the baby weighed at birth	"
label var	birthwt	"	Recorded birthweight	"
label var	status	"	Is the baby still alive	"
label var	diedwhen	"	Did baby die in first month	"
label var	diedage	"	Age at death	"
label var	diarrhea	"	Has baby had diarrhea within last two weeks	"
label var	diarrhea1	"	Was there any blood in the stool	"
label var	diarrhea2	"	How much was the baby given to drink during the diarrhea	"
label var	diarrhea3	"	Amount of food baby ate when he/she had diarrhea	"
label var	diarrtreat	"	Did you seek advice or treatment for the diarrhea	"
label var	diarrwhere	"	Where did you seek advice or treatment	"
label var	treators	"	For diarrhea did you give ORS or pedialyte	"
label var	treatsalt	"	For diarrhea did you give salt-sugar solution	"
label var	treatother	"	For diarrhea did you give anything else	"
label var	treatelse	"	What (else) was given to treat the diarrhea	"
label var	fever	"	Has baby had fever within last two weeks	"
label var	fevertreat	"	Did you seek advice or treatment for the fever	"
label var	feverwhere	"	Where did you seek advice or treatment	"
label var	cough	"	Has baby had cough within last two weeks	"
label var	cough1	"	Did they breathe faster than usual or have difficulty breathing	"
label var	cough2	"	Was this due to a problem in the chest or to a blocked or runny nose	"
label var	coughtreat	"	Did you seek advice or treatment for the cough	"
label var	coughwhere	"	Where did you seek advice or treatment	"
label var	vacrecord	"	Is there a vaccination card	"
label var	bcg	"	Did the child receive BCG vaccination	"
label var	opv	"	Did the child receive polio vaccine	"
label var	hep	"	Did the child receive Hepatitis B vaccine	"
label var	weight	"	Babys weight in kilograms	"
label var	length	"	Babys length in centimeters	"
label var	card	"	Is the womans health card available	"
label var	cardrec1	"	Are any antenatal visits recorded on the card	"
label var	carddoc1	"	Health card: saw doctor during pregnancy	"
label var	cardrec2	"	Is a facility delivery recorded on the card	"
label var	carddoc2	"	Health card: doctor present at birth	"
label var	cardrec3	"	Are any postnatal visits recorded on the card	"
label var	clinictreat	"	Clinic treatment	"

* Remove leading blanks in labels

foreach v of varlist _all {
	local a : variable label `v'
	label var `v' "`a'"
	label var `v' "`=strltrim("`: var lab `v''")'" 	
}

* Define value labels

#delimit;
label define birthcheck
	   1        "Her home"        
	   2        "Other home"      
	   3        "Tertiary/Teaching hospital"      
	   4        "Government hospital"     
	   5        "Health center"       
	   6        "Other health centre"     
	   7        "Health post/dispensary"  
	   8        "Other government facility"       
	   9        "Private hospital/clinic"         
	  10        "Maternity home"  
	  11        "Other private medical sector"   
	  12        Other   
	  ;
label define reason
	   1        "Did not have to go far"  
	   2        "Low cost"        
	   3        "Trust in provider"       
	   4        "Doctor is available"     
	   5        "Female provider"         
	   6        "Believe care is high quality"    
	   7        "Recommendation/referral"         
	   8        "Previous good experience"        
	   9        "In order to receive cash incentive"       
	  10        Other   
	  ;
label define yesno
	   0        No      
	   1        Yes    
	   2		No
	   ;
label define yesno1
	   1        Yes     
	   2        No      
	   3        "Dont know/remember" 
	   ;
label define treat
	   1        "Tertiary/Teaching hospital"      
	   2        "Government hospital"     
	   3        "Health center"       
	   4        "Other government health centre"          
	   5        "Government health post"          
	   6        "Other government facility"       
	   7        "Private hospital/clinic"         
	   8        "Maternity home"          
	   9        "Other private medical sector"    
	  10        "Pharmacy/Chemist"        
	  11        "Traditional birth attendant"     
	  12        Other   
	  ;
label define outcome
	   1        "Ended in a birth"        
	   2        Miscarriage     
	   3        Abortion        
	   4        "Woman died while Pregnant"       
	   ;
label define birthplace
	   1        "Her home"        
	   2        "Other home"      
	   3        "Tertiary/Teaching hospital"      
	   4        "Government hospital"     
	   5        "Health center"       
	   6        "Other health centre"     
	   7        "Health post/dispensary"  
	   8        "Other government facility"       
	   9        "Private hospital/clinic"         
	  10        "Maternity home"  
	  11        "Other private medical sector"    
	  12        "Church/spiritual house"  
	  13        "On the way to hospital"  
	  ;
label define birthtime
	   1        Early           
	   2        "At expected time"        
	   3        Late    
	   ;
label define labor
	   1        "Spontaneous labor"       
	   2        "Someone did something"   
	   3        Other   
	   ;
label define babypart
	   1        Head    
	   2        Buttocks        
	   3        "Hand/foot"       
	   4        Cord    
	  99        "Dont know/remember" 
	  ;
label define operation
	   1        "The doctor/nurse told me I had to"       
	   2        "I was bleeding"  
	   3        "The baby was stuck"      
	   4        "I was in labour pain for a long time"    
	   5        "The baby was not in the right position"  
	   6        "I had a disease"         
	   7        "My womb was broken/ruptured"     
	   8        "There were problems with the baby"       
	   9        "There was no medical reason"     
	  10        "I asked for it"  
	  11        "Dont know/remember" 
	  ;
label define babypull
	   1        Forceps 
	   2        Suction 
	   3        "Delivery was unassisted"    
	   ;
label define pmistreat
	   1        "Yes, hit or slapped"     
	   2        "Yes, physically threatened"      
	   3        "Yes, Other"      
	   4        "No physical mistreatment"  
	   ;
label define vmistreat
	   1        "Yes, verbally threatened"        
	   2        "Yes, shouted at"         
	   3        "Yes, Other"      
	   4        "No verbal mistreatment" 
	   ;
label define satisfy
	   1        "Very unsatisfied"        
	   2        "Somewhat unsatisfied"    
	   3        "Neither satisfied or unsatisfied"        
	   4        "Somewhat satisfied"      
	   5        "Very satisfied"          
	   ;
label define sex
	   1        Boy     
	   2        Girl    
	   3        "Dont Know"  
	   ;
label define multip
	   1 Single
	   2 Multiple
	   ;
label define died
	   1 "0-6 days"
	   2 "7-30 days"
	   ;
label define babysize
	   1        "Very large"      
	   2        "Larger than average"     
	   3        Average         
	   4        "Smaller than average"    
	   5        "Very small"      
	  99        "Dont know/remember" 
	  ;
label define chestnose 
	   1        Chest      
	   2        Nose     
	   3        "Dont know"
	   ;
label define treatment 0 Control 1 MLP 2 Doctor;
#delimit cr

* Apply value labels

label values	wanted	yesno
label values	anc	yesno
label values	anccare1	yesno
label values	anccare2	yesno
label values	anccare3	yesno
label values	anccare4	yesno
label values	anccare5	yesno
label values	anccare6	yesno
label values	anccare7	yesno
label values	anccare8	yesno
label values	anccare9	yesno
label values	anccare10	yesno
label values	tetanus	yesno
label values	iron	yesno
label values	malaria	yesno
label values	pregprob1	yesno
label values	pregprob2	yesno
label values	pregprob3	yesno
label values	pregprob4	yesno
label values	pregprob5	yesno
label values	pregprob6	yesno
label values	pregprob7	yesno
label values	pregprob8	yesno
label values	pregprob9	yesno
label values	pregprob10	yesno
label values	pregprob11	yesno
label values	pregprob12	yesno
label values	pregprob13	yesno
label values	pregprob_oth	yesno
label values	pregtreat	yesno
label values	delplace	birthplace
label values	outcome	outcome
label values	early	birthtime
label values	reason1	reason
label values	reason2	reason
label values	laborpain	labor
label values	delprob1	yesno
label values	delprob2	yesno
label values	delprob3	yesno
label values	delprob4	yesno
label values	delprob5	yesno
label values	delprob6	yesno
label values	delprob7	yesno
label values	delprob_oth	yesno
label values	referral	yesno
label values	refwhere	treat
label values	babypart	babypart
label values	cesarean	yesno
label values	cs_why	operation
label values	augment	yesno
label values	assist	babypull
label values	painmed	yesno
label values	episio	yesno
label values	push	yesno
label values	injmed	yesno
label values	tabmed	yesno
label values	ivmed	yesno
label values	cord	yesno
label values	massage	yesno
label values	turned	yesno
label values	mistreat1	pmistreat
label values	mistreat2	vmistreat
label values	satisf	satisfy
label values	pay1	yesno
label values	pay2	yesno
label values	pay3	yesno
label values	pay4	yesno
label values	pay5	yesno
label values	pay6	yesno
label values	pnc	yesno
label values	pncplace	birthcheck
label values	pnc2	yesno
label values	vitamin	yesno
label values	postpart1	yesno
label values	postpart2	yesno
label values	postpart3	yesno
label values	postpart4	yesno
label values	postpart5	yesno
label values	postpart6	yesno
label values	postpart7	yesno
label values	postpart_oth	yesno
label values	posttreat	yesno
label values	night	yesno
label values	card	yesno
label values	cardrec1	yesno
label values	cardrec2	yesno
label values	cardrec3	yesno
label values	alive	yesno
label values	sex	sex
label values	size	babysize
label values	weighed	yesno
label values	status	yesno
label values	diedage	died
label values	diarrhea	yesno
label values	diarrhea1	yesno
label values	diarrhea2	drink
label values	diarrhea3	eat
label values	diarrtreat	yesno
label values	fever	yesno
label values	fevertreat	yesno
label values	cough	yesno
label values	cough2	chestnose
label values	coughtreat	yesno
label values	diedwhen	yesno
label values	clinictreat	treatment

* Format/create variables

loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

foreach v in intmth month { 
	local a : variable label `v'
	g double _`v'=monthly(`v',"MY")
	format _`v' %tm
	label var _`v' "`a'"
	order _`v', after(`v')
	drop `v' 
	ren _`v' `v'
}

* Binary variables 

#delimit;
local var 
wanted
anc
anccare1
anccare2
anccare3
anccare4
anccare5
anccare6
anccare7
anccare8
anccare9
anccare10
tetanus
iron
malaria
pregprob1
pregprob2
pregprob3
pregprob4
pregprob5
pregprob6
pregprob7
pregprob8
pregprob9
pregprob10
pregprob11
pregprob12
pregprob13
pregprob_oth
pregtreat
delprob1
delprob2
delprob3
delprob4
delprob5
delprob6
delprob7
delprob_oth
referral
cesarean
augment
painmed
episio
push
injmed
tabmed
ivmed
cord
massage
turned
pay1
pay2
pay3
pay4
pay5
pay6
pnc
pnc2
vitamin
postpart1
postpart2
postpart3
postpart4
postpart5
postpart6
postpart7
postpart_oth
posttreat
night
card
cardrec1
cardrec2
cardrec3
alive
weighed
status
diarrhea
diarrhea1
diarrtreat
treators
treatsalt
treatother
fever
fevertreat
cough
cough1
coughtreat
vacrecord
bcg
opv
hep
followup
dead
consent
carddoc1
carddoc2
diedwhen
;
#delimit cr

foreach l of local var  {
	replace `l'=0 if `l'==2
	label values `l' yesno
}

* ANC provider

loc serv anc
loc servprov `serv'prov
foreach i of numlist 1/8 {
	g `servprov'`i'=regexm(`servprov',"`i'") if `serv'<.
	label values `servprov'`i' yesno
}
foreach string in NURSE {
	replace `servprov'3=1 if `servprov'_oth=="`string'" 
	replace `servprov'8=0 if `servprov'_oth=="`string'"  
}
foreach string in CHEW {
	replace `servprov'5=1 if `servprov'_oth=="`string'" 
	replace `servprov'8=0 if `servprov'_oth=="`string'"  
}

order `servprov'?, after(`servprov')
replace `servprov'=""

label var `servprov'1 "Saw doctor"
label var `servprov'2 "Saw nurse or midwife"
label var `servprov'3 "Saw auxiliary midwife"
label var `servprov'4 "Saw community health officer"
label var `servprov'5 "Saw community health worker"
label var `servprov'6 "Saw TBA"
label var `servprov'7 "Saw village health worker"
label var `servprov'8 "Saw other person"

* ANC place of service 
foreach v of varlist ancplace {
	split `v', destring generate(x)
	foreach i of numlist 1/13 {
		g `v'`i'=0 if consent==1
		label values `v'`i' yesno
			foreach x of varlist x? {
				replace `v'`i'=1 if `x'==`i'
			}
	}
	order `v'? `v'??, after(`v')
	replace `v'=""
	drop x?
	
	foreach string in "GOVT HOSPITAL" {
		replace `v'4=1 if `v'_oth=="`string'" 
		replace `v'13=0 if `v'_oth=="`string'"  
	}
	foreach string in "OTHER PHC" {
		replace `v'6=1 if `v'_oth=="`string'" 
		replace `v'13=0 if `v'_oth=="`string'"  
	}
	foreach string in "HEALTH POST" {
		replace `v'7=1 if `v'_oth=="`string'" 
		replace `v'13=0 if `v'_oth=="`string'"  
	}
	label var `v'1 "At home"
	label var `v'2 "Other home"
	label var `v'3 "Teaching hospital"
	label var `v'4 "Government hospital"
	label var `v'5 "Health center"
	label var `v'6 "Other health center"
	label var `v'7 "Health post/dispensary"
	label var `v'8 "Other government facility"
	label var `v'9 "Private hospital/clinic"
	label var `v'10 "Maternity home"
	label var `v'11 "Other private sector"
	label var `v'12 "Church/spiritual house"
	label var `v'13 "Other location"
}
	
* Delivery attendant

loc serv del
loc servprov `serv'prov
foreach i of numlist 1/9 {
	g `servprov'`i'=regexm(`servprov',"`i'") if consent==1
	label values `servprov'`i' yesno
}
foreach string in NURSE MIDWIFE {
	replace `servprov'2=1 if regexm(`servprov'_oth, "`string'")
	replace `servprov'9=0 if regexm(`servprov'_oth, "`string'")
}
foreach string in CHEW {
	replace `servprov'5=1 if `servprov'_oth=="`string'" 
	replace `servprov'9=0 if `servprov'_oth=="`string'"  
}
foreach string in NEIGHBOUR MOTHER RELATIVE {
	replace `servprov'7=1 if regexm(`servprov'_oth, "`string'")
	replace `servprov'9=0 if regexm(`servprov'_oth, "`string'")
}

order `servprov'?, after(`servprov')
replace `servprov'=""

label var `servprov'1 "Doctor"
label var `servprov'2 "Nurse or midwife"
label var `servprov'3 "Auxiliary midwife"
label var `servprov'4 "Community health officer"
label var `servprov'5 "Community health worker"
label var `servprov'6 "Traditional Birth Attendant"
label var `servprov'7 "Relative"
label var `servprov'8 "No one"
label var `servprov'9 "Other person"

* Treatment location

foreach v of varlist treatwhere postwhere diarrwhere feverwhere coughwhere {
	split `v', destring generate(x)
	foreach i of numlist 1/12 {
		g `v'`i'=0 if consent==1
		label values `v'`i' yes_no
			foreach x of varlist x? {
				replace `v'`i'=1 if `x'==`i'
			}
	}
	order `v'? `v'??, after(`v')
	replace `v'=""
	drop x?
}
foreach i of numlist 1/12 {
	qui replace treatwhere`i'=. if pregtreat==.
	foreach v in post diarr fever cough {
		qui replace `v'where`i'=. if `v'treat==.
	}
}
* Labels
loc var postwhere
	label var `var'1 "Teaching hospital"
	label var `var'2 "Government hospital"
	label var `var'3 "Health center"
	label var `var'4 "Other health center"
	label var `var'5 "Health post/dispensary"
	label var `var'6 "Other government facility"
	label var `var'7 "Private hospital/clinic"
	label var `var'8 "Maternity home"
	label var `var'9 "Other private sector"
	label var `var'10 "Other location"
	drop `var'11  `var'12

foreach var of varlist treatwhere diarrwhere feverwhere coughwhere {
	label var `var'1 "Teaching hospital"
	label var `var'2 "Government hospital"
	label var `var'3 "Health center"
	label var `var'4 "Other health center"
	label var `var'5 "Health post/dispensary"
	label var `var'6 "Other government facility"
	label var `var'7 "Private hospital/clinic"
	label var `var'8 "Maternity home"
	label var `var'9 "Other private sector"
	label var `var'10 "Pharmacy/Chemist"
	label var `var'11 "Traditional Birth Attendant"
	label var `var'12 "Other location"
}

* Delivery augmentation 

	local var1 augment
	local var2 augwhat
	foreach i in 1 2 3 {
		g `var2'`i'=0 if `var1'<.
		replace `var2'`i'=1 if  regexm(`var2',"`i'")
		label values `var2'`i' yesno
	}
	order `var2'?, after(`var2')
	replace `var2'=""
	label var `var2'1 "Received injection during labour"
	label var `var2'2 "Given medication in drip (IV line)"
	label var `var2'3 "Other"

* PNC location

	foreach v of varlist pncplace {
		loc a : variable label `v'
		ren `v' `v'_old
		recode `v'_old (1/2=1 "Home") (3/4=2 "Govt Hospital") (5=3 "Health center") (6/8=4 "Other govt facility") (9=5 "Private hospital/clinic") (10/12=6 "Other"), generate(`v')
		order `v', after(`v'_old)
		label var `v' "`a'"
		qui tab `v', g(`v') 
		order `v'?, after(`v')
		drop `v'_old
		replace `v'=.
		label var `v'1 "At home"
		label var `v'2 "Government hospital"
		label var `v'3 "Health center"
		label var `v'4 "Other government facility"
		label var `v'5 "Private hospital/clinic"		
		label var `v'6 "Other location"
	}
	foreach v of varlist pncplace? {
			label values `v' yesno
	}
	
* Code PNC provider

	foreach v of varlist pncprov {
		foreach i of numlist 1/9 {
			g `v'`i'=0 if consent==1
			replace `v'`i'=regexm(`v',"`i'")
			label values `v'`i' yesno
		}
		order `v'?, after(`v')
		label var `v'1 "Doctor"
		label var `v'2 "Nurse/midwife"
		label var `v'3 "Auxiliary midwife"
		label var `v'4 "Community health officer"
		label var `v'5 "Health extension worker"		
		label var `v'6 "Traditional birth attendant"
		label var `v'7 "Relative/friend"
		label var `v'8 "No one"
		label var `v'9 "Other person"
		
		foreach string in DOCTOR {
			replace `v'1=1 if regexm(`v'_oth,"`string'")==1 
			replace `v'9=0 if regexm(`v'_oth,"`string'")==1 
		}
		foreach string in CHEW {
			replace `v'5=1 if regexm(`v'_oth,"`string'")==1 
			replace `v'9=0 if regexm(`v'_oth,"`string'")==1 
		}
		replace `v'=""
	}

* What was done by the PNC provider
		
	foreach v of varlist pncwhat {
		split `v', destring generate(x)
		foreach i of numlist 1/10 {
			g `v'`i'=0 if pnc==1
			label values `v'`i' yesno
				foreach x of varlist x? {
					replace `v'`i'=1 if `x'==`i'
				}
		}
		order `v'? `v'??, after(`v')
		replace `v'=""
		drop x?
		label var `v'1 "Examined abdomen"
		label var `v'2 "Checked breasts"
		label var `v'3 "Checked for bleeding"
		label var `v'4 "Examined the infant"
		label var `v'5 "Counseled on danger signs"		
		label var `v'6 "Counseled on breastfeeding"
		label var `v'7 "Counseled on family planning"
		label var `v'8 "Counseled on nutrition"
		label var `v'9 "Counseled on baby care"
		label var `v'10 "Other action"
	}

* Code diarrhea treatment

	foreach v of varlist treatelse {
		split `v', destring generate(x)
		foreach i of numlist 1/10 {
			g `v'`i'=0 if treatother==1
			label values `v'`i' yesno
				foreach x of varlist x? {
					replace `v'`i'=1 if `x'==`i'
				}
		}
		order `v'? `v'??, after(`v')
		replace `v'=""
		drop x?
		label var `v'1 "Antibiotic tablet, capsule or syrup"
		label var `v'2 "Antimotility tablet, capsule or syrup"
		label var `v'3 "Zinc"
		label var `v'4 "Other tablet, capsule or syrup"
		label var `v'5 "Antibiotic injection"	
		label var `v'6 "Other injection (not antibiotic)"
		label var `v'7 "Intravenous fluid"
		label var `v'8 "Intravenous drug"
		label var `v'9 "Home remedy/herbal medicine"
		label var `v'10 "Other treatment"
	}
	
* Save
save "$proc/woman_el", replace


/*=============================================================================
		Clinic Baseline data
=============================================================================*/

use "$raw/facility_bl", clear

* Label variables

label var	state	"	State	"
label var	sid	"	State ID	"
label var	strata	"	Strata ID	"
label var	fid	"	 Clinic ID	"
label var	electric	"	Electricity source	"
label var	water	"	Does facility have running water	"
label var	beds	"	Number of beds	"
label var	travel_time	"	Estimated travel time to referral hospital (minutes)	"
label var	open24hrs	"	Is this facility open 24 hours a day/7 days a week	"
label var	lab	"	Does this facility have a laboratory	"
label var	test_malaria	"	Does the lab offer testing for Malaria 	"
label var	test_pcv	"	Does the lab offer Hemoglobin Test (Hb or PCV)	"
label var	test_urine	"	Does the lab offer Urine Test (protein, sugar)	"
label var	pmtct	"	Are PMTCT services provided in this facility	"
label var	inpatient	"	Does this facility provide inpatient admissions	"
label var	drugs	"	Does this facility have a pharmacy 	"
label var	cesarean	"	Does this facility do caesarean sections	"
label var	transfusion	"	Does this facility do blood transfusions	"
label var	workers	"	Number of health care providers	"
label var	equip	"	Do you have ____ available	"
label var	equip_bp	"	BP cuff	"
label var	equip_steth_ad	"	Adult stethoscope	"
label var	equip_steth_ch	"	Fetal stethoscope	"
label var	equip_thermo	"	Rectal thermometer for newborn	"
label var	equip_examcouch	"	Examination couch	"
label var	equip_del	"	Labor/delivery table	"
label var	equip_newb	"	Newborn resuscitation table	"
label var	equip_oxygen	"	 Oxygen/resuscitation set	"
label var	equip_incub	"	Incubator	"
label var	equip_dpack	"	Delivery Set/Pack	"
label var	equip_ambubag	"	 Ambu (ventilator) bag	"
label var	equip_clave	"	Autoclave/Sterilizer	"
label var	equip_shock	"	 Anti-shock garments	"
label var	births_m1	"	Number of deliveries in health facility-Month 1	"
label var	births_m2	"	Number of deliveries in health facility-Month 2	"
label var	births_m3	"	Number of deliveries in health facility-Month 3	"
label var	births_m4	"	Number of deliveries in health facility-Month 4	"
label var	births_m5	"	Number of deliveries in health facility-Month 5	"
label var	births_m6	"	Number of deliveries in health facility-Month 6	"
label var	cond	"	What is the general condition of the clinic building	"
label var	clean	"	How clean is the inside of the clinic	"
label var	vent	"	Is there a functional fan/air conditioning in delivery room	"
label var	clinictreat	"	Clinic treatment	"

* Remove leading blanks in labels

foreach v of varlist _all {
	local a : variable label `v'
	label var `v' "`a'"
	label var `v' "`=strltrim("`: var lab `v''")'" 	
}

* Define value labels

#delimit;
label define cond
	1	"Poor (requires major rehabilitation)"
	2	"Fair (requires some rehabilitation)"
	3	"Good (requires no rehabilitation)"
	4	"Excellent (like new or almost new)"
	;
label define clean
	1	"Very dirty"
	2	"Somewhat dirty"
	3	Clean
	4	"Very clean"
	;
label define electric 
	1 Grid 
	2 Solar 
	3 None 
	4 Other
	;
label define treatment 
	0 Control 
	1 MLP 
	2 Doctor
	;
label define yesno 
	0 No 
	1 Yes
	;
#delimit  cr


* Apply value labels

label values electric electric
label values cond cond
label values clean clean
label values clinictreat treatment
	
foreach v of varlist test_* {
	replace `v'=0 if `v'==.
	label values `v' yesno
}
foreach v of varlist open24hrs lab pmtct inpatient drugs cesarean transfusion equip_* vent {
	replace `v'=0 if `v'==2
	label values `v' yesno
}

* Format/create variables

loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

* Save
save "$proc/facility_bl", replace


/*=============================================================================
		Clinic Endline data
=============================================================================*/

use "$raw/facility_el", clear

* Label variables

label var	date	"	Interview Date	"
label var	state	"	State	"
label var	sid	"	State ID	"
label var	strata	"	Strata ID	"
label var	fid	"	Clinic ID	"
label var	open24hrs	"	Is PHC open with someone physically present 24 hours a day	"
label var	saturday	"	Is PHC open with someone physically present on Saturday	"
label var	sunday	"	Is PHC open with someone physically present on Sunday	"
label var	callduty	"	Is there a health provider on call after closing hours	"
label var	callroom	"	Is the provider on call usually physically present in the PHC	"
label var	emergserv	"	How often does the PHC provide services to patients after closing hours	"
label var	inpatient	"	Does this facility provide inpatient admissions	"
label var	new	"	Any new health workers on staff roster that started after the intervention	"
label var	newstaff	"	Number of new health workers	"
label var	liveclinic	"	Does new provider lives on the premises	"
label var	livewhere	"	Where do they live	"
label var	livewhere_oth	"	Other (Specify)	"
label var	distance	"	How far away do they live from the PHC in kilometers	"
label var	drivetime	"	How long does it take by car to get to the PHC	"
label var	drive_mins	"	Minutes	"
label var	drive_hrs	"	Hours	"
label var	worksat	"	Does new provider usually work on Saturday	"
label var	worksun	"	Does new provider usually work on Sunday	"
label var	emerg_call	"	How often are they called for patient emergencies outside normal working hours	"
label var	birth_call	"	How often are they called for deliveries outside normal working hours	"
label var	rate_know	"	Rate their clinical knowledge (0-10)	"
label var	rate_do	"	Rate their clinical skill (0-10)	"
label var	rate_manner	"	Rate their rapport with patients (0-10)	"
label var	rate_work	"	Rate their rapport with colleagues (0-10)	"
label var	consult	"	Likelihood that a provider would seek advice/help from the new provider	"
label var	rate_overall	"	Overall rating (0-10)	"
label var	impact	"	What was their impact on clinic operations	"
label var	impacthow	"	In what way did they impact operations	"
label var	impacthow_oth	"	Other (Specify)	"
label var	ideas	"	You say he/she brought new ideas: Can you give me an example	"
label var	assess1	"	What is the general condition of the clinic building	"
label var	assess2	"	What is the general condition of clinic infrastructure	"
label var	assess3	"	How clean is the inside of the clinic	"
label var	clinictreat	"	Clinic treatment	"

* Remove leading blanks in labels

foreach v of varlist _all {
	local a : variable label `v'
	label var `v' "`a'"
	label var `v' "`=strltrim("`: var lab `v''")'" 	
}

* Define value labels

#delimit;
label define condition
	1	"Poor (requires major rehabilitation)"
	2	"Fair (requires some rehabilitation)"
	3	"Good (requires no rehabilitation)"
	4	"Excellent (like new or almost new)"
	;
label define clean
	1	"Very dirty"
	2	"Somewhat dirty"
	3	Clean
	4	"Very clean"
	;
label define likely
	1	"Very likely"
	2	"Somewhat likely"
	3	"Neither likely nor unlikely"
	4	"Somewhat unlikely"
	5	"Very unlikely"
	;
label define impact
	1	"Strongly positive"
	2	"Fairly positive"
	3	"Neither positive nor negative"
	4	"Fairly negative"
	5	"Strongly negative"
	;
label define afterhours
	1	"All the time"
	2	Frequently
	3	Sometimes
	4	Seldom
	5	Never
	;
label define frequent
	1	"All the time"
	2	"Most of the time"
	3	Sometimes
	4	Seldom
	5	Never
	;
label define reside
	1	"PHC community"
	2	"Nearby community"
	3	"Town"
	4	Other
	;
label define yesno 
	0 No 
	1 Yes
	;
label define treatment 
	0 Control 
	1 MLP 
	2 Doctor;
#delimit cr

* Apply value labels

label values emergserv afterhours
label values emerg_call frequent
label values birth_call frequent
label values livewhere reside
label values impact impact
label values consult likely
label values assess1 condition
label values assess2 condition
label values assess3 clean
label values clinictreat treatment

foreach v of varlist open24 sat sund call* new {
	label values `v' yesno
}
foreach v of varlist inpatient liveclinic worksat worksun {
	replace `v'=0 if `v'==2
	label values `v' yesno
}

* Format/create variables

loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

foreach v in date { 
	local a : variable label `v'
	g double _`v'=monthly(`v',"MY")
	format _`v' %tm
	label var _`v' "`a'"
	order _`v', after(`v')
	drop `v' 
	ren _`v' `v'
}

replace drivetime=(drive_hrs*60)+ drive_min
drop drive_*

* Recode so that bigger is better

ren impact impact_old
#delimit;
	recode impact_old
	(1=5	"Strongly positive")
	(2=4	"Fairly positive")
	(3=3	"Neither positive nor negative")
	(4=2	"Fairly negative")
	(5=1	"Strongly negative"),
	g (impact);
	
	recode consult
	(1=5	"Very likely")
	(2=4	"Somewhat likely")
	(3=3	"Neither likely nor unlikely")
	(4=2	"Somewhat unlikely")
	(5=1	"Very unlikely"),
	g (likely);
#delimit cr

order likely, after(consult)
drop impact_old consult
label var likely "Likelihood that a provider would seek advice/help from new provider"
label var impact "What was their impact on clinic operations"

* Code provider impact
loc var impacthow
split `var', gen(impact)
foreach i of numlist 1/8 {
	destring impact`i', replace
}
foreach i of numlist 1/8 {
	egen `var'`i'=anymatch(impact?), v(`i')
	label values `var'`i' yesno
}
foreach i of numlist 1/8 {
	replace  `var'`i'=. if clinict==0
}
drop impact? `var'_oth
order impact `var' `var'?, after(rate_overall)
replace `var'=""
label var `var'1 "Providers were over-worked helped to reduce workload"
label var `var'2 "Allowed the PHC to extend hours of service"
label var `var'3 "Allowed the PHC to provide services not previously offered"
label var `var'4 "Helped other providers to improve clinical knowledge and skills"
label var `var'5 "Brought in new ideas/new ways of doing things"
label var `var'6 "Challenged other providers to be more hardworking"
label var `var'7 "Positive attitude made work environment more pleasant"
label var `var'8 "Other impact"

* Save
save "$proc/facility_el", replace


/*=============================================================================
		Provider data
=============================================================================*/

use "$raw/provider", clear

* Label variables

label var	date	"	Date of interview	"
label var	state	"	State	"
label var	sid	"	State ID	"
label var	strata	"	Strata ID	"
label var	fid	"	Clinic ID	"
label var	sex	"	Sex	"
label var	age	"	Age	"
label var	reside	"	State of usual residence	"
label var	experience	"	Years of experience	"
label var	d1	"	MCQ: Malaria is classified as severe when this is present	"
label var	d2	"	MCQ: Under-5 child with fever vomiting and severe dehydration	"
label var	d3	"	MCQ: Child with fever and diarrhea and mild dehydration	"
label var	d4	"	MCQ: Actions to decrease the risk of infection during childbirth	"
label var	d5	"	MCQ: The most effective way to immediately control eclamptic convulsions	"
label var	d6	"	MCQ: You can perform a vacuum extraction in the case of	"
label var	d7	"	MCQ: Signs and symptoms of ruptured uterus	"
label var	d8	"	MCQ: Signs and symptoms of acute severe asthma	"
label var	d9	"	MCQ: Management of severe asthmatic attack	"
label var	d10	"	MCQ: Sign of life-threatening asthmatic attack	"
label var	d11a	"	Case 1: Excessive vaginal bleeding: What will you do	"
label var	d11b	"	What are the signs and symptoms of shock	"
label var	d11c	"	Is patient in shock	"
label var	d11d	"	What are the possible causes of her bleeding	"
label var	d11e	"	Soft atonic uterus: what will you do	"
label var	d11f	"	Uterus still not firm: next steps	"
label var	d11g	"	Incomplete placenta: what will you do	"
label var	d11h	"	Uterus firm but bleeding continues: next steps	"
label var	d11i	"	Uterus firm, bleeding stopped, vital signs stable: next steps	"
label var	d12a	"	Case 2: non-breathing newborn: what will you do	"
label var	vignette1_a	"	Vignette 1: History	"
label var	vignette1_b1	"	Vignette 1: Any examination	"
label var	vignette1_b2	"	Vignette 1: What examination	"
label var	vignette1_c1	"	Vignette 1: Any test	"
label var	vignette1_c2	"	Vignette 1: What test	"
label var	vignette1_c2j_1	"	Vignette 1: Other lab test	"
label var	vignette1_c2j_2	"	Vignette 1: Other lab test	"
label var	vignette1_c2j_3	"	Vignette 1: Other lab test	"
label var	vignette1_d	"	Vignette 1: Preliminary diagnosis	"
label var	vignette1_e	"	Vignette 1: Final  diagnosis	"
label var	vignette1_f1	"	Vignette 1: Treatment	"
label var	vignette1_f2b	"	Vignette 1: TB drug  dose is correct	"
label var	vignette1_f2c	"	Vignette 1: Penicillin dose is correct	"
label var	vignette1_f2d	"	Vignette 1: Amoxicillin dose is correct	"
label var	vignette1_f1f_1	"	Vignette 1: Other drug	"
label var	vignette1_f2f_1	"	Vignette 1: Other drug dose is correct	"
label var	vignette1_f1f_2	"	Vignette 1: Other drug	"
label var	vignette1_f2f_2	"	Vignette 1: Other drug dose is correct	"
label var	vignette1_f1f_3	"	Vignette 1: Other drug	"
label var	vignette1_f2f_3	"	Vignette 1: Other drug dose is correct	"
label var	vignette1_g	"	Vignette 1: Health education	"
label var	vignette2_a	"	Vignette 2: History	"
label var	vignette2_a20_1	"	Vignette 2: Other question	"
label var	vignette2_a20_2	"	Vignette 2: Other question	"
label var	vignette2_a20_3	"	Vignette 2: Other question	"
label var	vignette2_b1	"	Vignette 2: Any examination	"
label var	vignette2_b2	"	Vignette 2: What examination	"
label var	vignette2_c1	"	Vignette 2: Any test	"
label var	vignette2_c2	"	Vignette 2: What test	"
label var	vignette2_d	"	Vignette 2: Preliminary diagnosis	"
label var	vignette2_e1	"	Vignette 2: Treatment	"
label var	vignette2_e2b	"	Vignette 2: Sulphadoxine-pyrimethamine dose is correct	"
label var	vignette2_e2c	"	Vignette 2: Artemisinin-combination therapies (ACT) dose is correct	"
label var	vignette2_e2d	"	Vignette 2: Quinine dose is correct	"
label var	vignette2_e2e	"	Vignette 2: Folic acid/Iron dose is correct	"
label var	vignette2_e2f	"	Vignette 2: Anticonvulsant dose is correct	"
label var	vignette2_f	"	Vignette 2: Health education	"
label var	cadre	"	Cadre	"
label var	cadre_other	"	Other cadre	"
label var	studyprov	"	Intervention provider	"
label var	clinictreat	"	Clinic treatment	"
label var	provtype	"	Provider type	"

* Remove leading blanks in labels

foreach v of varlist _all {
	local a : variable label `v'
	label var `v' "`a'"
	label var `v' "`=strltrim("`: var lab `v''")'" 	
}

* Define value labels

#delimit;
label define sex 
	1 Male 
	2 Female
	;
label define reside 
	1	Abia
	2	Adamawa
	3	Anambra
	4	"Akwa Ibom"
	5	Bauchi
	6	Bayelsa
	7	Benue
	8	Borno
	9	"Cross River"
	10	Delta
	11	Ebonyi
	12	Enugu
	13	Edo
	14	Ekiti
	15	Gombe
	16	Imo
	17	Jigawa
	18	Kaduna
	19	Kano
	20	Katsina
	21	Kebbi
	22	Kogi
	23	Kwara
	24	Lagos
	25	Nasarawa
	26	 Niger
	27	Ogun
	28	Ondo
	29	Osun
	30	Oyo
	31	Plateau
	32	Rivers
	33	Sokoto
	34	Taraba
	35	Yobe
	36	Zamfara
	37	"Federal Capital Territory (FCT)"
	;
label define d1
	0	"Dont know"
	1	Convulsions
	2	"Decreased consciousness"
	3	"Kidney failure"
	4	"Pulmonary edema"
	5	"All of the above"
	;
label define d2
	0	"Dont know"
	1	"Order a blood test for malaria"
	2	"Set up IV line for fluids"
	3	"Give Artemether/Lumefantrine tablets"
	4	"Check body temperature with thermometer"
	;
label define d3
	0	"Dont know"
	1	"Order a blood test for malaria"
	2	"Set up IV line for fluids"
	3	"Give Artemether/Lumefantrine tablets"
	4	"Check body temperature with thermometer"
	;
label define d4
	0	"Dont know"
	1	"Performing frequent vaginal examinations"
	2	"Rupturing membranes as soon as possible in the first stage of labor"
	3	"Routine catheterization of the bladder before childbirth"
	4	"Reducing prolonged labor"
	;
label define d5
	0	"Dont know"
	1	"Give diazepam"
	2	"Give magnesium sulfate"
	3	"Deliver the baby as soon as possible"
	4	"Give nifedipine"
	;
label define d6
	0	"Dont know"
	1	"A cephalic presentation"
	2	"A face presentation"
	3	"Cervical dilation of 7cm"
	4	"Fetal head not engaged"
	;
label define d7
	0	"Dont know"
	1	"Rapid maternal pulse"
	2	"Persistent abdominal pain and suprapubic tenderness"
	3	"Fetal distress"
	4	"All of the above"
	;
label define d8
	0	"Dont know"
	1	"Inability to complete a sentence in one breath"
	2	"Respiratory rate less than 20/min"
	3	"Bradycardia"
	4	"All of the above"
	;
label define d9
	0	"Dont know"
	1	"Given oxygen 40-60%"
	2	"Given nebulized salbutamol 5mg or terbutaline 10 mg repeated and administered 12hrly"
	3	"Asked to go buy a salbutamol inhaler"
	4	"None of the above"
	;
label define d10
	1	"A silent chest"
	2	Cyanosis
	3	Bradycardia
	4	Confusion
	5	"All of the above"
	6	"Dont know"
	;
label define diagnosis1
	1	"Pulmonary TB"
	2	Pneumonia
	3	"Chronic Bronchitis"
	4	"Diabetes mellitus"
	5	AIDS
	6	"Dont know"
	7	Other 
	;
label define treatment1
	1	"No treatment"
	2	"TB regimen"
	3	Penicillin 
	4	Amoxicillin
	5	Referral
	6	Other
	;
label define diagnosis2
	1	"Severe malaria"
	2	Malaria
	3	Anemia
	4	Meningitis
	5	"Dont know"
	6	Other 
	;
label define treatment2
	1	"No treatment"
	2	"Sulphadoxine-pyrimethamine"
	3	"Artemisinin-combination therapies"
	4	Quinine
	5	"Folic acid/Iron"
	6	Anticonvulsant
	7	Referral
	8	"Dont know"
	9	Other 
	;
label define cadre
	1	Doctor
	2	Nurse
	3 	Midwife
	4	"Nurse/midwife"
	5	CHO
	6	CHEW
	7	"J-CHEW"
	8	Other
	;
label define type 
	0 "Existing MLP" 
	1 "New MLP" 
	2 "Doctor"
	;
label define treatment 
	0 Control 
	1 MLP 
	2 Doctor
	;
label define yesno 
	0 No 
	1 Yes
	;
#delimit cr

* Apply value labels

label values sex sex
label values reside reside
foreach i of numlist 1/10 {
	label values d`i' d`i'
}
label values vignette1_e diagnosis1
foreach v of varlist d11c vignette?_b1 vignette?_c1 vignette1_f2b vignette1_f2c vignette1_f2d vignette2_e2b vignette2_e2c vignette2_e2d vignette2_e2e vignette2_e2f studyprov {
	label values `v' yesno
	}
label values clinictreat treatment
label values provtype type
	
* Format/create variables
	
loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

foreach v in date { 
	local a : variable label `v'
	g double _`v'=monthly(`v',"MY")
	format _`v' %tm
	label var _`v' "`a'"
	order _`v', after(`v')
	drop `v' 
	ren _`v' `v'
}

* Years of experience
loc v experience
replace `v'=2017-`v' if `v'>2000 & `v'<=2017


/*-------------------------------------------------
	Performance on clinical modules
--------------------------------------------------*/

* MCQ: Basic Clinical Knowledge

ge mcq1=d1==5 
ge mcq2=d2==3 
ge mcq3=d3==4 
ge mcq4=d4==4
ge mcq5=d5==2 
ge mcq6=d6==1 
ge mcq7=d7==4 
ge mcq8=d8==1 
ge mcq9=d9==2 
ge mcq10=d10==5

label define mcq 0 "Incorrect" 1 "Correct"
foreach i of numlist 1/10 {
	label values mcq`i' mcq
}
order mcq?, after(d10)

foreach i of numlist 1/10 {
	loc a : variable label d`i'
	label var mcq`i' "`a'"
	drop d`i'
	
}
 
* Case Scenarios

renvars d11a-vignette2_f, prefix(p_)
renvars p_d11a-p_d11i, presub(p_d11 cs_)
ren p_d12a cs_j

	foreach v of varlist cs_a cs_g cs_h  {
		forvalues i=1/4 {
			ge `v'_`i'=regexm(`v',"`i'")
			replace `v'_`i'=. if `v'==""
		}
	}
	foreach v of varlist cs_e cs_f cs_i  {
		forvalues i=1/3 {
			ge `v'_`i'=regexm(`v',"`i'")
			replace `v'_`i'=. if `v'==""
		}
	}
	foreach v of varlist cs_b  {
		forvalues i=1/6 {
			ge `v'_`i'=regexm(`v',"`i'")
			replace `v'_`i'=. if `v'==""
		}
	}
	foreach v of varlist cs_d  {
		forvalues i=1/5 {
			ge `v'_`i'=regexm(`v',"`i'")
			replace `v'_`i'=. if `v'==""
		}
	}
	foreach v of varlist cs_j  {
		replace `v'=" "+`v'+" " if `v'!=""
		forvalues i=1/12 {
			ge `v'_`i'=regexm(`v'," `i' ")
			replace `v'_`i'=. if `v'==""
		}
	}
	g cs_c_1=cs_c==0 if cs_c!=.

* Vignette 1

foreach x of varlist p_vignette?_a p_vignette?_b2 p_vignette?_c2 p_vignette?_d p_vignette2_e1 p_vignette1_f1 p_vignette1_g p_vignette2_f {
	replace `x'=" "+`x'+" " if `x'!=""
}

foreach x of numlist 1 {

** History taking
	forvalues i=1/12 {
		ge v`x'hx_`i'=regexm(p_vignette`x'_a," `i' ")
		replace v`x'hx_`i'=. if p_vignette`x'_a==""
	}

** Physical examination
	forvalues i=1/9 {
		ge v`x'pe_`i'=regexm(p_vignette`x'_b2," `i' ")
		replace v`x'pe_`i'=. if p_vignette`x'_a==""
	}

** Lab investigations
	forvalues i=2/9 {
		ge v`x'lab_`i'=regexm(p_vignette`x'_c2," `i' ")
		replace v`x'lab_`i'=. if p_vignette`x'_a==""
	}
	
** Include tests improperly listed under "Other"
	forvalues i=1/3 {
		replace v`x'lab_8=regexm(p_vignette1_c2j_`i',"alaria") if v`x'lab_8==0
		replace v`x'lab_9=regexm(p_vignette1_c2j_`i',"RVS") if v`x'lab_9==0
		replace v`x'lab_7=regexm(p_vignette1_c2j_`i',"Pcv") if v`x'lab_7==0
	}

** Mentioned TB among preliminary diagnoses
	ge v`x'diag1=regexm(p_vignette`x'_d," 1 ") if p_vignette`x'_a!=""
	label var v`x'diag1 "TB among preliminary diagnoses"
	
** Treated correctly
	ge v`x'treat_tb=regexm(p_vignette`x'_f1," 2 ") if p_vignette`x'_a!=""
	label var v`x'treat_tb "Prescribed TB medication"
	
	ge v`x'treat_refer=regexm(p_vignette`x'_f1," 5 ") if p_vignette`x'_a!=""
	label var v`x'treat_refer "Referred patient"

** Check if medication mentioned under "Other"
	forvalues i=1/3 {
		replace v`x'treat_tb=regexm(p_vignette`x'_f1f_`i',"soniaz") if v`x'treat_tb==0
	}

** Prescribed correct dose of medication
	ge v`x'treat_dose=p_vignette`x'_f2b==1 if p_vignette`x'_a!=""
	replace v`x'treat_dose=regexm(p_vignette`x'_f1f_1,"soniaz") if v`x'treat_dose==0 & p_vignette`x'_f2f_1==1
	replace v`x'treat_dose=. if v`x'treat_tb!=1
	label var v`x'treat_dose "Correct dose of TB medication"

** Patient counseling
	forvalues i=2/10 {
		ge v`x'educ_`i'=regexm(p_vignette`x'_g," `i' ")
		replace v`x'educ_`i'=. if p_vignette`x'_a==""
	}
}

* Vignette 2

foreach x of numlist 2 {

** History taking
	forvalues i=1/19 {
		ge v`x'hx_`i'=regexm(p_vignette`x'_a," `i' ")
		replace v`x'hx_`i'=. if p_vignette`x'_a==""
	}
	
**  Include questions improperly listed under "Other"
	foreach v of varlist p_vignette2_a20_? {
		replace v`x'hx_16=regexm(`v',"stool") if v`x'hx_16==0
		replace v`x'hx_8=regexm(`v',"omiting") if v`x'hx_8==0
	}

** Physical examination
	forvalues i=1/13 {
		ge v`x'pe_`i'=regexm(p_vignette`x'_b2," `i' ")
		replace v`x'pe_`i'=. if p_vignette`x'_a==""
	}

** Lab investigations
	forvalues i=2/5 {
		ge v`x'lab_`i'=regexm(p_vignette`x'_c2," `i' ")
		replace v`x'lab_`i'=. if p_vignette`x'_a==""
	}

** Diagnosed malaria
	ge v`x'diag1=regexm(p_vignette`x'_d," 1 ") if p_vignette`x'_a!=""
	replace v`x'diag1=regexm(p_vignette`x'_d," 2 ") if v`x'diag1==0
	label var v`x'diag1 "Malaria diagnosis"

** Treated correctly
	ge v`x'treat_malaria=regexm(p_vignette`x'_e1," 3 ") if p_vignette`x'_a!=""
	replace v`x'treat_malaria=regexm(p_vignette`x'_e1," 4 ") if v`x'treat_malaria==0
	label var v`x'treat_malaria "Prescribed ACT or Quinine"
	
	ge v`x'treat_folate=regexm(p_vignette`x'_e1," 5 ") if p_vignette`x'_a!=""
	label var v`x'treat_folate "Prescribed folate"
	
** Patient counseling
	forvalues i=2/6 {
		ge v`x'educ_`i'=regexm(p_vignette`x'_f," `i' ")
		replace v`x'educ_`i'=. if p_vignette`x'_a==""
	}
}  

* Labels

order mcq10 cs_a* cs_b* cs_c* cs_d* cs_e* cs_f* cs_g* cs_h* cs_i* cs_j*, after (mcq9)

label var cs_a_1 "Calls for help"
label var cs_a_2 "Explains and reassures the woman"
label var cs_a_3 "Checks for signs of shock"
label var cs_a_4 "Palpates the uterus to assess tone"
label var cs_b_1 "Pulse >110"
label var cs_b_2 "Systolic BP <90mm Hg"
label var cs_b_3 "Cold clammy skin"
label var cs_b_4 "Pallor"
label var cs_b_5 "Respiration > 30 / min"
label var cs_b_6 "Anxious and confused or unconscious"
label var cs_c_1 "Correctly states patient not in shock"
label var cs_d_1 "Atonic uterus"
label var cs_d_2 "Cervical and perineal tears"
label var cs_d_3 "Retained placenta"
label var cs_d_4 "Ruptured uterus"
label var cs_d_5 "Clotting disorder"
label var cs_e_1 "Massage the uterus"
label var cs_e_2 "Gives oxytocin or ergometrine or misoprostol"
label var cs_e_3 "Monitor vitals and blood loss and massage the uterus"
label var cs_f_1 "Explains what is to be done and what to expect"	
label var cs_f_2 "Performs internal bimanual compression of the uterus"
label var cs_f_3 "Locates placenta and examines for missing pieces"
label var cs_g_1 "Explains procedure and what to expect "
label var cs_g_2 "Gives sedative"
label var cs_g_3 "Gives prophylactic antibiotics"
label var cs_g_4 "Removes placental fragments from uterus"
label var cs_h_1 "Examines perineum, vagina and cervix for tears and repairs"
label var cs_h_2 "Considers use of bedside clotting test"
label var cs_h_3 "Encourages breastfeeding to help uterus contraction"
label var cs_h_4 "Calls for help"
label var cs_i_1 "Requests for type and cross-match for possible transfusion"
label var cs_i_2 "Makes plan for monitoring vital signs, uterine firmness and blood loss"
label var cs_i_3 "Continues with routine postpartum care"
label var cs_j_1 "Keep the baby warm"
label var cs_j_2 "Clamp and cut the cord if necessary"
label var cs_j_3 "Transfer the baby to a dry, clean and warm surface"
label var cs_j_4 "Inform mother about procedure"
label var cs_j_5 "Keep the baby wrapped and under a radiant heater if possible"
label var cs_j_6 "Open the airway"
label var cs_j_7 "Position the head so it is slightly extended"
label var cs_j_8 "Suction first the mouth and then the nose"
label var cs_j_9 "Repeat suction if necessary"	
label var cs_j_10 "Ventilate the baby"
label var cs_j_11 "Place mask to cover chin mouth and nose to form seal"	
label var cs_j_12 "Squeeze the bag 2 or 3 times and look if chest is rising"

label var v1hx_1 "History: Do you have night sweats"
label var v1hx_2 "History: Do you have any chest pain"	
label var v1hx_3 "History: Is there any blood in the sputum"	
label var v1hx_4 "History: Do you drink"
label var v1hx_5 "History: Has this happened before"
label var v1hx_6 "History: Are there others with similar cough"
label var v1hx_7 "History: What is your profession"
label var v1hx_8 "History: Any high-risk sexual behavior"
label var v1hx_9 "History: Do you feel tired"
label var v1hx_10 "History: What is your normal diet"
label var v1hx_11 "History: What is the pattern of the fever"
label var v1hx_12 "History: Smoking history"
label var v1pe_1 "Exam: measure height"
label var v1pe_2 "Exam: take weight"	
label var v1pe_3 "Exam: check pulse"
label var v1pe_4 "Exam: check respiratory rate"
label var v1pe_5 "Exam: check blood pressure"
label var v1pe_6 "Exam: check temperature"
label var v1pe_7 "Exam: check for retraction"
label var v1pe_8 "Exam: examine chest"
label var v1pe_9 "Exam: auscultate chest"
label var v1lab_2 "Lab: ESR"
label var v1lab_3 "Lab: Mantoux Test"
label var v1lab_4 "Lab: Sputum for AFB"
label var v1lab_5 "Lab: Chest X-ray"
label var v1lab_6 "Lab: WBC"
label var v1lab_7 "Lab: Hemoglobin"
label var v1lab_8 "Lab: Blood smear for malaria"
label var v1lab_9 "Lab: HIV test"
label var v1educ_2 "Educ: Emphasize the importance of taking medicine or going to referral"
label var v1educ_3 "Educ: Importance of high protein diet"
label var v1educ_4 "Educ: Importance of drug compliance"
label var v1educ_5 "Educ: Importance of boiling milk"	
label var v1educ_6 "Educ: Importance of well ventilated house"
label var v1educ_7 "Educ: Importance of rest"
label var v1educ_8 "Educ: Avoid strenuous work"
label var v1educ_9 "Educ: Adhere to return date to clinic"
label var v1educ_10 "Educ: Return if there are abnormal signs"

label var v2hx_1 "History: Duration of fever"
label var v2hx_2 "History: Pattern of fever"	
label var v2hx_3 "History: If temperature was taken"	
label var v2hx_4 "History: Presence of cough"
label var v2hx_5 "History: Productive or dry cough"
label var v2hx_6 "History: Severity of cough"
label var v2hx_7 "History: Presence of sore throat"
label var v2hx_8 "History: Presence of vomiting"
label var v2hx_9 "History: Presence of sweats and chills"
label var v2hx_10 "History: Presence of convulsions"
label var v2hx_11 "History: Presence of running nose"
label var v2hx_12 "History: Appetite"
label var v2hx_13 "History: Ability to drink"
label var v2hx_14 "History: Difficulty in breathing"
label var v2hx_15 "History: Presence of ear problems"
label var v2hx_16 "History: Presence of diarrhea"
label var v2hx_17 "History: Any medication given"
label var v2hx_18 "History: Amount of medication given"
label var v2hx_19 "History: Vaccination history"
label var v2pe_1 "Exam: Assess general health condition"
label var v2pe_2 "Exam: Take temperature"
label var v2pe_3 "Exam: Take pulse"
label var v2pe_4 "Exam: Check signs of dehydration"
label var v2pe_5 "Exam: Look for signs of anemia"
label var v2pe_6 "Exam: Assess neck stiffness"
label var v2pe_7 "Exam: Check ear/throat"
label var v2pe_8 "Exam: Check respiratory rate"
label var v2pe_9 "Exam: Palpate the spleen"
label var v2pe_10 "Exam: Check for visible severe wasting"
label var v2pe_11 "Exam: Weigh the child"
label var v2pe_12 "Exam: Check weight against a growth chart"
label var v2pe_13 "Exam: Look for edema of both feet"

label var v2lab_2 "Lab: Malaria test"
label var v2lab_3 "Lab: Full Blood Count"
label var v2lab_4 "Lab: Hemoglobin test"
label var v2lab_5 "Lab: Lumbar puncture"

label var v2educ_2 "Educ: Importance of iron intake"
label var v2educ_3 "Educ: When to return if no improvement"
label var v2educ_4 "Educ: Explains danger signs require patient return immediately"
label var v2educ_5 "Educ: Explain how to use ACT with folic acid or iron"	
label var v2educ_6 "Educ: When to return to re-evaluate anemia"


foreach v in a b d e f g h i j {
	qui replace cs_`v'=""
}
foreach var of varlist cs_?_? v1* v2* {
	label values `var' yesno
}
drop cs_c p_*
order studyprov provtype clinictreat, after(v2educ_6)

* Save
save "$proc/provider", replace


/*=============================================================================
		Patient data
=============================================================================*/

use "$raw/patient", clear

* Label variables

label var 	state " State "
label var 	sid  " State ID "
label var 	strata  " Strata ID "
label var 	fid  " Clinic ID "
label var	visitdate	"	Visit date	"
label var	patid	"	Patient ID	"
label var	age	"	Patient age	"
label var	sex	"	Patient sex 	"
label var	phone	"	Do you have a contact phone number	"
label var	transport	"	How did you get to this clinic today	"
label var	transport_mins	"	Travel time in minutes	"
label var	transport_hrs	"	Travel time in hours	"
label var	r_symptom1	"	Presenting Symptom 1	"
label var	r_duration1	"	Duration of presenting complaint 1	"
label var	r_unit1	"	Unit of duration of presenting complaint 1	"
label var	r_symptom2	"	Presenting Symptom 2	"
label var	r_duration2	"	Duration of presenting complaint 2	"
label var	r_unit2	"	Unit of duration of presenting complaint 2	"
label var	r_symptom3	"	Presenting Symptom 3	"
label var	r_duration3	"	Duration of presenting complaint 3	"
label var	r_unit3	"	Unit of duration of presenting complaint 3	"
label var	r_symptom4	"	Presenting Symptom 4	"
label var	r_duration4	"	Duration of presenting complaint 4	"
label var	r_unit4	"	Unit of duration of presenting complaint 4	"
label var	r_symptom5	"	Presenting Symptom 5	"
label var	r_duration5	"	Duration of presenting complaint 5	"
label var	r_unit5	"	Unit of duration of presenting complaint 5	"
label var	r_symptom6	"	Presenting Symptom 6	"
label var	r_duration6	"	Duration of presenting complaint 6	"
label var	r_unit6	"	Unit of duration of presenting complaint 6	"
label var	r_symptom7	"	Presenting Symptom 7	"
label var	r_duration7	"	Duration of presenting complaint 7	"
label var	r_unit7	"	Unit of duration of presenting complaint 7	"
label var	r_symptom8	"	Presenting Symptom 8	"
label var	r_duration8	"	Duration of presenting complaint 8	"
label var	r_unit8	"	Unit of duration of presenting complaint 8	"
label var	severity	"	Severity of symptoms experienced (0-10)	"
label var	bhealth	"	How would you rate your health today	"
label var	walk	"	Today would you have any physical trouble or difficulty: Walking up a flight of stairs	"
label var	run	"	Today would you have any physical trouble or difficulty: Running the length of a field	"
label var	ache	"	During the past week how much trouble have you had with hurting or aching in any part of your body	"
label var	sleep	"	During the past week how much trouble have you had with sleeping	"
label var	observe	"	Was the consultation observed	"
label var	provid	"	Provider ID	"
label var	interr	"	Was the consultation completed without interruption	"
label var	duration	"	Consultation time in minutes	"
label var	greet	"	Does provider respectfully greet the patient/caretaker	"
label var	ask	"	Does provider ask patient/caretaker for the purpose of the visit	"
label var	d_symptom1	"	DCO: Presenting Symptom 1	"
label var	d_duration1	"	DCO: Duration of presenting symptom 1	"
label var	d_unit1	"	DCO: Unit of duration of presenting symptom 1	"
label var	d_symptom2	"	DCO: Presenting Symptom 2	"
label var	d_duration2	"	DCO: Duration of presenting symptom 2	"
label var	d_unit2	"	DCO: Unit of duration of presenting symptom 2	"
label var	d_symptom3	"	DCO: Presenting Symptom 3	"
label var	d_duration3	"	DCO: Duration of presenting symptom 3	"
label var	d_unit3	"	DCO: Unit of duration of presenting symptom 3	"
label var	d_symptom4	"	DCO: Presenting Symptom 4	"
label var	d_duration4	"	DCO: Duration of presenting symptom 4	"
label var	d_unit4	"	DCO: Unit of duration of presenting symptom 4	"
label var	d_symptom5	"	DCO: Presenting Symptom 5	"
label var	d_duration5	"	DCO: Duration of presenting symptom 5	"
label var	d_unit5	"	DCO: Unit of duration of presenting symptom 5	"
label var	d_symptom6	"	DCO: Presenting Symptom 6	"
label var	d_duration6	"	DCO: Duration of presenting symptom 6	"
label var	d_unit6	"	DCO: Unit of duration of presenting symptom 6	"
label var	fever_dco	"	Fever: History-taking questions asked	"
label var	u5fever_dco	"	Fever: Additional questions for children under 5	"
label var	cough_dco	"	Cough: History-taking questions asked	"
label var	u5cough_dco	"	Cough: Additional questions for children under 5	"
label var	diarrhea_dco	"	Diarrhea: History-taking questions asked	"
label var	u5diarrhea_dco	"	Diarrhea: Additional questions for children under 5	"
label var	d_pe1	"	Exam: General	"
label var	d_pe2	"	Exam: Chest	"
label var	d_pe3	"	Exam: Abdomen	"
label var	d_pe4	"	Exam: Head and Neck	"
label var	d_pe5	"	Exam: Upper & Lower limbs	"
label var	d_pe6	"	Exam: For children under 5	"
label var	d_test	"	Lab tests	"
label var	d_test_other	"	Lab tests: Other	"
label var	diag	"	Was any diagnosis made	"
label var	drugs	"	Were any medicines prescribed	"
label var	antibio	"	Was an antibiotic prescribed	"
label var	inject	"	Was an injection prescribed	"
label var	comm	"	Provider communication with the patient	"
label var	clinictreat	"	Clinic treatment	"
label var	provtype	"	Provider type	"
label var	order	"	Consultation sequence	"
	
* Remove leading blanks in labels

foreach v of varlist _all {
	local a : variable label `v'
	label var `v' "`a'"
	label var `v' "`=strltrim("`: var lab `v''")'" 	
}

* Define value labels

#delimit;
label define type 
	0 "Existing MLP" 
	1 "New MLP" 
	2 "Doctor"
	;
label define treatment 
	0 Control 
	1 MLP 
	2 Doctor
	;
label define sex 
	1 Male 
	2 Female
	;
label define transport 
	1 "Walked" 
	2 "Bus or shared van" 
	3 "Taxi" 
	4 "My own car/motorcycle" 
	5 "Boat" 
	6 "Other"
	;
label define unit 
	1 Days 
	2 Weeks 
	3 Months 
	;
label define health 
	1 Excellent 
	2 "Very good" 
	3 Good 
	4 Fair 
	5 Poor 
	99 "Dont know"
	;
label define status 
	1 None 
	2 Some 
	3 "A lot"
	;
label define yesno  
	0 No  
	1 Yes
	;
#delimit cr

* Apply value labels

label values provtype type
label values clinictreat treatment
label values sex sex 
label values transport transport
foreach v of varlist ?_unit? {
	label values `v' unit  
}
label values bhealth health
foreach v in walk run ache sleep {
	label values `v' status  
}
replace observe=0 if observe==2 
foreach v of varlist phone observe interr greet ask diag drugs antibio inject {
	label values `v' yesno
}

* Format/create variables

loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

foreach v in visitdate { 
	local a : variable label `v'
	g double _`v'=monthly(`v',"MY")
	format _`v' %tm
	label var _`v' "`a'"
	order _`v', after(`v')
	drop `v' 
	ren _`v' `v'
}

* Travel time to clinic

ge distmin= transport_mins
replace distmin=transport_hrs if transport_hrs>5
replace distmin=0 if (transport_mins==60 | transport_mins==120) & transport_hrs>0
ge disthour= transport_hrs
replace disthour=transport_mins if transport_hrs>5
ge distime=distmin + (disthour*60)
drop disthour distmin
label var distime "Travel time to clinic (minutes)"
order distime, after(transport_hrs)
drop transport_*

* Split alphanumeric codes from symptoms

foreach x of varlist ?_symptom? {
	ge c_`x'=substr(`x',1,3)
	replace `x'=strtrim(substr(`x',4,.))
}

* How many of the recommended history-taking questions did they ask?
		
	foreach x of varlist fever_dco cough_dco diarrhea_dco u5* {
		replace `x'=" "+`x'+" " if `x'!=""
	}
	forvalues i=1/12 {
		ge fever_`i'= regexm(fever_dco," `i' ")
		replace fever_`i'=. if fever_dco==""
	}
	forvalues i=1/5 {
		ge u5fever_`i'= regexm(u5fever_dco," `i' ")
		replace u5fever_`i'=. if fever_dco==""
	}
	forvalues i=1/14 {
	ge cough_`i'=regexm(cough_dco," `i' ")
	replace cough_`i'=. if cough_dco==""
	}
	forvalues i=1/4 {
		ge u5cough_`i'= regexm(u5cough_dco," `i' ")
		replace u5cough_`i'=. if cough_dco==""
	}
	forvalues i=1/11 {
		ge diarrhea_`i'=regexm(diarrhea_dco," `i' ")
		ge u5diarrhea_`i'= regexm(u5diarrhea_dco," `i' ")
		replace diarrhea_`i'=. if diarrhea_dco=="" 
		replace u5diarrhea_`i'=. if diarrhea_dco==""
	}

** Check whether the provider asked about duration 

	forvalues i=1/6 {
		replace fever_1=1 if fever_1==0 & fever_dco!="" & c_d_symptom`i'=="A03" & d_duration`i'<99
		replace cough_1=1 if cough_1==0 & cough_dco!="" & c_d_symptom`i'=="R05" & d_duration`i'<99
		replace diarrhea_1=1 if diarrhea_1==0 & diarrhea_dco!="" & c_d_symptom`i'=="D11" & d_duration`i'<99
	}
	foreach v in fever cough diarrhea {
		egen `v'_count=rowtotal(`v'_? `v'_??), mi
		egen x=rownonmiss(`v'_? `v'_??) 
		ge `v'_perc=`v'_count/x
		drop x
	}

label var fever_1 "Asked about duration"
label var fever_2 "Asked about pattern"
label var fever_3 "Asked about chills/sweats"
label var fever_4 "Asked about cough"
label var fever_5 "Asked about sore throat/pain swallowing"
label var fever_6 "Asked about vomiting"
label var fever_7 "Asked about diarrhea "
label var fever_8 "Asked about convulsions"
label var fever_9 "Asked about catarrh"
label var fever_10 "Asked if medication given"
label var fever_11 "Asked medication amount"
label var fever_12 "Asked other question"
label var u5fever_1 "Child: Asked about drinking/breastfeeding"
label var u5fever_2 "Child: Asked about difficulty breathing/chest pain"
label var u5fever_3 "Child: Asked about ear pain/discharge"
label var u5fever_4 "Child: Asked about pain/crying while passing urine"
label var u5fever_5 "Child: Asked about vaccination history"
label var cough_1 "Asked about duration"
label var cough_2 "Asked about sputum production"
label var cough_3 "Asked about color of sputum"
label var cough_4 "Asked what makes it worse"
label var cough_5 "Asked whether worse at night"
label var cough_6 "Asked about contact with person with chronic cough"
label var cough_7 "Asked about night sweats "
label var cough_8 "Asked about chest pain"
label var cough_9 "Asked about difficulty breathing"
label var cough_10 "Asked about fever"
label var cough_11 "Asked about appetite"
label var cough_12 "Asked about diarrhea"
label var cough_13 "Asked about vomiting"
label var cough_14 "Asked about tiredness/fatigue"
label var u5cough_1 "Child: Asked about drinking/breastfeeding"
label var u5cough_2 "Child: Asked about convulsions"
label var u5cough_3 "Child: Asked about ear problems"
label var u5cough_4 "Child: Asked about vaccination history"
label var diarrhea_1 "Asked about duration"
label var diarrhea_2 "Asked about frequency"
label var diarrhea_3 "Asked about consistency"
label var diarrhea_4 "Asked about blood in stool"
label var diarrhea_5 "Asked about mucus in stool"
label var diarrhea_6 "Asked about abdominal pain"
label var diarrhea_7 "Asked about vomiting "
label var diarrhea_8 "Asked about fever"
label var diarrhea_9 "Asked about tiredness/fatigue"
label var diarrhea_10 "Asked if family members/neighbors have diarrhea"
label var diarrhea_11 "Asked about any medications"
label var u5diarrhea_1 "Child: Asked about drinking/breastfeeding"
label var u5diarrhea_2 "Child: Asked about convulsions"
label var u5diarrhea_3 "Child: Asked about ear problems"
label var u5diarrhea_4 "Child: Asked about cough/difficulty breathing"
label var u5diarrhea_5 "Child: Asked if tears when baby cries"
label var u5diarrhea_6 "Child: Asked if baby started taking other food"
label var u5diarrhea_7 "Child: Asked if change in food is recent"
label var u5diarrhea_8 "Child: Asked how the food has been given"
label var u5diarrhea_9 "Child: Asked who prepares and feeds the child"
label var u5diarrhea_10 "Child: Asked about hand washing of food preparer"
label var u5diarrhea_11 "Child: Asked about vaccination history"
label var fever_perc "Fever: Percent of recommended questions asked"
label var cough_perc "Cough: Percent of recommended questions asked"
label var diarrhea_perc "Diarrhea: Percent of recommended questions asked"

drop *_count *_dco
order fever_* cough_* diarrhea_* u5*, after(ask)

* Physical examinations

loc pe1_tot 8
loc pe2_tot 5
loc pe3_tot 6 
loc pe4_tot 8
loc pe5_tot 5
loc pe6_tot 8

foreach x in d {
	foreach exam in pe1 pe2 pe3 pe4 pe5 pe6 {
		split `x'_`exam', g(temp)
		forval val = 1/``exam'_tot' {
			gen `x'_`exam'_`val' = 0 if `x'_`exam'!="``exam'_tot'"
			foreach var of varlist temp* {
				replace `x'_`exam'_`val' = 1 if `var'=="`val'" 
			}
		}
		order `x'_`exam'_?, after(`x'_`exam')
		drop temp* `x'_`exam'
	}

	egen `x'_exam_num = rowtotal(`x'_pe1_? `x'_pe2_? `x'_pe3_? `x'_pe4_? `x'_pe5_? `x'_pe6_?)

	forval val = 1 / 6 {
			replace `x'_exam_num = `x'_exam_num - 1 if `x'_pe`val'_`pe`val'_tot'==1 // subtract "Not applicable"
			}
		gen `x'_exam_any = `x'_exam_num>0 if `x'_exam_num<.
			order `x'_exam_any `x'_exam_num, before(`x'_pe1_1)
}
	
ren d_pe1_* gen*
ren d_pe2_* chest*
ren d_pe3_* abd*
ren d_pe4_* head*
ren d_pe5_* limb*
ren d_pe6_* child*

label var gen1 "Feels for temperature"
label var gen2 "Takes temperature w/ thermometer"
label var gen3 "Measures blood pressure"
label var gen4 "Checks respiratory rate"
label var gen5 "Checks pulse rate"
label var gen6 "Checks for signs of anemia"
label var gen7 "Checks for signs of dehydration"
label var chest1 "Observes for lower chest in-drawing"
label var chest2 "Percusses chest"
label var chest3 "Auscultates chest"
label var chest4 "Checks for tracheal deviation"
label var abd1 "Checks for tenderness"
label var abd2 "Checks for rigidity"
label var abd3 "Checks for organ enlargement"
label var abd4 "Percusses the abdomen"
label var abd5 "Auscultates the abdomen"
label var head1 "Checks for neck stiffness"
label var head2 "Checks ear"
label var head3 "Examines throat"
label var head4 "Check for enlarged lymph nodes"
label var head5 "Examines the thyroid"
label var head6 "Temperature w/ thermometer"
label var head7 "Observes for nasal flaring"
label var limb1 "Checks for finger clubbing"
label var limb2 "Checks for peripheral cyanosis"
label var limb3 "Palpates the axilla"
label var limb4 "Checks femoral region for hernias"
label var child1 "Assesses general condition"
label var child2 "Checks for visible wasting"
label var child3 "Looks for edema"
label var child4 "Weighs the child"
label var child5 "Checks against growth chart"
label var child6 "Offers child water/observes breastfeeding"
label var child7 "Checks for skin changes/rash"
ren d_exam*  exam*
label var exam_any "Any physical exam"
drop exam_num gen8 chest5 abd6 head8 limb5 child8  
	
* Lab tests

ge d_test_any = d_test!="0" if d_test!=""
replace d_test = "" if d_test=="0"
foreach x in d {
	split `x'_test, gen(temp)
	forval val=1/20 {
		gen `x'_test`val' = 0 if `x'_test!=""
		foreach var of varlist temp* {
			replace `x'_test`val' = 1 if `var'=="`val'"
		}
	}
	egen `x'_test_num = rowtotal(`x'_test? `x'_test??)
	order `x'_test_any `x'_test_num `x'_test? `x'_test??, after(`x'_test)
	drop temp* `x'_test
}

ren d_test* test*
label var test1 "Malaria test"
label var test2 "HIV test"
label var test3 "Full Blood Count"
label var test4 "ESR"
label var test5 "Hb/PCV"
label var test6 "WBC"
label var test7 "Urinalysis"
label var test8 "Urine MCS"
label var test9 "Stool analysis"
label var test10 "Blood glucose"
label var test11 "Sputum AFB"
label var test12 "Mantoux test"
label var test13 "High Vaginal Swab MCS"
label var test14 "Lumbar puncture"
label var test15 "Chest X-Ray"
label var test16 "Ultrasound"
label var test17 "ECG"
label var test18 "EEG"
label var test19 "Pregnancy test"
label var test20 "Other test"
label var test_any "Any lab tests"
drop test_num

* Communication 

forvalues i=1/9 {
	ge comm`i'=regexm(comm ,"`i'")
	replace comm`i'=. if comm ==""
}

label var comm1 "Looks at the patient while talking"
label var comm2 "Tells the patient the diagnosis "
label var comm3 "Explains the diagnosis in common language"
label var comm4 "Explains the treatment being provided"
label var comm5 "Gives health education related to the diagnosis"
label var comm6 "Refers the patient to another facility"
label var comm7 "Explains whether to return for further treatment"
label var comm8 "Listens properly to the patient/caregiver"
label var comm9 "Allows the patient to talk"
order comm?, after(comm)
drop comm

* Clean up

ren (exam_any test_any provtype) (exam test provider)

foreach i of numlist 1/8 {
	ren c_r_symptom`i' code`i'
	order code`i', after(r_symptom`i')
	label var code`i' "Symptom code `i'"
	ren r_symptom`i' symptom`i' 
	ren r_duration`i' duration`i' 
	ren r_unit`i' unit`i' 
}

drop ?_symptom* ?_duration* ?_unit* c_d_symptom? 

foreach v of varlist fever_* cough_* diarrhea_* u5* exam gen1-test20 comm?  {
	label values `v' yesno
}

order observe order interr duration provid provider clinictreat, after(comm9)

* Save
save "$proc/patient", replace


/*=============================================================================
		Audit data
=============================================================================*/

use "$raw/audit", clear

loc v state
replace `v'=upper(`v')
replace `v'=regexr(`v',"_"," ")

foreach v in visitdate { 
	local a : variable label `v'
	g double _`v'=monthly(`v',"MY")
	format _`v' %tm
	label var _`v' "`a'"
	order _`v', after(`v')
	drop `v' 
	ren _`v' `v'
}

* Rename variables

ren (clinic_openpatients_any clinic_openhowmany clinic_openpresent_oic clinic_openpresent_provider clinic_openproviders_num) (patients_any patients_num present_oic present_prov present_num)

* Label variables

label var state 		"State"
label var sid  			"State ID"
label var strata  		"Strata ID"
label var fid  			"Clinic ID"
label var visitdate 	"Date of Visit"
label var open		 	"Was clinic open"
label var patients_any  "At time of visit were there any patients in the waiting area"
label var patients_num  "How many patients in the waiting area"
label var present_oic  	"At time of visit was the OIC present"
label var present_prov  "At time of visit was the deployed provider present"
label var present_num  	"How many providers were available to attend to outpatients"
label var clinictreat  	"Clinic treatment"

* Define value labels
		  
label define yesno 0 No 1 Yes
label define treatment 0 Control 1 MLP 2 Doctor

* Apply value labels

label values clinictreat treatment
local bin open patients_any present_oic present_prov
foreach x of local bin {
	replace `x'=0 if `x'==2
	label values `x' yesno
}

* Save
save "$proc/audit", replace

	

