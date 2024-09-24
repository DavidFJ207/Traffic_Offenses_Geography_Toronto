#### Preamble ####
# Purpose: Models the relationship between neighborhood income and traffic offenses in Toronto using linear regression.
# Author: Gadiel David Flores
# Date: 23/09/24
# Contact: davidgadiel.flores@mail.utoronto.ca
# License: MIT
# Pre-requisites: Requires the dataset `tickets_issued_data.csv` and `average_income.csv` to be in the `data/sim_data` folder


#### Workspace setup ####
library(tidyverse)

#### Read data ####
income_data <- read_csv("data/sim_data/average_income.csv")
tickets_data <- read_csv("data/sim_data/tickets_issued_data.csv")

#### Merge datasets by neighbourhood ####
# Ensure both datasets have a common key to merge on, like 'neighborhood'
merged_data <- inner_join(tickets_data, income_data, by = "neighbourhood")

#### Model data ####
# Assuming `tickets_issued` is the column for number of tickets and `average_income` is the column for income
first_model <- lm(tickets_issued ~ average_income, data = merged_data)

#### Save model ####
saveRDS(
  first_model,
  file = "models/sim_offence_linear_regression.rds"
)

