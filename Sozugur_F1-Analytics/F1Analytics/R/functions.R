# Week 2 functions
# there will be 3 functions: selecting year, circuit and driver

#load & merge dataset####
install.packages("shiny")
install.packages("shinythemes")
install.packages("dplyr")
library(shiny)
library(shinythemes)
library(readr)
library(dplyr)
races <- read_csv("/Users/deniz/Desktop/archive/races.csv")
drivers <- read_csv("/Users/deniz/Desktop/archive/drivers.csv")
driver_standings <- read_csv("/Users/deniz/Desktop/archive/driver_standings.csv")

f1_data <- races %>%
  left_join(driver_standings, by = "raceId") %>%
  left_join(drivers, by = "driverId")


##Function 1####

#' @title select year
#' @description this function gives options of years 2019, 2020, 2021, 2022 and 2023 in a drop-down menu
#' @param inputId input slot that will be used to access the value
#' @param label label for the selected input
#' @param years vector of years to choose from: c("2019", "2020", "2021", "2022", "2023")
#' @return enables user to choose a year

#' data
f1_data <- read_csv('/Users/deniz/Desktop/PTNS2024/Sozugur_F1-Analytics/f1data.csv")

#' @export
selectYear <- function(inputId, label, years = c("2019", "2020", "2021", "2022", "2023")) {
  selectInput(inputId, label, choices = years)
}

devtools::document()
devtools::build()
