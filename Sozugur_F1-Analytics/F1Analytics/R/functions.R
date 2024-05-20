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

#' @title Formula 1 Analytics
#' @description This package aims to provide a fun way of viewing the Formula 1 standings between years 2019-2023.
#' selectYear this function gives options of years 2019, 2020, 2021, 2022 and 2023 in a drop-down menu
#' selectCircuit selects the circuit based on the selected year in first function
#' selectDriver selects driver based on the output of previous 2 functions

#' data
f1_data <- read_csv('/Users/deniz/Desktop/PTNS2024/Sozugur_F1-Analytics/f1data.csv")

#' @export
selectYear <- function(inputId, label, years = c("2019", "2020", "2021", "2022", "2023")) {
  selectInput(inputId, label, choices = years)
}



