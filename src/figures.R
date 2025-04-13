#######################################################################################################
## This file generates the main figures
#######################################################################################################

library(ggplot2)
library(dplyr)
library(haven)
library(patchwork)
library(ggridges)

# Set theme similar to Stata
theme_set(theme_minimal() +
            theme(panel.grid.minor = element_blank(),
                  legend.position = "bottom"))

raw_dir <- "../data/raw"
intermediate_dir <- "../data/intermediate"
analysis_dir <- "../data/analysis"
output_dir <- "../data/output"

#-------------------------------------------------------------------------
# Figure 1. Experimental design
#-------------------------------------------------------------------------

# Figure was manually constructed using Powerpoint

#-------------------------------------------------------------------------
# Figure 2. Effect of the intervention on supply
#-------------------------------------------------------------------------

staffing <- read_dta(file.path(analysis_dir, "staffing.dta"))

# Collapse data
staffing_summary <- staffing %>%
  group_by(clinictreat, visit) %>%
  summarize(staff = mean(staff, na.rm = TRUE),
            doctor = mean(doctor, na.rm = TRUE),
            .groups = "drop")

# Panel A: Number of health providers
fig2a <- ggplot(staffing_summary, aes(x = visit, y = staff, color = factor(clinictreat), 
                                      linetype = factor(clinictreat), group = factor(clinictreat))) +
  geom_line() +
  geom_point() +
  scale_color_manual(values = c("gray70", "blue", "red"),
                     labels = c("Control", "MLP", "Doctor"),
                     name = "") +
  scale_linetype_manual(values = c("solid", "solid", "dashed"),
                        labels = c("Control", "MLP", "Doctor"),
                        name = "") +
  scale_x_discrete(limits = c("T0", "T1", "T2")) +
  scale_y_continuous(limits = c(4, 7), breaks = 4:7) +
  labs(y = "Number of providers", x = "") +
  theme(legend.position = c(0.5, 0.95),
        legend.direction = "horizontal")
fig2a
ggsave(file.path(output_dir, "fig2a.eps"), fig2a, width = 7, height = 5)
ggsave(file.path(output_dir, "fig2a.png"), fig2a, width = 7, height = 5)

# Panel B: Doctor on staff
fig2b <- ggplot(staffing_summary, aes(x = visit, y = doctor, color = factor(clinictreat), 
                                      linetype = factor(clinictreat), group = factor(clinictreat))) +
  geom_line() +
  geom_point() +
  scale_color_manual(values = c("gray70", "blue", "red"),
                     labels = c("Control", "MLP", "Doctor"),
                     name = "") +
  scale_linetype_manual(values = c("solid", "solid", "dashed"),
                        labels = c("Control", "MLP", "Doctor"),
                        name = "") +
  scale_x_discrete(limits = c("T0", "T1", "T2")) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) + 
  labs(y = "Probability", x = "") +
  theme(legend.position = c(0.5, 0.95),
        legend.direction = "horizontal")
fig2b
ggsave(file.path(output_dir, "fig2b.eps"), fig2b, width = 7, height = 5)
ggsave(file.path(output_dir, "fig2b.png"), fig2b, width = 7, height = 5)

#----------------------------------------------------------------------------
# Figure 3. Trends in 7-day mortality by experimental arm
#-----------------------------------------------------------------------------

child <- read_dta(file.path(analysis_dir, "child.dta"))

# Collapse data
child_summary <- child %>%
  mutate(mort7 = replace_na(mort7, 0)) %>%
  group_by(clinictreat, qtr) %>%
  summarize(mort7 = mean(mort7, na.rm = TRUE),
            n = n(),
            .groups = "drop") %>%
  filter(n > 150) 
fig3 <- ggplot(child_summary, aes(x = qtr, y = mort7, color = factor(clinictreat), 
                                  linetype = factor(clinictreat), group = factor(clinictreat))) +
  geom_line(na.rm = TRUE) +
  geom_point(na.rm = TRUE) +
  scale_color_manual(values = c("gray70", "blue", "red"),
                     labels = c("Control", "MLP", "Doctor"),
                     name = "") +
  scale_linetype_manual(values = c("solid", "solid", "dashed"),
                        labels = c("Control", "MLP", "Doctor"),
                        name = "") +
  coord_cartesian(ylim = c(0.01, 0.05)) +  # Use coord_cartesian instead of scale_y_continuous limits
  scale_y_continuous(breaks = seq(0.01, 0.05, 0.01)) +
  labs(y = "Probability", x = "") +
  theme(legend.position = c(0.5, 0.95),
        legend.direction = "horizontal")
fig3
ggsave(file.path(output_dir, "fig3.eps"), fig3, width = 7, height = 5)
ggsave(file.path(output_dir, "fig3.png"), fig3, width = 7, height = 5)
#----------------------------------------------------------------------------
# Figure 4. Dose-Response Effects
#-----------------------------------------------------------------------------

