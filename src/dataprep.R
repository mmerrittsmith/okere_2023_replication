#######################################################################################################
# This file prepares the analytical datasets 
#######################################################################################################

library(haven)
library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)

raw_dir <- "../data/raw"
intermediate_dir <- "../data/intermediate"
analysis_dir <- "../data/analysis"

#---------------------------------------------------------------
# Get outcomes data
#---------------------------------------------------------------
woman_el <- read_dta(file.path(intermediate_dir, "woman_el.dta"))

#---------------------------------------------------------------
# Merge in provider start/end dates
#---------------------------------------------------------------
dates <- read_dta(file.path(raw_dir, "dates.dta"))
merged_data <- merge(woman_el, dates, by = "fid", all.x = TRUE)

# Remove .y columns (keeping master version of duplicated variables)
y_cols <- grep("\\.y$", names(merged_data), value = TRUE)
merged_data <- merged_data[, !names(merged_data) %in% y_cols]

# Rename .x columns back to original names
x_cols <- grep("\\.x$", names(merged_data), value = TRUE)
for (col in x_cols) {
  base_name <- sub("\\.x$", "", col)
  names(merged_data)[names(merged_data) == col] <- base_name
}

# Filter to keep only observations that have a valid fid (equivalent to keep(1 3) in Stata)
woman_el <- merged_data[!is.na(merged_data$fid), ]
#-------------------------------------------------------------------------
# Merge in baseline clinic data to get service clinic characteristics
#-------------------------------------------------------------------------

# Create temporary objects (equivalent to tempfile in Stata)
facility <- NULL
master <- NULL

# Preserve current data (in R we just create a copy)
woman_el_preserved <- woman_el

# Load facility baseline data
facility_bl <- read_dta(file.path(intermediate_dir, "facility_bl.dta"))

# Create derived variables
facility_bl <- facility_bl %>%
  mutate(
    nopower = (electric == 3),
    drugs = drugs-1,
    lab = lab-1,
    open24hrs = open24hrs - 1,
    cesarean = cesarean-1,
    transfusion = transfusion-1,
    vent = vent-1,
    equipment = rowMeans(select(., starts_with("equip_")), na.rm = TRUE),
    deliveries = rowMeans(select(., starts_with("births_m")), na.rm = TRUE)
  )

# Add variable labels
attr(facility_bl$nopower, "label") <- "Facility has no source of electricity"
attr(facility_bl$equipment, "label") <- "Percent of essential equipment"
attr(facility_bl$deliveries, "label") <- "Average number of deliveries per month in the last 6 months"

# Keep only needed variables
facility <- facility_bl %>%
  select(fid, water, nopower, beds, workers, lab, drugs, open24hrs, travel_time, 
         cesarean, transfusion, equipment, deliveries, cond, clean, vent)

# Rename variables with prefix
names(facility) <- ifelse(names(facility) == "fid", "fid", 
                          paste0("hc_", names(facility)))
names(facility)[names(facility) == "hc_fid"] <- "fid"

# Restore the preserved data (in R, we just use the copy we made)
woman_el <- woman_el_preserved

# Merge with facility data
master <- merge(woman_el, facility, by = "fid", all.x = TRUE)

# Remove .y columns (keeping master version of duplicated variables)
y_cols <- grep("\\.y$", names(master), value = TRUE)
master <- master[, !names(master) %in% y_cols]

# Rename .x columns back to original names
x_cols <- grep("\\.x$", names(master), value = TRUE)
for (col in x_cols) {
  base_name <- sub("\\.x$", "", col)
  names(master)[names(master) == col] <- base_name
}

# Save the master dataset
write_dta(master, file.path(analysis_dir, "master.dta"))

#-------------------------------------------------------------------------
# Merge in demographics from enrollment survey
#-------------------------------------------------------------------------

# Load woman baseline data
woman_bl <- read_dta(file.path(intermediate_dir, "woman_bl.dta"))

# Age dummies
woman_bl <- woman_bl %>%
  mutate(
    magedum = case_when(
      age >= 10 & age <= 17 ~ 1,
      age >= 18 & age <= 24 ~ 2,
      age >= 25 & age <= 29 ~ 3,
      age >= 30 & age <= 34 ~ 4,
      age >= 35 & age <= 120 ~ 5,
      TRUE ~ NA_real_
    )
  )
# Add value labels to magedum
woman_bl$magedum <- haven::labelled(
  woman_bl$magedum,
  c("Less than 18" = 1, "18-24 years" = 2, "25-29 years" = 3, 
    "30-34 years" = 4, "35 and older" = 5)
)

# Mother's educational attainment
woman_bl <- woman_bl %>%
  mutate(
    mschool = case_when(
      schooling %in% c(1, 17) | education == 1 ~ 1,
      schooling >= 2 & schooling <= 7 ~ 2,
      schooling >= 8 & schooling <= 13 ~ 3,
      schooling >= 14 & schooling <= 16 ~ 4,
      TRUE ~ NA_real_
    )
  )
# Add value labels to mschool
woman_bl$mschool <- haven::labelled(
  woman_bl$mschool,
  c("None" = 1, "Some primary" = 2, "Some secondary" = 3, "Some tertiary" = 4)
)
attr(woman_bl$mschool, "label") <- "Mother's schooling"

