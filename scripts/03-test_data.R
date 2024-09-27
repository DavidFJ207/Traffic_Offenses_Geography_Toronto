#### Preamble ####
# Purpose: Tests dataset integrity 
# Author: Gadiel Flores Jimenez
# Date: 21 September, 2024
# Contact: davidgadiel.flores@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None
#### Workspace setup ####
library(tidyverse)
library(lubridate)
library(dplyr)
library(testthat)
library(here)

#### Test data ####
# Sample test dataset creation
sample_data <- function() {
  # Load data from CSV
  data <- read.csv(here("data", "analysis_data", "income_and_offences.csv"))
  return(data)
}

# Test for correct data types
test_that("Data types are correct", {
  df <- sample_data()
  expect_type(df$HOOD_158, "integer")
  expect_type(df$NEIGHBOURHOOD_158.x, "character")
  expect_type(df$Income, "integer")
  expect_type(df$Total_Tickets, "integer")
})

# Test for non-null fields
test_that("Non-null values in important fields", {
  df <- sample_data()
  expect_true(all(!is.na(df$HOOD_158)), info = "_id should not contain null values")
  expect_true(all(!is.na(df$NEIGHBOURHOOD_158.x)), info = "DIVISION should not contain null values")
  expect_true(all(!is.na(df$Income)), info = "Income_COUNT should not contain null values")
  expect_true(all(!is.na(df$Total_Tickets)), info = "TICKET_COUNT should not contain null values")
})

# Test for duplicates
test_that("Dataset should not contain duplicates", {
  df <- sample_data()
  expect_true(nrow(df) == nrow(distinct(df)), info = "Dataset contains duplicate rows")
})

