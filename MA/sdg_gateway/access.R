# Accessing API Data from SDG Gateway

# Session info
# R version 3.6.3 (2020-02-29)
# Platform: x86_64-apple-darwin15.6.0 (64-bit)
# Running under: macOS Catalina 10.15.5

# Packages & Libraries ----
library(httr)
library(jsonlite)
library(tidyverse)

# Developer API query builder ----

# httr package
# GET() request from httr package

# SDG Indicator 3.3.3 - Malaria Series
# API: SSL certificate problem: certificate has expired

malaria_incidence = GET('https://api-dataexplorer.unescap.org/rest/data/ESCAP,DF_ESCAP_SDG_Dataflow,1.0/.G08_01_01...A?startPeriod=1970&endPeriod=2020&dimensionAtObservation=AllDimensions')