# Create dummy variables for mschool
woman_bl <- woman_bl %>%
  mutate(
    mschool1 = as.numeric(mschool == 1),
    mschool2 = as.numeric(mschool == 2),
    mschool3 = as.numeric(mschool == 3),
    mschool4 = as.numeric(mschool == 4)
  )
attr(woman_bl$mschool1, "label") <- "No formal schooling"
attr(woman_bl$mschool2, "label") <- "Some primary schooling"
attr(woman_bl$mschool3, "label") <- "Some secondary schooling"
attr(woman_bl$mschool4, "label") <- "Some tertiary schooling"

# Literacy
woman_bl <- woman_bl %>%
  mutate(
    literacy = case_when(
      read == 2 ~ 1,
      read == 3 ~ 2,
      TRUE ~ 0
    )
  )
# Add value labels to literacy
woman_bl$literacy <- haven::labelled(
  woman_bl$literacy,
  c("Can't read" = 0, "Read part" = 1, "Read whole" = 2)
)
attr(woman_bl$literacy, "label") <- "Mother's reading level"

woman_bl <- woman_bl %>%
  mutate(notread = as.numeric(literacy == 0))
attr(woman_bl$notread, "label") <- "Cannot read"

# Ethnicity
woman_bl <- woman_bl %>%
  mutate(hausa = as.numeric(ethnicity <= 2))
attr(woman_bl$hausa, "label") <- "Hausa/Fulani ethnicity"

# Religion
woman_bl <- woman_bl %>%
  mutate(moslem = as.numeric(religion == 5 & !is.na(religion)))
attr(woman_bl$moslem, "label") <- "Religion is Islam"

# Autonomy
woman_bl <- woman_bl %>%
  mutate(autonomy = as.numeric(decide2 == 2))
attr(woman_bl$autonomy, "label") <- "Husband makes health-care decisions"

# First birth
woman_bl <- woman_bl %>%
  mutate(first = as.numeric(priorb == 0 & !is.na(priorb)))
attr(woman_bl$first, "label") <- "First birth"

# Last delivery in a health facility
woman_bl <- woman_bl %>%
  mutate(last = as.numeric(lastbfac == 1))
attr(woman_bl$last, "label") <- "Last birth in health facility"

# Household assets
woman_bl <- woman_bl %>%
  mutate(across(radio:fridge, ~ifelse(is.na(.), NA, . - 1))) %>%
  mutate(asset = rowSums(select(., radio:fridge), na.rm = TRUE))
attr(woman_bl$asset, "label") <- "Household assets (out of 11)"

# Keep only needed variables
vars_to_keep <- c("wid", "blmth", "gest", "age", "magedum", "hausa", "moslem", 
                  paste0("mschool", 1:4), "notread", "autonomy", "priorb", 
                  "first", "pastdeath", "last", "hhsize", "car", "asset")

woman_bl <- woman_bl %>%
  select(all_of(vars_to_keep))

# Merge in follow-up data
master <- master %>%
  left_join(woman_bl, by = "wid")

# Save the updated master dataset
write_dta(master, file.path(analysis_dir, "master.dta"))

#-------------------------------------------------------------------------
# Create analysis variables
#-------------------------------------------------------------------------

# Attrition
master <- master %>%
  mutate(attrit = as.numeric(consent == 1 | followup == 1))
attr(master$attrit, "label") <- "Dropped out from study"

# Place of delivery
cond <- "consent == 2"
var <- "delplace"

master <- master %>%
  mutate(
    delplace1 = as.numeric(delplace %in% c(1, 2) & consent == 2),
    delplace2 = as.numeric(delplace %in% c(3, 4) & consent == 2),
    delplace3 = as.numeric(delplace == 5 & consent == 2),
    delplace4 = as.numeric(delplace %in% c(6, 7, 8) & consent == 2),
    delplace5 = as.numeric(delplace == 9 & consent == 2),
    delplace6 = as.numeric(delplace %in% c(10, 11, 12, 13) & consent == 2)
  )

# Apply value labels to delplace variables
for (i in 1:6) {
  master[[paste0("delplace", i)]] <- haven::labelled(
    master[[paste0("delplace", i)]],
    c("No" = 0, "Yes" = 1)
  )
}

# Add variable labels
attr(master$delplace1, "label") <- "At home"
attr(master$delplace2, "label") <- "Government hospital"
attr(master$delplace3, "label") <- "Health center"
attr(master$delplace4, "label") <- "Other health center"
attr(master$delplace5, "label") <- "Private hospital/clinic"
attr(master$delplace6, "label") <- "Other location"

# Facility delivery
master <- master %>%
  mutate(
    facility = case_when(
      consent == 2 ~ 0,
      TRUE ~ NA_real_
    ),
    facility = case_when(
      delplace >= 3 & delplace <= 9 ~ 1,
      TRUE ~ facility
    )
  )
attr(master$facility, "label") <- "Gave birth in a hospital/clinic"
master$facility <- haven::labelled(master$facility, c("No" = 0, "Yes" = 1))

