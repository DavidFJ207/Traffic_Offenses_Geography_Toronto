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
set.seed(304)


#### Simulate data ####
num_days <- 30

start_date <- as.Date("2023-01-01")
dates <- seq(start_date, by = "day", length.out = num_days)

# Simulate the number of tickets issued per person
tickets_issued <- rpois(num_days, lambda = 1)

id <- seq(1, num_days)

# ticket types, age groups, and neighbourhoods
ticket_types <- c("Distracted Driving", "Speeding", "Aggressive Driving", "CAIA")
age_groups <- c("Adult", "Youth")
neighbourhoods <- c("Clanton Park", "Avondale", "Henry Farm")

# Create simulated data
tickets_data <- data.frame(
  id = id,
  Date = dates,
  ticket_type = sample(ticket_types, num_days, replace = TRUE),
  age_group = sample(age_groups, num_days, replace = TRUE),
  neighbourhood = sample(neighbourhoods, num_days, replace = TRUE),
  LicensesIssued = tickets_issued
)

write.csv(tickets_data, "data/sim_data/tickets_issued_data.csv", row.names = FALSE)

# Simulate average income for each neighbourhood (in thousands)
average_income <- c(
  rnorm(1, mean = 85, sd = 10),  # Clanton Park
  rnorm(1, mean = 90, sd = 12),  # Avondale
  rnorm(1, mean = 75, sd = 8)    # Henry Farm
)

# Create a data frame with the simulated data
income_data <- data.frame(
  neighbourhood = neighbourhoods,
  average_income = average_income
)

# Write the simulated data to a CSV file
write.csv(income_data, "data/sim_data/average_income.csv", row.names = FALSE)
