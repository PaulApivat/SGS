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
    group_by(GeoAreaName, Sex) %>%
    # tally(sort = TRUE) literally counts the rows
    summarize(
        total_value = sum(Value)
    ) %>%
    # Sorting & Arranging 
    arrange(desc(total_value))
    
    # NOTE: come to think of it, it doesn't make sense to add proportions, 
    # so you want to see proportion by gender - add 'Sex' to group_by
    

# Filtering ----



# Group By ----

# Count & Tally ----

# Time Series ----