# Received medical care during pregnancy
# First create ancfacility with 0 for non-missing anc values
master <- master %>%
  mutate(
    ancfacility = case_when(
      !is.na(anc) ~ 0,
      TRUE ~ NA_real_
    )
  )

# Update ancfacility if any of ancplace3 through ancplace9 is 1
for (i in 3:9) {
  col_name <- paste0("ancplace", i)
  
  # Check if the column exists
  if (col_name %in% names(master)) {
    master <- master %>%
      mutate(
        ancfacility = case_when(
          get(col_name) == 1 ~ 1,  # Changed from 2 to 1 to match Stata
          !is.na(ancfacility) ~ ancfacility,  # Keep existing non-NA values
          TRUE ~ NA_real_
        )
      )
  }
}

master <- master %>%
  mutate( 
    anc3 = case_when(
      !is.na(ancfacility) & ancvisits >= 3 & !is.na(ancvisits) ~ 1,
      !is.na(ancfacility) ~ 0,
      TRUE ~ NA_real_
    ),
    anc3 = case_when(
      ancfacility == 0 ~ 0,
      TRUE ~ anc3
    ),
    
    usedcare = case_when(
      consent == 2 ~ 0,
      TRUE ~ NA_real_
    ),
    usedcare = case_when(
      (facility == 1 | anc3 == 1) & usedcare == 0 ~ 1,
      TRUE ~ usedcare
    )
  )
attr(master$usedcare, "label") <- "Received medical care"

# Received care from doctor
master <- master %>%
  mutate(
    doctorcare1 = as.numeric((carddoc1 == 2 | carddoc2 == 2) & consent == 2),
    doctorcare2 = as.numeric((ancprov1 == 2 | delprov1 == 2) & consent == 2)
  )
attr(master$doctorcare1, "label") <- "Received care from doctor (card)"
attr(master$doctorcare2, "label") <- "Received care from doctor (self-report)"
# Function to convert month-year strings to numeric months since a reference date
convert_month_to_numeric <- function(month_str) {
  if (is.na(month_str) || month_str == "") {
    return(NA_real_)
  }
  
  # Parse the month-year string
  date <- try(as.Date(paste0("01 ", month_str), format = "%d %b %Y"), silent = TRUE)
  
  # If parsing fails, return NA
  if (inherits(date, "try-error") || is.na(date)) {
    return(NA_real_)
  }
  
  # Convert to numeric representation (months since Jan 1960, similar to Stata's monthly function)
  year <- as.numeric(format(date, "%Y"))
  month_num <- as.numeric(format(date, "%m"))
  
  # Calculate months since Jan 1960
  return((year - 1960) * 12 + month_num - 1)
}

# First convert month to numeric
master <- master %>%
  mutate(
    month_numeric = sapply(month, convert_month_to_numeric),
    pregmths = as.numeric(pregmths),
    pregweeks = as.numeric(pregweeks),
    blmth = as.numeric(blmth),
    gest = as.numeric(gest)
  )

# Now use month_numeric in the case_when statement
master <- master %>%
  mutate(
    pstart = case_when(
      outcome == 1 ~ month_numeric - 10,  # use standard duration if reported as birth
      outcome %in% c(2, 3) & !is.na(pregmths) ~ month_numeric - pregmths,  # use pregnancy age at termination if pregnancy terminated early
      outcome %in% c(2, 3) & !is.na(pregweeks) ~ month_numeric - round(pregweeks/4),
      (consent == 1 | outcome == 4) ~ blmth - gest,  # use gestational age at enrollment if no consent or died during pregnancy
      !is.na(outcome) ~ blmth - gest,  # use gestational age at enrollment if missing date
      TRUE ~ NA_real_
    )
  )
# Apply the conversion to the month column
master <- master %>%
  mutate(
    month_numeric = sapply(month, convert_month_to_numeric),
    pregmths = as.numeric(pregmths),
    pregweeks = as.numeric(pregweeks),
    blmth = as.numeric(blmth),
    gest = as.numeric(gest)
  )
# First estimate the start month of the pregnancy
master <- master %>%
  mutate(
    pregmths = as.numeric(pregmths),
    pregweeks = as.numeric(pregweeks),
    blmth = as.numeric(blmth),
    gest = as.numeric(gest)
  )



# Then calculate dosage
master <- master %>%
  mutate(
    # If preg end date is before provider start date: end date-start date
    dosage = case_when(
      !is.na(month_numeric) & month_numeric < startdate ~ month_numeric - startdate,
      TRUE ~ NA_real_
    ),
    # If preg end date is after provider start date: min(posting end date, preg end date)-max(posting start date, preg start date)
    dosage = case_when(
      !is.na(month) & month >= startdate ~ pmin(stopdate, month_numeric) - pmax(startdate, pstart),
      TRUE ~ dosage
    ),
    # Code as 0 if no provider posted
    dosage = case_when(
      duration == 0 ~ 0,
      TRUE ~ dosage
    )
  )
attr(master$dosage, "label") <- "Months of exposure"

# Remove temporary variable
master <- master %>% select(-pstart)

# Treatment dose dummy
master <- master %>%
  mutate(
    dose = case_when(
      !is.na(dosage) ~ 1,
      TRUE ~ NA_real_
    )
  )

