library(haven)
library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)

# Set up directories
raw_dir <- "../data/raw"
intermediate_dir <- "../data/intermediate"

# Create directories if they don't exist
dir.create(intermediate_dir, showWarnings = FALSE)

#=============================================================================
#   Woman Baseline data
#=============================================================================

# Read the data
woman_bl <- read_dta(file.path(raw_dir, "woman_bl.dta"))

rename_mapping <- c(
  state = "state",
  sid = "sid",
  strata = "strata",
  fid = "fid",
  eaid = "eaid",
  wid = "wid",
  blmth = "blmth",
  gest = "monthspreg",  # Note the order: new_name = old_name
  age = "age",
  cct = "cct",
  phonenum = "bl_havenumber",
  mob = "bl_b1",
  estage = "bl_b2",
  marital = "bl_b3",
  ethnicity = "bl_b4",
  religion = "bl_b5",
  reside = "bl_b6",
  reside_yr = "bl_b7",
  education = "bl_b8",
  schooling = "bl_b9",
  read = "bl_b10",
  occup = "bl_b11",
  work = "bl_b12",
  husbage = "bl_b13",
  polygamy = "bl_b14",
  wives = "bl_b15",
  husbeduc = "bl_b16",
  husbschool = "bl_b17",
  husboccup = "bl_b18",
  husbwork = "bl_b19",
  decide1 = "bl_b20",
  decide2 = "bl_b21",
  hhsize = "bl_c1",
  own = "bl_c2",
  dwelling = "bl_c3",
  floor = "bl_c4",
  walls = "bl_c5",
  roof = "bl_c6",
  water = "bl_c7",
  electric = "bl_c8",
  fuel = "bl_c9",
  toilet = "bl_c10",
  share = "bl_c11",
  kitchen = "bl_c12",
  rooms = "bl_c13",
  radio = "bl_c14a",
  tv = "bl_c14b",
  bicycle = "bl_c14c",
  motorbike = "bl_c14d",
  generator = "bl_c14e",
  phone = "bl_c14f",
  computer = "bl_c14g",
  cart = "bl_c14h",
  car = "bl_c14i",
  boat = "bl_c14j",
  fridge = "bl_c14k",
  bank = "bl_c15",
  priorb = "priorb",
  lastbfac = "lastbfac",
  pastdeath = "pastdeath",
  clinictreat = "clinictreat"
)
woman_bl <- woman_bl %>%
  rename(!!!rename_mapping)




# Set variable labels
# Add variable labels
attr(woman_bl$state, "label") <- "State"
attr(woman_bl$sid, "label") <- "State ID"
attr(woman_bl$strata, "label") <- "Strata ID"
attr(woman_bl$fid, "label") <- "Clinic ID"
attr(woman_bl$eaid, "label") <- "Enumeration area ID"
attr(woman_bl$wid, "label") <- "Woman ID"
attr(woman_bl$blmth, "label") <- "Month of enrollment"
attr(woman_bl$gest, "label") <- "Months pregnant at enrollment"
attr(woman_bl$age, "label") <- "Age at enrollment"
attr(woman_bl$cct, "label") <- "Offered incentive"
attr(woman_bl$phonenum, "label") <- "Does repondent have a phone"
attr(woman_bl$mob, "label") <- "Do you know your date of birth"
attr(woman_bl$estage, "label") <- "If unknown: estimated age"
attr(woman_bl$marital, "label") <- "What is your current marital status"
attr(woman_bl$ethnicity, "label") <- "What is your ethnic group or tribe"
attr(woman_bl$religion, "label") <- "What religion do you practice?"
attr(woman_bl$reside, "label") <- "Have you always lived in this community"
attr(woman_bl$reside_yr, "label") <- "In what year did you start living in this community"
attr(woman_bl$education, "label") <- "Have you ever attended school (western or Islamic)"
attr(woman_bl$schooling, "label") <- "What is the highest level of school you attended"
attr(woman_bl$read, "label") <- "I would like you to read this sentence to me: The man goes to his farm every day"
attr(woman_bl$occup, "label") <- "What is the your main occupation"
attr(woman_bl$work, "label") <- "Have you worked in the last 12 months"
attr(woman_bl$husbage, "label") <- "How old was your husband or partner on his last birthday"
attr(woman_bl$polygamy, "label") <- "Are you his only wife or does he have other wives"
attr(woman_bl$wives, "label") <- "How many other wives does he have"
attr(woman_bl$husbeduc, "label") <- "Did he ever attend school (western or Islamic)"
attr(woman_bl$husbschool, "label") <- "What is the highest level of school he attended"
attr(woman_bl$husboccup, "label") <- "What is his main occupation"
attr(woman_bl$husbwork, "label") <- "Has your husband/partner worked in the last 12 months"
attr(woman_bl$decide1, "label") <- "Who usually decides how the money you earn will be used in the family"
attr(woman_bl$decide2, "label") <- "Who usually makes decisions about health care for yourself"
attr(woman_bl$hhsize, "label") <- "How many people live in your household (including yourself)"
attr(woman_bl$own, "label") <- "Who owns the dwelling the household occupies"
attr(woman_bl$dwelling, "label") <- "What is main type of dwelling of the household"
attr(woman_bl$floor, "label") <- "What is the main material of the floor"
attr(woman_bl$walls, "label") <- "What is the main material of the exterior wall"
attr(woman_bl$roof, "label") <- "What is the main material of the roof"
attr(woman_bl$water, "label") <- "What is the main source of drinking water for the household"
attr(woman_bl$electric, "label") <- "Is the household connected to electricity i.e., PHCN/NEPA"
attr(woman_bl$fuel, "label") <- "What is the main source of cooking fuel"
attr(woman_bl$toilet, "label") <- "What type of toilet facility does the household use"
attr(woman_bl$share, "label") <- "Is this toilet shared with other households?"
attr(woman_bl$kitchen, "label") <- "Do you have a separate room that is used as a kitchen"
attr(woman_bl$rooms, "label") <- "How many rooms in this household are used for sleeping"
attr(woman_bl$radio, "label") <- "Does the household own - radio"
attr(woman_bl$tv, "label") <- "Does the household own - tv"
attr(woman_bl$bicycle, "label") <- "Does the household own - bike"
attr(woman_bl$motorbike, "label") <- "Does the household own - motorbike"
attr(woman_bl$generator, "label") <- "Does the household own - generator"
attr(woman_bl$phone, "label") <- "Does the household own - mobile phone"
attr(woman_bl$computer, "label") <- "Does the household own - computer"
attr(woman_bl$cart, "label") <- "Does the household own - animal drawn cart"
attr(woman_bl$car, "label") <- "Does the household own - car/truck"
attr(woman_bl$boat, "label") <- "Does the household own - boat with motor"
attr(woman_bl$fridge, "label") <- "Does the household own - refridgerator"
attr(woman_bl$bank, "label") <- "Does any member of this household have a bank account"
attr(woman_bl$priorb, "label") <- "Number of previous births"
attr(woman_bl$lastbfac, "label") <- "Last birth was in a health facility"
attr(woman_bl$pastdeath, "label") <- "Prior stillbirth or newborn death"
attr(woman_bl$clinictreat, "label") <- "Clinic treatment"

