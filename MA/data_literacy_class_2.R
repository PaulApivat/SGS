# Session Info ----

sessionInfo()  # command

R version 3.6.3 (2020-02-29)
Platform: x86_64-apple-darwin15.6.0 (64-bit)
Running under: macOS Catalina 10.15.5

── Attaching packages ────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
✓ ggplot2 3.3.1     ✓ purrr   0.3.3
✓ tibble  3.0.1     ✓ dplyr   0.8.5
✓ tidyr   1.0.0     ✓ stringr 1.4.0
✓ readr   1.3.1     ✓ forcats 0.4.0

# Libraries & Packages ----
library(tidyverse)
library(readxl)

# Loading Data ----

# data source: https://unstats.un.org/sdgs/indicators/database/
# select Goal 4.4 (only, n = 4795) 2000-2019,

# also xls, read_excel()
data <- read_xlsx("./data/sdg_goal_4.4.xlsx")
View(data)

# str(), glimpse()
glimpse(data)
str(data)


# Cleaning Data ---- 

# Outliers and Missing Data ----

# Manipulating Columns and Rows ----

# Plot: Boxplot

# Plot: Histogram / Density Plots




