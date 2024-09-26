#### Preamble ####
# Purpose: Downloads and saves the data from the Police Annual Statistical Report and Neighbourhood Profiles
# Author: Gadiel Flores Jimenez
# Date: 24/09/24
# Contact: davidgadiel.flores@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
# Download Police Annual Statistical Report data
# Get package
offence_package <- show_package("police-annual-statistical-report-tickets-issued")
# Get all resources for this package
offence_resources <- list_package_resources("police-annual-statistical-report-tickets-issued")
# Identify datastore resources (CSV or GeoJSON)
offence_datastore_resources <- filter(offence_resources, tolower(format) %in% c('csv', 'geojson'))
# Load the first datastore resource as a sample
offences_data <- filter(offence_datastore_resources, row_number() == 1) %>% get_resource()

# Download Neighbourhood Profiles data
# Get package
neighbourhood_package <- show_package("6e19a90f-971c-46b3-852c-0c48c436d1fc")
# Get all resources for this package
neighbourhood_resources <- list_package_resources("6e19a90f-971c-46b3-852c-0c48c436d1fc")
# Identify datastore resources (CSV or GeoJSON)
neighbourhood_datastore_resources <- filter(neighbourhood_resources, tolower(format) %in% c('csv', 'geojson'))
# Load the first datastore resource as a sample
neighbourhood_data <- filter(neighbourhood_datastore_resources, row_number() == 1) %>% get_resource()

#### Save data ####
write_csv(offences_data, "data/raw_data/raw_offences_data.csv") 
write_csv(neighbourhood_data, "data/raw_data/raw_neighbourhood_data.csv")