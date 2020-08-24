# Session info ----
R version 4.0.2 (2020-06-22)
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
glimpse(data)
View(data)

data_clmv <- read_xlsx("./data/sdg_goal_4.4_clmv.xlsx")
glimpse(data_clmv)

# Review ----

## What is a more efficient way to find missing value for data all at once?
data %>%
    summarize_all(~ sum(is.na(.))) %>%
    view()

# Atomic Vectors
inclass_sample_data <- c(3,4,7,2,8,10,7,4,5,6,12,15,11,8,5,9,13,10)
inclass_sample_data_1 <- c(3,4,7,2,8,10,7,4,5,6,12,15,11,8,5,9,13,50000)

# Vectors into Tibble
inclass_sample_data <- as.tibble(inclass_sample_data)
inclass_sample_data_1 <- as.tibble(inclass_sample_data_1)

# Intro to visualization (for detecting outliers)
inclass_sample_data_1 %>%
    ggplot(aes(x = value)) +
    geom_boxplot()


# without outliers
inclass_sample_data %>%
    ggplot(aes(x = value)) +
    geom_boxplot()

# Data Wrangling: Selecting ----

## What are the rows with missing data?
## Answer: TimeCoverage, UpperBound, LowerBound, BasePeriod, GeoInfoUrl, FootNote, Nature

## DE-Select all columns that have missing values 
## note: this isn't the way to handle missing values (except when the entire column has missing values)

data %>%
    select(-TimeCoverage, -UpperBound, -LowerBound, -BasePeriod, -GeoInfoUrl, -FootNote, -Nature) %>%
    view()

# Now, Instead of de-select, select columns you're interested in
data %>%
    select(GeoAreaName, Value, Units, Sex, `Type of skill`, TimePeriod, Time_Detail) %>%
    view()

# What TYPE of variables have we selected? This gives us a clue as to how to proceed
# NOTE through piping (%>%) we can combine new functions (select) with previous functions we learned (str)
data %>%
    select(GeoAreaName, Value, Units, Sex, `Type of skill`, TimePeriod, Time_Detail) %>%
    # also try summary()
    str()

## NOTE: We used summary() to determine that there are NO outliers for TimePeriod
## But we were not able to see for Value - why?
## Also, Time_Detail is the same as TimePeriod, but we want 'num' data types

## FOR OUTLIERS, we'll focus on NUMERICAL variables
## This implies we need to CONVERT "Value" to numeric
## We convert Value to numeric by creating a new column using the mutate() function 

data %>%
    select(GeoAreaName, Value, Units, Sex, `Type of skill`, TimePeriod) %>%
    # review that num and dbl are basically interchangeable
    # also note: Units = PERCENT (0-100%)
    mutate(
        value_dbl = as.double(Value),
        value_num = as.numeric(Value)
    ) %>%
    # Introduction to GGPLOT, aesthetics
    ggplot(aes(x = value_num)) +
    # geometries for outliers: boxplots, try histograms
    geom_boxplot()
    

## NOTE: also visually examin TimePeriod with both geom_histogram and geom_boxplot

data %>%
    select(GeoAreaName, Value, Units, Sex, `Type of skill`, TimePeriod) %>%
    ggplot(aes(x = TimePeriod)) +
    # geometries for outliers: boxplots, try histograms
    geom_histogram()

###### PAUSE + REFLECT: What did we just learn about outliers from examining distributions of numeric data? ######

## Also teach incrementally highlighting portions of code, then running it. 
## Also teach view()
## Also teach filter once in spreadsheet view (similar to excel)
## Also teach how once filter(TimePeriod == xxxx), data is cross sectional
## (Even without filtering for year, group_by collapses all years into one)


# Objective: Find Proportion of Youth/Adult with ICT skills by Country & Gender

data %>%
    # select specific columns (de-select others)
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    # rename column
    rename(type_of_skill = `Type of skill`) %>%
    # mutate creates new column
    mutate(
        Value = as.double(Value)
    ) %>%
    # filter on condition within parentheses
    filter(GeoAreaName == 'Thailand') %>% 
    filter(TimePeriod == 2018) %>%
    # group_by, followed by summarize
    group_by(type_of_skill) %>%
    summarize(
        sum_value = sum(Value)
    ) %>%
    # arrange
    arrange(desc(sum_value))

# PICK UP HERE
# Filter ----

## Teach: if going to summarize across years - use mean in stead of sum, when describing proportions
## Show TWO cases of summarize - by sum vs mean


# Summarizing & Aggregating, Sorting & Arranging ----

# Objective: Group By Country (MEAN)
data %>%
    # select specific columns (de-select others)
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    # rename column
    rename(type_of_skill = `Type of skill`) %>% 
    # group by
    # notice the console code reads 88 groups (implying 88 countries)
    # re-inforce that data-types are always important; show summarize ERROR first
    mutate(
        Value = as.numeric(Value)
    ) %>%
