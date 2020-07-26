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
library(reshape2)

# Loading Data ----

# data source: https://unstats.un.org/sdgs/indicators/database/
# select Goal 4.4 (only, n = 4795) 2000-2019,

# also xls, read_excel()
data <- read_xlsx("./data/sdg_goal_4.4.xlsx")
View(data)

data2 <- read_xlsx("./data/sdg_goal_4.4_clmv.xlsx")
glimpse(data2)
View(data2)

# str(), glimpse()
glimpse(data)
str(data) 
str(data2)

# Things to note when using glimpse():
# - number of rows, observations
# - number of columns, variables 

# Things to note with str():
# - data types:
## - num / dbl
## - chr (strings)
## - lgl / logi ('NA')


# Cleaning Data ---- 
    

# Outliers and Missing Data ----

# detect missing values by column
# outcome: either zero missing values or all missing values
# interpretation: you can afford to get rid of some columns
data %>%
    summarize_all(~ sum(is.na(.))) %>% 
    view()

# Outliers: Individual Histograms
# primarily num/dbl
# select only num / dbl
data %>%
    select(GeoAreaCode, TimePeriod, Value, Time_Detail) %>%  
    # note: I selected two variables that are strings/chr
    # they can still have outliers, but are slightly harder to detect
    # use mutate to change to numeric
    mutate(
        Value = as.numeric(Value),
        Time_Detail = as.numeric(Time_Detail)
    ) %>%
    # use histogram one-by-one
    ggplot(aes(x = Time_Detail)) + 
    geom_histogram()

# Outliers: Multiple density plots
library(reshape2)

multiple_histo <- data %>%
    select(GeoAreaCode, TimePeriod, Value, Time_Detail) %>%
    mutate(
        Value = as.numeric(Value),
        Time_Detail = as.numeric(Time_Detail)
    )
    
multiple_histo

# use melt() function to turn from wide into long format
melt_multiple_histo <- melt(multiple_histo)
View(melt_multiple_histo)

# plot facetted boxplots
# note: we need to have some awareness of the data dictionary
ggplot(data = melt_multiple_histo, mapping = aes(x = variable, y = value)) +
    geom_boxplot() +
    facet_wrap(~variable, scales = 'free')





# Manipulating Columns and Rows ----

# caveat - this might not make sense
data %>%
    # we could just select GeoAreaName and Value
    select(SeriesDescription, GeoAreaName, Value) %>%
    # need to turn Value into numeric - like above
    mutate(Value = as.numeric(Value)) %>%
    # group_by GeoAreaName
    group_by(GeoAreaName) %>%
    summarize(avg_value = mean(Value)) %>%
    ungroup() %>%
    
    # keep it manageable (6 countries)
    head() %>%
    
# Plot: Boxplot
    ggplot(aes(x = GeoAreaName, y = avg_value)) +
    geom_boxplot() +
    facet_wrap(~ GeoAreaName, scales = 'free')


# Now that we have a sense for our data, we can ask specific questions:

# pick specific columns of interest for specific question 

names(data)

# Objective: Find Proportion of Youth/Adult with ICT skills by Country & Gender

data %>%
    # select specific columns (de-select others)
    select(GeoAreaName, Value, Sex, `Type of skill`) %>%
    # rename column
    rename(type_of_skill = `Type of skill`)


    