# Create factor variables with value labels
woman_bl <- woman_bl %>%
  mutate(
    # yesno label
    cct = factor(cct, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    phonenum = factor(phonenum, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    reside = factor(reside, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    education = factor(education, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    work = factor(work, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    husbeduc = factor(husbeduc, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    husbwork = factor(husbwork, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    electric = factor(electric, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    share = factor(share, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    kitchen = factor(kitchen, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    radio = factor(radio, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    tv = factor(tv, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    bicycle = factor(bicycle, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    motorbike = factor(motorbike, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    generator = factor(generator, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    phone = factor(phone, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    computer = factor(computer, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cart = factor(cart, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    car = factor(car, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    boat = factor(boat, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    fridge = factor(fridge, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    bank = factor(bank, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    
    # yesno1 label
    # (Apply to variables that use this label set)
    
    # wife label
    polygamy = factor(polygamy, levels = c(1, 2), 
                      labels = c("Only wife", "Other wives")),
    
    # decision label
    decide1 = factor(decide1, levels = 1:4, 
                     labels = c("Respondent", "Husband/partner", 
                                "Respondent and husband/partner", "Other")),
    decide2 = factor(decide2, levels = 1:4, 
                     labels = c("Respondent", "Husband/partner", 
                                "Respondent and husband/partner", "Other")),
    
    # occup label
    occup = factor(occup, levels = c(1:13, 99), 
                   labels = c("Agricultural worker, own field", 
                              "Agricultural wage-labor, for cash or in kind",
                              "Salaried employee (private sector)",
                              "Salaried employee (government)",
                              "Has a trade e.g., carpenter",
                              "Business/trader",
                              "Petty trader/kiosk",
                              "Laborer",
                              "Homemaker",
                              "Retired",
                              "Student",
                              "Never worked, seeking work",
                              "Never worked, not seeking work",
                              "Dont know")),
    husboccup = factor(husboccup, levels = c(1:13, 99), 
                       labels = c("Agricultural worker, own field", 
                                  "Agricultural wage-labor, for cash or in kind",
                                  "Salaried employee (private sector)",
                                  "Salaried employee (government)",
                                  "Has a trade e.g., carpenter",
                                  "Business/trader",
                                  "Petty trader/kiosk",
                                  "Laborer",
                                  "Homemaker",
                                  "Retired",
                                  "Student",
                                  "Never worked, seeking work",
                                  "Never worked, not seeking work",
                                  "Dont know")),
    
    # educ label
    schooling = factor(schooling, levels = c(1:17, 99), 
                       labels = c("Kindergarten",
                                  "Primary 1",
                                  "Primary 2",
                                  "Primary 3",
                                  "Primary 4",
                                  "Primary 5",
                                  "Primary 6",
                                  "JS1",
                                  "JS2",
                                  "JS3",
                                  "SS1",
                                  "SS2",
                                  "SS3",
                                  "College of educ/polytechnic",
                                  "University (bachelors)",
                                  "University (masters or up)",
                                  "Koranic school",
                                  "Dont know")),
    husbschool = factor(husbschool, levels = c(1:17, 99), 
                        labels = c("Kindergarten",
                                   "Primary 1",
                                   "Primary 2",
                                   "Primary 3",
                                   "Primary 4",
                                   "Primary 5",
                                   "Primary 6",
                                   "JS1",
                                   "JS2",
                                   "JS3",
                                   "SS1",
                                   "SS2",
                                   "SS3",
                                   "College of educ/polytechnic",
                                   "University (bachelors)",
                                   "University (masters or up)",
                                   "Koranic school",
                                   "Dont know")),
    
    # m_status label
    marital = factor(marital, levels = 1:6, 
                     labels = c("never married",
                                "married",
                                "partner-living together, not married",
                                "divorced",
                                "separated",
                                "widowed")),
    
    # dateknown label
    mob = factor(mob, levels = 1:2, 
                 labels = c("Respondent knows", "Respondent does not know")),
    
    # toilet label
    toilet = factor(toilet, levels = 1:6, 
                    labels = c("flush toilet",
                               "traditional pit latrine",
                               "ventilated improved pit lat.",
                               "bucket latrine",
                               "no facility/bush/field",
                               "other")),
    
    # water label
    water = factor(water, levels = 1:15, 
                   labels = c("piped-dwelling",
                              "piped-yard/plot",
                              "piped to neighbor",
                              "public tap",
                              "tube well or borehole",
                              "protected well",
                              "unprotected well",
                              "protected spring",
                              "unprotected spring",
                              "rainwater",
                              "tanker truck",
                              "cart with small tank",
                              "surface water",
                              "bottled water",
                              "other")),
    
    # fuel label
    fuel = factor(fuel, levels = 1:12, 
                  labels = c("electricity",
                             "gas",
                             "kerosene",
                             "coal,lignite",
                             "charcoal",
                             "wood",
                             "solar",
                             "straw/shrubs/grass",
                             "agricultural crop",
                             "animal dung",
                             "no food cooked in household",
                             "other")),
    
    # roof label
    roof = factor(roof, levels = 1:3, 
                  labels = c("natural roof", "rudimentary roof", "finished roof")),
    
    # exterior label
    walls = factor(walls, levels = 1:3, 
                   labels = c("natural walls", "rudimentary walls", "finished walls")),
    
    # floor label
    floor = factor(floor, levels = 1:3, 
                   labels = c("natural floor", "rudimentary floor", "finished floor")),
    
    # owner label
    own = factor(own, levels = 1:4, 
                 labels = c("Owned by family or one of its members",
                            "rented",
                            "occupied without payment",
                            "other")),
    
    # dwelling_type label
    dwelling = factor(dwelling, levels = 1:3, 
                      labels = c("permanent buildling", "semi permanent", "temporary")),
    
    # read label
    read = factor(read, levels = 1:4, 
                  labels = c("Cannot read at all",
                             "Able to read only parts of sentence",
                             "Able to read whole sentence",
                             "Blind/visually impaired")),
    
    # ethnic label
    ethnicity = factor(ethnicity, levels = 1:12, 
                       labels = c("Fulani",
                                  "Hausa",
                                  "Tangale",
                                  "Tera",
                                  "Waja",
                                  "Igbo",
                                  "Yoruba",
                                  "Ibibio",
                                  "Efik",
                                  "Oron",
                                  "Annang",
                                  "Other")),
    
    # religion label
    religion = factor(religion, levels = 1:8, 
                      labels = c("catholic",
                                 "anglican",
                                 "pentecostal",
                                 "other christian",
                                 "muslim",
                                 "traditionalist",
                                 "atheist",
                                 "other")),
    
    # treatment label
    clinictreat = factor(clinictreat, levels = 0:2, 
                         labels = c("Control", "MLP", "Doctor"))
  )

# Format date variables
woman_bl <- woman_bl %>%
  mutate(
    blmth = as.Date(paste0(blmth, "-01"), format = "%Y-%m-%d")
  )

# Recode binary variables from 2 to 0
binary_vars <- c("phonenum", "reside", "education", "work", "husbeduc", "husbwork", 
                 "electric", "share", "kitchen", "radio", "tv", "bicycle", "motorbike", 
                 "generator", "phone", "computer", "cart", "car", "boat", "fridge", "bank")

woman_bl <- woman_bl %>%
  mutate(across(all_of(binary_vars), ~ifelse(. == 2, 0, .)))

# Fix reside_yr variable
woman_bl <- woman_bl %>%
  mutate(
    reside_yr = ifelse(reside_yr < 1900, year(blmth) - reside_yr, reside_yr),
    reside_yr = ifelse(reside_yr == 20005, 2005, reside_yr),
    reside_yr = ifelse(reside_yr == 20016, 2016, reside_yr)
  )

# Save processed data
write_dta(woman_bl, file.path(intermediate_dir, "woman_bl.dta"))

#=============================================================================
#   Woman Endline data
#=============================================================================

# Read the data
woman_el <- read_dta(file.path(raw_dir, "woman_el.dta"))

rename_mapping <- c(
  state = "state",
  sid = "sid",
  strata = "strata",
  fid = "fid",
  eaid = "eaid",
  wid = "wid",
  intmth = "date",
  followup = "followup",
  dead = "dead",
  consent = "consent",
  cct = "cct",
  wanted = "b1",
  anc = "b2",
  ancprov = "b3",
  ancprov_oth = "b3_other",
  ancplace = "b4",
  ancplace_oth = "b4_other",
  anctime = "b5",
  ancvisits = "b6",
  anccare1 = "b7",
  anccare2 = "b8",
  anccare3 = "b9",
  anccare4 = "b10",
  anccare5 = "b11",
  anccare6 = "b12",
  anccare7 = "b13",
  anccare8 = "b14",
  anccare9 = "b15",
  anccare10 = "b16",
  tetanus = "b17",
  iron = "b18",
  malaria = "b19",
  pregprob1 = "b20",
  pregprob2 = "b21",
  pregprob3 = "b22",
  pregprob4 = "b23",
  pregprob5 = "b24",
  pregprob6 = "b25",
  pregprob7 = "b26",
  pregprob8 = "b27",
  pregprob9 = "b28",
  pregprob10 = "b29",
  pregprob11 = "b30",
  pregprob12 = "b31",
  pregprob13 = "b32",
  pregprob_oth = "b33",
  pregtreat = "b34",
  treatwhere = "b35",
  outcome = "c1",
  month = "c2",
  pregweeks = "c3a",
  pregmths = "c3b",
  early = "c4",
  delplace = "c5",
  delnights = "c6",
  reason1 = "c7",
  reason2 = "c8",
  delprov = "c9",
  delprov_oth = "c9_other",
  laborpain = "c10",
  delprob1 = "c11",
  delprob2 = "c12",
  delprob3 = "c13",
  delprob4 = "c14",
  delprob5 = "c15",
  delprob6 = "c16",
  delprob7 = "c17",
  delprob_oth = "c18",
  referral = "c19",
  refwhere = "c20",
  babypart = "c21",
  cesarean = "c22",
  cs_why = "c23",
  augment = "c24",
  augwhat = "c25",
  assist = "c26",
  painmed = "c27",
  episio = "c28",
  push = "c29",
  injmed = "c30",
  tabmed = "c31",
  ivmed = "c32",
  cord = "c33",
  massage = "c34",
  turned = "c35",
  mistreat1 = "c36",
  mistreat2 = "c37",
  satisf = "c38",
  pay1 = "c39",
  cost1 = "c40",
  pay2 = "c41",
  cost2 = "c42",
  pay3 = "c43",
  cost3 = "c44",
  pay4 = "c45",
  cost4 = "c46",
  pay5 = "c47",
  cost5 = "c48",
  pay6 = "c49",
  cost6 = "c50",
  pnc = "d1",
  pncwhen = "d2",
  pncplace = "d3",
  pncprov = "d4",
  pncprov_oth = "d4_other",
  pncwhat = "d5",
  pnc2 = "d6",
  pncwhen2 = "d7",
  pncvisits = "d8",
  vitamin = "d9",
  postpart1 = "d10",
  postpart2 = "d11",
  postpart3 = "d12",
  postpart4 = "d13",
  postpart5 = "d14",
  postpart6 = "d15",
  postpart7 = "d16",
  postpart_oth = "d17",
  posttreat = "d18",
  postwhere = "d19",
  night = "d20",
  los = "d21",
  multip = "e1",
  multipnum = "e2",
  alive = "e3",
  sex = "e4",
  size = "e6",
  weighed = "e7",
  birthwt = "e8",
  status = "e9",
  diedwhen = "e10",
  diedage = "e11",
  diarrhea = "e12",
  diarrhea1 = "e13",
  diarrhea2 = "e14",
  diarrhea3 = "e15",
  diarrtreat = "e16",
  diarrwhere = "e17",
  treators = "e18",
  treatsalt = "e19",
  treatother = "e20",
  treatelse = "e21",
  fever = "e22",
  fevertreat = "e23",
  feverwhere = "e24",
  cough = "e25",
  cough1 = "e26",
  cough2 = "e27",
  coughtreat = "e28",
  coughwhere = "e29",
  vacrecord = "e30",
  bcg = "e31",
  opv = "e32",
  hep = "e33",
  weight = "e34",
  length = "e35",
  card = "card",
  cardrec1 = "card_anc",
  carddoc1 = "card_anc_doc",
  cardrec2 = "card_del",
  carddoc2 = "card_del_doc",
  cardrec3 = "card_pnc",
  clinictreat = "clinictreat"
)

woman_el <- woman_el %>%
  rename(!!!rename_mapping)

# Add variable labels to the woman_el dataset
attr(woman_el$state, "label") <- "State"
attr(woman_el$sid, "label") <- "State ID"
attr(woman_el$strata, "label") <- "Strata ID"
attr(woman_el$fid, "label") <- "Clinic ID"
attr(woman_el$eaid, "label") <- "Enumeration area ID"
attr(woman_el$wid, "label") <- "Woman ID"
attr(woman_el$intmth, "label") <- "Month of follow-up"
attr(woman_el$followup, "label") <- "Participant found at followup"
attr(woman_el$dead, "label") <- "Participant is deceased"
attr(woman_el$consent, "label") <- "Gave consent for followup"
attr(woman_el$cct, "label") <- "Offered incentive"
attr(woman_el$wanted, "label") <- "When you got pregnant did you want to get pregnant at the time"
attr(woman_el$anc, "label") <- "Did you see anyone for antenatal care for this pregnancy"
attr(woman_el$ancprov, "label") <- "Whom did you see"
attr(woman_el$ancprov_oth, "label") <- "Other provider"
attr(woman_el$ancplace, "label") <- "Where did you receive antenatal care for this pregnancy"
attr(woman_el$ancplace_oth, "label") <- "Other location"
attr(woman_el$anctime, "label") <- "How many months pregnant when first received antenatal care"
attr(woman_el$ancvisits, "label") <- "How many times in total did you receive antenatal care"
attr(woman_el$anccare1, "label") <- "Were you weighed"
attr(woman_el$anccare2, "label") <- "Was your height measured"
attr(woman_el$anccare3, "label") <- "Was your blood pressure measured"
attr(woman_el$anccare4, "label") <- "Did you give a urine sample"
attr(woman_el$anccare5, "label") <- "Did you give a blood sample"
attr(woman_el$anccare6, "label") <- "Did the provider press on your tummy"
attr(woman_el$anccare7, "label") <- "Was your uterine height measured"
attr(woman_el$anccare8, "label") <- "Did the provider ask for your blood type"
attr(woman_el$anccare9, "label") <- "Were you told about danger signs"
attr(woman_el$anccare10, "label") <- "Were you counseled and tested for HIV"
attr(woman_el$tetanus, "label") <- "During this pregnancy were you given an injection to prevent tetanus"
attr(woman_el$iron, "label") <- "During this pregnancy did you take any iron tablets or iron syrup"
attr(woman_el$malaria, "label") <- "During this pregnancy did you take drugs to keep you from getting malaria"
attr(woman_el$pregprob1, "label") <- "Experienced swelling of hands, feet and face during pregnancy"
attr(woman_el$pregprob2, "label") <- "Experienced paleness, giddiness, weakness during pregnancy"
attr(woman_el$pregprob3, "label") <- "Experienced blurred vision or other visual disturbance during pregnancy"
attr(woman_el$pregprob4, "label") <- "Experienced weak or no movement of the fetus during pregnancy"
attr(woman_el$pregprob5, "label") <- "Experienced excessive fatigue/tiredness during pregnancy"
attr(woman_el$pregprob6, "label") <- "Experienced convulsions (not from fever) during pregnancy"
attr(woman_el$pregprob7, "label") <- "Experienced high blood pressure during pregnancy"
attr(woman_el$pregprob8, "label") <- "Experienced vaginal bleeding during pregnancy"
attr(woman_el$pregprob9, "label") <- "Experienced excessive vomiting during pregnancy"
attr(woman_el$pregprob10, "label") <- "Experienced abnormal position of the fetus during pregnancy"
attr(woman_el$pregprob11, "label") <- "Experienced high fever during pregnancy"
attr(woman_el$pregprob12, "label") <- "Experienced jaundice during pregnancy"
attr(woman_el$pregprob13, "label") <- "Experienced water break without labour during pregnancy"
attr(woman_el$pregprob_oth, "label") <- "Any other problem not mentioned"
attr(woman_el$pregtreat, "label") <- "Did you seek treatment for these problems"
attr(woman_el$treatwhere, "label") <- "Where did you seek treatment"
attr(woman_el$outcome, "label") <- "Pregnancy outcome"
attr(woman_el$month, "label") <- "When did this happen"
attr(woman_el$pregweeks, "label") <- "How many weeks pregnant was she"
attr(woman_el$pregmths, "label") <- "How many months pregnant was she"
attr(woman_el$early, "label") <- "Was baby born at the expected time"
attr(woman_el$delplace, "label") <- "Where did you give birth"
attr(woman_el$delnights, "label") <- "How many nights did you spend in this place"
attr(woman_el$reason1, "label") <- "Most important reason for chosing delivery location"
attr(woman_el$reason2, "label") <- "Next most important reason for chosing delivery location"
attr(woman_el$delprov, "label") <- "Who assisted with the delivery of this pregnancy"
attr(woman_el$delprov_oth, "label") <- "Other birth attendant"
attr(woman_el$laborpain, "label") <- "How did your labour pain start"
attr(woman_el$delprob1, "label") <- "Delivery problems: Convulsions"
attr(woman_el$delprob2, "label") <- "Delivery problems: Prolonged labour"
attr(woman_el$delprob3, "label") <- "Delivery problems: Obstructed labour"
attr(woman_el$delprob4, "label") <- "Delivery problems: Severe vaginal bleeding"
attr(woman_el$delprob5, "label") <- "Was it serious enough to warrant a blood transfusion"
attr(woman_el$delprob6, "label") <- "Delivery problems: Loss of consciousness"
attr(woman_el$delprob7, "label") <- "Delivery problems: Vaginal tear"
attr(woman_el$delprob_oth, "label") <- "Any other problem not mentioned"
attr(woman_el$referral, "label") <- "Were you referred to a different place for treatment"
attr(woman_el$refwhere, "label") <- "Where were you referred to"
attr(woman_el$babypart, "label") <- "Which part of the baby came out first"
attr(woman_el$cesarean, "label") <- "Was the baby delivered by Caesarean section"
attr(woman_el$cs_why, "label") <- "What was the main reason for Caesarean section"
attr(woman_el$augment, "label") <- "Was anything done to speed up or to strengthen your pain"
attr(woman_el$augwhat, "label") <- "What was done"
attr(woman_el$assist, "label") <- "Baby delivered using forceps or suction"
attr(woman_el$painmed, "label") <- "Did you receive pain medication"
attr(woman_el$episio, "label") <- "Did anyone do an episiotomy shortly before delivery"
attr(woman_el$push, "label") <- "Did someone push on your stomach"
attr(woman_el$injmed, "label") <- "Did you receive an injection in the first few minutes after delivery"
attr(woman_el$tabmed, "label") <- "Did you receive tablets in the first few minutes after delivery"
attr(woman_el$ivmed, "label") <- "Did you receive IV medication in the first few minutes after delivery"
attr(woman_el$cord, "label") <- "Did you receive cord traction"
attr(woman_el$massage, "label") <- "Was your abdomen massaged to help your womb contract"
attr(woman_el$turned, "label") <- "Was the baby held upside down"
attr(woman_el$mistreat1, "label") <- "Did anyone physically mistreat you during delivery"
attr(woman_el$mistreat2, "label") <- "Did anyone verbally mistreat you during delivery"
attr(woman_el$satisf, "label") <- "Satisfaction with care"
attr(woman_el$pay1, "label") <- "Did you make any payment for your delivery"
attr(woman_el$cost1, "label") <- "How much"
attr(woman_el$pay2, "label") <- "Did you pay any money for registration/card"
attr(woman_el$cost2, "label") <- "How much"
attr(woman_el$pay3, "label") <- "Did you pay any money for lab tests"
attr(woman_el$cost3, "label") <- "How much"
attr(woman_el$pay4, "label") <- "Did you pay any money for transportation"
attr(woman_el$cost4, "label") <- "How much total (to and fro) include the cost for any companions"
attr(woman_el$pay5, "label") <- "Did you make any other payments for this delivery"
attr(woman_el$cost5, "label") <- "How much did you pay"
attr(woman_el$pay6, "label") <- "Did you make any other payments for this delivery"
attr(woman_el$cost6, "label") <- "How much did you pay"
attr(woman_el$pnc, "label") <- "Postnatal checkup"
attr(woman_el$pncwhen, "label") <- "How many days after delivery"
attr(woman_el$pncplace, "label") <- "Where did this check take place"
attr(woman_el$pncprov, "label") <- "Who did the checkup"
attr(woman_el$pncprov_oth, "label") <- "Other provider"
attr(woman_el$pncwhat, "label") <- "What was done by the health worker during the health check"
attr(woman_el$pnc2, "label") <- "Did you receive another postnatal check"
attr(woman_el$pncwhen2, "label") <- "How many days after delivery"
attr(woman_el$pncvisits, "label") <- "Total number of postnatal checks"
attr(woman_el$vitamin, "label") <- "Since birth, have you received a Vitamin A dose"
attr(woman_el$postpart1, "label") <- "Did you experience convulsions in the first 6 weeks after delivery"
attr(woman_el$postpart2, "label") <- "Did you experience high fever in the first 6 weeks after delivery"
attr(woman_el$postpart3, "label") <- "Did you experience headache in the first 6 weeks after delivery"
attr(woman_el$postpart4, "label") <- "Did you experience bleeding in the first 6 weeks after delivery"
attr(woman_el$postpart5, "label") <- "Did you experience discharge in the first 6 weeks after delivery"
attr(woman_el$postpart6, "label") <- "Did you experience loss of consciousness in the first 6 weeks after delivery"
attr(woman_el$postpart7, "label") <- "Did you experience lower abdominal pain in the first 6 weeks after delivery"
attr(woman_el$postpart_oth, "label") <- "Did you experience any other problems"
attr(woman_el$posttreat, "label") <- "Did you go to a health facility for assistance"
attr(woman_el$postwhere, "label") <- "Where did you receive care"
attr(woman_el$night, "label") <- "Did you stay overnight in the health facility"
attr(woman_el$los, "label") <- "How many nights in total"
attr(woman_el$multip, "label") <- "Single or multiple birth"
attr(woman_el$multipnum, "label") <- "How many babies"
attr(woman_el$alive, "label") <- "Was the baby born alive"
attr(woman_el$sex, "label") <- "Sex of baby"
attr(woman_el$size, "label") <- "Size of baby when born"
attr(woman_el$weighed, "label") <- "Was the baby weighed at birth"
attr(woman_el$birthwt, "label") <- "Recorded birthweight"
attr(woman_el$status, "label") <- "Is the baby still alive"
attr(woman_el$diedwhen, "label") <- "Did baby die in first month"
attr(woman_el$diedage, "label") <- "Age at death"
attr(woman_el$diarrhea, "label") <- "Has baby had diarrhea within last two weeks"
attr(woman_el$diarrhea1, "label") <- "Was there any blood in the stool"
attr(woman_el$diarrhea2, "label") <- "How much was the baby given to drink during the diarrhea"
attr(woman_el$diarrhea3, "label") <- "Amount of food baby ate when he/she had diarrhea"
attr(woman_el$diarrtreat, "label") <- "Did you seek advice or treatment for the diarrhea"
attr(woman_el$diarrwhere, "label") <- "Where did you seek advice or treatment"
attr(woman_el$treators, "label") <- "For diarrhea did you give ORS or pedialyte"
attr(woman_el$treatsalt, "label") <- "For diarrhea did you give salt-sugar solution"
attr(woman_el$treatother, "label") <- "For diarrhea did you give anything else"
attr(woman_el$treatelse, "label") <- "What (else) was given to treat the diarrhea"
attr(woman_el$fever, "label") <- "Has baby had fever within last two weeks"
attr(woman_el$fevertreat, "label") <- "Did you seek advice or treatment for the fever"
attr(woman_el$feverwhere, "label") <- "Where did you seek advice or treatment"
attr(woman_el$cough, "label") <- "Has baby had cough within last two weeks"
attr(woman_el$cough1, "label") <- "Did they breathe faster than usual or have difficulty breathing"
attr(woman_el$cough2, "label") <- "Was this due to a problem in the chest or to a blocked or runny nose"
attr(woman_el$coughtreat, "label") <- "Did you seek advice or treatment for the cough"
attr(woman_el$coughwhere, "label") <- "Where did you seek advice or treatment"
attr(woman_el$vacrecord, "label") <- "Is there a vaccination card"
attr(woman_el$bcg, "label") <- "Did the child receive BCG vaccination"
attr(woman_el$opv, "label") <- "Did the child receive polio vaccine"
attr(woman_el$hep, "label") <- "Did the child receive Hepatitis B vaccine"
attr(woman_el$weight, "label") <- "Babys weight in kilograms"
attr(woman_el$length, "label") <- "Babys length in centimeters"
attr(woman_el$card, "label") <- "Is the womans health card available"
attr(woman_el$cardrec1, "label") <- "Are any antenatal visits recorded on the card"
attr(woman_el$carddoc1, "label") <- "Health card: saw doctor during pregnancy"
attr(woman_el$cardrec2, "label") <- "Is a facility delivery recorded on the card"
attr(woman_el$carddoc2, "label") <- "Health card: doctor present at birth"
attr(woman_el$cardrec3, "label") <- "Are any postnatal visits recorded on the card"
attr(woman_el$clinictreat, "label") <- "Clinic treatment"

# Define and apply all value labels as factors for woman_el dataset
woman_el <- woman_el %>%
  mutate(
    # yesno label
    wanted = factor(wanted, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anc = factor(anc, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare1 = factor(anccare1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare2 = factor(anccare2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare3 = factor(anccare3, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare4 = factor(anccare4, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare5 = factor(anccare5, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare6 = factor(anccare6, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare7 = factor(anccare7, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare8 = factor(anccare8, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare9 = factor(anccare9, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    anccare10 = factor(anccare10, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    tetanus = factor(tetanus, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    iron = factor(iron, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    malaria = factor(malaria, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob1 = factor(pregprob1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob2 = factor(pregprob2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob3 = factor(pregprob3, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob4 = factor(pregprob4, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob5 = factor(pregprob5, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob6 = factor(pregprob6, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob7 = factor(pregprob7, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob8 = factor(pregprob8, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob9 = factor(pregprob9, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob10 = factor(pregprob10, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob11 = factor(pregprob11, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob12 = factor(pregprob12, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob13 = factor(pregprob13, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregprob_oth = factor(pregprob_oth, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pregtreat = factor(pregtreat, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob1 = factor(delprob1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob2 = factor(delprob2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob3 = factor(delprob3, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob4 = factor(delprob4, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob5 = factor(delprob5, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob6 = factor(delprob6, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob7 = factor(delprob7, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    delprob_oth = factor(delprob_oth, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    referral = factor(referral, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cesarean = factor(cesarean, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    augment = factor(augment, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    painmed = factor(painmed, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    episio = factor(episio, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    push = factor(push, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    injmed = factor(injmed, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    tabmed = factor(tabmed, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    ivmed = factor(ivmed, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cord = factor(cord, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    massage = factor(massage, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    turned = factor(turned, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pay1 = factor(pay1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pay2 = factor(pay2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pay3 = factor(pay3, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pay4 = factor(pay4, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pay5 = factor(pay5, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pay6 = factor(pay6, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pnc = factor(pnc, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    pnc2 = factor(pnc2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    vitamin = factor(vitamin, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart1 = factor(postpart1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart2 = factor(postpart2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart3 = factor(postpart3, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart4 = factor(postpart4, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart5 = factor(postpart5, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart6 = factor(postpart6, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart7 = factor(postpart7, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    postpart_oth = factor(postpart_oth, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    posttreat = factor(posttreat, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    night = factor(night, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    card = factor(card, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cardrec1 = factor(cardrec1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cardrec2 = factor(cardrec2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cardrec3 = factor(cardrec3, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    alive = factor(alive, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    weighed = factor(weighed, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    status = factor(status, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    diarrhea = factor(diarrhea, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    diarrhea1 = factor(diarrhea1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    diarrtreat = factor(diarrtreat, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    treators = factor(treators, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    treatsalt = factor(treatsalt, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    treatother = factor(treatother, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    fever = factor(fever, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    fevertreat = factor(fevertreat, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cough = factor(cough, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    cough1 = factor(cough1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    coughtreat = factor(coughtreat, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    vacrecord = factor(vacrecord, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    bcg = factor(bcg, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    opv = factor(opv, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    hep = factor(hep, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    followup = factor(followup, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    dead = factor(dead, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    consent = factor(consent, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    carddoc1 = factor(carddoc1, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    carddoc2 = factor(carddoc2, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    diedwhen = factor(diedwhen, levels = c(0, 1, 2), labels = c("No", "Yes", "No")),
    
    # reason label
    reason1 = factor(reason1, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 
                     labels = c("Close to home", "Affordable", "Good reputation", 
                                "Only facility available", "Female provider", 
                                "Believe care is high quality", "Recommendation/referral", 
                                "Previous good experience", "In order to receive cash incentive", 
                                "Other")),
    reason2 = factor(reason2, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10), 
                     labels = c("Close to home", "Affordable", "Good reputation", 
                                "Only facility available", "Female provider", 
                                "Believe care is high quality", "Recommendation/referral", 
                                "Previous good experience", "In order to receive cash incentive", 
                                "Other")),
    
    # treat label
    refwhere = factor(refwhere, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), 
                      labels = c("Tertiary/Teaching hospital", "Government hospital", 
                                 "Health center", "Other government health centre", 
                                 "Government health post", "Other government facility", 
                                 "Private hospital/clinic", "Maternity home", 
                                 "Other private medical sector", "Pharmacy/Chemist", 
                                 "Traditional birth attendant", "Other")),
    
    # outcome label
    outcome = factor(outcome, levels = c(1, 2, 3, 4), 
                     labels = c("Ended in a birth", "Miscarriage", "Abortion", 
                                "Woman died while Pregnant")),
    
    # birthplace label
    delplace = factor(delplace, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13), 
                      labels = c("Her home", "Other home", "Tertiary/Teaching hospital", 
                                 "Government hospital", "Health center", "Other health centre", 
                                 "Health post/dispensary", "Other government facility", 
                                 "Private hospital/clinic", "Maternity home", 
                                 "Other private medical sector", "Church/spiritual house", 
                                 "On the way to hospital")),
    
    # birthtime label
    early = factor(early, levels = c(1, 2, 3), 
                   labels = c("Early", "At expected time", "Late")),
    
    # labor label
    laborpain = factor(laborpain, levels = c(1, 2, 3), 
                       labels = c("Spontaneous labor", "Someone did something", "Other")),
    
    # babypart label
    babypart = factor(babypart, levels = c(1, 2, 3, 4, 99), 
                      labels = c("Head", "Buttocks", "Hand/foot", "Cord", "Dont know/remember")),
    
    # operation label
    cs_why = factor(cs_why, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), 
                    labels = c("The doctor/nurse told me I had to", "I was bleeding", 
                               "The baby was stuck", "I was in labour pain for a long time", 
                               "The baby was not in the right position", "I had a disease", 
                               "My womb was broken/ruptured", "There were problems with the baby", 
                               "There was no medical reason", "I asked for it", 
                               "Dont know/remember")),
    
    # babypull label
    assist = factor(assist, levels = c(1, 2, 3), 
                    labels = c("Forceps", "Suction", "Delivery was unassisted")),
    
    # pmistreat label
    mistreat1 = factor(mistreat1, levels = c(1, 2, 3, 4), 
                       labels = c("Yes, hit or slapped", "Yes, physically threatened", 
                                  "Yes, Other", "No physical mistreatment")),
    
    # vmistreat label
    mistreat2 = factor(mistreat2, levels = c(1, 2, 3, 4), 
                       labels = c("Yes, verbally threatened", "Yes, shouted at", 
                                  "Yes, Other", "No verbal mistreatment")),
    
    # satisfy label
    satisf = factor(satisf, levels = c(1, 2, 3, 4, 5), 
                    labels = c("Very unsatisfied", "Somewhat unsatisfied", 
                               "Neither satisfied or unsatisfied", "Somewhat satisfied", 
                               "Very satisfied")),
    
    # sex label
    sex = factor(sex, levels = c(1, 2, 3), 
                 labels = c("Boy", "Girl", "Dont Know")),
    
    # multip label
    multip = factor(multip, levels = c(1, 2), 
                    labels = c("Single", "Multiple")),
    
    # died label
    diedage = factor(diedage, levels = c(1, 2), 
                     labels = c("0-6 days", "7-30 days")),
    
    # babysize label
    size = factor(size, levels = c(1, 2, 3, 4, 5, 99), 
                  labels = c("Very large", "Larger than average", "Average", 
                             "Smaller than average", "Very small", "Dont know/remember")),
    
    # chestnose label
    cough2 = factor(cough2, levels = c(1, 2, 3), 
                    labels = c("Chest", "Nose", "Dont know")),
    
    # treatment label
    clinictreat = factor(clinictreat, levels = c(0, 1, 2), 
                         labels = c("Control", "MLP", "Doctor")),
    
    # drink label (if present in the data)
    diarrhea2 = factor(diarrhea2, levels = c(1, 2, 3, 4, 5), 
                       labels = c("Much less", "Somewhat less", "About the same", 
                                  "More", "Nothing to drink")),
    
    # eat label (if present in the data)
    diarrhea3 = factor(diarrhea3, levels = c(1, 2, 3, 4, 5), 
                       labels = c("None", "Much less", "Somewhat less", 
                                  "About the same", "More"))
  )

# Format variables
woman_el <- woman_el %>%
  mutate(
    state = toupper(state),
    state = str_replace_all(state, "_", " "),
    intmth = as.Date(paste0(intmth, "-01"), format = "%Y-%m-%d")
  )
# Create dummy variables for provider types
serv <- "anc"
servprov <- "ancprov"

# Create or update binary indicators for each provider type (1-8)
for (i in 1:8) {
  var_name <- paste0(servprov, i)
  
  # Initialize with default value (1 = No)
  woman_el[[var_name]] <- 1
  
  # Find rows with valid data
  valid_rows <- which(!is.na(woman_el[[servprov]]) & woman_el[[servprov]] != "")
  
  # Process each valid row
  for (row in valid_rows) {
    # Split the provider string and check if i is in it
    codes <- strsplit(as.character(woman_el[[servprov]][row]), "\\s+")[[1]]
    if (as.character(i) %in% codes) {
      woman_el[[var_name]][row] <- 2  # Yes
    }
  }
}

# Handle special cases from other field
# NURSE should be coded as auxiliary midwife (3)
nurse_rows <- which(!is.na(woman_el[[paste0(servprov, "_oth")]]) & 
                      woman_el[[paste0(servprov, "_oth")]] == "NURSE")
if (length(nurse_rows) > 0) {
  woman_el[[paste0(servprov, "3")]][nurse_rows] <- 2  # Yes
  woman_el[[paste0(servprov, "8")]][nurse_rows] <- 1  # No
}

# CHEW should be coded as community health worker (5)
chew_rows <- which(!is.na(woman_el[[paste0(servprov, "_oth")]]) & 
                     woman_el[[paste0(servprov, "_oth")]] == "CHEW")
if (length(chew_rows) > 0) {
  woman_el[[paste0(servprov, "5")]][chew_rows] <- 2  # Yes
  woman_el[[paste0(servprov, "8")]][chew_rows] <- 1  # No
}

# Reorder columns to place new variables after the original
col_idx <- which(names(woman_el) == servprov)
new_order <- c(
  names(woman_el)[1:col_idx],
  paste0(servprov, 1:8),
  setdiff(names(woman_el)[(col_idx+1):ncol(woman_el)], paste0(servprov, 1:8))
)
woman_el <- woman_el[, new_order]

# Add variable labels
var_labels <- c(
  "Saw doctor",
  "Saw nurse or midwife",
  "Saw auxiliary midwife",
  "Saw community health officer",
  "Saw community health worker",
  "Saw TBA",
  "Saw village health worker",
  "Saw other person"
)

for (i in 1:8) {
  attr(woman_el[[paste0(servprov, i)]], "label") <- var_labels[i]
}

# Clear the original variable
woman_el[[servprov]] <- ""

# ANC place of service
v <- "ancplace"

# Split the string variable into numeric components
woman_el <- woman_el %>%
  mutate(
    x_split = strsplit(as.character(get(v)), " ")
  )

# Create temporary x variables
for (i in 1:max(lengths(woman_el$x_split))) {
  woman_el[[paste0("x", i)]] <- sapply(woman_el$x_split, function(x) {
    if (length(x) >= i) as.numeric(x[i]) else NA
  })
}

# Remove the temporary split variable
woman_el$x_split <- NULL

# Create binary indicators for each place type
for (i in 1:13) {
  # Initialize with 0 where consent is 1
  woman_el[[paste0(v, i)]] <- ifelse(woman_el$consent == 2, 0, NA)
  
  # Set to 1 if any x variable equals i
  for (j in 1:length(grep("^x\\d+$", names(woman_el)))) {
    x_var <- paste0("x", j)
    if (x_var %in% names(woman_el)) {
      woman_el[[paste0(v, i)]] <- ifelse(woman_el[[x_var]] == i, 1, woman_el[[paste0(v, i)]])
    }
  }
  
  # Apply yesno labels as factors
  woman_el[[paste0(v, i)]] <- factor(woman_el[[paste0(v, i)]], levels = c(0, 1, 2), labels = c("No", "Yes", "No"))
}

# Reorder columns
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == v)], 
         paste0(v, 1:13), 
         everything())

# Clear the original variable
woman_el[[v]] <- ""

# Drop temporary x variables
woman_el <- woman_el %>%
  select(-matches("^x\\d+$"))

# Recode specific place types from "other" category
# GOVT HOSPITAL should be coded as Government hospital
woman_el[[paste0(v, 4)]] <- ifelse(
  woman_el[[paste0(v, "_oth")]] == "GOVT HOSPITAL", 
  "Yes", 
  as.character(woman_el[[paste0(v, 4)]])
)
woman_el[[paste0(v, 13)]] <- ifelse(
  woman_el[[paste0(v, "_oth")]] == "GOVT HOSPITAL", 
  "No", 
  as.character(woman_el[[paste0(v, 13)]])
)

# OTHER PHC should be coded as Other health center
woman_el[[paste0(v, 6)]] <- ifelse(
  woman_el[[paste0(v, "_oth")]] == "OTHER PHC", 
  "Yes", 
  as.character(woman_el[[paste0(v, 6)]])
)
woman_el[[paste0(v, 13)]] <- ifelse(
  woman_el[[paste0(v, "_oth")]] == "OTHER PHC", 
  "No", 
  as.character(woman_el[[paste0(v, 13)]])
)

# HEALTH POST should be coded as Health post/dispensary
woman_el[[paste0(v, 7)]] <- ifelse(
  woman_el[[paste0(v, "_oth")]] == "HEALTH POST", 
  "Yes", 
  as.character(woman_el[[paste0(v, 7)]])
)
woman_el[[paste0(v, 13)]] <- ifelse(
  woman_el[[paste0(v, "_oth")]] == "HEALTH POST", 
  "No", 
  as.character(woman_el[[paste0(v, 13)]])
)

# For variables that are already factors
for (i in 1:13) {
  var_name <- paste0(v, i)
  if (var_name %in% names(woman_el) && is.factor(woman_el[[var_name]])) {
    # Get the current levels
    current_levels <- levels(woman_el[[var_name]])
    
    # If there are more than 2 levels, we need to consolidate
    if (length(current_levels) > 2) {
      # Create a mapping of old levels to new levels
      # This is just an example - adjust based on your actual data
      level_map <- rep("No", length(current_levels))
      level_map[current_levels == "Yes"] <- "Yes"
      
      # Apply the mapping
      levels(woman_el[[var_name]]) <- level_map[match(levels(woman_el[[var_name]]), current_levels)]
    }
  }
}

# Add variable labels
attr(woman_el[[paste0(v, 1)]], "label") <- "At home"
attr(woman_el[[paste0(v, 2)]], "label") <- "Other home"
attr(woman_el[[paste0(v, 3)]], "label") <- "Teaching hospital"
attr(woman_el[[paste0(v, 4)]], "label") <- "Government hospital"
attr(woman_el[[paste0(v, 5)]], "label") <- "Health center"
attr(woman_el[[paste0(v, 6)]], "label") <- "Other health center"
attr(woman_el[[paste0(v, 7)]], "label") <- "Health post/dispensary"
attr(woman_el[[paste0(v, 8)]], "label") <- "Other government facility"
attr(woman_el[[paste0(v, 9)]], "label") <- "Private hospital/clinic"
attr(woman_el[[paste0(v, 10)]], "label") <- "Maternity home"
attr(woman_el[[paste0(v, 11)]], "label") <- "Other private sector"
attr(woman_el[[paste0(v, 12)]], "label") <- "Church/spiritual house"
attr(woman_el[[paste0(v, 13)]], "label") <- "Other location"

# Define provider labels
var_labels <- c(
  "Doctor",
  "Nurse or midwife",
  "Auxiliary midwife",
  "Community health officer",
  "Community health worker",
  "Traditional Birth Attendant",
  "Relative",
  "Other person",
  "No one"
)
# Define the variables
serv <- "del"
servprov <- "delprov"




# Create binary indicators for each provider type (1-9)
for (i in 1:9) {
  var_name <- paste0(servprov, i)
  
  # Initialize with default value (1 = No)
  woman_el[[var_name]] <- 1
  
  # Find rows with valid data
  valid_rows <- which(!is.na(woman_el[[servprov]]) & woman_el[[servprov]] != "")
  
  # Process each valid row
  for (row in valid_rows) {
    # Split the provider string and check if i is in it
    # Extract the first element of the list returned by strsplit
    codes <- strsplit(as.character(woman_el[[servprov]][row]), "\\s+")[[1]]
    if (as.character(i) %in% codes) {
      woman_el[[var_name]][row] <- 2  # Yes
    }
  }
}

# Handle special cases from other field
# For NURSE or MIDWIFE
nurse_midwife_rows <- which(!is.na(woman_el[[paste0(servprov, "_oth")]]) & 
                              grepl("NURSE|MIDWIFE", woman_el[[paste0(servprov, "_oth")]]))
if (length(nurse_midwife_rows) > 0) {
  woman_el[[paste0(servprov, 2)]][nurse_midwife_rows] <- 2  # Yes
  woman_el[[paste0(servprov, 9)]][nurse_midwife_rows] <- 1  # No
}

# For CHEW
chew_rows <- which(!is.na(woman_el[[paste0(servprov, "_oth")]]) & 
                     woman_el[[paste0(servprov, "_oth")]] == "CHEW")
if (length(chew_rows) > 0) {
  woman_el[[paste0(servprov, 5)]][chew_rows] <- 2  # Yes
  woman_el[[paste0(servprov, 9)]][chew_rows] <- 1  # No
}

# For NEIGHBOUR, MOTHER, RELATIVE
relative_rows <- which(!is.na(woman_el[[paste0(servprov, "_oth")]]) & 
                         grepl("NEIGHBOUR|MOTHER|RELATIVE", woman_el[[paste0(servprov, "_oth")]]))
if (length(relative_rows) > 0) {
  woman_el[[paste0(servprov, 7)]][relative_rows] <- 2  # Yes
  woman_el[[paste0(servprov, 9)]][relative_rows] <- 1  # No
}

# Reorder columns to place new variables after the original
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == servprov)], 
         paste0(servprov, 1:9), 
         everything())

# Clear the original variable
woman_el[[servprov]] <- ""

# Add variable labels
var_labels <- c(
  "Doctor",
  "Nurse or midwife",
  "Auxiliary midwife",
  "Community health officer",
  "Community health worker",
  "Traditional Birth Attendant",
  "Relative",
  "No one",
  "Other person"
)

for (i in 1:9) {
  var_name <- paste0(servprov, i)
  attr(woman_el[[var_name]], "label") <- var_labels[i]
}

# Print summary of results
cat("\nSummary of results:\n")
for (i in 1:9) {
  var_name <- paste0(servprov, i)
  cat(var_name, ":", table(woman_el[[var_name]]), "\n")
}
# Add variable labels
attr(woman_el[[paste0(servprov, 1)]], "label") <- "Doctor"
attr(woman_el[[paste0(servprov, 2)]], "label") <- "Nurse or midwife"
attr(woman_el[[paste0(servprov, 3)]], "label") <- "Auxiliary midwife"
attr(woman_el[[paste0(servprov, 4)]], "label") <- "Community health officer"
attr(woman_el[[paste0(servprov, 5)]], "label") <- "Community health worker"
attr(woman_el[[paste0(servprov, 6)]], "label") <- "Traditional Birth Attendant"
attr(woman_el[[paste0(servprov, 7)]], "label") <- "Relative"
attr(woman_el[[paste0(servprov, 8)]], "label") <- "No one"
attr(woman_el[[paste0(servprov, 9)]], "label") <- "Other person"

# Treatment location
treatment_vars <- c("treatwhere", "postwhere", "diarrwhere", "feverwhere", "coughwhere")

# Process each treatment location variable
for (v in treatment_vars) {
  # Split the string variable into numeric components
  woman_el <- woman_el %>%
    mutate(
      x_split = strsplit(as.character(get(v)), " ")
    )
  
  # Create temporary x variables
  for (i in 1:max(lengths(woman_el$x_split), na.rm = TRUE)) {
    woman_el[[paste0("x", i)]] <- sapply(woman_el$x_split, function(x) {
      if (length(x) >= i && x[i] != "") as.numeric(x[i]) else NA
    })
  }
  
  # Remove the temporary split variable
  woman_el$x_split <- NULL
  
  # Create binary indicators for each location type
  for (i in 1:12) {
    # Initialize with 0 where consent is 1
    woman_el[[paste0(v, i)]] <- ifelse(woman_el$consent == 2, 0, NA)
    
    # Set to 1 if any x variable equals i
    for (j in 1:length(grep("^x\\d+$", names(woman_el)))) {
      x_var <- paste0("x", j)
      if (x_var %in% names(woman_el)) {
        woman_el[[paste0(v, i)]] <- ifelse(!is.na(woman_el[[x_var]]) & woman_el[[x_var]] == i, 
                                           1, 
                                           woman_el[[paste0(v, i)]])
      }
    }
    
    # Apply yes_no labels as factors
    woman_el[[paste0(v, i)]] <- factor(woman_el[[paste0(v, i)]], 
                                       levels = c(0, 1), 
                                       labels = c("No", "Yes"))
  }
  
  # Reorder columns
  woman_el <- woman_el %>%
    select(names(woman_el)[1:which(names(woman_el) == v)], 
           paste0(v, 1:12), 
           everything())
  
  # Clear the original variable
  woman_el[[v]] <- ""
  
  # Drop temporary x variables
  woman_el <- woman_el %>%
    select(-matches("^x\\d+$"))
}

# Set missing values based on treatment variables
for (i in 1:12) {
  # For treatwhere, set to NA if pregtreat is NA
  woman_el[[paste0("treatwhere", i)]] <- ifelse(
    is.na(woman_el$pregtreat),
    NA,
    woman_el[[paste0("treatwhere", i)]]
  )
  
  # For other treatment locations
  for (v in c("post", "diarr", "fever", "cough")) {
    woman_el[[paste0(v, "where", i)]] <- ifelse(
      is.na(woman_el[[paste0(v, "treat")]]),
      NA,
      woman_el[[paste0(v, "where", i)]]
    )
  }
}

# Add labels for postwhere
var <- "postwhere"
attr(woman_el[[paste0(var, 1)]], "label") <- "Teaching hospital"
attr(woman_el[[paste0(var, 2)]], "label") <- "Government hospital"
attr(woman_el[[paste0(var, 3)]], "label") <- "Health center"
attr(woman_el[[paste0(var, 4)]], "label") <- "Other health center"
attr(woman_el[[paste0(var, 5)]], "label") <- "Health post/dispensary"
attr(woman_el[[paste0(var, 6)]], "label") <- "Other government facility"
attr(woman_el[[paste0(var, 7)]], "label") <- "Private hospital/clinic"
attr(woman_el[[paste0(var, 8)]], "label") <- "Maternity home"
attr(woman_el[[paste0(var, 9)]], "label") <- "Other private sector"
attr(woman_el[[paste0(var, 10)]], "label") <- "Other location"

# Drop postwhere11 and postwhere12
woman_el <- woman_el %>%
  select(-postwhere11, -postwhere12)

# Add labels for other treatment locations
for (var in c("treatwhere", "diarrwhere", "feverwhere", "coughwhere")) {
  attr(woman_el[[paste0(var, 1)]], "label") <- "Teaching hospital"
  attr(woman_el[[paste0(var, 2)]], "label") <- "Government hospital"
  attr(woman_el[[paste0(var, 3)]], "label") <- "Health center"
  attr(woman_el[[paste0(var, 4)]], "label") <- "Other health center"
  attr(woman_el[[paste0(var, 5)]], "label") <- "Health post/dispensary"
  attr(woman_el[[paste0(var, 6)]], "label") <- "Other government facility"
  attr(woman_el[[paste0(var, 7)]], "label") <- "Private hospital/clinic"
  attr(woman_el[[paste0(var, 8)]], "label") <- "Maternity home"
  attr(woman_el[[paste0(var, 9)]], "label") <- "Other private sector"
  attr(woman_el[[paste0(var, 10)]], "label") <- "Pharmacy/Chemist"
  attr(woman_el[[paste0(var, 11)]], "label") <- "Traditional Birth Attendant"
  attr(woman_el[[paste0(var, 12)]], "label") <- "Other location"
}

# Delivery augmentation
var1 <- "augment"
var2 <- "augwhat"

# Create binary indicators for each augmentation type
for (i in 1:3) {
  woman_el[[paste0(var2, i)]] <- ifelse(
    !is.na(woman_el[[var1]]), 
    0, 
    NA
  )
  
  # Set to 1 if the digit appears in augwhat
  woman_el[[paste0(var2, i)]] <- ifelse(
    grepl(i, woman_el[[var2]], fixed = TRUE), 
    1, 
    woman_el[[paste0(var2, i)]]
  )
  
  # Apply yesno labels as factors
  woman_el[[paste0(var2, i)]] <- factor(
    woman_el[[paste0(var2, i)]], 
    levels = c(0, 1, 2), 
    labels = c("No", "Yes", "No")
  )
}

# Reorder columns
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == var2)], 
         paste0(var2, 1:3), 
         everything())

# Clear the original variable
woman_el[[var2]] <- ""

# Add variable labels
attr(woman_el[[paste0(var2, 1)]], "label") <- "Received injection during labour"
attr(woman_el[[paste0(var2, 2)]], "label") <- "Given medication in drip (IV line)"
attr(woman_el[[paste0(var2, 3)]], "label") <- "Other"

# PNC location
v <- "pncplace"

# Get the original variable label
pncplace_label <- attr(woman_el[[v]], "label")

# Rename the original variable to _old
woman_el[[paste0(v, "_old")]] <- woman_el[[v]]

# Recode the variable
woman_el[[v]] <- NA
woman_el[[v]] <- case_when(
  woman_el[[paste0(v, "_old")]] %in% 1:2 ~ 1,  # Home
  woman_el[[paste0(v, "_old")]] %in% 3:4 ~ 2,  # Govt Hospital
  woman_el[[paste0(v, "_old")]] == 5 ~ 3,      # Health center
  woman_el[[paste0(v, "_old")]] %in% 6:8 ~ 4,  # Other govt facility
  woman_el[[paste0(v, "_old")]] == 9 ~ 5,      # Private hospital/clinic
  woman_el[[paste0(v, "_old")]] %in% 10:12 ~ 6 # Other
)

# Apply labels to the recoded variable
woman_el[[v]] <- factor(
  woman_el[[v]], 
  levels = 1:6,
  labels = c("Home", "Govt Hospital", "Health center", 
             "Other govt facility", "Private hospital/clinic", "Other")
)

# Reorder columns
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == paste0(v, "_old"))], 
         v, 
         everything())

# Add the original variable label
attr(woman_el[[v]], "label") <- pncplace_label

# Create dummy variables for each category
for (i in 1:6) {
  woman_el[[paste0(v, i)]] <- ifelse(as.numeric(woman_el[[v]]) == i, 1, 0)
  
  # Apply yesno labels as factors
  woman_el[[paste0(v, i)]] <- factor(
    woman_el[[paste0(v, i)]], 
    levels = c(0, 1, 2), 
    labels = c("No", "Yes", "No")
  )
}

# Reorder columns to place dummy variables after the recoded variable
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == v)], 
         paste0(v, 1:6), 
         everything())

# Drop the _old variable
woman_el <- woman_el %>%
  select(-paste0(v, "_old"))

# Set the recoded variable to missing
woman_el[[v]] <- NA

# Add variable labels for the dummy variables
attr(woman_el[[paste0(v, 1)]], "label") <- "At home"
attr(woman_el[[paste0(v, 2)]], "label") <- "Government hospital"
attr(woman_el[[paste0(v, 3)]], "label") <- "Health center"
attr(woman_el[[paste0(v, 4)]], "label") <- "Other government facility"
attr(woman_el[[paste0(v, 5)]], "label") <- "Private hospital/clinic"
attr(woman_el[[paste0(v, 6)]], "label") <- "Other location"

# Code PNC provider
v <- "pncprov"

# Create binary indicators for each provider type
for (i in 1:9) {
  # Initialize with 0 where consent is 1
  woman_el[[paste0(v, i)]] <- ifelse(woman_el$consent == 1, 0, NA)
  
  # Set to 1 if the digit appears in pncprov
  woman_el[[paste0(v, i)]] <- ifelse(
    grepl(i, woman_el[[v]], fixed = TRUE), 
    1, 
    woman_el[[paste0(v, i)]]
  )
  
  # Apply yesno labels as factors
  woman_el[[paste0(v, i)]] <- factor(
    woman_el[[paste0(v, i)]], 
    levels = c(0, 1, 2), 
    labels = c("No", "Yes", "No")
  )
}

# Reorder columns
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == v)], 
         paste0(v, 1:9), 
         everything())

# Add variable labels
attr(woman_el[[paste0(v, 1)]], "label") <- "Doctor"
attr(woman_el[[paste0(v, 2)]], "label") <- "Nurse/midwife"
attr(woman_el[[paste0(v, 3)]], "label") <- "Auxiliary midwife"
attr(woman_el[[paste0(v, 4)]], "label") <- "Community health officer"
attr(woman_el[[paste0(v, 5)]], "label") <- "Health extension worker"
attr(woman_el[[paste0(v, 6)]], "label") <- "Traditional birth attendant"
attr(woman_el[[paste0(v, 7)]], "label") <- "Relative/friend"
attr(woman_el[[paste0(v, 8)]], "label") <- "No one"
attr(woman_el[[paste0(v, 9)]], "label") <- "Other person"

# Recode specific provider types from "other" category
# DOCTOR should be coded as doctor
woman_el[[paste0(v, 1)]] <- ifelse(
  grepl("DOCTOR", woman_el[[paste0(v, "_oth")]]), 
  "Yes", 
  as.character(woman_el[[paste0(v, 1)]])
)
woman_el[[paste0(v, 9)]] <- ifelse(
  grepl("DOCTOR", woman_el[[paste0(v, "_oth")]]), 
  "No", 
  as.character(woman_el[[paste0(v, 9)]])
)

# CHEW should be coded as health extension worker
woman_el[[paste0(v, 5)]] <- ifelse(
  grepl("CHEW", woman_el[[paste0(v, "_oth")]]), 
  "Yes", 
  as.character(woman_el[[paste0(v, 5)]])
)
woman_el[[paste0(v, 9)]] <- ifelse(
  grepl("CHEW", woman_el[[paste0(v, "_oth")]]), 
  "No", 
  as.character(woman_el[[paste0(v, 9)]])
)

# First, recode the values so that both 0 and 2 become 0
for (i in 1:9) {
  var_name <- paste0(v, i)
  if (var_name %in% names(woman_el)) {
    # Convert to numeric if it's a factor or character
    if (is.factor(woman_el[[var_name]])) {
      woman_el[[var_name]] <- as.numeric(as.character(woman_el[[var_name]]))
    } else if (is.character(woman_el[[var_name]])) {
      woman_el[[var_name]] <- as.numeric(woman_el[[var_name]])
    }
    
    # Now recode: if value is 2, change it to 0
    woman_el[[var_name]][woman_el[[var_name]] == 2] <- 0
    
    # Then create the factor with unique levels
    woman_el[[var_name]] <- factor(
      woman_el[[var_name]], 
      levels = c(0, 1),
      labels = c("No", "Yes")
    )
  }
}

# Clear the original variable
woman_el[[v]] <- ""

# What was done by the PNC provider
v <- "pncwhat"

# Split the string variable into numeric components
woman_el <- woman_el %>%
  mutate(
    x_split = strsplit(as.character(get(v)), " ")
  )

# Create temporary x variables
for (i in 1:max(lengths(woman_el$x_split), na.rm = TRUE)) {
  woman_el[[paste0("x", i)]] <- sapply(woman_el$x_split, function(x) {
    if (length(x) >= i && x[i] != "") as.numeric(x[i]) else NA
  })
}

# Remove the temporary split variable
woman_el$x_split <- NULL

# Create binary indicators for each action type
for (i in 1:10) {
  # Initialize with 0 where pnc is 1
  woman_el[[paste0(v, i)]] <- ifelse(woman_el$pnc == 1, 0, NA)
  
  # Set to 1 if any x variable equals i
  for (j in 1:length(grep("^x\\d+$", names(woman_el)))) {
    x_var <- paste0("x", j)
    if (x_var %in% names(woman_el)) {
      woman_el[[paste0(v, i)]] <- ifelse(!is.na(woman_el[[x_var]]) & woman_el[[x_var]] == i, 
                                         1, 
                                         woman_el[[paste0(v, i)]])
    }
  }
  
  # Apply yesno labels as factors
  woman_el[[paste0(v, i)]] <- factor(
    woman_el[[paste0(v, i)]], 
    levels = c(0, 1, 2), 
    labels = c("No", "Yes", "No")
  )
}

# Reorder columns
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == v)], 
         paste0(v, 1:10), 
         everything())

# Clear the original variable
woman_el[[v]] <- ""

# Drop temporary x variables
woman_el <- woman_el %>%
  select(-matches("^x\\d+$"))

# Add variable labels
attr(woman_el[[paste0(v, 1)]], "label") <- "Examined abdomen"
attr(woman_el[[paste0(v, 2)]], "label") <- "Checked breasts"
attr(woman_el[[paste0(v, 3)]], "label") <- "Checked for bleeding"
attr(woman_el[[paste0(v, 4)]], "label") <- "Examined the infant"
attr(woman_el[[paste0(v, 5)]], "label") <- "Counseled on danger signs"
attr(woman_el[[paste0(v, 6)]], "label") <- "Counseled on breastfeeding"
attr(woman_el[[paste0(v, 7)]], "label") <- "Counseled on family planning"
attr(woman_el[[paste0(v, 8)]], "label") <- "Counseled on nutrition"
attr(woman_el[[paste0(v, 9)]], "label") <- "Counseled on baby care"
attr(woman_el[[paste0(v, 10)]], "label") <- "Other action"

# Code diarrhea treatment
v <- "treatelse"

# Split the string variable into numeric components
woman_el <- woman_el %>%
  mutate(
    x_split = strsplit(as.character(get(v)), " ")
  )

# Create temporary x variables
for (i in 1:max(lengths(woman_el$x_split), na.rm = TRUE)) {
  woman_el[[paste0("x", i)]] <- sapply(woman_el$x_split, function(x) {
    if (length(x) >= i && x[i] != "") as.numeric(x[i]) else NA
  })
}

# Remove the temporary split variable
woman_el$x_split <- NULL

# Create binary indicators for each treatment type
for (i in 1:10) {
  # Initialize with 0 where treatother is 1
  woman_el[[paste0(v, i)]] <- ifelse(woman_el$treatother == 1, 0, NA)
  
  # Set to 1 if any x variable equals i
  for (j in 1:length(grep("^x\\d+$", names(woman_el)))) {
    x_var <- paste0("x", j)
    if (x_var %in% names(woman_el)) {
      woman_el[[paste0(v, i)]] <- ifelse(!is.na(woman_el[[x_var]]) & woman_el[[x_var]] == i, 
                                         1, 
                                         woman_el[[paste0(v, i)]])
    }
  }
  
  # Apply yesno labels as factors
  woman_el[[paste0(v, i)]] <- factor(
    woman_el[[paste0(v, i)]], 
    levels = c(0, 1, 2), 
    labels = c("No", "Yes", "No")
  )
}

# Reorder columns
woman_el <- woman_el %>%
  select(names(woman_el)[1:which(names(woman_el) == v)], 
         paste0(v, 1:10), 
         everything())

# Clear the original variable
woman_el[[v]] <- ""

# Drop temporary x variables
woman_el <- woman_el %>%
  select(-matches("^x\\d+$"))

# Add variable labels
attr(woman_el[[paste0(v, 1)]], "label") <- "Antibiotic tablet, capsule or syrup"
attr(woman_el[[paste0(v, 2)]], "label") <- "Antimotility tablet, capsule or syrup"
attr(woman_el[[paste0(v, 3)]], "label") <- "Zinc"
attr(woman_el[[paste0(v, 4)]], "label") <- "Other tablet, capsule or syrup"
attr(woman_el[[paste0(v, 5)]], "label") <- "Antibiotic injection"
attr(woman_el[[paste0(v, 6)]], "label") <- "Other injection (not antibiotic)"
attr(woman_el[[paste0(v, 7)]], "label") <- "Intravenous fluid"
attr(woman_el[[paste0(v, 8)]], "label") <- "Intravenous drug"
attr(woman_el[[paste0(v, 9)]], "label") <- "Home remedy/herbal medicine"
attr(woman_el[[paste0(v, 10)]], "label") <- "Other treatment"

# Save processed data
write_dta(woman_el, file.path(intermediate_dir, "woman_el.dta"))

#=============================================================================
#   Clinic Baseline Data
#=============================================================================

facility_bl <- read_dta(file.path(raw_dir, "facility_bl.dta"))

# Add variable labels
attr(facility_bl$state, "label") <- "State"
attr(facility_bl$sid, "label") <- "State ID"
attr(facility_bl$strata, "label") <- "Strata ID"
attr(facility_bl$fid, "label") <- "Clinic ID"
attr(facility_bl$electric, "label") <- "Electricity source"
attr(facility_bl$water, "label") <- "Does facility have running water"
attr(facility_bl$beds, "label") <- "Number of beds"
attr(facility_bl$travel_time, "label") <- "Estimated travel time to referral hospital (minutes)"
attr(facility_bl$open24hrs, "label") <- "Is this facility open 24 hours a day/7 days a week"
attr(facility_bl$lab, "label") <- "Does this facility have a laboratory"
attr(facility_bl$test_malaria, "label") <- "Does the lab offer testing for Malaria"
attr(facility_bl$test_pcv, "label") <- "Does the lab offer Hemoglobin Test (Hb or PCV)"
attr(facility_bl$test_urine, "label") <- "Does the lab offer Urine Test (protein, sugar)"
attr(facility_bl$pmtct, "label") <- "Are PMTCT services provided in this facility"
attr(facility_bl$inpatient, "label") <- "Does this facility provide inpatient admissions"
attr(facility_bl$drugs, "label") <- "Does this facility have a pharmacy"
attr(facility_bl$cesarean, "label") <- "Does this facility do caesarean sections"
attr(facility_bl$transfusion, "label") <- "Does this facility do blood transfusions"
attr(facility_bl$workers, "label") <- "Number of health care providers"
attr(facility_bl$equip, "label") <- "Do you have ____ available"
attr(facility_bl$equip_bp, "label") <- "BP cuff"
attr(facility_bl$equip_steth_ad, "label") <- "Adult stethoscope"
attr(facility_bl$equip_steth_ch, "label") <- "Fetal stethoscope"
attr(facility_bl$equip_thermo, "label") <- "Rectal thermometer for newborn"
attr(facility_bl$equip_examcouch, "label") <- "Examination couch"
attr(facility_bl$equip_del, "label") <- "Labor/delivery table"
attr(facility_bl$equip_newb, "label") <- "Newborn resuscitation table"
attr(facility_bl$equip_oxygen, "label") <- "Oxygen/resuscitation set"
attr(facility_bl$equip_incub, "label") <- "Incubator"
attr(facility_bl$equip_dpack, "label") <- "Delivery Set/Pack"
attr(facility_bl$equip_ambubag, "label") <- "Ambu (ventilator) bag"
attr(facility_bl$equip_clave, "label") <- "Autoclave/Sterilizer"
attr(facility_bl$equip_shock, "label") <- "Anti-shock garments"
attr(facility_bl$births_m1, "label") <- "Number of deliveries in health facility-Month 1"
attr(facility_bl$births_m2, "label") <- "Number of deliveries in health facility-Month 2"
attr(facility_bl$births_m3, "label") <- "Number of deliveries in health facility-Month 3"
attr(facility_bl$births_m4, "label") <- "Number of deliveries in health facility-Month 4"
attr(facility_bl$births_m5, "label") <- "Number of deliveries in health facility-Month 5"
attr(facility_bl$births_m6, "label") <- "Number of deliveries in health facility-Month 6"
attr(facility_bl$cond, "label") <- "What is the general condition of the clinic building"
attr(facility_bl$clean, "label") <- "How clean is the inside of the clinic"
attr(facility_bl$vent, "label") <- "Is there a functional fan/air conditioning in delivery room"
attr(facility_bl$clinictreat, "label") <- "Clinic treatment"

# Remove leading blanks in labels
for (v in names(facility_bl)) {
  label <- attr(facility_bl[[v]], "label")
  if (!is.null(label)) {
    attr(facility_bl[[v]], "label") <- str_trim(label)
  }
}

# Define and apply value labels

# Condition of clinic building
facility_bl$cond <- factor(facility_bl$cond, 
                           levels = 1:4,
                           labels = c("Poor (requires major rehabilitation)",
                                      "Fair (requires some rehabilitation)",
                                      "Good (requires no rehabilitation)",
                                      "Excellent (like new or almost new)"))

# Cleanliness of clinic
facility_bl$clean <- factor(facility_bl$clean, 
                            levels = 1:4,
                            labels = c("Very dirty",
                                       "Somewhat dirty",
                                       "Clean",
                                       "Very clean"))

# Electricity source
facility_bl$electric <- factor(facility_bl$electric, 
                               levels = 1:4,
                               labels = c("Grid", 
                                          "Solar", 
                                          "None", 
                                          "Other"))

# Treatment assignment
facility_bl$clinictreat <- factor(facility_bl$clinictreat, 
                                  levels = 0:2,
                                  labels = c("Control", 
                                             "MLP", 
                                             "Doctor"))

# Apply yes/no labels to test variables
test_vars <- names(facility_bl)[grepl("^test_", names(facility_bl))]
for (v in test_vars) {
  # Replace missing values with 0
  facility_bl[[v]] <- ifelse(is.na(facility_bl[[v]]), 0, facility_bl[[v]])
  
  # Convert to factor
  facility_bl[[v]] <- factor(facility_bl[[v]], 
                             levels = 0:1,
                             labels = c("No", "Yes"))
}

# Apply yes/no labels to other binary variables
binary_vars <- c("open24hrs", "lab", "pmtct", "inpatient", "drugs", 
                 "cesarean", "transfusion", "vent")
equip_vars <- names(facility_bl)[grepl("^equip_", names(facility_bl))]
binary_vars <- c(binary_vars, equip_vars)

for (v in binary_vars) {
  # Recode 2 as 0
  facility_bl[[v]] <- ifelse(facility_bl[[v]] == 2, 0, facility_bl[[v]])
  
  # Convert to factor
  facility_bl[[v]] <- factor(facility_bl[[v]], 
                             levels = 0:1,
                             labels = c("No", "Yes"))
}

# Format state variable
facility_bl$state <- toupper(facility_bl$state)
facility_bl$state <- gsub("_", " ", facility_bl$state)

# Save processed data
write_dta(facility_bl, file.path(intermediate_dir, "facility_bl.dta"))

#=============================================================================
#   Clinic Endline data
#=============================================================================

facility_el <- read_dta(file.path(raw_dir, "facility_el.dta"))

# Add variable labels
attr(facility_el$date, "label") <- "Interview Date"
attr(facility_el$state, "label") <- "State"
attr(facility_el$sid, "label") <- "State ID"
attr(facility_el$strata, "label") <- "Strata ID"
attr(facility_el$fid, "label") <- "Clinic ID"
attr(facility_el$open24hrs, "label") <- "Is PHC open with someone physically present 24 hours a day"
attr(facility_el$saturday, "label") <- "Is PHC open with someone physically present on Saturday"
attr(facility_el$sunday, "label") <- "Is PHC open with someone physically present on Sunday"
attr(facility_el$callduty, "label") <- "Is there a health provider on call after closing hours"
attr(facility_el$callroom, "label") <- "Is the provider on call usually physically present in the PHC"
attr(facility_el$emergserv, "label") <- "How often does the PHC provide services to patients after closing hours"
attr(facility_el$inpatient, "label") <- "Does this facility provide inpatient admissions"
attr(facility_el$new, "label") <- "Any new health workers on staff roster that started after the intervention"
attr(facility_el$newstaff, "label") <- "Number of new health workers"
attr(facility_el$liveclinic, "label") <- "Does new provider lives on the premises"
attr(facility_el$livewhere, "label") <- "Where do they live"
attr(facility_el$livewhere_oth, "label") <- "Other (Specify)"
attr(facility_el$distance, "label") <- "How far away do they live from the PHC in kilometers"
attr(facility_el$drivetime, "label") <- "How long does it take by car to get to the PHC"
attr(facility_el$drive_mins, "label") <- "Minutes"
attr(facility_el$drive_hrs, "label") <- "Hours"
attr(facility_el$worksat, "label") <- "Does new provider usually work on Saturday"
attr(facility_el$worksun, "label") <- "Does new provider usually work on Sunday"
attr(facility_el$emerg_call, "label") <- "How often are they called for patient emergencies outside normal working hours"
attr(facility_el$birth_call, "label") <- "How often are they called for deliveries outside normal working hours"
attr(facility_el$rate_know, "label") <- "Rate their clinical knowledge (0-10)"
attr(facility_el$rate_do, "label") <- "Rate their clinical skill (0-10)"
attr(facility_el$rate_manner, "label") <- "Rate their rapport with patients (0-10)"
attr(facility_el$rate_work, "label") <- "Rate their rapport with colleagues (0-10)"
attr(facility_el$consult, "label") <- "Likelihood that a provider would seek advice/help from the new provider"
attr(facility_el$rate_overall, "label") <- "Overall rating (0-10)"
attr(facility_el$impact, "label") <- "What was their impact on clinic operations"
attr(facility_el$impacthow, "label") <- "In what way did they impact operations"
attr(facility_el$impacthow_oth, "label") <- "Other (Specify)"
attr(facility_el$ideas, "label") <- "You say he/she brought new ideas: Can you give me an example"
attr(facility_el$assess1, "label") <- "What is the general condition of the clinic building"
attr(facility_el$assess2, "label") <- "What is the general condition of clinic infrastructure"
attr(facility_el$assess3, "label") <- "How clean is the inside of the clinic"
attr(facility_el$clinictreat, "label") <- "Clinic treatment"

# Create factor levels and labels for condition
condition_levels <- 1:4
condition_labels <- c(
  "Poor (requires major rehabilitation)",
  "Fair (requires some rehabilitation)",
  "Good (requires no rehabilitation)",
  "Excellent (like new or almost new)"
)

# Create factor levels and labels for clean
clean_levels <- 1:4
clean_labels <- c(
  "Very dirty",
  "Somewhat dirty",
  "Clean",
  "Very clean"
)

# Create factor levels and labels for likely
likely_levels <- 1:5
likely_labels <- c(
  "Very likely",
  "Somewhat likely",
  "Neither likely nor unlikely",
  "Somewhat unlikely",
  "Very unlikely"
)

# Create factor levels and labels for impact
impact_levels <- 1:5
impact_labels <- c(
  "Strongly positive",
  "Fairly positive",
  "Neither positive nor negative",
  "Fairly negative",
  "Strongly negative"
)

# Create factor levels and labels for afterhours
afterhours_levels <- 1:5
afterhours_labels <- c(
  "All the time",
  "Frequently",
  "Sometimes",
  "Seldom",
  "Never"
)

# Create factor levels and labels for frequent
frequent_levels <- 1:5
frequent_labels <- c(
  "All the time",
  "Most of the time",
  "Sometimes",
  "Seldom",
  "Never"
)

# Create factor levels and labels for reside
reside_levels <- 1:4
reside_labels <- c(
  "PHC community",
  "Nearby community",
  "Town",
  "Other"
)

# Create factor levels and labels for yesno
yesno_levels <- c(0, 1)
yesno_labels <- c("No", "Yes")

# Create factor levels and labels for treatment
treatment_levels <- 0:2
treatment_labels <- c("Control", "MLP", "Doctor")

# Apply value labels by converting variables to factors
facility_el$emergserv <- factor(facility_el$emergserv, 
                                levels = afterhours_levels, 
                                labels = afterhours_labels)

facility_el$emerg_call <- factor(facility_el$emerg_call, 
                                 levels = frequent_levels, 
                                 labels = frequent_labels)

facility_el$birth_call <- factor(facility_el$birth_call, 
                                 levels = frequent_levels, 
                                 labels = frequent_labels)

facility_el$livewhere <- factor(facility_el$livewhere, 
                                levels = reside_levels, 
                                labels = reside_labels)

facility_el$impact <- factor(facility_el$impact, 
                             levels = impact_levels, 
                             labels = impact_labels)

facility_el$consult <- factor(facility_el$consult, 
                              levels = likely_levels, 
                              labels = likely_labels)

facility_el$assess1 <- factor(facility_el$assess1, 
                              levels = condition_levels, 
                              labels = condition_labels)

facility_el$assess2 <- factor(facility_el$assess2, 
                              levels = condition_levels, 
                              labels = condition_labels)

facility_el$assess3 <- factor(facility_el$assess3, 
                              levels = clean_levels, 
                              labels = clean_labels)

facility_el$clinictreat <- factor(facility_el$clinictreat, 
                                  levels = treatment_levels, 
                                  labels = treatment_labels)

# Apply yes/no labels to binary variables
binary_vars <- c("open24hrs", "saturday", "sunday", "callduty", "callroom", "new")
for (v in binary_vars) {
  facility_el[[v]] <- factor(facility_el[[v]], 
                             levels = 0:1,
                             labels = c("No", "Yes"))
}

# Recode 2 to 0 for some binary variables and apply yes/no labels
recode_vars <- c("inpatient", "liveclinic", "worksat", "worksun")
for (v in recode_vars) {
  facility_el[[v]] <- ifelse(facility_el[[v]] == 2, 0, facility_el[[v]])
  facility_el[[v]] <- factor(facility_el[[v]], 
                             levels = 0:1,
                             labels = c("No", "Yes"))
}

# Format state variable
facility_el$state <- toupper(facility_el$state)
facility_el$state <- gsub("_", " ", facility_el$state)

# Convert date to proper format (assuming it's in MY format)
date_label <- attr(facility_el$date, "label")
facility_el <- facility_el %>%
  mutate(
    date_new = as.Date(paste0("01-", date), format = "%d-%b-%Y")
  )
attr(facility_el$date_new, "label") <- date_label
facility_el <- facility_el %>%
  select(date_new, everything()) %>%
  select(-date) %>%
  rename(date = date_new)

# Calculate drivetime in minutes
facility_el <- facility_el %>%
  mutate(
    drivetime = (drive_hrs * 60) + drive_mins
  ) %>%
  select(-drive_hrs, -drive_mins)

# Recode impact and consult so that bigger is better
# First, create a copy of impact
facility_el <- facility_el %>%
  mutate(
    impact_old = impact
  )

# Recode impact (1=5, 2=4, 3=3, 4=2, 5=1)
facility_el <- facility_el %>%
  mutate(
    impact = case_when(
      as.numeric(impact_old) == 1 ~ 5,
      as.numeric(impact_old) == 2 ~ 4,
      as.numeric(impact_old) == 3 ~ 3,
      as.numeric(impact_old) == 4 ~ 2,
      as.numeric(impact_old) == 5 ~ 1
    )
  )

# Apply new labels to impact
facility_el$impact <- factor(facility_el$impact, 
                             levels = 1:5,
                             labels = c("Strongly negative",
                                        "Fairly negative",
                                        "Neither positive nor negative",
                                        "Fairly positive",
                                        "Strongly positive"))

# Recode consult (1=5, 2=4, 3=3, 4=2, 5=1)
facility_el <- facility_el %>%
  mutate(
    likely = case_when(
      as.numeric(consult) == 1 ~ 5,
      as.numeric(consult) == 2 ~ 4,
      as.numeric(consult) == 3 ~ 3,
      as.numeric(consult) == 4 ~ 2,
      as.numeric(consult) == 5 ~ 1
    )
  )

# Apply new labels to likely
facility_el$likely <- factor(facility_el$likely, 
                             levels = 1:5,
                             labels = c("Very unlikely",
                                        "Somewhat unlikely",
                                        "Neither likely nor unlikely",
                                        "Somewhat likely",
                                        "Very likely"))

# Reorder columns and drop old variables
facility_el <- facility_el %>%
  select(names(facility_el)[1:which(names(facility_el) == "consult")], 
         likely, 
         everything()) %>%
  select(-impact_old, -consult)

# Add variable labels for new variables
attr(facility_el$likely, "label") <- "Likelihood that a provider would seek advice/help from new provider"
attr(facility_el$impact, "label") <- "What was their impact on clinic operations"

# Code provider impact
var <- "impacthow"

# Split the impacthow variable into separate components
facility_el <- facility_el %>%
  mutate(
    impact_split = strsplit(as.character(get(var)), " ")
  )

# 1 Create temporary impact variables
for (i in 1:max(lengths(facility_el$impact_split), na.rm = TRUE)) {
  facility_el[[paste0("impact", i)]] <- sapply(facility_el$impact_split, function(x) {
    # Check if x is NULL, NA, or empty
    if (is.null(x) || length(x) == 0 || all(is.na(x))) {
      return(NA)
    }
    # Check if the index exists and the value isn't empty
    if (length(x) >= i && !is.na(x[i]) && x[i] != "") {
      return(as.numeric(x[i]))
    } else {
      return(NA)
    }
  })
}

# Remove the temporary split variable
facility_el$impact_split <- NULL

# Create binary indicators for each impact type
for (i in 1:8) {
  # Initialize with 0
  facility_el[[paste0(var, i)]] <- 0
  
  # Check if any of the impact variables equals i
  for (j in 1:length(grep("^impact\\d+$", names(facility_el)))) {
    impact_var <- paste0("impact", j)
    if (impact_var %in% names(facility_el)) {
      facility_el[[paste0(var, i)]] <- ifelse(
        !is.na(facility_el[[impact_var]]) & facility_el[[impact_var]] == i, 
        1, 
        facility_el[[paste0(var, i)]]
      )
    }
  }
  
  # Apply yesno labels as factors
  facility_el[[paste0(var, i)]] <- factor(
    facility_el[[paste0(var, i)]], 
    levels = 0:1,
    labels = c("No", "Yes")
  )
  
  # Set to NA if clinictreat is 0
  facility_el[[paste0(var, i)]] <- ifelse(
    as.numeric(facility_el$clinictreat) == 1, # 1 corresponds to "Control"
    NA,
    facility_el[[paste0(var, i)]]
  )
}

# Drop temporary impact variables and impacthow_oth
facility_el <- facility_el %>%
  select(-matches("^impact\\d+$"), -paste0(var, "_oth"))

# Reorder columns
facility_el <- facility_el %>%
  select(names(facility_el)[1:which(names(facility_el) == "rate_overall")], 
         "impact", var, paste0(var, 1:8), 
         everything())

# Clear the original variable
facility_el[[var]] <- ""

# Add variable labels
attr(facility_el[[paste0(var, 1)]], "label") <- "Providers were over-worked helped to reduce workload"
attr(facility_el[[paste0(var, 2)]], "label") <- "Allowed the PHC to extend hours of service"
attr(facility_el[[paste0(var, 3)]], "label") <- "Allowed the PHC to provide services not previously offered"
attr(facility_el[[paste0(var, 4)]], "label") <- "Helped other providers to improve clinical knowledge and skills"
attr(facility_el[[paste0(var, 5)]], "label") <- "Brought in new ideas/new ways of doing things"
attr(facility_el[[paste0(var, 6)]], "label") <- "Challenged other providers to be more hardworking"
attr(facility_el[[paste0(var, 7)]], "label") <- "Positive attitude made work environment more pleasant"
attr(facility_el[[paste0(var, 8)]], "label") <- "Other impact"

# Save processed data
write_dta(facility_el, file.path(intermediate_dir, "facility_el.dta"))

#=============================================================================
#   Provider data
#=============================================================================

# Read the data
provider <- read_dta(file.path(raw_dir, "provider.dta"))
# Code provider impact
var <- "impacthow"

# Split the impacthow variable into separate components
facility_el <- facility_el %>%
  mutate(
    impact_split = strsplit(as.character(get(var)), " ")
  )

# Create temporary impact variables
for (i in 1:max(lengths(facility_el$impact_split), na.rm = TRUE)) {
  facility_el[[paste0("impact", i)]] <- sapply(facility_el$impact_split, function(x) {
    # Check if x is NULL, NA, or empty
    if (is.null(x) || length(x) == 0 || all(is.na(x))) {
      return(NA)
    }
    # Check if the index exists and the value isn't empty
    if (length(x) >= i && !is.na(x[i]) && x[i] != "") {
      return(as.numeric(x[i]))
    } else {
      return(NA)
    }
  })
}

# Remove the temporary split variable
facility_el$impact_split <- NULL

# Create binary indicators for each impact type
for (i in 1:8) {
  # Initialize with 0
  facility_el[[paste0(var, i)]] <- 0
  
  # Check if any of the impact variables equals i
  for (j in 1:length(grep("^impact\\d+$", names(facility_el)))) {
    impact_var <- paste0("impact", j)
    if (impact_var %in% names(facility_el)) {
      facility_el[[paste0(var, i)]] <- ifelse(
        !is.na(facility_el[[impact_var]]) & facility_el[[impact_var]] == i, 
        1, 
        facility_el[[paste0(var, i)]]
      )
    }
  }
  
  # Apply yesno labels as factors
  facility_el[[paste0(var, i)]] <- factor(
    facility_el[[paste0(var, i)]], 
    levels = 0:1,
    labels = c("No", "Yes")
  )
  
  # Set to NA if clinictreat is 0
  facility_el[[paste0(var, i)]] <- ifelse(
    as.numeric(facility_el$clinictreat) == 1, # 1 corresponds to "Control"
    NA,
    facility_el[[paste0(var, i)]]
  )
}

# Drop temporary impact variables and impacthow_oth if it exists
facility_el <- facility_el %>%
  select(-matches("^impact\\d+$"), -any_of(paste0(var, "_oth")))

# Reorder columns
facility_el <- facility_el %>%
  select(names(facility_el)[1:which(names(facility_el) == "rate_overall")], 
         "impact", var, paste0(var, 1:8), 
         everything())

# Clear the original variable
facility_el[[var]] <- ""

# Add variable labels
attr(facility_el[[paste0(var, 1)]], "label") <- "Providers were over-worked helped to reduce workload"
attr(facility_el[[paste0(var, 2)]], "label") <- "Allowed the PHC to extend hours of service"
attr(facility_el[[paste0(var, 3)]], "label") <- "Allowed the PHC to provide services not previously offered"
attr(facility_el[[paste0(var, 4)]], "label") <- "Helped other providers to improve clinical knowledge and skills"
attr(facility_el[[paste0(var, 5)]], "label") <- "Brought in new ideas/new ways of doing things"
attr(facility_el[[paste0(var, 6)]], "label") <- "Challenged other providers to be more hardworking"
attr(facility_el[[paste0(var, 7)]], "label") <- "Positive attitude made work environment more pleasant"
attr(facility_el[[paste0(var, 8)]], "label") <- "Other impact"

# Define value labels

# Sex
provider$sex <- factor(provider$sex, 
                       levels = 1:2,
                       labels = c("Male", "Female"))

# State of residence
provider$reside <- factor(provider$reside, 
                          levels = 1:37,
                          labels = c("Abia", "Adamawa", "Anambra", "Akwa Ibom", 
                                     "Bauchi", "Bayelsa", "Benue", "Borno", 
                                     "Cross River", "Delta", "Ebonyi", "Enugu", 
                                     "Edo", "Ekiti", "Gombe", "Imo", 
                                     "Jigawa", "Kaduna", "Kano", "Katsina", 
                                     "Kebbi", "Kogi", "Kwara", "Lagos", 
                                     "Nasarawa", "Niger", "Ogun", "Ondo", 
                                     "Osun", "Oyo", "Plateau", "Rivers", 
                                     "Sokoto", "Taraba", "Yobe", "Zamfara", 
                                     "Federal Capital Territory (FCT)"))

# MCQ questions
provider$d1 <- factor(provider$d1, 
                      levels = 0:5,
                      labels = c("Dont know", "Convulsions", "Decreased consciousness", 
                                 "Kidney failure", "Pulmonary edema", "All of the above"))

provider$d2 <- factor(provider$d2, 
                      levels = 0:4,
                      labels = c("Dont know", "Order a blood test for malaria", 
                                 "Set up IV line for fluids", 
                                 "Give Artemether/Lumefantrine tablets", 
                                 "Check body temperature with thermometer"))

provider$d3 <- factor(provider$d3, 
                      levels = 0:4,
                      labels = c("Dont know", "Order a blood test for malaria", 
                                 "Set up IV line for fluids", 
                                 "Give Artemether/Lumefantrine tablets", 
                                 "Check body temperature with thermometer"))

provider$d4 <- factor(provider$d4, 
                      levels = 0:4,
                      labels = c("Dont know", "Performing frequent vaginal examinations", 
                                 "Rupturing membranes as soon as possible in the first stage of labor", 
                                 "Routine catheterization of the bladder before childbirth", 
                                 "Reducing prolonged labor"))

provider$d5 <- factor(provider$d5, 
                      levels = 0:4,
                      labels = c("Dont know", "Give diazepam", "Give magnesium sulfate", 
                                 "Deliver the baby as soon as possible", "Give nifedipine"))

provider$d6 <- factor(provider$d6, 
                      levels = 0:4,
                      labels = c("Dont know", "A cephalic presentation", "A face presentation", 
                                 "Cervical dilation of 7cm", "Fetal head not engaged"))

provider$d7 <- factor(provider$d7, 
                      levels = 0:4,
                      labels = c("Dont know", "Rapid maternal pulse", 
                                 "Persistent abdominal pain and suprapubic tenderness", 
                                 "Fetal distress", "All of the above"))

provider$d8 <- factor(provider$d8, 
                      levels = 0:4,
                      labels = c("Dont know", "Inability to complete a sentence in one breath", 
                                 "Respiratory rate less than 20/min", "Bradycardia", 
                                 "All of the above"))

provider$d9 <- factor(provider$d9, 
                      levels = 0:4,
                      labels = c("Dont know", "Given oxygen 40-60%", 
                                 "Given nebulized salbutamol 5mg or terbutaline 10 mg repeated and administered 12hrly", 
                                 "Asked to go buy a salbutamol inhaler", "None of the above"))

provider$d10 <- factor(provider$d10, 
                       levels = 1:6,
                       labels = c("A silent chest", "Cyanosis", "Bradycardia", 
                                  "Confusion", "All of the above", "Dont know"))

# Diagnosis and treatment labels
provider$vignette1_e <- factor(provider$vignette1_e, 
                               levels = 1:7,
                               labels = c("Pulmonary TB", "Pneumonia", "Chronic Bronchitis", 
                                          "Diabetes mellitus", "AIDS", "Dont know", "Other"))

# Yes/No variables
yesno_vars <- c("d11c", "vignette1_b1", "vignette1_c1", "vignette2_b1", "vignette2_c1", 
                "vignette1_f2b", "vignette1_f2c", "vignette1_f2d", 
                "vignette2_e2b", "vignette2_e2c", "vignette2_e2d", "vignette2_e2e", "vignette2_e2f", 
                "studyprov")

for (v in yesno_vars) {
  if (v %in% names(provider)) {
    provider[[v]] <- factor(provider[[v]], 
                            levels = 0:1,
                            labels = c("No", "Yes"))
  }
}

# Treatment and provider type
provider$clinictreat <- factor(provider$clinictreat, 
                               levels = 0:2,
                               labels = c("Control", "MLP", "Doctor"))

provider$provtype <- factor(provider$provtype, 
                            levels = 0:2,
                            labels = c("Existing MLP", "New MLP", "Doctor"))

provider$cadre <- factor(provider$cadre, 
                         levels = 1:8,
                         labels = c("Doctor", "Nurse", "Midwife", "Nurse/midwife", 
                                    "CHO", "CHEW", "J-CHEW", "Other"))

# Format/create variables

# Format state variable
provider$state <- toupper(provider$state)
provider$state <- gsub("_", " ", provider$state)

# Format date variable
date_label <- attr(provider$date, "label")
provider <- provider %>%
  mutate(
    date_new = as.Date(paste0("01-", date), format = "%d-%b-%Y")
  )
attr(provider$date_new, "label") <- date_label
provider <- provider %>%
  select(date_new, everything()) %>%
  select(-date) %>%
  rename(date = date_new)

# Calculate years of experience
provider <- provider %>%
  mutate(
    experience = ifelse(experience > 2000 & experience <= 2017, 
                        2017 - experience, 
                        experience)
  )

# Performance on clinical modules

# MCQ: Basic Clinical Knowledge
provider <- provider %>%
  mutate(
    mcq1 = d1 == "All of the above",
    mcq2 = d2 == "Give Artemether/Lumefantrine tablets",
    mcq3 = d3 == "Check body temperature with thermometer",
    mcq4 = d4 == "Reducing prolonged labor",
    mcq5 = d5 == "Give magnesium sulfate",
    mcq6 = d6 == "A cephalic presentation",
    mcq7 = d7 == "All of the above",
    mcq8 = d8 == "Inability to complete a sentence in one breath",
    mcq9 = d9 == "Given nebulized salbutamol 5mg or terbutaline 10 mg repeated and administered 12hrly",
    mcq10 = d10 == "All of the above"
  )

# Convert to factors with labels
for (i in 1:10) {
  mcq_var <- paste0("mcq", i)
  provider[[mcq_var]] <- factor(provider[[mcq_var]], 
                                levels = c(FALSE, TRUE),
                                labels = c("Incorrect", "Correct"))
}

# Reorder columns to place mcq variables after d10
provider <- provider %>%
  select(names(provider)[1:which(names(provider) == "d10")], 
         paste0("mcq", 1:10), 
         everything())

# Copy variable labels from d variables to mcq variables
for (i in 1:10) {
  d_var <- paste0("d", i)
  mcq_var <- paste0("mcq", i)
  attr(provider[[mcq_var]], "label") <- attr(provider[[d_var]], "label")
}

# Drop original d variables
provider <- provider %>%
  select(-paste0("d", 1:10))

# Case Scenarios
# First, rename variables with prefix p_
old_names <- names(provider)[grep("^d11a|^d11b|^d11c|^d11d|^d11e|^d11f|^d11g|^d11h|^d11i|^d12a|^vignette", names(provider))]
new_names <- paste0("p_", old_names)
names(provider)[match(old_names, names(provider))] <- new_names

# Then rename d11 variables to cs_
d11_vars <- names(provider)[grep("^p_d11", names(provider))]
cs_vars <- gsub("p_d11", "cs_", d11_vars)
names(provider)[match(d11_vars, names(provider))] <- cs_vars

# Rename p_d12a to cs_j
provider <- provider %>%
  rename(cs_j = p_d12a)

# Process cs_a, cs_g, cs_h variables
for (v in c("cs_a", "cs_g", "cs_h")) {
  if (v %in% names(provider)) {
    for (i in 1:4) {
      provider[[paste0(v, "_", i)]] <- grepl(i, provider[[v]])
      provider[[paste0(v, "_", i)]][is.na(provider[[v]]) | provider[[v]] == ""] <- NA
    }
  }
}

# Process cs_e, cs_f, cs_i variables
for (v in c("cs_e", "cs_f", "cs_i")) {
  if (v %in% names(provider)) {
    for (i in 1:3) {
      provider[[paste0(v, "_", i)]] <- grepl(i, provider[[v]])
      provider[[paste0(v, "_", i)]][is.na(provider[[v]]) | provider[[v]] == ""] <- NA
    }
  }
}

# Process cs_b variable
if ("cs_b" %in% names(provider)) {
  for (i in 1:6) {
    provider[[paste0("cs_b_", i)]] <- grepl(i, provider[["cs_b"]])
    provider[[paste0("cs_b_", i)]][is.na(provider[["cs_b"]]) | provider[["cs_b"]] == ""] <- NA
  }
}

# Process cs_d variable
if ("cs_d" %in% names(provider)) {
  for (i in 1:5) {
    provider[[paste0("cs_d_", i)]] <- grepl(i, provider[["cs_d"]])
    provider[[paste0("cs_d_", i)]][is.na(provider[["cs_d"]]) | provider[["cs_d"]] == ""] <- NA
  }
}

# Process cs_j variable
if ("cs_j" %in% names(provider)) {
  provider[["cs_j"]] <- ifelse(!is.na(provider[["cs_j"]]) & provider[["cs_j"]] != "", 
                               paste0(" ", provider[["cs_j"]], " "), 
                               provider[["cs_j"]])
  
  for (i in 1:12) {
    pattern <- paste0(" ", i, " ")
    provider[[paste0("cs_j_", i)]] <- grepl(pattern, provider[["cs_j"]])
    provider[[paste0("cs_j_", i)]][is.na(provider[["cs_j"]]) | provider[["cs_j"]] == ""] <- NA
  }
}

# Create cs_c_1 variable
if ("cs_c" %in% names(provider)) {
  provider[["cs_c_1"]] <- !is.na(provider[["cs_c"]]) & provider[["cs_c"]] == 0
}

# Vignette 1
# Add spaces to vignette variables
vignette_vars <- c(
  "p_vignette1_a", "p_vignette1_b2", "p_vignette1_c2", "p_vignette1_d", 
  "p_vignette2_a", "p_vignette2_b2", "p_vignette2_c2", "p_vignette2_d", 
  "p_vignette2_e1", "p_vignette1_f1", "p_vignette1_g", "p_vignette2_f"
)

for (v in vignette_vars) {
  if (v %in% names(provider)) {
    provider[[v]] <- ifelse(!is.na(provider[[v]]) & provider[[v]] != "", 
                            paste0(" ", provider[[v]], " "), 
                            provider[[v]])
  }
}

# Process Vignette 1 (x = 1)
x <- 1

# History taking
for (i in 1:12) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "hx_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_a")]])
  provider[[paste0("v", x, "hx_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                         provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Physical examination
for (i in 1:9) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "pe_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_b2")]])
  provider[[paste0("v", x, "pe_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                         provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Lab investigations
for (i in 2:9) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "lab_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_c2")]])
  provider[[paste0("v", x, "lab_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                          provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Include tests improperly listed under "Other"
for (i in 1:3) {
  # Check for malaria test
  malaria_idx <- !is.na(provider[[paste0("v", x, "lab_8")]]) & provider[[paste0("v", x, "lab_8")]] == FALSE
  if (any(malaria_idx)) {
    provider[[paste0("v", x, "lab_8")]][malaria_idx] <- grepl("alaria", provider[[paste0("p_vignette1_c2j_", i)]][malaria_idx], ignore.case = TRUE)
  }
  
  # Check for HIV test
  hiv_idx <- !is.na(provider[[paste0("v", x, "lab_9")]]) & provider[[paste0("v", x, "lab_9")]] == FALSE
  if (any(hiv_idx)) {
    provider[[paste0("v", x, "lab_9")]][hiv_idx] <- grepl("RVS", provider[[paste0("p_vignette1_c2j_", i)]][hiv_idx], ignore.case = TRUE)
  }
  
  # Check for hemoglobin test
  hemo_idx <- !is.na(provider[[paste0("v", x, "lab_7")]]) & provider[[paste0("v", x, "lab_7")]] == FALSE
  if (any(hemo_idx)) {
    provider[[paste0("v", x, "lab_7")]][hemo_idx] <- grepl("Pcv", provider[[paste0("p_vignette1_c2j_", i)]][hemo_idx], ignore.case = TRUE)
  }
}

# Mentioned TB among preliminary diagnoses
pattern <- " 1 "
provider[[paste0("v", x, "diag1")]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_d")]])
provider[[paste0("v", x, "diag1")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                      provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
attr(provider[[paste0("v", x, "diag1")]], "label") <- "TB among preliminary diagnoses"

# Treated correctly
pattern <- " 2 "
provider[[paste0("v", x, "treat_tb")]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_f1")]])
provider[[paste0("v", x, "treat_tb")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                         provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
attr(provider[[paste0("v", x, "treat_tb")]], "label") <- "Prescribed TB medication"

pattern <- " 5 "
provider[[paste0("v", x, "treat_refer")]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_f1")]])
provider[[paste0("v", x, "treat_refer")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                            provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
attr(provider[[paste0("v", x, "treat_refer")]], "label") <- "Referred patient"

# Check if medication mentioned under "Other"
for (i in 1:3) {
  # Create a logical vector for rows where treat_tb is FALSE
  idx <- !is.na(provider[[paste0("v", x, "treat_tb")]]) & 
    provider[[paste0("v", x, "treat_tb")]] == FALSE
  
  # Only proceed if there are any rows to update
  if (any(idx)) {
    # Get the column with other medications
    other_med_col <- paste0("p_vignette", x, "_f1f_", i)
    
    # Only update if the column exists
    if (other_med_col %in% names(provider)) {
      # Update only the FALSE rows where "soniaz" is mentioned
      provider[[paste0("v", x, "treat_tb")]][idx] <- 
        grepl("soniaz", provider[[other_med_col]][idx], ignore.case = TRUE)
    }
  }
}

# Prescribed correct dose of medication
provider[[paste0("v", x, "treat_dose")]] <- provider[[paste0("p_vignette", x, "_f2b")]] == "Yes"
provider[[paste0("v", x, "treat_dose")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                           provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA

# Check if correct dose mentioned in other field
# First, create a logical vector for rows meeting all conditions
idx <- !is.na(provider[[paste0("v", x, "treat_dose")]]) & 
  provider[[paste0("v", x, "treat_dose")]] == FALSE

# Add additional conditions if the columns exist
if (paste0("p_vignette", x, "_f2f_1") %in% names(provider)) {
  idx <- idx & 
    !is.na(provider[[paste0("p_vignette", x, "_f2f_1")]]) & 
    provider[[paste0("p_vignette", x, "_f2f_1")]] == 1
}

# Only proceed if there are any rows to update
if (any(idx)) {
  # Get the column with other medications
  other_med_col <- paste0("p_vignette", x, "_f1f_1")
  
  # Only update if the column exists
  if (other_med_col %in% names(provider)) {
    # Update only the rows meeting all conditions
    provider[[paste0("v", x, "treat_dose")]][idx] <- 
      grepl("soniaz", provider[[other_med_col]][idx], ignore.case = TRUE)
  }
}

# Set to NA if TB medication not prescribed
provider[[paste0("v", x, "treat_dose")]][is.na(provider[[paste0("v", x, "treat_tb")]]) | 
                                           provider[[paste0("v", x, "treat_tb")]] == FALSE] <- NA
attr(provider[[paste0("v", x, "treat_dose")]], "label") <- "Correct dose of TB medication"

# Patient counseling
for (i in 2:10) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "educ_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_g")]])
  provider[[paste0("v", x, "educ_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                           provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Process Vignette 2 (x = 2)
x <- 2

# History taking
for (i in 1:19) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "hx_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_a")]])
  provider[[paste0("v", x, "hx_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                         provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Include questions improperly listed under "Other"
# Include questions improperly listed under "Other"
other_vars <- c("p_vignette2_a20_1", "p_vignette2_a20_2", "p_vignette2_a20_3")

for (v in other_vars) {
  if (v %in% names(provider)) {
    # Check for stool-related questions
    stool_idx <- !is.na(provider[[paste0("v", x, "hx_16")]]) & 
      provider[[paste0("v", x, "hx_16")]] == FALSE
    
    if (any(stool_idx)) {
      provider[[paste0("v", x, "hx_16")]][stool_idx] <- 
        grepl("stool", provider[[v]][stool_idx], ignore.case = TRUE)
    }
    
    # Check for vomiting-related questions
    vomit_idx <- !is.na(provider[[paste0("v", x, "hx_8")]]) & 
      provider[[paste0("v", x, "hx_8")]] == FALSE
    
    if (any(vomit_idx)) {
      provider[[paste0("v", x, "hx_8")]][vomit_idx] <- 
        grepl("omiting", provider[[v]][vomit_idx], ignore.case = TRUE)
    }
  }
}

# Physical examination
for (i in 1:13) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "pe_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_b2")]])
  provider[[paste0("v", x, "pe_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                         provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Lab investigations
for (i in 2:5) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "lab_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_c2")]])
  provider[[paste0("v", x, "lab_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                          provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Diagnosed malaria
pattern1 <- " 1 "
provider[[paste0("v", x, "diag1")]] <- grepl(pattern1, provider[[paste0("p_vignette", x, "_d")]])
provider[[paste0("v", x, "diag1")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                      provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA

# Check for alternative malaria diagnosis code
pattern2 <- " 2 "

# Create a logical vector for rows where diag1 is FALSE
idx <- !is.na(provider[[paste0("v", x, "diag1")]]) & 
  provider[[paste0("v", x, "diag1")]] == FALSE

# Only proceed if there are any rows to update
if (any(idx)) {
  # Update only the rows where diag1 is FALSE
  provider[[paste0("v", x, "diag1")]][idx] <- 
    grepl(pattern2, provider[[paste0("p_vignette", x, "_d")]][idx])
}

# Set the attribute for the entire column
attr(provider[[paste0("v", x, "diag1")]], "label") <- "Malaria diagnosis"

# Treated correctly - ACT or Quinine
pattern1 <- " 3 "
provider[[paste0("v", x, "treat_malaria")]] <- grepl(pattern1, provider[[paste0("p_vignette", x, "_e1")]])
provider[[paste0("v", x, "treat_malaria")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                              provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA

# Check for alternative treatment code (Quinine)
pattern2 <- " 4 "

# Create a logical vector for rows where treat_malaria is FALSE
idx <- !is.na(provider[[paste0("v", x, "treat_malaria")]]) & 
  provider[[paste0("v", x, "treat_malaria")]] == FALSE

# Only proceed if there are any rows to update
if (any(idx)) {
  # Update only the rows where treat_malaria is FALSE
  provider[[paste0("v", x, "treat_malaria")]][idx] <- 
    grepl(pattern2, provider[[paste0("p_vignette", x, "_e1")]][idx])
}

# Set the attribute for the entire column
attr(provider[[paste0("v", x, "treat_malaria")]], "label") <- "Prescribed ACT or Quinine"

# Prescribed folate
pattern <- " 5 "
provider[[paste0("v", x, "treat_folate")]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_e1")]])
provider[[paste0("v", x, "treat_folate")]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                             provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
attr(provider[[paste0("v", x, "treat_folate")]], "label") <- "Prescribed folate"

# Patient counseling
for (i in 2:6) {
  pattern <- paste0(" ", i, " ")
  provider[[paste0("v", x, "educ_", i)]] <- grepl(pattern, provider[[paste0("p_vignette", x, "_f")]])
  provider[[paste0("v", x, "educ_", i)]][is.na(provider[[paste0("p_vignette", x, "_a")]]) | 
                                           provider[[paste0("p_vignette", x, "_a")]] == ""] <- NA
}

# Reorder variables
provider <- provider %>%
  select(names(provider)[1:which(names(provider) == "mcq9")], 
         "mcq10", 
         starts_with("cs_a_"), starts_with("cs_b_"), starts_with("cs_c_"), 
         starts_with("cs_d_"), starts_with("cs_e_"), starts_with("cs_f_"), 
         starts_with("cs_g_"), starts_with("cs_h_"), starts_with("cs_i_"), 
         starts_with("cs_j_"), 
         everything())

# Add variable labels for case scenarios
attr(provider$cs_a_1, "label") <- "Calls for help"
attr(provider$cs_a_2, "label") <- "Explains and reassures the woman"
attr(provider$cs_a_3, "label") <- "Checks for signs of shock"
attr(provider$cs_a_4, "label") <- "Palpates the uterus to assess tone"
attr(provider$cs_b_1, "label") <- "Pulse >110"
attr(provider$cs_b_2, "label") <- "Systolic BP <90mm Hg"
attr(provider$cs_b_3, "label") <- "Cold clammy skin"
attr(provider$cs_b_4, "label") <- "Pallor"
attr(provider$cs_b_5, "label") <- "Respiration > 30 / min"
attr(provider$cs_b_6, "label") <- "Anxious and confused or unconscious"
attr(provider$cs_c_1, "label") <- "Correctly states patient not in shock"
attr(provider$cs_d_1, "label") <- "Atonic uterus"
attr(provider$cs_d_2, "label") <- "Cervical and perineal tears"
attr(provider$cs_d_3, "label") <- "Retained placenta"
attr(provider$cs_d_4, "label") <- "Ruptured uterus"
attr(provider$cs_d_5, "label") <- "Clotting disorder"
attr(provider$cs_e_1, "label") <- "Massage the uterus"
attr(provider$cs_e_2, "label") <- "Gives oxytocin or ergometrine or misoprostol"
attr(provider$cs_e_3, "label") <- "Monitor vitals and blood loss and massage the uterus"
attr(provider$cs_f_1, "label") <- "Explains what is to be done and what to expect"
attr(provider$cs_f_2, "label") <- "Performs internal bimanual compression of the uterus"
attr(provider$cs_f_3, "label") <- "Locates placenta and examines for missing pieces"
attr(provider$cs_g_1, "label") <- "Explains procedure and what to expect"
attr(provider$cs_g_2, "label") <- "Gives sedative"
attr(provider$cs_g_3, "label") <- "Gives prophylactic antibiotics"
attr(provider$cs_g_4, "label") <- "Removes placental fragments from uterus"
attr(provider$cs_h_1, "label") <- "Examines perineum, vagina and cervix for tears and repairs"
attr(provider$cs_h_2, "label") <- "Considers use of bedside clotting test"
attr(provider$cs_h_3, "label") <- "Encourages breastfeeding to help uterus contraction"
attr(provider$cs_h_4, "label") <- "Calls for help"
attr(provider$cs_i_1, "label") <- "Requests for type and cross-match for possible transfusion"
attr(provider$cs_i_2, "label") <- "Makes plan for monitoring vital signs, uterine firmness and blood loss"
attr(provider$cs_i_3, "label") <- "Continues with routine postpartum care"
attr(provider$cs_j_1, "label") <- "Keep the baby warm"
attr(provider$cs_j_2, "label") <- "Clamp and cut the cord if necessary"
attr(provider$cs_j_3, "label") <- "Transfer the baby to a dry, clean and warm surface"
attr(provider$cs_j_4, "label") <- "Inform mother about procedure"
attr(provider$cs_j_5, "label") <- "Keep the baby wrapped and under a radiant heater if possible"
attr(provider$cs_j_6, "label") <- "Open the airway"
attr(provider$cs_j_7, "label") <- "Position the head so it is slightly extended"
attr(provider$cs_j_8, "label") <- "Suction first the mouth and then the nose"
attr(provider$cs_j_9, "label") <- "Repeat suction if necessary"
attr(provider$cs_j_10, "label") <- "Ventilate the baby"
attr(provider$cs_j_11, "label") <- "Place mask to cover chin mouth and nose to form seal"
attr(provider$cs_j_12, "label") <- "Squeeze the bag 2 or 3 times and look if chest is rising"

# Add variable labels for vignette 1
attr(provider$v1hx_1, "label") <- "History: Do you have night sweats"
attr(provider$v1hx_2, "label") <- "History: Do you have any chest pain"
attr(provider$v1hx_3, "label") <- "History: Is there any blood in the sputum"
attr(provider$v1hx_4, "label") <- "History: Do you drink"
attr(provider$v1hx_5, "label") <- "History: Has this happened before"
attr(provider$v1hx_6, "label") <- "History: Are there others with similar cough"
attr(provider$v1hx_7, "label") <- "History: What is your profession"
attr(provider$v1hx_8, "label") <- "History: Any high-risk sexual behavior"
attr(provider$v1hx_9, "label") <- "History: Do you feel tired"
attr(provider$v1hx_10, "label") <- "History: What is your normal diet"
attr(provider$v1hx_11, "label") <- "History: What is the pattern of the fever"
attr(provider$v1hx_12, "label") <- "History: Smoking history"
attr(provider$v1pe_1, "label") <- "Exam: measure height"
attr(provider$v1pe_2, "label") <- "Exam: take weight"
attr(provider$v1pe_3, "label") <- "Exam: check pulse"
attr(provider$v1pe_4, "label") <- "Exam: check respiratory rate"
attr(provider$v1pe_5, "label") <- "Exam: check blood pressure"
attr(provider$v1pe_6, "label") <- "Exam: check temperature"
attr(provider$v1pe_7, "label") <- "Exam: check for retraction"
attr(provider$v1pe_8, "label") <- "Exam: examine chest"
attr(provider$v1pe_9, "label") <- "Exam: auscultate chest"
attr(provider$v1lab_2, "label") <- "Lab: ESR"
attr(provider$v1lab_3, "label") <- "Lab: Mantoux Test"
attr(provider$v1lab_4, "label") <- "Lab: Sputum for AFB"
attr(provider$v1lab_5, "label") <- "Lab: Chest X-ray"
attr(provider$v1lab_6, "label") <- "Lab: WBC"
attr(provider$v1lab_7, "label") <- "Lab: Hemoglobin"
attr(provider$v1lab_8, "label") <- "Lab: Blood smear for malaria"
attr(provider$v1lab_9, "label") <- "Lab: HIV test"
attr(provider$v1educ_2, "label") <- "Educ: Emphasize the importance of taking medicine or going to referral"
attr(provider$v1educ_3, "label") <- "Educ: Importance of high protein diet"
attr(provider$v1educ_4, "label") <- "Educ: Importance of drug compliance"
attr(provider$v1educ_5, "label") <- "Educ: Importance of boiling milk"
attr(provider$v1educ_6, "label") <- "Educ: Importance of well ventilated house"
attr(provider$v1educ_7, "label") <- "Educ: Importance of rest"
attr(provider$v1educ_8, "label") <- "Educ: Avoid strenuous work"
attr(provider$v1educ_9, "label") <- "Educ: Adhere to return date to clinic"
attr(provider$v1educ_10, "label") <- "Educ: Return if there are abnormal signs"

# Add variable labels for vignette 2
attr(provider$v2hx_1, "label") <- "History: Duration of fever"
attr(provider$v2hx_2, "label") <- "History: Pattern of fever"
attr(provider$v2hx_3, "label") <- "History: If temperature was taken"
attr(provider$v2hx_4, "label") <- "History: Presence of cough"
attr(provider$v2hx_5, "label") <- "History: Productive or dry cough"
attr(provider$v2hx_6, "label") <- "History: Severity of cough"
attr(provider$v2hx_7, "label") <- "History: Presence of sore throat"
attr(provider$v2hx_8, "label") <- "History: Presence of vomiting"
attr(provider$v2hx_9, "label") <- "History: Presence of sweats and chills"
attr(provider$v2hx_10, "label") <- "History: Presence of convulsions"
attr(provider$v2hx_11, "label") <- "History: Presence of running nose"
attr(provider$v2hx_12, "label") <- "History: Appetite"
attr(provider$v2hx_13, "label") <- "History: Ability to drink"
attr(provider$v2hx_14, "label") <- "History: Difficulty in breathing"
attr(provider$v2hx_15, "label") <- "History: Presence of ear problems"
attr(provider$v2hx_16, "label") <- "History: Presence of diarrhea"
attr(provider$v2hx_17, "label") <- "History: Any medication given"
attr(provider$v2hx_18, "label") <- "History: Amount of medication given"
attr(provider$v2hx_19, "label") <- "History: Vaccination history"
attr(provider$v2pe_1, "label") <- "Exam: Assess general health condition"
attr(provider$v2pe_2, "label") <- "Exam: Take temperature"
attr(provider$v2pe_3, "label") <- "Exam: Take pulse"
attr(provider$v2pe_4, "label") <- "Exam: Check signs of dehydration"
attr(provider$v2pe_5, "label") <- "Exam: Look for signs of anemia"
attr(provider$v2pe_6, "label") <- "Exam: Assess neck stiffness"
attr(provider$v2pe_7, "label") <- "Exam: Check ear/throat"
attr(provider$v2pe_8, "label") <- "Exam: Check respiratory rate"
attr(provider$v2pe_9, "label") <- "Exam: Palpate the spleen"
attr(provider$v2pe_10, "label") <- "Exam: Check for visible severe wasting"
attr(provider$v2pe_11, "label") <- "Exam: Weigh the child"
attr(provider$v2pe_12, "label") <- "Exam: Check weight against a growth chart"
attr(provider$v2pe_13, "label") <- "Exam: Look for edema of both feet"
attr(provider$v2lab_2, "label") <- "Lab: Malaria test"
attr(provider$v2lab_3, "label") <- "Lab: Full Blood Count"
attr(provider$v2lab_4, "label") <- "Lab: Hemoglobin test"
attr(provider$v2lab_5, "label") <- "Lab: Lumbar puncture"
attr(provider$v2educ_2, "label") <- "Educ: Importance of iron intake"
attr(provider$v2educ_3, "label") <- "Educ: When to return if no improvement"
attr(provider$v2educ_4, "label") <- "Educ: Explains danger signs require patient return immediately"
attr(provider$v2educ_5, "label") <- "Educ: Explain how to use ACT with folic acid or iron"
attr(provider$v2educ_6, "label") <- "Educ: When to return to re-evaluate anemia"

# Clear original case scenario variables
cs_vars <- c("cs_a", "cs_b", "cs_d", "cs_e", "cs_f", "cs_g", "cs_h", "cs_i", "cs_j")
for (v in cs_vars) {
  if (v %in% names(provider)) {
    provider[[v]] <- ""
  }
}

# Convert all binary variables to factors with Yes/No labels
binary_vars <- c(grep("^cs_[a-z]_[0-9]+$", names(provider), value = TRUE),
                 grep("^v1", names(provider), value = TRUE),
                 grep("^v2", names(provider), value = TRUE))

for (var in binary_vars) {
  if (var %in% names(provider)) {
    provider[[var]] <- factor(provider[[var]], 
                              levels = c(FALSE, TRUE),
                              labels = c("No", "Yes"))
  }
}

# Drop unnecessary variables
provider <- provider %>%
  select(-cs_c, -starts_with("p_"))

# Reorder key variables to the end
provider <- provider %>%
  select(-studyprov, -provtype, -clinictreat, everything(), 
         studyprov, provtype, clinictreat)

# Save processed data
write_dta(facility_bl, file.path(intermediate_dir, "facility_bl.dta"))
write_dta(provider, file.path(intermediate_dir, "provider.dta"))
#=============================================================================
#   Patient data
#=============================================================================

# Read the data
patient <- read_dta(file.path(raw_dir, "patient.dta"))

# Add variable labels
attr(patient$state, "label") <- "State"
attr(patient$sid, "label") <- "State ID"
attr(patient$strata, "label") <- "Strata ID"
attr(patient$fid, "label") <- "Clinic ID"
attr(patient$visitdate, "label") <- "Visit date"
attr(patient$patid, "label") <- "Patient ID"
attr(patient$age, "label") <- "Patient age"
attr(patient$sex, "label") <- "Patient sex"
attr(patient$phone, "label") <- "Do you have a contact phone number"
attr(patient$transport, "label") <- "How did you get to this clinic today"
attr(patient$transport_mins, "label") <- "Travel time in minutes"
attr(patient$transport_hrs, "label") <- "Travel time in hours"
attr(patient$r_symptom1, "label") <- "Presenting Symptom 1"
attr(patient$r_duration1, "label") <- "Duration of presenting complaint 1"
attr(patient$r_unit1, "label") <- "Unit of duration of presenting complaint 1"
attr(patient$r_symptom2, "label") <- "Presenting Symptom 2"
attr(patient$r_duration2, "label") <- "Duration of presenting complaint 2"
attr(patient$r_unit2, "label") <- "Unit of duration of presenting complaint 2"
attr(patient$r_symptom3, "label") <- "Presenting Symptom 3"
attr(patient$r_duration3, "label") <- "Duration of presenting complaint 3"
attr(patient$r_unit3, "label") <- "Unit of duration of presenting complaint 3"
attr(patient$r_symptom4, "label") <- "Presenting Symptom 4"
attr(patient$r_duration4, "label") <- "Duration of presenting complaint 4"
attr(patient$r_unit4, "label") <- "Unit of duration of presenting complaint 4"
attr(patient$r_symptom5, "label") <- "Presenting Symptom 5"
attr(patient$r_duration5, "label") <- "Duration of presenting complaint 5"
attr(patient$r_unit5, "label") <- "Unit of duration of presenting complaint 5"
attr(patient$r_symptom6, "label") <- "Presenting Symptom 6"
attr(patient$r_duration6, "label") <- "Duration of presenting complaint 6"
attr(patient$r_unit6, "label") <- "Unit of duration of presenting complaint 6"
attr(patient$r_symptom7, "label") <- "Presenting Symptom 7"
attr(patient$r_duration7, "label") <- "Duration of presenting complaint 7"
attr(patient$r_unit7, "label") <- "Unit of duration of presenting complaint 7"
attr(patient$r_symptom8, "label") <- "Presenting Symptom 8"
attr(patient$r_duration8, "label") <- "Duration of presenting complaint 8"
attr(patient$r_unit8, "label") <- "Unit of duration of presenting complaint 8"
attr(patient$severity, "label") <- "Severity of symptoms experienced (0-10)"
attr(patient$bhealth, "label") <- "How would you rate your health today"
attr(patient$walk, "label") <- "Today would you have any physical trouble or difficulty: Walking up a flight of stairs"
attr(patient$run, "label") <- "Today would you have any physical trouble or difficulty: Running the length of a field"
attr(patient$ache, "label") <- "During the past week how much trouble have you had with hurting or aching in any part of your body"
attr(patient$sleep, "label") <- "During the past week how much trouble have you had with sleeping"
attr(patient$observe, "label") <- "Was the consultation observed"
attr(patient$provid, "label") <- "Provider ID"
attr(patient$interr, "label") <- "Was the consultation completed without interruption"
attr(patient$duration, "label") <- "Consultation time in minutes"
attr(patient$greet, "label") <- "Does provider respectfully greet the patient/caretaker"
attr(patient$ask, "label") <- "Does provider ask patient/caretaker for the purpose of the visit"
attr(patient$d_symptom1, "label") <- "DCO: Presenting Symptom 1"
attr(patient$d_duration1, "label") <- "DCO: Duration of presenting symptom 1"
attr(patient$d_unit1, "label") <- "DCO: Unit of duration of presenting symptom 1"
attr(patient$d_symptom2, "label") <- "DCO: Presenting Symptom 2"
attr(patient$d_duration2, "label") <- "DCO: Duration of presenting symptom 2"
attr(patient$d_unit2, "label") <- "DCO: Unit of duration of presenting symptom 2"
attr(patient$d_symptom3, "label") <- "DCO: Presenting Symptom 3"
attr(patient$d_duration3, "label") <- "DCO: Duration of presenting symptom 3"
attr(patient$d_unit3, "label") <- "DCO: Unit of duration of presenting symptom 3"
attr(patient$d_symptom4, "label") <- "DCO: Presenting Symptom 4"
attr(patient$d_duration4, "label") <- "DCO: Duration of presenting symptom 4"
attr(patient$d_unit4, "label") <- "DCO: Unit of duration of presenting symptom 4"
attr(patient$d_symptom5, "label") <- "DCO: Presenting Symptom 5"
attr(patient$d_duration5, "label") <- "DCO: Duration of presenting symptom 5"
attr(patient$d_unit5, "label") <- "DCO: Unit of duration of presenting symptom 5"
attr(patient$d_symptom6, "label") <- "DCO: Presenting Symptom 6"
attr(patient$d_duration6, "label") <- "DCO: Duration of presenting symptom 6"
attr(patient$d_unit6, "label") <- "DCO: Unit of duration of presenting symptom 6"
attr(patient$fever_dco, "label") <- "Fever: History-taking questions asked"
attr(patient$u5fever_dco, "label") <- "Fever: Additional questions for children under 5"
attr(patient$cough_dco, "label") <- "Cough: History-taking questions asked"
attr(patient$u5cough_dco, "label") <- "Cough: Additional questions for children under 5"
attr(patient$diarrhea_dco, "label") <- "Diarrhea: History-taking questions asked"
attr(patient$u5diarrhea_dco, "label") <- "Diarrhea: Additional questions for children under 5"
attr(patient$d_pe1, "label") <- "Exam: General"
attr(patient$d_pe2, "label") <- "Exam: Chest"
attr(patient$d_pe3, "label") <- "Exam: Abdomen"
attr(patient$d_pe4, "label") <- "Exam: Head and Neck"
attr(patient$d_pe5, "label") <- "Exam: Upper & Lower limbs"
attr(patient$d_pe6, "label") <- "Exam: For children under 5"
attr(patient$d_test, "label") <- "Lab tests"
attr(patient$d_test_other, "label") <- "Lab tests: Other"
attr(patient$diag, "label") <- "Was any diagnosis made"
attr(patient$drugs, "label") <- "Were any medicines prescribed"
attr(patient$antibio, "label") <- "Was an antibiotic prescribed"
attr(patient$inject, "label") <- "Was an injection prescribed"
attr(patient$comm, "label") <- "Provider communication with the patient"
attr(patient$clinictreat, "label") <- "Clinic treatment"
attr(patient$provtype, "label") <- "Provider type"
attr(patient$order, "label") <- "Consultation sequence"

# Remove leading blanks in labels
for (v in names(patient)) {
  if (!is.null(attr(patient[[v]], "label"))) {
    attr(patient[[v]], "label") <- trimws(attr(patient[[v]], "label"))
  }
}

# Define value labels
# Provider type
patient$provtype <- factor(patient$provtype,
                           levels = c(0, 1, 2),
                           labels = c("Existing MLP", "New MLP", "Doctor"))

# Treatment
patient$clinictreat <- factor(patient$clinictreat,
                              levels = c(0, 1, 2),
                              labels = c("Control", "MLP", "Doctor"))

# Sex
patient$sex <- factor(patient$sex,
                      levels = c(1, 2),
                      labels = c("Male", "Female"))

# Transport
patient$transport <- factor(patient$transport,
                            levels = c(1, 2, 3, 4, 5, 6),
                            labels = c("Walked", "Bus or shared van", "Taxi", 
                                       "My own car/motorcycle", "Boat", "Other"))

# Duration units
unit_vars <- grep("^[rd]_unit[0-9]$", names(patient), value = TRUE)
for (v in unit_vars) {
  if (v %in% names(patient)) {
    patient[[v]] <- factor(patient[[v]],
                           levels = c(1, 2, 3),
                           labels = c("Days", "Weeks", "Months"))
  }
}

# Health rating
patient$bhealth <- factor(patient$bhealth,
                          levels = c(1, 2, 3, 4, 5, 99),
                          labels = c("Excellent", "Very good", "Good", 
                                     "Fair", "Poor", "Dont know"))

# Status variables
status_vars <- c("walk", "run", "ache", "sleep")
for (v in status_vars) {
  if (v %in% names(patient)) {
    patient[[v]] <- factor(patient[[v]],
                           levels = c(1, 2, 3),
                           labels = c("None", "Some", "A lot"))
  }
}

# Yes/No variables
# First fix observe variable
patient$observe <- ifelse(patient$observe == 2, 0, patient$observe)

yesno_vars <- c("phone", "observe", "interr", "greet", "ask", 
                "diag", "drugs", "antibio", "inject")
for (v in yesno_vars) {
  if (v %in% names(patient)) {
    patient[[v]] <- factor(patient[[v]],
                           levels = c(0, 1),
                           labels = c("No", "Yes"))
  }
}

# Apply value labels - already done in previous code block

# Format/create variables
# Convert state to uppercase and replace underscores with spaces
patient$state <- toupper(patient$state)
patient$state <- gsub("_", " ", patient$state)

# Convert visitdate to proper date format
if ("visitdate" %in% names(patient)) {
  # Save the label
  visit_label <- attr(patient$visitdate, "label")
  
  # Convert "MMM YYYY" format to Date objects
  # We'll set each date to the first day of the month
  patient$visitdate <- as.Date(paste0("01 ", patient$visitdate), format = "%d %b %Y")
  
  # Restore the label
  attr(patient$visitdate, "label") <- visit_label
}

# Calculate travel time to clinic
patient$distmin <- patient$transport_mins
patient$distmin[patient$transport_hrs > 5] <- patient$transport_hrs[patient$transport_hrs > 5]
patient$distmin[(patient$transport_mins == 60 | patient$transport_mins == 120) & 
                  patient$transport_hrs > 0] <- 0

patient$disthour <- patient$transport_hrs
patient$disthour[patient$transport_hrs > 5] <- patient$transport_mins[patient$transport_hrs > 5]

patient$distime <- patient$distmin + (patient$disthour * 60)
attr(patient$distime, "label") <- "Travel time to clinic (minutes)"

# Drop temporary variables
patient <- patient %>%
  select(-distmin, -disthour, -transport_mins, -transport_hrs)

# Reorder variables to place distime after transport
col_names <- names(patient)
transport_pos <- which(col_names == "transport")
patient <- patient %>%
  select(
    col_names[1:transport_pos],
    distime,
    col_names[(transport_pos+1):length(col_names)]
  )

# Split alphanumeric codes from symptoms
symptom_vars <- grep("^[rd]_symptom[0-9]$", names(patient), value = TRUE)
for (x in symptom_vars) {
  # Extract first 3 characters as code
  patient[[paste0("c_", x)]] <- substr(patient[[x]], 1, 3)
  # Extract remaining characters as symptom description
  patient[[x]] <- trimws(substr(patient[[x]], 4, nchar(patient[[x]])))
}

# How many of the recommended history-taking questions did they ask?
# Add spaces around values for pattern matching
history_vars <- c("fever_dco", "cough_dco", "diarrhea_dco", 
                  grep("^u5", names(patient), value = TRUE))
for (x in history_vars) {
  if (x %in% names(patient) && !all(is.na(patient[[x]]))) {
    patient[[x]][!is.na(patient[[x]]) & patient[[x]] != ""] <- 
      paste0(" ", patient[[x]][!is.na(patient[[x]]) & patient[[x]] != ""], " ")
  }
}

# Create fever question indicators
for (i in 1:12) {
  pattern <- paste0(" ", i, " ")
  patient[[paste0("fever_", i)]] <- grepl(pattern, patient$fever_dco)
  patient[[paste0("fever_", i)]][is.na(patient$fever_dco) | patient$fever_dco == ""] <- NA
}

# Create under-5 fever question indicators
for (i in 1:5) {
  pattern <- paste0(" ", i, " ")
  patient[[paste0("u5fever_", i)]] <- grepl(pattern, patient$u5fever_dco)
  patient[[paste0("u5fever_", i)]][is.na(patient$fever_dco) | patient$fever_dco == ""] <- NA
}

# Create cough question indicators
for (i in 1:14) {
  pattern <- paste0(" ", i, " ")
  patient[[paste0("cough_", i)]] <- grepl(pattern, patient$cough_dco)
  patient[[paste0("cough_", i)]][is.na(patient$cough_dco) | patient$cough_dco == ""] <- NA
}

# Create under-5 cough question indicators
for (i in 1:4) {
  pattern <- paste0(" ", i, " ")
  patient[[paste0("u5cough_", i)]] <- grepl(pattern, patient$u5cough_dco)
  patient[[paste0("u5cough_", i)]][is.na(patient$cough_dco) | patient$cough_dco == ""] <- NA
}

# Create diarrhea and under-5 diarrhea question indicators
for (i in 1:11) {
  pattern <- paste0(" ", i, " ")
  patient[[paste0("diarrhea_", i)]] <- grepl(pattern, patient$diarrhea_dco)
  patient[[paste0("diarrhea_", i)]][is.na(patient$diarrhea_dco) | patient$diarrhea_dco == ""] <- NA
  
  patient[[paste0("u5diarrhea_", i)]] <- grepl(pattern, patient$u5diarrhea_dco)
  patient[[paste0("u5diarrhea_", i)]][is.na(patient$diarrhea_dco) | patient$diarrhea_dco == ""] <- NA
}

# Check whether the provider asked about duration
for (i in 1:6) {
  # For fever
  fever_idx <- !is.na(patient$fever_1) & 
    patient$fever_1 == FALSE & 
    !is.na(patient$fever_dco) & 
    patient$fever_dco != "" & 
    !is.na(patient[[paste0("c_d_symptom", i)]]) & 
    patient[[paste0("c_d_symptom", i)]] == "A03" & 
    !is.na(patient[[paste0("d_duration", i)]]) & 
    patient[[paste0("d_duration", i)]] < 99
  
  if (any(fever_idx)) {
    patient$fever_1[fever_idx] <- TRUE
  }
  
  # For cough
  cough_idx <- !is.na(patient$cough_1) & 
    patient$cough_1 == FALSE & 
    !is.na(patient$cough_dco) & 
    patient$cough_dco != "" & 
    !is.na(patient[[paste0("c_d_symptom", i)]]) & 
    patient[[paste0("c_d_symptom", i)]] == "R05" & 
    !is.na(patient[[paste0("d_duration", i)]]) & 
    patient[[paste0("d_duration", i)]] < 99
  
  if (any(cough_idx)) {
    patient$cough_1[cough_idx] <- TRUE
  }
  
  # For diarrhea
  diarrhea_idx <- !is.na(patient$diarrhea_1) & 
    patient$diarrhea_1 == FALSE & 
    !is.na(patient$diarrhea_dco) & 
    patient$diarrhea_dco != "" & 
    !is.na(patient[[paste0("c_d_symptom", i)]]) & 
    patient[[paste0("c_d_symptom", i)]] == "D11" & 
    !is.na(patient[[paste0("d_duration", i)]]) & 
    patient[[paste0("d_duration", i)]] < 99
  
  if (any(diarrhea_idx)) {
    patient$diarrhea_1[diarrhea_idx] <- TRUE
  }
}

# Calculate percentage of recommended questions asked
for (v in c("fever", "cough", "diarrhea")) {
  # Get all question variables for this symptom
  question_vars <- grep(paste0("^", v, "_[0-9]+$"), names(patient), value = TRUE)
  
  # Count total questions asked (sum of TRUE values)
  patient[[paste0(v, "_count")]] <- rowSums(patient[question_vars], na.rm = TRUE)
  
  # Count non-missing questions
  non_missing <- rowSums(!is.na(patient[question_vars]))
  
  # Calculate percentage
  patient[[paste0(v, "_perc")]] <- patient[[paste0(v, "_count")]] / non_missing
}

# Add variable labels for fever questions
attr(patient$fever_1, "label") <- "Asked about duration"
attr(patient$fever_2, "label") <- "Asked about pattern"
attr(patient$fever_3, "label") <- "Asked about chills/sweats"
attr(patient$fever_4, "label") <- "Asked about cough"
attr(patient$fever_5, "label") <- "Asked about sore throat/pain swallowing"
attr(patient$fever_6, "label") <- "Asked about vomiting"
attr(patient$fever_7, "label") <- "Asked about diarrhea"
attr(patient$fever_8, "label") <- "Asked about convulsions"
attr(patient$fever_9, "label") <- "Asked about catarrh"
attr(patient$fever_10, "label") <- "Asked if medication given"
attr(patient$fever_11, "label") <- "Asked medication amount"
attr(patient$fever_12, "label") <- "Asked other question"

# Add variable labels for under-5 fever questions
attr(patient$u5fever_1, "label") <- "Child: Asked about drinking/breastfeeding"
attr(patient$u5fever_2, "label") <- "Child: Asked about difficulty breathing/chest pain"
attr(patient$u5fever_3, "label") <- "Child: Asked about ear pain/discharge"
attr(patient$u5fever_4, "label") <- "Child: Asked about pain/crying while passing urine"
attr(patient$u5fever_5, "label") <- "Child: Asked about vaccination history"

# Add variable labels for cough questions
attr(patient$cough_1, "label") <- "Asked about duration"
attr(patient$cough_2, "label") <- "Asked about sputum production"
attr(patient$cough_3, "label") <- "Asked about color of sputum"
attr(patient$cough_4, "label") <- "Asked what makes it worse"
attr(patient$cough_5, "label") <- "Asked whether worse at night"
attr(patient$cough_6, "label") <- "Asked about contact with person with chronic cough"
attr(patient$cough_7, "label") <- "Asked about night sweats"
attr(patient$cough_8, "label") <- "Asked about chest pain"
attr(patient$cough_9, "label") <- "Asked about difficulty breathing"
attr(patient$cough_10, "label") <- "Asked about fever"
attr(patient$cough_11, "label") <- "Asked about appetite"
attr(patient$cough_12, "label") <- "Asked about diarrhea"
attr(patient$cough_13, "label") <- "Asked about vomiting"
attr(patient$cough_14, "label") <- "Asked about tiredness/fatigue"

# Add variable labels for under-5 cough questions
attr(patient$u5cough_1, "label") <- "Child: Asked about drinking/breastfeeding"
attr(patient$u5cough_2, "label") <- "Child: Asked about convulsions"
attr(patient$u5cough_3, "label") <- "Child: Asked about ear problems"
attr(patient$u5cough_4, "label") <- "Child: Asked about vaccination history"

# Add variable labels for diarrhea questions
attr(patient$diarrhea_1, "label") <- "Asked about duration"
attr(patient$diarrhea_2, "label") <- "Asked about frequency"
attr(patient$diarrhea_3, "label") <- "Asked about consistency"
attr(patient$diarrhea_4, "label") <- "Asked about blood in stool"
attr(patient$diarrhea_5, "label") <- "Asked about mucus in stool"
attr(patient$diarrhea_6, "label") <- "Asked about abdominal pain"
attr(patient$diarrhea_7, "label") <- "Asked about vomiting"
attr(patient$diarrhea_8, "label") <- "Asked about fever"
attr(patient$diarrhea_9, "label") <- "Asked about tiredness/fatigue"
attr(patient$diarrhea_10, "label") <- "Asked if family members/neighbors have diarrhea"
attr(patient$diarrhea_11, "label") <- "Asked about any medications"

# Add variable labels for under-5 diarrhea questions
attr(patient$u5diarrhea_1, "label") <- "Child: Asked about drinking/breastfeeding"
attr(patient$u5diarrhea_2, "label") <- "Child: Asked about convulsions"
attr(patient$u5diarrhea_3, "label") <- "Child: Asked about ear problems"
attr(patient$u5diarrhea_4, "label") <- "Child: Asked about cough/difficulty breathing"
attr(patient$u5diarrhea_5, "label") <- "Child: Asked if tears when baby cries"
attr(patient$u5diarrhea_6, "label") <- "Child: Asked if baby started taking other food"
attr(patient$u5diarrhea_7, "label") <- "Child: Asked if change in food is recent"
attr(patient$u5diarrhea_8, "label") <- "Child: Asked how the food has been given"
attr(patient$u5diarrhea_9, "label") <- "Child: Asked who prepares and feeds the child"
attr(patient$u5diarrhea_10, "label") <- "Child: Asked about hand washing of food preparer"
attr(patient$u5diarrhea_11, "label") <- "Child: Asked about vaccination history"

# Add variable labels for percentage variables
attr(patient$fever_perc, "label") <- "Fever: Percent of recommended questions asked"
attr(patient$cough_perc, "label") <- "Cough: Percent of recommended questions asked"
attr(patient$diarrhea_perc, "label") <- "Diarrhea: Percent of recommended questions asked"

# Drop count and DCO variables
patient <- patient %>%
  select(-ends_with("_count"), -ends_with("_dco"))

# Reorder variables to place fever, cough, diarrhea and u5 variables after ask
fever_vars <- grep("^fever_", names(patient), value = TRUE)
cough_vars <- grep("^cough_", names(patient), value = TRUE)
diarrhea_vars <- grep("^diarrhea_", names(patient), value = TRUE)
u5_vars <- grep("^u5", names(patient), value = TRUE)

# We'll need to reorder columns - this is a placeholder for that operation
# In actual code, you'd need to implement the reordering logic

# Physical examinations
pe1_tot <- 8
pe2_tot <- 5
pe3_tot <- 6
pe4_tot <- 8
pe5_tot <- 5
pe6_tot <- 8

# Process each physical examination type
x <- "d"  # We're only processing "d" variables

for (exam in c("pe1", "pe2", "pe3", "pe4", "pe5", "pe6")) {
  # Get the total number of items for this exam type
  exam_tot <- get(paste0(exam, "_tot"))
  
  # Split the exam string into individual values
  if (paste0(x, "_", exam) %in% names(patient)) {
    # Create a temporary data frame with split values
    temp_df <- data.frame(matrix(NA, nrow = nrow(patient), ncol = 0))
    
    # For each patient, split the exam string and create columns
    for (i in 1:nrow(patient)) {
      if (!is.na(patient[[paste0(x, "_", exam)]][i]) && 
          patient[[paste0(x, "_", exam)]][i] != "") {
        values <- strsplit(patient[[paste0(x, "_", exam)]][i], " ")[[1]]
        values <- values[values != ""]
        
        for (j in 1:length(values)) {
          col_name <- paste0("temp", j)
          if (!(col_name %in% names(temp_df))) {
            temp_df[[col_name]] <- NA
          }
          temp_df[i, col_name] <- values[j]
        }
      }
    }
    
    # Create binary indicators for each exam item
    for (val in 1:exam_tot) {
      col_name <- paste0(x, "_", exam, "_", val)
      patient[[col_name]] <- 0
      patient[[col_name]][is.na(patient[[paste0(x, "_", exam)]]) | 
                            patient[[paste0(x, "_", exam)]] == paste0(exam_tot)] <- NA
      
      # Check each temp column for matching values
      for (temp_col in names(temp_df)) {
        patient[[col_name]][!is.na(temp_df[[temp_col]]) & 
                              temp_df[[temp_col]] == as.character(val)] <- 1
      }
    }
    
    # Remove the original exam variable
    patient[[paste0(x, "_", exam)]] <- NULL
  }
}

# Calculate total number of exams performed
pe_vars <- grep("^d_pe[1-6]_[1-9]$", names(patient), value = TRUE)
patient$d_exam_num <- rowSums(patient[pe_vars], na.rm = TRUE)

# Subtract "Not applicable" responses
for (val in 1:6) {
  exam_tot <- get(paste0("pe", val, "_tot"))
  na_col <- paste0("d_pe", val, "_", exam_tot)
  
  if (na_col %in% names(patient)) {
    patient$d_exam_num[patient[[na_col]] == 1] <- 
      patient$d_exam_num[patient[[na_col]] == 1] - 1
  }
}

# Create indicator for any exam performed
patient$d_exam_any <- patient$d_exam_num > 0
patient$d_exam_any[is.na(patient$d_exam_num)] <- NA

# Rename examination variables to more descriptive names
# First, create a list of old and new names
rename_list <- list(
  d_pe1_ = "gen",
  d_pe2_ = "chest",
  d_pe3_ = "abd",
  d_pe4_ = "head",
  d_pe5_ = "limb",
  d_pe6_ = "child"
)

# Rename variables
for (old_prefix in names(rename_list)) {
  new_prefix <- rename_list[[old_prefix]]
  old_vars <- grep(paste0("^", old_prefix), names(patient), value = TRUE)
  
  for (old_var in old_vars) {
    # Extract the number at the end
    num <- sub(paste0("^", old_prefix), "", old_var)
    # Create the new variable name
    new_var <- paste0(new_prefix, num)
    # Rename the variable
    names(patient)[names(patient) == old_var] <- new_var
  }
}

# Add variable labels for physical examination variables
attr(patient$gen1, "label") <- "Feels for temperature"
attr(patient$gen2, "label") <- "Takes temperature w/ thermometer"
attr(patient$gen3, "label") <- "Measures blood pressure"
attr(patient$gen4, "label") <- "Checks respiratory rate"
attr(patient$gen5, "label") <- "Checks pulse rate"
attr(patient$gen6, "label") <- "Checks for signs of anemia"
attr(patient$gen7, "label") <- "Checks for signs of dehydration"
attr(patient$chest1, "label") <- "Observes for lower chest in-drawing"
attr(patient$chest2, "label") <- "Percusses chest"
attr(patient$chest3, "label") <- "Auscultates chest"
attr(patient$chest4, "label") <- "Checks for tracheal deviation"
attr(patient$abd1, "label") <- "Checks for tenderness"
attr(patient$abd2, "label") <- "Checks for rigidity"
attr(patient$abd3, "label") <- "Checks for organ enlargement"
attr(patient$abd4, "label") <- "Percusses the abdomen"
attr(patient$abd5, "label") <- "Auscultates the abdomen"
attr(patient$head1, "label") <- "Checks for neck stiffness"
attr(patient$head2, "label") <- "Checks ear"
attr(patient$head3, "label") <- "Examines throat"
attr(patient$head4, "label") <- "Check for enlarged lymph nodes"
attr(patient$head5, "label") <- "Examines the thyroid"
attr(patient$head6, "label") <- "Temperature w/ thermometer"
attr(patient$head7, "label") <- "Observes for nasal flaring"
attr(patient$limb1, "label") <- "Checks for finger clubbing"
attr(patient$limb2, "label") <- "Checks for peripheral cyanosis"
attr(patient$limb3, "label") <- "Palpates the axilla"
attr(patient$limb4, "label") <- "Checks femoral region for hernias"
attr(patient$child1, "label") <- "Assesses general condition"
attr(patient$child2, "label") <- "Checks for visible wasting"
attr(patient$child3, "label") <- "Looks for edema"
attr(patient$child4, "label") <- "Weighs the child"
attr(patient$child5, "label") <- "Checks against growth chart"
attr(patient$child6, "label") <- "Offers child water/observes breastfeeding"
attr(patient$child7, "label") <- "Checks for skin changes/rash"

# Rename exam variables
names(patient)[names(patient) == "d_exam_any"] <- "exam_any"
attr(patient$exam_any, "label") <- "Any physical exam"

# Drop unnecessary variables
patient <- patient %>%
  select(-d_exam_num, -gen8, -chest5, -abd6, -head8, -limb5, -child8)

# Lab tests
# Create indicator for any lab test
patient$d_test_any <- FALSE
if ("d_test" %in% names(patient)) {
  patient$d_test_any[!is.na(patient$d_test) & patient$d_test != "" & patient$d_test != "0"] <- TRUE
  patient$d_test_any[is.na(patient$d_test) | patient$d_test == ""] <- NA
  
  # Set d_test to empty if it's "0"
  patient$d_test[!is.na(patient$d_test) & patient$d_test == "0"] <- ""
}

# Process lab test variables
x <- "d"  # We're only processing "d" variables

if (paste0(x, "_test") %in% names(patient)) {
  # Split the test string into individual values
  temp_df <- data.frame(matrix(NA, nrow = nrow(patient), ncol = 0))
  
  # For each patient, split the test string and create columns
  for (i in 1:nrow(patient)) {
    if (!is.na(patient[[paste0(x, "_test")]][i]) && 
        patient[[paste0(x, "_test")]][i] != "") {
      values <- strsplit(patient[[paste0(x, "_test")]][i], " ")[[1]]
      values <- values[values != ""]
      
      for (j in 1:length(values)) {
        col_name <- paste0("temp", j)
        if (!(col_name %in% names(temp_df))) {
          temp_df[[col_name]] <- NA
        }
        temp_df[i, col_name] <- values[j]
      }
    }
  }
  
  # Create binary indicators for each test
  for (val in 1:20) {
    col_name <- paste0(x, "_test", val)
    patient[[col_name]] <- 0
    patient[[col_name]][is.na(patient[[paste0(x, "_test")]]) | 
                          patient[[paste0(x, "_test")]] == ""] <- NA
    
    # Check each temp column for matching values
    for (temp_col in names(temp_df)) {
      patient[[col_name]][!is.na(temp_df[[temp_col]]) & 
                            temp_df[[temp_col]] == as.character(val)] <- 1
    }
  }
  
  # Calculate total number of tests performed
  test_vars <- paste0(x, "_test", 1:20)
  patient[[paste0(x, "_test_num")]] <- rowSums(patient[test_vars], na.rm = TRUE)
  
  # Reorder variables
  # This is a placeholder - in actual code you'd need to implement the reordering
  
  # Remove the original test variable and temporary variables
  patient[[paste0(x, "_test")]] <- NULL
}

# Rename test variables
test_vars <- grep("^d_test", names(patient), value = TRUE)
for (old_var in test_vars) {
  new_var <- sub("^d_test", "test", old_var)
  names(patient)[names(patient) == old_var] <- new_var
}

# Add variable labels for test variables
attr(patient$test1, "label") <- "Malaria test"
attr(patient$test2, "label") <- "HIV test"
attr(patient$test3, "label") <- "Full Blood Count"
attr(patient$test4, "label") <- "ESR"
attr(patient$test5, "label") <- "Hb/PCV"
attr(patient$test6, "label") <- "WBC"
attr(patient$test7, "label") <- "Urinalysis"
attr(patient$test8, "label") <- "Urine MCS"
attr(patient$test9, "label") <- "Stool analysis"
attr(patient$test10, "label") <- "Blood glucose"
attr(patient$test11, "label") <- "Sputum AFB"
attr(patient$test12, "label") <- "Mantoux test"
attr(patient$test13, "label") <- "High Vaginal Swab MCS"
attr(patient$test14, "label") <- "Lumbar puncture"
attr(patient$test15, "label") <- "Chest X-Ray"
attr(patient$test16, "label") <- "Ultrasound"
attr(patient$test17, "label") <- "ECG"
attr(patient$test18, "label") <- "EEG"
attr(patient$test19, "label") <- "Pregnancy test"
attr(patient$test20, "label") <- "Other test"
attr(patient$test_any, "label") <- "Any lab tests"

# Drop test_num variable
patient <- patient %>%
  select(-test_num)

# Communication variables
# Create binary indicators for each communication aspect
for (i in 1:9) {
  pattern <- as.character(i)
  patient[[paste0("comm", i)]] <- grepl(pattern, patient$comm)
  patient[[paste0("comm", i)]][is.na(patient$comm) | patient$comm == ""] <- NA
}

# Add variable labels for communication variables
attr(patient$comm1, "label") <- "Looks at the patient while talking"
attr(patient$comm2, "label") <- "Tells the patient the diagnosis"
attr(patient$comm3, "label") <- "Explains the diagnosis in common language"
attr(patient$comm4, "label") <- "Explains the treatment being provided"
attr(patient$comm5, "label") <- "Gives health education related to the diagnosis"
attr(patient$comm6, "label") <- "Refers the patient to another facility"
attr(patient$comm7, "label") <- "Explains whether to return for further treatment"
attr(patient$comm8, "label") <- "Listens properly to the patient/caregiver"
attr(patient$comm9, "label") <- "Allows the patient to talk"

# Reorder variables to place comm variables after comm
comm_vars <- grep("^comm[1-9]$", names(patient), value = TRUE)
# This is a placeholder - in actual code you'd need to implement the reordering

# Drop the original comm variable
patient <- patient %>%
  select(-comm)

# Clean up

# Rename variables
names(patient)[names(patient) == "exam_any"] <- "exam"
names(patient)[names(patient) == "test_any"] <- "test"
names(patient)[names(patient) == "provtype"] <- "provider"

# Rename and reorder symptom variables
for (i in 1:8) {
  # Rename symptom code variables
  old_code_var <- paste0("c_r_symptom", i)
  new_code_var <- paste0("code", i)
  if (old_code_var %in% names(patient)) {
    names(patient)[names(patient) == old_code_var] <- new_code_var
    attr(patient[[new_code_var]], "label") <- paste0("Symptom code ", i)
  }
  
  # Rename symptom variables
  old_symptom_var <- paste0("r_symptom", i)
  new_symptom_var <- paste0("symptom", i)
  if (old_symptom_var %in% names(patient)) {
    names(patient)[names(patient) == old_symptom_var] <- new_symptom_var
  }
  
  # Rename duration variables
  old_duration_var <- paste0("r_duration", i)
  new_duration_var <- paste0("duration", i)
  if (old_duration_var %in% names(patient)) {
    names(patient)[names(patient) == old_duration_var] <- new_duration_var
  }
  
  # Rename unit variables
  old_unit_var <- paste0("r_unit", i)
  new_unit_var <- paste0("unit", i)
  if (old_unit_var %in% names(patient)) {
    names(patient)[names(patient) == old_unit_var] <- new_unit_var
  }
  
  # Reorder variables - this is a placeholder
  # In actual code, you'd need to implement the reordering logic
}

# Drop unnecessary variables
drop_pattern <- c("^[rd]_symptom", "^[rd]_duration", "^[rd]_unit", "^c_d_symptom[0-9]$")
vars_to_drop <- c()
for (pattern in drop_pattern) {
  vars_to_drop <- c(vars_to_drop, grep(pattern, names(patient), value = TRUE))
}
patient <- patient %>%
  select(-all_of(vars_to_drop))

# Apply Yes/No labels to binary variables
binary_vars <- c(
  grep("^fever_", names(patient), value = TRUE),
  grep("^cough_", names(patient), value = TRUE),
  grep("^diarrhea_", names(patient), value = TRUE),
  grep("^u5", names(patient), value = TRUE),
  "exam",
  paste0("gen", 1:7),
  paste0("chest", 1:4),
  paste0("abd", 1:5),
  paste0("head", 1:7),
  paste0("limb", 1:4),
  paste0("child", 1:7),
  paste0("test", 1:20),
  paste0("comm", 1:9)
)

for (v in binary_vars) {
  if (v %in% names(patient)) {
    patient[[v]] <- factor(patient[[v]], 
                           levels = c(0, 1),
                           labels = c("No", "Yes"))
  }
}

# Reorder variables to place key variables after comm9
vars_to_move <- c("observe", "order", "interr", "duration", "provid", "provider", "clinictreat")

# Reordering logic for symptom variables
for (i in 1:8) {
  # Get current column positions
  symptom_pos <- which(names(patient) == paste0("symptom", i))
  code_pos <- which(names(patient) == paste0("code", i))
  
  # Only proceed if both variables exist
  if (length(symptom_pos) > 0 && length(code_pos) > 0) {
    # Create a new column order that places code after symptom
    col_order <- 1:ncol(patient)
    
    # If code is not already after symptom, reorder
    if (code_pos != symptom_pos + 1) {
      # Remove code from its current position
      col_order <- col_order[-code_pos]
      
      # Insert code after symptom
      if (symptom_pos < code_pos) {
        # If symptom is before code, adjust symptom_pos
        insert_pos <- symptom_pos
      } else {
        # If symptom is after code, no adjustment needed
        insert_pos <- symptom_pos
      }
      
      col_order <- c(col_order[1:insert_pos], code_pos, col_order[(insert_pos+1):length(col_order)])
      
      # Apply the reordering
      patient <- patient[, col_order]
    }
  }
}

# Simplest reordering approach
if ("comm9" %in% names(patient)) {
  # Print debugging information
  cat("Total columns in dataset:", ncol(patient), "\n")
  
  # Get all current column names and their positions
  current_cols <- names(patient)
  
  # Variables to move after comm9
  vars_to_move <- c("observe", "order", "interr", "duration", "provid", "provider", "clinictreat")
  
  # Filter to only include variables that actually exist in the dataset
  vars_to_move <- vars_to_move[vars_to_move %in% current_cols]
  
  if (length(vars_to_move) > 0) {
    # Create a completely new ordering manually
    # First, get all columns that are not in vars_to_move
    other_cols <- current_cols[!(current_cols %in% vars_to_move)]
    
    # Find the position of comm9 in other_cols
    comm9_pos <- which(other_cols == "comm9")
    
    # Create the new order by inserting vars_to_move after comm9
    new_order <- c(
      other_cols[1:comm9_pos],  # Columns up to and including comm9
      vars_to_move,             # Variables to move
      other_cols[(comm9_pos+1):length(other_cols)]  # Remaining columns
    )
    
    # Verify the new order
    cat("New column count:", length(new_order), "\n")
    cat("Original column count:", length(current_cols), "\n")
    cat("Are all columns accounted for:", all(sort(new_order) == sort(current_cols)), "\n")
    
    # Only proceed if the new order is valid
    if (length(new_order) == length(current_cols) && 
        all(sort(new_order) == sort(current_cols)) && 
        !any(is.na(new_order)) && 
        !any(duplicated(new_order))) {
      
      # Apply the reordering
      patient <- patient[, new_order]
      cat("Reordering successful\n")
    } else {
      cat("Reordering skipped due to validation failure\n")
    }
  }
}

# Reordering logic for fever, cough, diarrhea and u5 variables after ask
if ("ask" %in% names(patient)) {
  # Find position of ask
  ask_pos <- which(names(patient) == "ask")
  
  # Get all fever, cough, diarrhea and u5 variables
  fever_vars <- grep("^fever_", names(patient), value = TRUE)
  cough_vars <- grep("^cough_", names(patient), value = TRUE)
  diarrhea_vars <- grep("^diarrhea_", names(patient), value = TRUE)
  u5_vars <- grep("^u5", names(patient), value = TRUE)
  
  all_vars <- c(fever_vars, cough_vars, diarrhea_vars, u5_vars)
  
  if (length(all_vars) > 0) {
    # Get current positions
    var_positions <- sapply(all_vars, function(v) which(names(patient) == v))
    
    # Create new column order
    col_order <- 1:ncol(patient)
    
    # Remove variables from their current positions
    col_order <- col_order[!(col_order %in% var_positions)]
    
    # Insert variables after ask
    col_order <- c(
      col_order[1:ask_pos],
      var_positions,
      col_order[(ask_pos+1):length(col_order)]
    )
    
    # Apply the reordering
    patient <- patient[, col_order]
  }
}

# Save processed data
write_dta(patient, file.path(intermediate_dir, "patient.dta"))

#=============================================================================
#   Audit data
#=============================================================================

# Read the data
audit <- read_dta(file.path(raw_dir, "audit.dta"))
# Convert state to uppercase and replace underscores with spaces
audit$state <- toupper(audit$state)
audit$state <- gsub("_", " ", audit$state)

if ("visitdate" %in% names(audit)) {
  # Save the variable label
  visit_label <- attr(audit$visitdate, "label")
  
  # Convert month-year strings to dates (first day of the month)
  audit$visitdate <- as.Date(paste0("01 ", audit$visitdate), format="%d %b %Y")
  
  # Reapply the label
  attr(audit$visitdate, "label") <- visit_label
}

# Rename variables
old_names <- c("clinic_openpatients_any", "clinic_openhowmany", 
               "clinic_openpresent_oic", "clinic_openpresent_provider", 
               "clinic_openproviders_num")
new_names <- c("patients_any", "patients_num", "present_oic", 
               "present_prov", "present_num")

for (i in 1:length(old_names)) {
  if (old_names[i] %in% names(audit)) {
    names(audit)[names(audit) == old_names[i]] <- new_names[i]
  }
}

# Add variable labels
attr(audit$state, "label") <- "State"
attr(audit$sid, "label") <- "State ID"
attr(audit$strata, "label") <- "Strata ID"
attr(audit$fid, "label") <- "Clinic ID"
attr(audit$visitdate, "label") <- "Date of Visit"
attr(audit$open, "label") <- "Was clinic open"
attr(audit$patients_any, "label") <- "At time of visit were there any patients in the waiting area"
attr(audit$patients_num, "label") <- "How many patients in the waiting area"
attr(audit$present_oic, "label") <- "At time of visit was the OIC present"
attr(audit$present_prov, "label") <- "At time of visit was the deployed provider present"
attr(audit$present_num, "label") <- "How many providers were available to attend to outpatients"
attr(audit$clinictreat, "label") <- "Clinic treatment"

# Define and apply value labels
# For treatment variable
audit$clinictreat <- factor(audit$clinictreat,
                            levels = c(0, 1, 2),
                            labels = c("Control", "MLP", "Doctor"))

# For binary variables
binary_vars <- c("open", "patients_any", "present_oic", "present_prov")
for (x in binary_vars) {
  if (x %in% names(audit)) {
    # Convert 2 to 0 (No)
    audit[[x]][audit[[x]] == 2] <- 0
    
    # Convert to factor with labels
    audit[[x]] <- factor(audit[[x]],
                         levels = c(0, 1),
                         labels = c("No", "Yes"))
  }
}

# Save processed data
write_dta(audit, file.path(intermediate_dir, "audit.dta"))