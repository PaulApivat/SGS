# Session info ----
R version 3.6.3 (2020-02-29)
Platform: x86_64-apple-darwin15.6.0 (64-bit)
Running under: macOS Catalina 10.15.5

# RStudio --> Session --> Restart R

# Data Wrangling ----

# Library ----
library(tidyverse)
library(readxl)

# Load Data ----
# Instruction: Load XYZ from this folder

# also xls, read_excel()
data <- read_xlsx("./data/sdg_goal_4.4.xlsx")
View(data)

# Selecting ----
names(data)

# Objective: Find Proportion of Youth/Adult with ICT skills by Country & Gender

data %>%
    # select specific columns (de-select others)
    select(GeoAreaName, Value, Sex, `Type of skill`) %>%
    # rename column
    rename(type_of_skill = `Type of skill`)


# Summarizing & Aggregating, Sorting & Arranging ----

# Objective: Group By Country
data %>%
    # select specific columns (de-select others)
    select(GeoAreaName, Value, Sex, `Type of skill`) %>%
    # rename column
    rename(type_of_skill = `Type of skill`) %>% 
    # group by
    # notice the console code reads 88 groups (implying 88 countries)
    # re-inforce that data-types are always important; show summarize ERROR first
    mutate(
        Value = as.numeric(Value)
    ) %>%
# Group By ----
    group_by(GeoAreaName, Sex) %>%
    # tally(sort = TRUE) literally counts the rows
    summarize(
        total_value = sum(Value)
    ) %>%
    # Sorting & Arranging 
    arrange(desc(total_value)) %>%
    # NOTE: come to think of it, it doesn't make sense to add proportions, 
    # so you want to see proportion by gender - add 'Sex' to group_by

# Filtering ----
    # filter by MALE, FEMALE, BOTHSEX
    filter(Sex=='FEMALE') %>% view()

## REDO but add ICT Skill Type
names(data)

data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`) %>%
    rename(
        type_of_skill = `Type of skill`
    ) %>%
    group_by(GeoAreaName, Sex, type_of_skill) %>%
    mutate(
        Value = as.numeric(Value)
    ) %>%
    summarize(avg_value = mean(Value)) %>%
    ungroup() %>%
    filter(Sex=='BOTHSEX') %>%
    filter(type_of_skill=='EMAIL') %>% 
    arrange(desc(avg_value)) 

## consider saving and converting to heatmap()


# Count & Tally ----

# Time Series ----

## Use different dataset
SDGData <- read_csv("./data/SDGData.csv")
glimpse(SDGData)

## Select CLMV countries
names(SDGData)

SDGData %>% view()

# Objective: Find ONE Indicator Name for CLMV countries with the most complete data
# Solution: Primary Education snd Women Business
SDGData %>%
    select(`Country Name`, `Indicator Name`, '1990', '1991', '2018', '2019') %>% 
    filter(`Country Name` == 'Thailand' | `Country Name` == 'Cambodia' | `Country Name` == 'Myanmar' | `Country Name` == 'Lao PDR' | `Country Name` == 'Vietnam') %>%
    # DROP missing values in NA
    drop_na(c('1990', '1991', '2018', '2019')) %>%
    filter(`Indicator Name` == 'Women Business and the Law Index Score (1-100)' | `Indicator Name` == 'Primary education, duration (years)') %>% view()


# Women and Business and the Law Indes Score (1-100) appears to have more interesting data than Primary Education
SDGData %>% 
    filter(`Indicator Name` == 'Women Business and the Law Index Score (1-100)') %>% 
    filter(`Country Name` == 'Thailand' | `Country Name` == 'Cambodia' | `Country Name` == 'Myanmar' | `Country Name` == 'Lao PDR' | `Country Name` == 'Vietnam') %>%
    view()

# Next Step: Time Series Data requires TIDY data from LONG to WIDE

