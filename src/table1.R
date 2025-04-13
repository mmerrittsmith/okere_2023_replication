# ================================================================================
# Table 1. Baseline covariate balance
# ================================================================================

library(tidyverse)
library(lmtest)
library(car)
library(kableExtra)
library(haven)
library(sandwich)
library(systemfit)
analysis_dir <- "../data/analysis"
output_dir <- "../data/output"

run_stata_like_omnibus_test <- function(data, treatment_vars, predictor_vars, strata_var, cluster_var) {
  # Create formulas for each treatment
  formulas <- lapply(treatment_vars, function(treat) {
    as.formula(paste(treat, "~", paste(predictor_vars, collapse = " + "), 
                     "+ factor(", strata_var, ")"))
  })
  
  # Fit models
  models <- lapply(formulas, function(f) lm(f, data = data))
  names(models) <- treatment_vars
  
  # Get coefficient names for predictors (excluding intercept and strata)
  coef_names <- names(coef(models[[1]]))
  pred_coef_names <- coef_names[grep(paste(predictor_vars, collapse="|"), coef_names)]
  
  # Create constraint matrix for joint test across all models
  # This is similar to how Stata's suest works
  n_models <- length(models)
  n_preds <- length(pred_coef_names)
  
  # Prepare for joint hypothesis test
  # We need to test if all coefficients for predictors are jointly zero
  
  # Get clustered vcov for each model
  vcov_list <- lapply(models, function(m) {
    vcovCL(m, cluster = data[[cluster_var]])
  })
  
  # Perform joint test for each model with clustered standard errors
  p_values <- sapply(1:length(models), function(i) {
    model <- models[[i]]
    vcov_clustered <- vcov_list[[i]]
    
    # Test if all predictor coefficients are jointly zero
    test_result <- linearHypothesis(model, 
                                    pred_coef_names,
                                    vcov. = vcov_clustered)
    return(test_result$"Pr(>F)"[2])
  })
  
  # For a more accurate replication, we should use a seemingly unrelated regression approach
  # But as an approximation, we can use Fisher's method to combine p-values
  # This tests whether the predictors are jointly significant across all models
  
  # Fisher's method to combine p-values
  fisher_stat <- -2 * sum(log(p_values))
  combined_p <- pchisq(fisher_stat, df = 2*length(p_values), lower.tail = FALSE)
  
  return(combined_p)
}

