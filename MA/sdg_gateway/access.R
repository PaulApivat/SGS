# Accessing API Data from SDG Gateway

# Session info
# R version 3.6.3 (2020-02-29)
# Platform: x86_64-apple-darwin15.6.0 (64-bit)
# Running under: macOS Catalina 10.15.5

# Packages & Libraries ----
library(httr)
library(jsonlite)
library(tidyverse)
library(readxl)

# Developer API query builder ----

# httr package
# GET() request from httr package

# SDG Indicator 3.3.3 - Malaria Series
# API: SSL certificate problem: certificate has expired

malaria_incidence = GET('https://api-dataexplorer.unescap.org/rest/data/ESCAP,DF_ESCAP_SDG_Dataflow,1.0/.G08_01_01...A?startPeriod=1970&endPeriod=2020&dimensionAtObservation=AllDimensions')


# CSV Data (Filtered Data) ----

# All ESCAP Indicators Data: Medium & High Tech Industry

# Filtered Data in Tabular Text (CSV)
escap_tech_industry <- read_csv('./data/ESCAP_DF_ESCAP_THEME_Dataflow_1.0_.MED_HIGH_TECH_IND...A.csv')
glimpse(escap_tech_industry)

escap_tech_industry %>% view()

# Education SDG Indicator: 4.4.1, ICT Skills

# Filtered Data in Tabular Text (CSV)
ict_skills <- read_csv('./data/ESCAP_DF_ESCAP_SDG_Dataflow_1.0_.G04_04_01...A.csv')
glimpse(ict_skills)

ict_skills %>% view()

# Education SDG Indicator: 4.4.1, Reading and mathematics proficiency of children and young people

# Filtered Data in Tabular Text (CSV)
read_math_proficiency <- read_csv('./data/ESCAP_DF_ESCAP_SDG_Dataflow_1.0_.G04_01_01...A.csv')
glimpse(read_math_proficiency)

read_math_proficiency %>% view()

View(read_math_proficiency)

# Excel Data ----
library(readxl)

# Education SDG Indicator: 4.4.1, Reading and mathematics proficiency of children and young people

# Excel Table
read_math_proficiency_excel <- read_excel('./data/ESCAP_DF_ESCAP_SDG_Dataflow_1.0_.G04_01_01...A.xlsx')
glimpse(read_math_proficiency_excel)

read_math_proficiency_excel %>% view()