# Calculate median dosage
dosage_median <- median(master$dosage, na.rm = TRUE)

master <- master %>%
  mutate(
    dose = case_when(
      dose == 1 & dosage > dosage_median ~ 2,
      TRUE ~ dose
    )
  )

# Add value labels to dose
master$dose <- haven::labelled(
  master$dose,
  c("Low" = 1, "High" = 2)
)
attr(master$dose, "label") <- "Treatment dose"

# Mortality
master <- master %>%
  mutate(
    mort7 = as.numeric(diedage == 1 & consent == 2),
    mort30 = as.numeric(diedage <= 2 & consent == 2)
  )
attr(master$mort7, "label") <- "7-day mortality"
attr(master$mort30, "label") <- "30-day mortality"

# Male child
master <- master %>%
  mutate(
    male = as.numeric(sex == 1 & consent == 2)
  )
attr(master$male, "label") <- "Male infant"

# In utero death
master <- master %>%
  mutate(
    inut = as.numeric((outcome > 1 | alive == 1) & consent == 2)
  )
attr(master$inut, "label") <- "In utero death"

# Multiple pregnancy
master <- master %>%
  mutate(
    multiple = as.numeric(multip == 2 & consent == 2)
  )
attr(master$multiple, "label") <- "Multiple birth"

master <- master %>%
  mutate(
    # Create temporary date column
    temp_date = as.Date(paste0("01 ", month), format = "%d %b %Y", optional = TRUE),
    
    # Extract quarter information
    qtr = ifelse(!is.na(delplace) & !is.na(temp_date), 
                 paste0(year(temp_date), "q", quarter(temp_date)), 
                 NA_character_),
    
    # Remove temporary column
    temp_date = NULL
  )
attr(master$qtr, "label") <- "Quarter of birth"

# Caesarean
master <- master %>%
  mutate(
    csection = as.numeric(cesarean == 2 & consent == 2)
  )
attr(master$csection, "label") <- "Caesarean delivery"

# Treatment dummies
master <- master %>%
  mutate(
    control = as.numeric(clinictreat == 1),
    mlp = as.numeric(clinictreat == 2),
    doctor = as.numeric(clinictreat == 3)
  )
attr(master$control, "label") <- "Control"
attr(master$mlp, "label") <- "MLP Village"
attr(master$doctor, "label") <- "Doctor Village"

# Apply value labels to binary variables
binary_vars <- c("attrit", paste0("mschool", 1:4), "hausa", "moslem", "notread", 
                 "autonomy", "first", "last", "usedcare", "doctorcare1", "doctorcare2", 
                 "mort7", "mort30", "male", "csection", "control", "mlp", "doctor")

for (var in binary_vars) {
  if (var %in% names(master)) {
    master[[var]] <- haven::labelled(
      master[[var]],
      c("No" = 0, "Yes" = 1)
    )
  }
}

# Save the updated master dataset
write_dta(master, file.path(analysis_dir, "master.dta"))

#---------------------------------------------------------------
# Save files
#---------------------------------------------------------------

# Woman file
woman_data <- master %>%
  # Group by woman ID and calculate max values for mortality variables
  group_by(wid) %>%
  mutate(
    mort = max(mort7[consent == 2], na.rm = TRUE),
    inutero = max(inut[consent == 2], na.rm = TRUE)
  ) %>%
  ungroup()

# Fix NA values that might result from empty groups
woman_data <- woman_data %>%
  mutate(
    mort = ifelse(is.infinite(mort), NA, mort),
    inutero = ifelse(is.infinite(inutero), NA, inutero)
  )

# Add variable labels
attr(woman_data$mort, "label") <- "Woman's child died in the first week"
attr(woman_data$inutero, "label") <- "Woman experienced an in utero death"

# Drop child variables
child_vars <- c(
  "multip", "outcome", "alive", "sex", "diedage", "mort7", "mort30", 
  "male", "inut", "multiple", "csection"
)
# Also drop any variables starting with "__0000"
drop_vars <- c(child_vars, grep("^__0000", names(woman_data), value = TRUE))
drop_vars <- drop_vars[drop_vars %in% names(woman_data)]

woman_data <- woman_data %>%
  select(-all_of(drop_vars))

# Keep only one record per woman
woman_data <- woman_data %>%
  distinct(wid, .keep_all = TRUE)

# Save woman file
write_dta(woman_data, file.path(analysis_dir, "woman.dta"))

# Child file
child_data <- master %>%
  filter(alive == 2)

# Drop any variables starting with "__0000"
drop_vars <- grep("^__0000", names(child_data), value = TRUE)
child_data <- child_data %>%
  select(-all_of(drop_vars))

# Save child file
write_dta(child_data, file.path(analysis_dir, "child.dta"))

#---------------------------------------------------------------------
# Provider data
#---------------------------------------------------------------------

# Load provider data
provider <- read_dta(file.path(intermediate_dir, "provider.dta"))

# Score on general medical knowledge module 
provider <- provider %>%
  mutate(
    # Calculate mean score by converting factors to numeric properly
    mscore = rowMeans(across(starts_with("mcq"), ~as.numeric(.) == 2), na.rm = TRUE)
  )
