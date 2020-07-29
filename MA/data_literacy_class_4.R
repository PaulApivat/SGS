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

# Tidy vs Un-Tidy ----

# We'll demonstrate Tidy vs Un-Tidy through Visualization
# NOTE with previous geom_col - we could only visualize ONE year

# Line Chart ----

# NOTE: geom_point IMPLICITLY groups by color, geom_line requires EXPLICIT group assignment

# Preprocessing required before visualize Time-Series
women_business_law_index_clmv %>%
    # select variables you need - helps make your work manageable
    select(`Country Name`, `Indicator Name`, c(`1990`:`2019`)) %>% 
    # rename variables with 'spaces' in their names - makes it easier to handle
    rename(
        country_name = `Country Name`,
        indicator_name = `Indicator Name`
    ) %>%
    # Tidy principle: turn Wide data into Long data
    gather(`1990`:`2019`, key = 'year', value = 'score') %>%
    # Belatedly changing year from chr to date
    mutate(
        year = as.Date(year, format = "%Y")
    ) %>%
    ggplot(aes(x = year, y = score, group = country_name)) +
    geom_line(aes(color = country_name), size = 3) +
    # NOTE: geom_point IMPLICITLY groups by color, geom_line requires EXPLICIT group assignment
    #geom_point(aes(color = country_name))

    # Theme ----
    # fix year numbers overlapping
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_minimal() +
    # To break up dates into 5-year ranges
    scale_x_date(breaks = '5 years') +
    # Labels ----
    labs(
        title = 'Women Business and the Law Index Score (1-100)',
        subtitle = '1990 - 2019',
        x = '',
        y = 'Index Score',
        color = 'Country',
        caption = 'Lao PDR has made the most progress in the last 20 years'
        )

# Next step: Create Stacked Barchart + Stacked Area chart
# Bonus: Then, create heatmap of the LONG table.

# Stacked Bar Chart or Area Chart ----

# NOTE: can do stack bar (fill), stack bar (stack) OR area_area()
# No need for group_by, summarized, ungroup

women_business_law_index_clmv %>%
    select(`Country Name`, `Indicator Name`, c(`1990`:`2019`)) %>% 
    rename(
        country_name = `Country Name`,
        indicator_name = `Indicator Name`
    ) %>%
    gather(`1990`:`2019`, key = 'year', value = 'score') %>%
    mutate(
        year = as.Date(year, format = "%Y")
    ) %>%
    ggplot(aes(x = year, y = score, fill = country_name, group = country_name)) +
    #geom_col(position = 'fill') +
    #geom_col(position = 'stack') +
    geom_area() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_minimal() +
    scale_x_date(breaks = '5 years')





# alternative way using inverse selection
women_business_law_index_clmv %>%
    select(-`Country Code`, -`Indicator Code`, everything())



# Defining GROUP in ggplot vs group_by in pre-processing: Better Example for STACKED Bar chart or AREA chart???
women_business_law_index_clmv %>%
    select(`Country Name`, `Indicator Name`, c(`1990`:`2019`)) %>% 
    rename(
        country_name = `Country Name`,
        indicator_name = `Indicator Name`
    ) %>%
    gather(`1990`:`2019`, key = 'year', value = 'score') %>%
    # must change country_name from character to factor -- DATA TYPES
    mutate(
        country_name = as.factor(country_name)
    ) %>%
    # Now there are five groups
    group_by(country_name, year) %>%
    summarize(
        total_score = sum(score)
    ) %>%
    ungroup() %>%
    ggplot(aes(x = year, y = total_score)) +
    geom_line(aes(group = country_name, color = country_name)) 
   






# Scatter Plot or BarChart
# NOTE: Not as clear
women_business_law_index_clmv %>%
    select(`Country Name`, `Indicator Name`, c(`1990`:`2019`)) %>% 
    rename(
        country_name = `Country Name`,
        indicator_name = `Indicator Name`
    ) %>%
    gather(`1990`:`2019`, key = 'year', value = 'score') %>%
    # must change country_name from character to factor -- DATA TYPES
    mutate(
        country_name = as.factor(country_name),
        year1 = year
    ) %>%
    ggplot(aes(x = country_name, y = score)) +
    #geom_point(aes(color = country_name), position = 'jitter') 
    geom_col(aes(fill = country_name))


# Lollipop Better = Scatter + Bar

library(ggrepel)

#### MONSTROSITY: Mistakes in GGPLOT are beautiful ----
women_business_law_index_clmv %>%
    select(`Country Name`, `Indicator Name`, c(`1990`:`2019`)) %>% 
    rename(
        country_name = `Country Name`,
        indicator_name = `Indicator Name`
    ) %>%
    gather(`1990`:`2019`, key = 'year', value = 'score') %>%
    # must change country_name from character to factor -- DATA TYPES
    mutate(
        country_name = as.factor(country_name)
    ) %>%
    ggplot(aes(x = country_name, y = score)) +
    geom_segment(aes(x = country_name, y = 0, xend = country_name, yend = score), color = 'black', size = 3) +
    # setting color to variable name only works when mapping across aes()
    geom_point(size = 5, aes(color = country_name), alpha = 0.3) +
    #geom_text(aes(label = year), nudge_x = 0.2) +
    geom_text_repel(aes(label = year), color = 'red', size = 5)


# Lollipop - with Year Label bookend ----
women_business_law_index_clmv %>%
    select(`Country Name`, `Indicator Name`, c(`1990`:`2019`)) %>% 
    rename(
        country_name = `Country Name`,
        indicator_name = `Indicator Name`
    ) %>%
    gather(`1990`:`2019`, key = 'year', value = 'score') %>%
    # must change country_name from character to factor -- DATA TYPES
    mutate(
        country_name = as.factor(country_name)
    ) %>%
    ggplot(aes(x = country_name, y = score)) +
    geom_segment(aes(x = country_name, y = 0, xend = country_name, yend = score, color = country_name)) +
    # setting color to variable name only works when mapping across aes()
    geom_point(aes(color = country_name, size = score), alpha = 0.3) +
    geom_text(aes(label = ifelse(year == '2019' | year == '1990', year, '')), nudge_x = 0.2, nudge_y = 0.2)
    #geom_text_repel(aes(label = year), size = 3)




# Visualization: Beyond the Basics ----

# Themes

# Labels

# Color Palettes

# Linear Model: An Introduction ----

# Best Fitting Line

# Statistical Process Charts: Introduction ----



