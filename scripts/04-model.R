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
income_data <- read_csv(here::here("data/analysis_data/income_and_offences.csv"))

#### Model data ####
# Modeling for every increase of income, how many tickets get given out
first_model <- lm(Total_Tickets ~ Income, data = income_data)
Aggressive_Driving_model <- lm(Aggressive_Driving ~ Income, data = income_data)
All_CAIA_model <- lm(All_CAIA ~ Income, data = income_data)
Distracted_Driving_model <- lm(Distracted_Driving ~ Income, data = income_data)
Other_HTA_model <- lm(Other_HTA ~ Income, data = income_data)
Speeding_model <- lm(Speeding ~ Income, data = income_data)

#### Combine models into a list ####
all_models <- list(
  Total_Tickets_model = first_model,
  Aggressive_Driving_model = Aggressive_Driving_model,
  All_CAIA_model = All_CAIA_model,
  Distracted_Driving_model = Distracted_Driving_model,
  Other_HTA_model = Other_HTA_model,
  Speeding_model = Speeding_model
)

#### Save the list of models as an RDS file ####
saveRDS(
  all_models,
  file = "models/all_offence_models.rds"
)
