#### Preamble ####
# Purpose: Cleans the raw data of neighbourhoods and offences commited and merges them to one dataset
# Author: Gadiel David Flores
# Date: 09/24/24
# Contact: davidgadiel.flores@mail.toronto.com
# License: MIT
# Pre-requisites: Data needs to be extracted from Opendatatoronto to file raw_data


#### Work space setup ####
library(dplyr)
library(tidyverse)
library(readr)


#### Clean Neighborhood data ####
# Load the raw data
raw_neighbourhood_data <- read_csv("data/raw_data/raw_neighbourhood_data.csv")
# Rename the '_id' column to 'id'
raw_neighbourhood_data <- raw_neighbourhood_data %>%
  rename(id = `_id`)
# Filter rows where id is equal to 1030 or 1
income_data <- raw_neighbourhood_data %>%
  filter(id %in% c(1030, 1))
# Remove the first 6 columns
income_data <- income_data %>%
  select(-c(1:6))

# Use the column names as NEIGHBOURHOOD_158
neighborhoods <- names(income_data)
hood_ids <- as.vector(unlist(income_data[1, ]))  
# Fix income being a string
income <- as.vector(unlist(income_data[2, ]))
income <- gsub(",", "", income)
income <- as.numeric(income)
# new data frame with NEIGHBOURHOOD_158, HOOD_158, and Income
income_data <- data.frame(
  NEIGHBOURHOOD_158 = neighborhoods,
  HOOD_158 = hood_ids,
  Income = income
)



#### Clean Offences data ####
# Load the raw offence data
raw_offence_data <- read_csv("data/raw_data/raw_offences_data.csv")
# Select the relevant columns
raw_offence_data <- raw_offence_data %>%
  select(OFFENCE_YEAR, OFFENCE_CATEGORY, HOOD_158, NEIGHBOURHOOD_158, TICKET_COUNT)
# Summarize the data by neighbourhood, year, and offence category
summary_data <- raw_offence_data %>%
  group_by(NEIGHBOURHOOD_158, HOOD_158, OFFENCE_YEAR, OFFENCE_CATEGORY) %>%
  summarise(Total_Tickets = sum(TICKET_COUNT), .groups = 'drop')
# Summarize the data by neighbourhood and hood, aggregating total tickets
summary_neighbourhood_data <- raw_offence_data %>%
  group_by(NEIGHBOURHOOD_158, HOOD_158) %>%
  summarise(
    Total_Tickets = sum(TICKET_COUNT, na.rm = TRUE),
    Aggressive_Driving = sum(TICKET_COUNT[OFFENCE_CATEGORY == "Aggressive Driving"], na.rm = TRUE),
    All_CAIA = sum(TICKET_COUNT[OFFENCE_CATEGORY == "All CAIA"], na.rm = TRUE),
    Distracted_Driving = sum(TICKET_COUNT[OFFENCE_CATEGORY == "Distracted Driving"], na.rm = TRUE),
    Other_HTA = sum(TICKET_COUNT[OFFENCE_CATEGORY == "Other HTA"], na.rm = TRUE),
    Speeding = sum(TICKET_COUNT[OFFENCE_CATEGORY == "Speeding"], na.rm = TRUE),
    .groups = 'drop'
  )



#### Merge cleaned neighborhood and offences data set and Save data ####
# Perform a full join by HOOD_158
income_and_offences <- merge(income_data, summary_neighbourhood_data, 
                             by = "HOOD_158", 
                             all = TRUE) 
# Cleans data
income_and_offences <- income_and_offences %>%
  select(-c(4:4))
# Gets ride of rows with no data
income_and_offences <- income_and_offences %>%
  filter(!is.na(Income) & !is.na(Total_Tickets))

# Define a function to identify and remove outliers using IQR
remove_outliers <- function(df) {
  # Select only the numeric columns (Income, Total_Tickets, Aggressive_Driving, etc.)
  numeric_cols <- df %>% select(Income, Total_Tickets, Aggressive_Driving, All_CAIA, Distracted_Driving, Other_HTA, Speeding)
  
  # Calculate IQR for each numeric column
  Q1 <- apply(numeric_cols, 2, quantile, 0.25, na.rm = TRUE)
  Q3 <- apply(numeric_cols, 2, quantile, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  
  # Define limits for outliers
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  
  # Filter the data to remove rows with outliers
  filtered_df <- df %>%
    filter(
      Income >= lower_bound["Income"] & Income <= upper_bound["Income"] &
        Total_Tickets >= lower_bound["Total_Tickets"] & Total_Tickets <= upper_bound["Total_Tickets"] &
        Aggressive_Driving >= lower_bound["Aggressive_Driving"] & Aggressive_Driving <= upper_bound["Aggressive_Driving"] &
        All_CAIA >= lower_bound["All_CAIA"] & All_CAIA <= upper_bound["All_CAIA"] &
        Distracted_Driving >= lower_bound["Distracted_Driving"] & Distracted_Driving <= upper_bound["Distracted_Driving"] &
        Other_HTA >= lower_bound["Other_HTA"] & Other_HTA <= upper_bound["Other_HTA"] &
        Speeding >= lower_bound["Speeding"] & Speeding <= upper_bound["Speeding"]
    )
  
  return(filtered_df)
}

# Apply the function to your dataset
income_and_offences <- remove_outliers(income_and_offences)


# Save the combined data to a CSV file
write_csv(summary_data, "data/analysis_data/analysis_data.csv")

# Save the new dataset to a CSV file
write_csv(income_and_offences, "data/analysis_data/income_and_offences.csv")