# Group By ----
    group_by(GeoAreaName, Sex, TimePeriod) %>%
    # summarize (mean) across years for Country & Gender
    summarize(
        mean_value = mean(Value)
    ) %>%
    # Sorting & Arranging 
    arrange(desc(mean_value)) %>%
    # NOTE: come to think of it, it doesn't make sense to add proportions, 
    # so you want to see proportion by gender - add 'Sex' to group_by

# Filtering ----
    # filter by MALE, FEMALE, BOTHSEX
    filter(TimePeriod==2018) %>%
    filter(Sex=='FEMALE') %>% view()


# NOTE: summarize(total_value) makes less sense than summarize(mean_value)
# Objective: Group By Country (SUM)
data %>%
    # select specific columns (de-select others)
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    # rename column
    rename(type_of_skill = `Type of skill`) %>% 
    # group by
    # notice the console code reads 88 groups (implying 88 countries)
    # re-inforce that data-types are always important; show summarize ERROR first
    mutate(
        Value = as.numeric(Value)
    ) %>%
    # Group By ----
    group_by(GeoAreaName, Sex, TimePeriod) %>%
    # summarize (mean) across years for Country & Gender
    summarize(
        total_value = sum(Value)
    ) %>%
    # Sorting & Arranging 
    arrange(desc(total_value)) %>%
    # NOTE: come to think of it, it doesn't make sense to add proportions, 
    # so you want to see proportion by gender - add 'Sex' to group_by
    
    # Filtering ----
# filter by MALE, FEMALE, BOTHSEX
    filter(TimePeriod==2018) %>%
    filter(Sex=='FEMALE')

####################################
### QUESTIONS TO ASK OF THE DATA ###
####################################

# Which countries did the best for women acquiring ICT Skills in 2017


data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    group_by(GeoAreaName, Sex, TimePeriod) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value)) %>%
    filter(TimePeriod==2017) %>%
    filter(Sex=='FEMALE')

# How about over the entire time period?

data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    # to summarize over extended time period, remove TimePeriod from group_by
    group_by(GeoAreaName, Sex) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value)) %>%
    filter(Sex=='FEMALE')

# Which countries did the best for men acquiring ICT Skills in 2016?

data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    group_by(GeoAreaName, Sex, TimePeriod) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value)) %>%
    filter(TimePeriod==2016) %>%
    filter(Sex=='MALE')

# How about over the entire time period?

data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    group_by(GeoAreaName, Sex) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value)) %>%
    filter(Sex=='MALE')

# Which countries did the best for both sex in acquiring ICT Skills in 2015?


data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    group_by(GeoAreaName, Sex, TimePeriod) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value)) %>%
    filter(TimePeriod==2015) %>%
    filter(Sex=='BOTHSEX')


# How about over the entire time period?

data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    group_by(GeoAreaName, Sex) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value)) %>%
    filter(Sex=='BOTHSEX')

#### CUT TO Meta-Data ####
# See ICT skills breakdown

# Which countries, across time, did the best (% of population) for EMAIL specifically?

data %>%
    select(GeoAreaName, Value, Sex, `Type of skill`, TimePeriod) %>%
    rename(type_of_skill = `Type of skill`) %>% 
    mutate(
        Value = as.numeric(Value)
    ) %>%
    group_by(GeoAreaName) %>%
    filter(type_of_skill=='EMAIL') %>%
    arrange(desc(Value)) %>%
    summarize(
        mean_value = mean(Value)
    ) %>%
    arrange(desc(mean_value))

# Which countries had the most "TimePeriod"(s) recorded? (As in tally)

data %>%
    select(GeoAreaName, TimePeriod) %>%
    group_by(GeoAreaName, TimePeriod) %>%
    tally(sort = TRUE) %>%
    summarize(
        sum_n = sum(n)
    ) %>%
    arrange(desc(sum_n))
    
# SPREAD
# NOTE: not sure if this is the best place to introduce spread
data %>%
    filter(GeoAreaName=="Morocco" | GeoAreaName=="Qatar") %>% 
    select(GeoAreaName, TimePeriod, Sex, `Type of skill`, Value) %>%
    group_by(GeoAreaName, TimePeriod, Sex, `Type of skill`, Value) %>%
    tibble::rowid_to_column() %>%
    spread(key = `Type of skill`, value = Value) %>% view()




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
# Google Search definition for 'Women and Business and the Law'
SDGData %>% 
    filter(`Indicator Name` == 'Women Business and the Law Index Score (1-100)') %>% 
    filter(`Country Name` == 'Thailand' | `Country Name` == 'Cambodia' | `Country Name` == 'Myanmar' | `Country Name` == 'Lao PDR' | `Country Name` == 'Vietnam') %>%
    view()

# Next Step: Time Series Data requires TIDY data from LONG to WIDE


