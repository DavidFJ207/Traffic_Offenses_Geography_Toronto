#### Preamble ####
# Purpose: Simulates Police Statistical Report of tickets issued.
# Author: Gadiel David Jimenez
# Date: 21 September, 2024
# Contact: davidgadiel.flores@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(ggplot2)

#### Simulate data ####
num_days <- 30

start_date <- as.Date("2023-01-01")
dates <- seq(start_date, by = "day", length.out = num_days)

# Simulate the number of tickets issued per person
tickets_issued <- rpois(num_days, lambda = 1)

# Create ID column
id <- seq(1, num_days)

# ticket types, age groups, and neighbourhoods
ticket_types <- c("Distracted Driving", "Speeding", "Aggressive Driving", "CAIA")
age_groups <- c("Adult", "Youth")
neighbourhoods <- c("Clanton Park", "Avondale", "Henry Farm")

# Create a dataframe for the simulated data
tickets_data <- data.frame(
  id = id,
  Date = dates,
  ticket_type = sample(ticket_types, num_days, replace = TRUE),
  age_group = sample(age_groups, num_days, replace = TRUE),
  neighbourhood = sample(neighbourhoods, num_days, replace = TRUE),
  LicensesIssued = tickets_issued
)

write.csv(tickets_data, "tickets_issued_data.csv", row.names = FALSE)