# Panel A: Received care from a doctor
woman <- read_dta(file.path(analysis_dir, "woman.dta"))

# Replace negative dosage with 0
woman <- woman %>%
  mutate(dosage = ifelse(dosage < 0, 0, dosage))

# Calculate means by clinictreat and dosage
woman_summary <- woman %>%
  group_by(clinictreat, dosage) %>%
  mutate(doctorcare1 = replace_na(doctorcare1, 0)) %>%
  summarize(doctorcare1_m = mean(doctorcare1, na.rm = TRUE),
            .groups = "drop") %>%
  drop_na(dosage)

fig4a <- ggplot() +
  geom_point(data = woman_summary %>% filter(clinictreat == 3), 
             aes(x = dosage, y = doctorcare1_m), color = "red") +
  geom_point(data = woman_summary %>% filter(clinictreat == 2), 
             aes(x = dosage, y = doctorcare1_m), color = "blue") +
  geom_smooth(data = woman_summary %>% filter(clinictreat == 3), 
              aes(x = dosage, y = doctorcare1_m),
              method = "loess", formula = y ~ x, span = 0.75, se = TRUE, color = "red", linetype="dashed") +
#  scale_linetype_manual(values = c("dashed"),
#                        name = "") +
  scale_x_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
  scale_y_continuous(limits = c(0, 0.3), breaks = seq(0, 0.3, 0.1)) +
  labs(y = "Probability", x = "Months of exposure") +
  theme(legend.position = c(0.5, 0.95),
        legend.direction = "horizontal")
fig4a
ggsave(file.path(output_dir, "fig4a.eps"), fig4a, width = 7, height = 5)
ggsave(file.path(output_dir, "fig4a.png"), fig4a, width = 10, height = 8)

# Panel B: 7-day mortality
child <- child %>%
  mutate(dosage = ifelse(dosage < 0, 0, dosage))

# Collapse data
child_dose_summary <- child %>%
  group_by(clinictreat, dosage) %>%
  mutate(mort7 = replace_na(mort7, 0)) %>%
  summarize(mort7 = mean(mort7, na.rm = TRUE),
            n = n(),
            .groups = "drop") %>%
  filter(dosage < 10)  # Exclude Month 10 because too few obs

fig4b <- ggplot(child_dose_summary, aes(x = dosage, y = mort7, color = factor(clinictreat), 
                                        linetype = factor(clinictreat), group = factor(clinictreat))) +
  geom_line() +
  geom_point() +
  scale_color_manual(values = c("blue", "red"),
                     labels = c("MLP", "Doctor"),
                     name = "") +
  scale_linetype_manual(values = c("solid", "dashed"),
                        labels = c("MLP", "Doctor"),
                        name = "") +
  scale_y_continuous(limits = c(0, 0.08), breaks = seq(0, 0.08, 0.02)) +
  scale_x_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
  labs(y = "Probability", x = "Months of exposure") +
  theme(legend.position = c(0.5, 0.95),
        legend.direction = "horizontal")
fig4b
ggsave(file.path(output_dir, "fig4b.eps"), fig4b, width = 7, height = 5)
ggsave(file.path(output_dir, "fig4b.png"), fig4b, width = 7, height = 5)
#--------------------------------------------------------------------------
# Figure 5. Differences in proficiency by provider type
#---------------------------------------------------------------------------

provider <- read_dta(file.path(analysis_dir, "provider.dta"))

# Create density plots for each score
plot_density <- function(var_name, var_label) {
  ggplot(provider, aes(x = .data[[var_name]], fill = factor(provider), color = factor(provider))) +
    geom_density(alpha = 0.0, aes(linetype = factor(provider))) +
    scale_fill_manual(values = c("gray70", "blue", "red"),
                      labels = c("Existing MLP", "New MLP", "Doctor"),
                      name = "") +
    scale_color_manual(values = c("gray70", "blue", "red"),
                       labels = c("Existing MLP", "New MLP", "Doctor"),
                       name = "") +
    scale_linetype_manual(values = c("solid", "solid", "dashed"),
                         labels = c("Existing MLP", "New MLP", "Doctor"),
                         name = "") +
    labs(x = var_label, y = "Density") +
    theme(legend.position = "bottom")
}

# Create individual plots
mscore_plot <- plot_density("mscore", "Management score")
cscore_plot <- plot_density("cscore", "Clinical score")
vscore_plot <- plot_density("vscore", "Vignette score")
qscore_plot <- plot_density("qscore", "Overall performance (%)")

# Combine plots
fig5 <- (mscore_plot + cscore_plot) / (vscore_plot + qscore_plot) + 
  plot_layout(guides = "collect") & 
  theme(legend.position = "bottom")
fig5
ggsave(file.path(output_dir, "fig5.eps"), fig5, width = 10, height = 8)
ggsave(file.path(output_dir, "fig5.png"), fig5, width = 10, height = 8)