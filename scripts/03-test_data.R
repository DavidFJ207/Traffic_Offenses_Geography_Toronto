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

#### Test data ####
# Sample test dataset creation
sample_data <- function() {
  
  # Load data from CSV
  data <- read.csv("data/analysis_data/cleaned_tickets_issued_data.csv")
  
  # Convert 'OFFENCE_YEAR' to a datetime format
  data$OFFENCE_YEAR <- ymd(paste0(data$OFFENCE_YEAR, "-01-01"))
  
  return(data)
}

# Test for correct data types
test_that("Data types are correct", {
  df <- sample_data()
  
  expect_type(df$`_id`, "integer")
  expect_type(df$DIVISION, "character")
  expect_type(df$TICKET_COUNT, "integer")
  expect_s3_class(df$OFFENCE_YEAR, "Date")
})

# Test that ticket counts are non-negative
test_that("Ticket counts should be non-negative", {
  df <- sample_data()
  
  expect_true(all(df$TICKET_COUNT >= 0), info = "TICKET_COUNT should be non-negative.")
})

# Test for valid time periods format (should be datetime)
test_that("OFFENCE_YEAR should be in datetime format", {
  df <- sample_data()
  
  expect_s3_class(df$OFFENCE_YEAR, "Date")
})

# Test for non-null fields
test_that("Non-null values in important fields", {
  df <- sample_data()
  
  expect_true(all(!is.na(df$`_id`)), info = "_id should not contain null values.")
  expect_true(all(!is.na(df$DIVISION)), info = "DIVISION should not contain null values.")
  expect_true(all(!is.na(df$TICKET_COUNT)), info = "TICKET_COUNT should not contain null values.")
  expect_true(all(!is.na(df$OFFENCE_YEAR)), info = "OFFENCE_YEAR should not contain null values.")
})

# Test for duplicates
test_that("Dataset should not contain duplicates", {
  df <- sample_data()
  
  expect_true(nrow(df) == nrow(distinct(df)), info = "Dataset should not contain duplicate rows.")
})

# Test for valid DIVISION values (this can be customized based on known valid values)
test_that("Valid DIVISION values", {
  df <- sample_data()
  valid_divisions <- c('NSA', 'ET', 'NY', 'SC', 'TO', 'YK') # Add valid DIVISION codes here
  
  expect_true(all(df$DIVISION %in% valid_divisions), info = "Invalid DIVISION value found.")
})

# Test for reasonable date range (example: dates should be from 2010 onwards)
test_that("Reasonable date range for OFFENCE_YEAR", {
  df <- sample_data()
  start_date <- as.Date('2010-01-01')
  
  expect_true(all(df$OFFENCE_YEAR >= start_date), info = "OFFENCE_YEAR should be from 2010 onwards.")
})