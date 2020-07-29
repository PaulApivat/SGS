# Session info ----
R version 3.6.3 (2020-02-29)
Platform: x86_64-apple-darwin15.6.0 (64-bit)
Running under: macOS Catalina 10.15.5

# RStudio --> Session --> Restart R

# Data Visualization & Exploratory Data Analysis ----

# Libraries ----
library(tidyverse)

# Load data ----
SDGData <- read_csv("./data/SDGData.csv")
glimpse(SDGData)

# Resume Time Series Wrangling ----

# Objective: Find ONE Indicator Name for CLMV countries with the most complete data
# Solution: Primary Education snd Women Business
SDGData %>%
    select(`Country Name`, `Indicator Name`, '1990', '1991', '2018', '2019') %>% 
    filter(`Country Name` == 'Thailand' | `Country Name` == 'Cambodia' | `Country Name` == 'Myanmar' | `Country Name` == 'Lao PDR' | `Country Name` == 'Vietnam') %>%
    # DROP missing values in NA
    drop_na(c('1990', '1991', '2018', '2019')) %>%
    filter(`Indicator Name` == 'Women Business and the Law Index Score (1-100)' | `Indicator Name` == 'Primary education, duration (years)') %>% view()

# NOTE: Women Business & Law has more variance (more interesting) data than Primary Education

# Women and Business and the Law Indes Score (1-100) appears to have more interesting data than Primary Education
# Google Search definition for 'Women and Business and the Law'
women_business_law_index_clmv <- SDGData %>% 
    filter(`Indicator Name` == 'Women Business and the Law Index Score (1-100)') %>% 
    filter(`Country Name` == 'Thailand' | `Country Name` == 'Cambodia' | `Country Name` == 'Myanmar' | `Country Name` == 'Lao PDR' | `Country Name` == 'Vietnam')
    
women_business_law_index_clmv

# Tidy vs Un-Tidy: We'll demonstrate Tidy vs Un-Tidy through Visualization


# Visualization ----

# NOTE: We generally pre-process the data BEFORE visualizing

# Grammar of Graphics ----

# Bar chart

women_business_law_index_clmv %>%
    ggplot(aes(x = `1990`, y = `Country Code`)) +
    # default width = 0.9
    geom_col(width = 0.5, color = 'red')

# Global vs Local Aesthetic Mapping (map ACROSS variables)

# Color: Globally defined
women_business_law_index_clmv %>%
    ggplot(aes(x = `1990`, y = `Country Code`, fill = `Country Code`)) +
    # default width = 0.9
    geom_col(width = 0.5)

# Color: Locally defined
women_business_law_index_clmv %>%
    ggplot(aes(x = `1990`, y = `Country Code`)) +
    # default width = 0.9
    geom_col(aes(fill = `Country Code`), width = 0.5)

# NO Aesthetic Mapping
womem_business_law_index_clmv %>%
    ggplot(aes(x = `1990`, y = `Country Code`)) +
    geom_col(width = 0.7, fill = 'red')

# By default geom_bar uses stat='count' which is incompatible with mapping values to the y-aesthetic
ggplot(data = women_business_law_index_clmv, mapping = aes(x = `1990`, y = `Country Code`)) +
    geom_bar(stat = 'identity')

# NOTE Help documentation
?geom_bar
?geom_col






# Line Chart

# Scatter Plot



# Visualization: Beyond the Basics ----

# Themes

# Labels

# Color Palettes

# Linear Model: An Introduction ----

# Best Fitting Line

# Statistical Process Charts: Introduction ----