# Initialize the LaTeX file
cat("\\small
\\begin{tabular}{lccccccc}
\\toprule
 & Control & MLP & Doctor & MLP = C & D = C & D = MLP & Joint \\\\
", file = file.path(output_dir, "table1.tex"))

# ---------------------------------------------------------------
# Panel A: health services variables
# ---------------------------------------------------------------

cat("\\multicolumn{8}{p{0.99\\textwidth}}{\\textbf{A: Health center variables}} \\\\ 
", file.path(output_dir, "table1.tex"), append = TRUE)

# Read in dataset
woman <- read_dta(file.path(analysis_dir, "woman.dta"))
woman <- woman %>% filter(consent == 2)

# Preserve dataset for health center variables
hc_data <- woman %>%
  distinct(fid, .keep_all = TRUE) %>%
  select(fid, strata, clinictreat, starts_with("hc_"), control, mlp, doctor)

# Rename hc_ variables
hc_data <- hc_data %>%
  rename_with(~str_remove(., "hc_"), starts_with("hc_"))

# Add variable labels
attr(hc_data$water, "label") <- "Has running water"
attr(hc_data$lab, "label") <- "Has a laboratory"
attr(hc_data$drugs, "label") <- "Has a pharmacy"
attr(hc_data$open24hrs, "label") <- "24-hour service"
attr(hc_data$travel_time, "label") <- "Travel time to referral hospital"
attr(hc_data$cesarean, "label") <- "Does caesarean"
attr(hc_data$transfusion, "label") <- "Does blood transfusion"
attr(hc_data$equipment, "label") <- "Essential equipment (% available)"
attr(hc_data$deliveries, "label") <- "Deliveries per month"
attr(hc_data$cond, "label") <- "General condition (1-4)"
attr(hc_data$clean, "label") <- "Cleanliness (1-4)"
attr(hc_data$vent, "label") <- "Delivery room has fan or A/C"

# Create dataframe to store p-values
pvals <- data.frame(var = character(), p1 = character(), p2 = character(), p3 = character())

# Variables for balance tests
a_vars <- c("water", "nopower", "beds", "workers", "lab", "drugs", "open24hrs", 
            "travel_time", "cesarean", "transfusion", "equipment", "deliveries", 
            "cond", "clean", "vent")

# Balance tests for Panel A
con <- file(file.path(output_dir, "table1.tex"), "a")
# hc_data <- hc_data %>% 
#  mutate(lab = lab-1, drugs = drugs-1, open24hrs = open24hrs - 1, cesarean = cesarean - 1, transfusion = transfusion-1,
#         equipment = equipment-1, vent= vent-1)

for (var in a_vars) {
  cat("Processing variable:", var, "\n", file = con)
  # Calculate means by treatment group
  means <- hc_data %>%
    mutate(clinictreat_num = as.numeric(clinictreat)) %>%
    group_by(clinictreat_num) %>%
    summarize(mean = mean(!!sym(var), na.rm = TRUE)) %>%
    mutate(mean_str = sprintf("%.3f", mean))
  
  formula <- as.formula(paste(var, "~ mlp + doctor | strata"))
  cat("Formula:", deparse(formula), "\n")
  
  # Check if the variable has variation
  if (var(hc_data[[var]], na.rm = TRUE) == 0) {
    p1 <- p2 <- p3 <- p_all <- "NA"
  } else {
    # Run the regression
    reg <- feols(formula, data = hc_data, cluster = "fid")
    print(summary(reg))
    
    # Get p-values directly from the regression summary
    coef_table <- summary(reg)$coeftable
    
    # Extract p-values
    p1 <- if ("mlp" %in% rownames(coef_table)) 
      sprintf("%.2f", coef_table["mlp", "Pr(>|t|)"]) else "NA"
    
    p2 <- if ("doctor" %in% rownames(coef_table)) 
      sprintf("%.2f", coef_table["doctor", "Pr(>|t|)"]) else "NA"
    
    # For mlp = doctor test
    library(car)
    test_mlp_doctor <- linearHypothesis(reg, "mlp = doctor")
    p3 <- sprintf("%.2f", test_mlp_doctor$`Pr(>Chisq)`[2])
    
    # Joint test
    test_joint <- waldtest(reg, c("mlp", "doctor"))
    p_all <- sprintf("%.2f", test_joint$`Pr(>Chisq)`[2])
  }
  
  # Get mean values, handling potential missing groups
  mean0 <- means$mean_str[means$clinictreat_num == 1]  # Control
  mean1 <- means$mean_str[means$clinictreat_num == 2]  # MLP
  mean2 <- means$mean_str[means$clinictreat_num == 3]  # Doctor
  
  # Handle missing values
  if (length(mean0) == 0) mean0 <- "NA"
  if (length(mean1) == 0) mean1 <- "NA"
  if (length(mean2) == 0) mean2 <- "NA"
  
  # Write to LaTeX file
  var_label <- attr(hc_data[[var]], "label")
  if (is.null(var_label)) var_label <- var
  
  cat(sprintf("%s & %s & %s & %s & %s & %s & %s & %s\\\\\n", 
              var_label, mean0, mean1, mean2, p1, p2, p3, p_all), 
      file = con)
}
# Sample sizes
n_by_group <- hc_data %>%
  group_by(clinictreat) %>%
  summarize(n = n())

cat(sprintf("Sample size & %d & %d & %d & & & & \\\\\n", 
            n_by_group$n[n_by_group$clinictreat == 1],
            n_by_group$n[n_by_group$clinictreat == 2],
            n_by_group$n[n_by_group$clinictreat == 3]),
    file = file.path(output_dir, "table1.tex"), append = TRUE)

# Omnibus test
omnibus_p <- run_stata_like_omnibus_test(
  data = hc_data,
  treatment_vars = c("mlp", "doctor"),
  predictor_vars = a_vars,
  strata_var = "strata",
  cluster_var = "fid"
)
omnibus_p_formatted <- sprintf("%.2f", omnibus_p)
cat(sprintf("Omnibus test (p-value) & & & & & & & %s \\\\\n\\midrule\n", omnibus_p_formatted), 
    file = file.path(output_dir, "table1.tex"), append = TRUE)

# ---------------------------------------------------------------
# Panel B: Participant characteristics
# ---------------------------------------------------------------

cat("\\multicolumn{8}{p{0.99\\textwidth}}{\\textbf{B: Mother and Household variables}} \\\\ 
", file = file.path(output_dir, "table1.tex"), append = TRUE)

# Define variables for Panel B
b_vars <- c("age", "hausa", "moslem", "mschool1", "notread", "autonomy", "priorb", 
            "pastdeath", "last", "cct", "asset", "hhsize")

# Add variable labels for Panel B
attr(woman$age, "label") <- "Mother's age (years)"
attr(woman$hausa, "label") <- "Hausa/Fulani ethnicity"
attr(woman$moslem, "label") <- "Religion is Islam"
attr(woman$mschool1, "label") <- "No formal schooling"
attr(woman$notread, "label") <- "Cannot read"
attr(woman$autonomy, "label") <- "Husband makes health-care decisions"
attr(woman$priorb, "label") <- "Number of prior births"
attr(woman$pastdeath, "label") <- "Prior stillbirth or newborn death"
attr(woman$last, "label") <- "Last birth in health facility"
attr(woman$cct, "label") <- "Offered conditional incentive"
attr(woman$asset, "label") <- "Household assets (out of 11)"
attr(woman$hhsize, "label") <- "Household size"

woman <- woman %>%
  mutate(last = replace_na(last, 0),
         autonomy = replace_na(autonomy, 0))

# Balance tests for Panel B
for (var in b_vars) {
  # Calculate means by treatment group
  means <- woman %>%
    mutate(clinictreat_num = as.numeric(clinictreat)) %>%
    group_by(clinictreat_num) %>%
    summarize(mean = mean(!!sym(var), na.rm = TRUE)) %>%
    mutate(mean_str = sprintf("%.3f", mean))
  
  # Run regression
  formula <- as.formula(paste(var, "~ mlp + doctor | strata"))
  
  # Check if the variable has variation
  if (var(woman[[var]], na.rm = TRUE) == 0) {
    cat("WARNING: Variable", var, "has no variation!\n")
    p1 <- p2 <- p3 <- p_all <- "NA"
  } else {
    # Run the regression
    reg <- feols(formula, data = woman, cluster = "fid")
    
    # Test mlp = control
    test_mlp_control <- waldtest(reg, c("mlp"))
    p1 <- sprintf("%.2f", test_mlp_control$`Pr(>Chisq)`[2])
    
    # Test doctor = control
    test_doctor_control <- waldtest(reg, c("doctor"))
    p2 <- sprintf("%.2f", test_doctor_control$`Pr(>Chisq)`[2])
    
    # Test mlp = doctor
    library(car)
    test_mlp_doctor <- linearHypothesis(reg, "mlp = doctor")
    p3 <- sprintf("%.2f", test_mlp_doctor$`Pr(>Chisq)`[2])
    
    # Joint test
    test_joint <- waldtest(reg, c("mlp", "doctor"))
    p_all <- sprintf("%.2f", test_joint$`Pr(>Chisq)`[2])
  }
  
  # Get mean values, handling potential missing groups
  mean0 <- means$mean_str[means$clinictreat_num == 1]  # Control
  mean1 <- means$mean_str[means$clinictreat_num == 2]  # MLP
  mean2 <- means$mean_str[means$clinictreat_num == 3]  # Doctor
  
  # Handle missing values
  if (length(mean0) == 0) mean0 <- "NA"
  if (length(mean1) == 0) mean1 <- "NA"
  if (length(mean2) == 0) mean2 <- "NA"
  
  # Write to LaTeX file
  var_label <- attr(woman[[var]], "label")
  if (is.null(var_label)) var_label <- var
  
  cat(sprintf("%s & %s & %s & %s & %s & %s & %s & %s\\\\\n", 
              var_label, mean0, mean1, mean2, p1, p2, p3, p_all), 
      file = file.path(output_dir, "table1.tex"), append = TRUE)
}

# Sample sizes
n_by_group <- woman %>%
  group_by(clinictreat) %>%
  summarize(n = n())

cat(sprintf("Sample size & %d & %d & %d & & & & \\\\\n", 
            n_by_group$n[n_by_group$clinictreat == 1],  # Control
            n_by_group$n[n_by_group$clinictreat == 2],  # MLP
            n_by_group$n[n_by_group$clinictreat == 3]), # Doctor
    file = file.path(output_dir, "table1.tex"), append = TRUE)

# Omnibus test placeholder
omnibus_p <- run_stata_like_omnibus_test(
  data = woman,
  treatment_vars = c("mlp", "doctor"),
  predictor_vars = b_vars,
  strata_var = "strata",
  cluster_var = "fid"
)
omnibus_p_formatted <- sprintf("%.2f", omnibus_p)
cat(sprintf("Omnibus test (p-value) & & & & & & & %s \\\\\n\\midrule\n", omnibus_p_formatted), 
    file = file.path(output_dir, "table1.tex"), append = TRUE)

# ---------------------------------------------------------------
# Panel C: Child characteristics
# ---------------------------------------------------------------

cat("\\multicolumn{8}{p{0.99\\textwidth}}{\\textbf{C: Child variables}} \\\\ 
", file = file.path(output_dir, "table1.tex"), append = TRUE)

# Read in dataset
child <- read_dta(file.path(analysis_dir, "child.dta"))

# Add variable labels
attr(child$card, "label") <- "Health card available"
attr(child$male, "label") <- "Male child"
attr(child$multiple, "label") <- "Multiple birth"
attr(child$csection, "label") <- "Delivered by C-section"

# Define variables for Panel C
c_vars <- c("male", "multiple", "csection", "card")
child <- child %>% mutate(csection = replace_na(csection, 0))
  
# Balance tests for Panel C
for (var in c_vars) {
  # Calculate means by treatment group
  means <- child %>%
    mutate(clinictreat_num = as.numeric(clinictreat)) %>%
    mutate(card = card - 1) %>%
    group_by(clinictreat_num) %>%
    summarize(mean = mean(!!sym(var), na.rm = TRUE)) %>%
    mutate(mean_str = sprintf("%.3f", mean))
  
  # Run regression
  formula <- as.formula(paste(var, "~ mlp + doctor | strata"))
  
  # Check if the variable has variation
  if (var(child[[var]], na.rm = TRUE) == 0) {
    cat("WARNING: Variable", var, "has no variation!\n")
    p1 <- p2 <- p3 <- p_all <- "NA"
  } else {
    # Run the regression
    reg <- feols(formula, data = child, cluster = "fid")
    
    # Test mlp = control
    test_mlp_control <- waldtest(reg, c("mlp"))
    p1 <- sprintf("%.2f", test_mlp_control$`Pr(>Chisq)`[2])
    
    # Test doctor = control
    test_doctor_control <- waldtest(reg, c("doctor"))
    p2 <- sprintf("%.2f", test_doctor_control$`Pr(>Chisq)`[2])
    
    # Test mlp = doctor
    library(car)
    test_mlp_doctor <- linearHypothesis(reg, "mlp = doctor")
    p3 <- sprintf("%.2f", test_mlp_doctor$`Pr(>Chisq)`[2])
    
    # Joint test
    test_joint <- waldtest(reg, c("mlp", "doctor"))
    p_all <- sprintf("%.2f", test_joint$`Pr(>Chisq)`[2])
  }
  
  # Get mean values, handling potential missing groups
  mean0 <- means$mean_str[means$clinictreat_num == 1]  # Control
  mean1 <- means$mean_str[means$clinictreat_num == 2]  # MLP
  mean2 <- means$mean_str[means$clinictreat_num == 3]  # Doctor
  
  # Handle missing values
  if (length(mean0) == 0) mean0 <- "NA"
  if (length(mean1) == 0) mean1 <- "NA"
  if (length(mean2) == 0) mean2 <- "NA"
  
  # Write to LaTeX file
  var_label <- attr(child[[var]], "label")
  if (is.null(var_label)) var_label <- var
  
  cat(sprintf("%s & %s & %s & %s & %s & %s & %s & %s\\\\\n", 
              var_label, mean0, mean1, mean2, p1, p2, p3, p_all), 
      file = con)
  flush(con)
}

# Sample sizes
n_by_group <- child %>%
  group_by(clinictreat) %>%
  summarize(n = n())

cat(sprintf("Sample size & %d & %d & %d & & & & \\\\\n", 
            n_by_group$n[n_by_group$clinictreat == 1],  # Control
            n_by_group$n[n_by_group$clinictreat == 2],  # MLP
            n_by_group$n[n_by_group$clinictreat == 3]), # Doctor
    file = con)

# Omnibus test placeholder
omnibus_p <- run_stata_like_omnibus_test(
  data = child,
  treatment_vars = c("mlp", "doctor"),
  predictor_vars = c_vars,
  strata_var = "strata",
  cluster_var = "fid"
)
omnibus_p_formatted <- sprintf("%.2f", omnibus_p)
cat(sprintf("Omnibus test (p-value) & & & & & & & %s \\\\\n\\midrule\n", omnibus_p_formatted), 
    file = file.path(output_dir, "table1.tex"), append = TRUE)

# ---------------------------------------------------------------
# End table
# ---------------------------------------------------------------

cat("\\bottomrule\n\\end{tabular}\n", 
    file = con)
close(con)