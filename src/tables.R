#######################################################################################################
## This file generates the main tables in the Paper
#######################################################################################################

# Load required packages
library(dplyr)
library(fixest)
library(hdm)
library(modelsummary)
library(haven)

# Define directory paths
raw_dir <- "../data/raw"
intermediate_dir <- "../data/intermediate"
analysis_dir <- "../data/analysis"
output_dir <- "../data/output"

# Define global variables
treat <- c("mlp", "doctor")
cont_ind <- c("cct", "magedum", "first", "hausa", "mschool1", "autonomy", "car", "last", "gest")
cont_base <- c(cont_ind, "male")
cont_hc <- c("hc_deliveries", "hc_cesarean", "hc_transfusion", "hc_clean", 
             "hc_workers", "hc_open24hrs", "hc_equipment", "hc_beds", "hc_lab", 
             "hc_drugs", "hc_nopower", "hc_vent", "hc_cond")
cont_all <- c(cont_base, cont_hc, "pastdeath", "hc_workers", "hc_open24hrs", "hc_equipment", 
              "hc_beds", "hc_lab", "hc_drugs", "hc_nopower", "hc_vent", "hc_cond")
patient <- c("agegroup1", "agegroup2", "agegroup3", "agegroup4", "agegroup5", "sex", "phone", 
             "transport", "bhealth", "severity", "fever", "cough", "headache", "abd_pain", 
             "weakness", "pregnancy", "order", "interr")

#-----------------------------------------------------------------------------
# Table 2. Effect of the intervention on supply
#-----------------------------------------------------------------------------

staffing <- read_dta(file.path(analysis_dir, "staffing.dta"))

# Prepare data
staffing <- staffing %>%
  filter(visit > 1) %>%
  mutate(
    clinictreat = factor(clinictreat),
    visit = factor(visit)
  )

# Create models for staff and doctor
models <- list()

# Model 1: staff ~ clinictreat*visit
models[[1]] <- feols(staff ~ clinictreat*visit, 
                     data = staffing,
                     cluster = "fid")

# Model 2: staff ~ clinictreat*visit with strata FE
models[[2]] <- feols(staff ~ clinictreat*visit | strata, 
                     data = staffing,
                     cluster = "fid")

# Model 3: doctor ~ clinictreat*visit
models[[3]] <- feols(doctor ~ clinictreat*visit, 
                     data = staffing,
                     cluster = "fid")

# Model 4: doctor ~ clinictreat*visit with strata FE
models[[4]] <- feols(doctor ~ clinictreat*visit | strata, 
                     data = staffing,
                     cluster = "fid")

# Calculate control group means
control_means <- staffing %>%
  filter(clinictreat == 0) %>%
  summarise(
    staff_mean = mean(staff, na.rm = TRUE),
    doctor_mean = mean(doctor, na.rm = TRUE)
  )

# Create a data frame for the control means
cm_df <- data.frame(
  term = "Control group mean",
  model1 = control_means$staff_mean,
  model2 = control_means$staff_mean,
  model3 = control_means$doctor_mean,
  model4 = control_means$doctor_mean
)

# Create the table with modelsummary
modelsummary(models, 
             coef_map = c("clinictreat1" = "MLP Arm",
                          "clinictreat2" = "Doctor Arm",
                          "visit3" = "T2",
                          "clinictreat1:visit3" = "MLP Arm x T2",
                          "clinictreat2:visit3" = "Doctor Arm x T2"),
             stars = FALSE,
             gof_omit = ".*",
             add_rows = cm_df,
             fmt = "%.3f",
             estimate = "{estimate} ({std.error})",
             statistic = NULL,
             title = "Table 2. Effect of the intervention on supply",
             output = file.path(output_dir, "table2.tex"))

#-----------------------------------------------------------------------------
# Table 3. Effect on probability that health care was provided by a doctor
#-----------------------------------------------------------------------------

woman <- read_dta(file.path(analysis_dir, "woman.dta"))

# Models for doctorcare1 (Card)
card_models <- list()
# Model 1: doctorcare1 ~ mlp + doctor with strata FE
card_models[[1]] <- feols(doctorcare1 ~ mlp + doctor | strata, 
                          data = woman %>% filter(card == 2), 
                          cluster = "fid")
# Model 2: doctorcare1 ~ controls + mlp + doctor with strata FE
card_models[[2]] <- feols(as.formula(paste("doctorcare1 ~", paste(cont_ind, collapse = " + "), 
                                           "+ mlp + doctor | strata")), 
                          data = woman %>% filter(card == 2), 
                          cluster = "fid")

# Models for doctorcare2 (Self-report)
self_models <- list()
# Model 3: doctorcare2 ~ mlp + doctor with strata FE
self_models[[1]] <- feols(doctorcare2 ~ mlp + doctor | strata, 
                          data = woman, 
                          cluster = "fid")
# Model 4: doctorcare2 ~ controls + mlp + doctor with strata FE
self_models[[2]] <- feols(as.formula(paste("doctorcare2 ~", paste(cont_ind, collapse = " + "), 
                                           "+ mlp + doctor | strata")), 
                          data = woman, 
                          cluster = "fid")

# Calculate control group means
control_means <- woman %>%
  filter(mlp == 0, doctor == 0) %>%
  summarise(
    doctorcare1_mean = mean(doctorcare1[card == 2], na.rm = TRUE),
    doctorcare2_mean = mean(doctorcare2, na.rm = TRUE)
  )

# Create a data frame for the control means
cm_df <- data.frame(
  term = "Control group mean",
  model1 = control_means$doctorcare1_mean,
  model2 = control_means$doctorcare1_mean,
  model3 = control_means$doctorcare2_mean,
  model4 = control_means$doctorcare2_mean
)

# Combine models and create table
table3_models <- c(card_models, self_models)
modelsummary(table3_models, 
             coef_map = c("mlp" = "MLP Arm", "doctor" = "Doctor Arm"),
             stars = FALSE,
             gof_omit = ".*",
             add_rows = cm_df,
             fmt = "%.3f",
             estimate = "{estimate} ({std.error})",
             statistic = NULL,
             title = "Table 3. Effect on probability that health care was provided by a doctor",
             output = file.path(output_dir, "table3.tex"))