attr(provider$mscore, "label") <- "Basic medical knowledge (%)"

# Score on obstetric module
#cs_pattern <- grep("^cs_._.$|^cs_._...$", names(provider), value = TRUE)
provider <- provider %>%
  mutate(
    cscore = select(., matches("^cs_._.$|^cs_._...$")) %>% 
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE)
  )
attr(provider$cscore, "label") <- "Emergency obstetric care (%)"

# Performance on Vignette 1
provider <- provider %>%
  mutate(
    # For v1hx - convert from 1/2 to 0/1 coding
    v1hx = select(., starts_with("v1hx_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For v1exam - convert from 1/2 to 0/1 coding
    v1exam = select(., starts_with("v1pe_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For v1lab - convert from 1/2 to 0/1 coding
    v1lab = select(., starts_with("v1lab_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For v1educ - convert from 1/2 to 0/1 coding
    v1educ = select(., starts_with("v1educ_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For vscore1 - convert from 1/2 to 0/1 coding
    vscore1 = select(., starts_with("v1hx_"), starts_with("v1pe_"), 
                     starts_with("v1lab_"), starts_with("v1educ_"),
                     "v1diag1", "v1treat_tb") %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE)
  )

# Performance on Vignette 2
provider <- provider %>%
  mutate(
    # For v2hx - convert from 1/2 to 0/1 coding
    v2hx = select(., starts_with("v2hx_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For v2exam - convert from 1/2 to 0/1 coding
    v2exam = select(., starts_with("v2pe_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For v2lab - convert from 1/2 to 0/1 coding
    v2lab = select(., starts_with("v2lab_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For v2educ - convert from 1/2 to 0/1 coding
    v2educ = select(., starts_with("v2educ_")) %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE),
    
    # For vscore2 - convert from 1/2 to 0/1 coding
    vscore2 = select(., starts_with("v2hx_"), starts_with("v2pe_"), 
                     starts_with("v2lab_"), starts_with("v2educ_"),
                     "v2diag1", "v2treat_malaria", "v2treat_folate") %>%
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE)
  )

# Add labels
for (i in 1:2) {
  attr(provider[[paste0("v", i, "hx")]], "label") <- paste0("Vignette ", i, " history score")
  attr(provider[[paste0("v", i, "exam")]], "label") <- paste0("Vignette ", i, " examination score")
  attr(provider[[paste0("v", i, "lab")]], "label") <- paste0("Vignette ", i, " lab test score")
  attr(provider[[paste0("v", i, "educ")]], "label") <- paste0("Vignette ", i, " patient education score")
  attr(provider[[paste0("vscore", i)]], "label") <- paste0("Vignette ", i, " total score")
}

# Average performance across vignettes
provider <- provider %>%
  mutate(
    # First select all the vignette variables and convert from 1/2 to 0/1
    vscore = select(., matches("v[12]hx_|v[12]pe_|v[12]lab_|v[12]educ_|v[12]diag1"), 
                    "v1treat_tb", "v2treat_malaria", "v2treat_folate") %>%
      # Convert from 1/2 coding to 0/1 coding
      mutate(across(everything(), ~(. - 1))) %>%
      rowMeans(na.rm = TRUE) * 100
  )
attr(provider$vscore, "label") <- "Outpatient primary care (%)"

# Average score on proficiency tests
provider <- provider %>%
  mutate(
    mscore = mscore * 100,
    cscore = cscore * 100,
    vscore1 = vscore1 * 100,
    vscore2 = vscore2 * 100,
    qscore = rowMeans(select(., mscore, cscore, vscore1, vscore2), na.rm = TRUE) * 100
  )
attr(provider$qscore, "label") <- "Proficiency score (%)"

# Aggregate using Principal Component Analysis
# First, select all variables for PCA
pca_vars <- provider %>%
  select(starts_with("mcq"), matches("cs_[0-9]_"), 
         matches("v[12]hx_|v[12]pe_|v[12]lab_|v[12]educ_|v[12]diag1"), 
         "v1treat_tb", "v1treat_refer", "v2treat_malaria", "v2treat_folate")

# Run PCA
pca_result <- prcomp(pca_vars, scale = TRUE, center = TRUE, na.action = na.omit)

# Extract first principal component
provider$x <- predict(pca_result, newdata = pca_vars)[,1]

# Standardize against the control group
control_mean <- mean(provider$x[provider$clinictreat == 1], na.rm = TRUE)
control_sd <- sd(provider$x[provider$clinictreat == 1], na.rm = TRUE)

provider <- provider %>%
  mutate(
    qindex = (x - control_mean) / control_sd
  )
attr(provider$qindex, "label") <- "Standardized proficiency"

# Remove temporary variable
provider <- provider %>% select(-x)

# Facility-level averages
provider <- provider %>%
  group_by(fid) %>%
  mutate(
    avgqscore = mean(qscore, na.rm = TRUE),
    avgqindex = mean(qindex, na.rm = TRUE)
  ) %>%
  ungroup()

attr(provider$avgqscore, "label") <- "Average proficiency score"
attr(provider$avgqindex, "label") <- "Average standardized quality"

# Rename provtype to provider
provider <- provider %>%
  rename(provider = provtype)

# Save
write_dta(provider, file.path(analysis_dir, "provider.dta"))

#---------------------------------------------------------------------
# Patient data
#---------------------------------------------------------------------

# Load patient data
patient <- read_dta(file.path(intermediate_dir, "patient.dta"))

# Presenting complaint
# Create empty variables for all complaints
complaint_vars <- c("fever", "headache", "abd_pain", "cough", "weakness", "diarrhea", 
                    "vomiting", "chest_pain", "pregnancy", "back_pain", "feeling_ill", 
                    "genital", "leg", "sneezing", "rash", "eyedischarge", "redeye", 
                    "dizziness", "sob", "nausea", "abd_distention", "chills", "pain", 
                    "hypertension", "earache", "appetite", "eardischarge", "eyepain")

for (var in complaint_vars) {
  patient[[var]] <- 0
}

# Map ICPC-2 codes to complaints
for (i in 1:8) {
  code_col <- paste0("code", i)
  
  # Only process if the code column exists
  if (code_col %in% names(patient)) {
    patient <- patient %>%
      mutate(
        pain = ifelse(get(code_col) == "A01", 1, pain),
        chills = ifelse(get(code_col) == "A02", 1, chills),
        fever = ifelse(get(code_col) == "A03", 1, fever),
        weakness = ifelse(get(code_col) == "A04", 1, weakness),
        feeling_ill = ifelse(get(code_col) == "A05", 1, feeling_ill),
        chest_pain = ifelse(get(code_col) == "A11", 1, chest_pain),
        abd_pain = ifelse(get(code_col) == "D01", 1, abd_pain),
        nausea = ifelse(get(code_col) == "D09", 1, nausea),
        vomiting = ifelse(get(code_col) == "D10", 1, vomiting),
        diarrhea = ifelse(get(code_col) == "D11", 1, diarrhea),
        abd_distention = ifelse(get(code_col) == "D25", 1, abd_distention),
        eyepain = ifelse(get(code_col) == "F01", 1, eyepain),
        redeye = ifelse(get(code_col) == "F02", 1, redeye),
        eyedischarge = ifelse(get(code_col) == "F03", 1, eyedischarge),
        earache = ifelse(get(code_col) == "H01", 1, earache),
        eardischarge = ifelse(get(code_col) == "H04", 1, eardischarge),
        hypertension = ifelse(get(code_col) == "K25", 1, hypertension),
        back_pain = ifelse(get(code_col) %in% c("L02", "L03"), 1, back_pain),
        leg = ifelse(get(code_col) %in% c("L14", "L15", "L16", "L17"), 1, leg),
        headache = ifelse(get(code_col) == "N01", 1, headache),
        dizziness = ifelse(get(code_col) == "N17", 1, dizziness),
        sob = ifelse(get(code_col) == "R02", 1, sob),
        cough = ifelse(get(code_col) == "R05", 1, cough),
        sneezing = ifelse(get(code_col) == "R07", 1, sneezing),
        rash = ifelse(get(code_col) %in% c("S06", "S07"), 1, rash),
        appetite = ifelse(get(code_col) == "T03", 1, appetite),
        pregnancy = ifelse(grepl("W", get(code_col)), 1, pregnancy),
        genital = ifelse(grepl("X|Y", get(code_col)), 1, genital)
      )
  }
}

# Add variable labels
complaint_labels <- c(
  "Complains of fever", "Complains of headache", "Complains of abdominal pain",
  "Complains of cough", "Complains of tiredness/weakness", "Complains of diarrhea",
  "Complains of vomiting", "Complains of chest pain", "Pregnancy-related visit",
  "Back complaint", "Complains of feeling ill", "Genital complaint", "Leg complaint",
  "Complains of nasal congestion", "Complains of rash", "Complains of eye discharge",
  "Complains of red eye", "Complains of dizziness", "Complains of shortness of breath",
  "Complains of nausea", "Complains of abdominal distention", "Complains of chills",
  "Complains of general pain", "Complains of hypertension", "Complains of ear ache",
  "Complains of poor appetite", "Complains of ear discharge", "Complains of eye pain"
)

for (i in 1:length(complaint_vars)) {
  attr(patient[[complaint_vars[i]]], "label") <- complaint_labels[i]
}

# Group age into categories because of measurement error
patient <- patient %>%
  mutate(
    agegp = cut(age, breaks = c(0, 5, 10, 20, 30, 40, 50, 100), include.lowest = TRUE, right = FALSE)
  )

# Create dummy variables for age groups
patient <- patient %>%
  mutate(
    agegroup1 = as.numeric(agegp == "[0,5)"),
    agegroup2 = as.numeric(agegp == "[5,10)"),
    agegroup3 = as.numeric(agegp == "[10,20)"),
    agegroup4 = as.numeric(agegp == "[20,30)"),
    agegroup5 = as.numeric(agegp == "[30,40)"),
    agegroup6 = as.numeric(agegp == "[40,50)"),
    agegroup7 = as.numeric(agegp == "[50,100)")
  )

# Add variable labels for age groups
attr(patient$agegroup1, "label") <- "Age < 5 years"
attr(patient$agegroup2, "label") <- "Age 5-9 years"
attr(patient$agegroup3, "label") <- "Age 10-19 years"
attr(patient$agegroup4, "label") <- "Age 20-29 years"
attr(patient$agegroup5, "label") <- "Age 30-39 years"
attr(patient$agegroup6, "label") <- "Age 40-49 years"
attr(patient$agegroup7, "label") <- "Age 50 or older"

# Drop temporary variable
patient <- patient %>% select(-agegp)

# Health variables: Recode so that higher is better
# First, create value labels
health_labels <- c("Poor" = 1, "Fair" = 2, "Good" = 3, "Very good" = 4, "Excellent" = 5)
status_labels <- c("A lot" = 1, "Some" = 2, "None" = 3)

# Recode bhealth
patient <- patient %>%
  mutate(
    bhealth = case_when(
      bhealth == 99 ~ NA_real_,
      bhealth == 5 ~ 1,
      bhealth == 4 ~ 2,
      bhealth == 2 ~ 4,
      bhealth == 1 ~ 5,
      TRUE ~ bhealth
    )
  )
patient$bhealth <- haven::labelled(patient$bhealth, health_labels)

# Recode walk, run, ache, sleep
for (var in c("walk", "run", "ache", "sleep")) {
  if (var %in% names(patient)) {
    patient <- patient %>%
      mutate(
        !!sym(var) := case_when(
          get(var) == 3 ~ 1,
          get(var) == 1 ~ 3,
          TRUE ~ get(var)
        )
      )
    patient[[var]] <- haven::labelled(patient[[var]], status_labels)
  }
}

# Create dummy variables for health variables
for (var in c("bhealth", "walk", "run")) {
  if (var %in% names(patient)) {
    # Get unique values
    values <- sort(unique(patient[[var]]))
    values <- values[!is.na(values)]
    
    # Create dummy for each value
    for (val in values) {
      new_var <- paste0(var, val)
      patient[[new_var]] <- as.numeric(patient[[var]] == val)
    }
  }
}

# Create other dummy variables
patient <- patient %>%
  mutate(
    walked = as.numeric(transport == 1),
    car = as.numeric(transport == 4),
    male = as.numeric(sex == 1),
    severe = as.numeric(severity >= 7 & !is.na(severity))
  )

# Add variable labels
attr(patient$male, "label") <- "Male"
attr(patient$severe, "label") <- "Severity score 7 or higher"
attr(patient$walk3, "label") <- "Difficulty walking: None"
attr(patient$walk2, "label") <- "Difficulty walking: Some"
attr(patient$walk1, "label") <- "Difficulty walking: A lot"
attr(patient$run3, "label") <- "Difficulty running: None"
attr(patient$run2, "label") <- "Difficulty running: Some"
attr(patient$run1, "label") <- "Difficulty running: A lot"
attr(patient$bhealth1, "label") <- "Poor"
attr(patient$bhealth2, "label") <- "Fair"
attr(patient$bhealth3, "label") <- "Good"
attr(patient$bhealth4, "label") <- "Very good"
attr(patient$bhealth5, "label") <- "Excellent"
attr(patient$walked, "label") <- "Transport to clinic: walked"
attr(patient$car, "label") <- "Transport to clinic: own car/motorcycle"

# Apply value labels to binary variables
binary_vars <- c(
  paste0("agegroup", 1:7),
  paste0("bhealth", 1:5),
  paste0("walk", 1:3),
  paste0("run", 1:3),
  complaint_vars,
  "severe", "male"
)

for (var in binary_vars) {
  if (var %in% names(patient)) {
    patient[[var]] <- haven::labelled(
      patient[[var]],
      c("No" = 0, "Yes" = 1)
    )
  }
}

# Save
write_dta(patient, file.path(analysis_dir, "patient.dta"))

#---------------------------------------------------------------------
# Audit data
#---------------------------------------------------------------------

# Load audit data
audit <- read_dta(file.path(intermediate_dir, "audit.dta"))

# Merge with deployment data
dates <- read_dta(file.path(raw_dir, "dates.dta"))
audit <- merge(audit, dates, by = "fid", all.x = TRUE)

# Remove .y columns (keeping master version of duplicated variables)
y_cols <- grep("\\.y$", names(audit), value = TRUE)
audit <- audit[, !names(audit) %in% y_cols]

# Rename .x columns back to original names
x_cols <- grep("\\.x$", names(audit), value = TRUE)
for (col in x_cols) {
  base_name <- sub("\\.x$", "", col)
  names(audit)[names(audit) == col] <- base_name
}

# Keep only rows that exist in audit or in both datasets (equivalent to keep(1 3))
audit <- audit[!is.na(audit$visitdate), ]

# Identify audit visits that took place during the provider's posting
audit$auditwhen <- audit$visitdate - audit$startdate
# Add variable label (R doesn't have built-in labels, but we can add a comment)
# "Timing of visit relative to provider startdate (months)"

# Replace with NA if before provider arrived
audit$auditwhen[audit$auditwhen < 0] <- NA
# Replace with NA if after provider left
audit$auditwhen[audit$visitdate > audit$stopdate] <- NA

# Count number of visits by facility
visits_count <- aggregate(audit$fid, by = list(audit$fid), FUN = length)
colnames(visits_count) <- c("fid", "visits")
audit <- merge(audit, visits_count, by = "fid", all.x = TRUE)
# "Number of audit visits"

# Save
write_dta(audit, file.path(analysis_dir, "audit.dta"))
#---------------------------------------------------------------------
# Provider assessment data
#---------------------------------------------------------------------

# Load facility data
facility_el <- read_dta(file.path(intermediate_dir, "facility_el.dta"))

# Add row number for sorting later
facility_el$n <- seq_len(nrow(facility_el))

# Merge in provider start/end dates
impact <- merge(facility_el, dates, by = "fid", all.x = TRUE)
# Check what columns actually exist in the impact dataframe
print(names(impact))

# Modify the column selection to only include columns that exist
# First, get the impact columns that actually exist
impact_cols <- grep("^impact", names(impact), value = TRUE)

# Create a vector of basic columns we want to keep
basic_cols <- c("state", "sid", "strata", "fid")

# Check which of these basic columns actually exist
existing_basic_cols <- basic_cols[basic_cols %in% names(impact)]

# Check if "ideas" and "clinict" exist
additional_cols <- c("ideas", "clinict")
existing_additional_cols <- additional_cols[additional_cols %in% names(impact)]

# Combine all existing columns
all_cols_to_keep <- c(existing_basic_cols, impact_cols, existing_additional_cols)

# Now select only these columns
impact <- impact[, all_cols_to_keep]

# Save
write_dta(impact, file.path(analysis_dir, "impact.dta"))

#---------------------------------------------------------------------
# Clinic staff roster
#---------------------------------------------------------------------

# Load roster data
roster <- read_dta(file.path(raw_dir, "roster.dta"))

# Doctor on staff at various timepoints

# doctor1
roster$x <- ifelse(roster$provtype == 1 & roster$present1 == 1 & is.na(roster$studyprov), 1, NA)
doctor1 <- aggregate(x ~ fid, data = roster, FUN = min, na.rm = TRUE)
names(doctor1)[2] <- "doctor1"
roster <- merge(roster, doctor1, by = "fid", all.x = TRUE)
roster$doctor1[is.na(roster$doctor1)] <- 0
roster$x <- NULL

# doctor2
roster$x <- ifelse(roster$provtype == 1 & roster$present1 == 1, 1, NA)
doctor2 <- aggregate(x ~ fid, data = roster, FUN = min, na.rm = TRUE)
names(doctor2)[2] <- "doctor2"
roster <- merge(roster, doctor2, by = "fid", all.x = TRUE)
roster$doctor2[is.na(roster$doctor2)] <- 0
roster$x <- NULL

# doctor3
roster$x <- ifelse(roster$provtype == 1 & roster$present2 == 1 & roster$present12 > 0, 1, NA)
doctor3 <- aggregate(x ~ fid, data = roster, FUN = min, na.rm = TRUE)
names(doctor3)[2] <- "doctor3"
roster <- merge(roster, doctor3, by = "fid", all.x = TRUE)
roster$doctor3[is.na(roster$doctor3)] <- 0
roster$x <- NULL

# Number of health workers at various timepoints

# staff1
roster$x <- ifelse(roster$present1 == 1 & is.na(roster$studyprov), 1, 0)
staff1 <- aggregate(x ~ fid, data = roster, FUN = sum)
names(staff1)[2] <- "staff1"
roster <- merge(roster, staff1, by = "fid", all.x = TRUE)
roster$staff1[is.na(roster$staff1)] <- 0
roster$x <- NULL

# staff2
staff2 <- aggregate(present1 ~ fid, data = roster, FUN = sum)
names(staff2)[2] <- "staff2"
roster <- merge(roster, staff2, by = "fid", all.x = TRUE)
roster$staff2[is.na(roster$staff2)] <- 0

# staff3
staff3 <- aggregate(present2 ~ fid, data = roster, FUN = sum)
names(staff3)[2] <- "staff3"
roster <- merge(roster, staff3, by = "fid", all.x = TRUE)
roster$staff3[is.na(roster$staff3)] <- 0

# Remove duplicates, keeping one row per facility
roster_unique <- roster[!duplicated(roster$fid), ]

# Keep only needed variables
roster_unique <- roster_unique[, c("state", "sid", "strata", "fid", 
                                   "doctor1", "doctor2", "doctor3", 
                                   "staff1", "staff2", "staff3", 
                                   "clinictreat")]

# Reshape the data from wide to long
staffing <- pivot_longer(
  roster_unique,
  cols = c(starts_with("doctor"), starts_with("staff")),
  names_to = c(".value", "visit"),
  names_pattern = "(doctor|staff)(\\d)"
)

# Convert visit to numeric
staffing$visit <- as.numeric(staffing$visit)

# Add variable labels (as attributes in R)
attr(staffing$doctor, "label") <- "Doctor on staff"
attr(staffing$staff, "label") <- "Number of providers"
attr(staffing$visit, "label") <- "Visit timing"

# Create a factor for visit with labels
staffing$visit <- factor(staffing$visit, 
                         levels = 1:3, 
                         labels = c("T0", "T1", "T2"))

# Save
write_dta(staffing, file.path(analysis_dir, "staffing.dta"))
