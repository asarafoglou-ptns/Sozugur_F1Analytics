#' @title Select Year
#' @description this function selects years 2019, 2020, 2021, 2022 and 2023 out of the years between 1950-2023
#' @param inputId input slot that will be used to access the value
#' @param label label for the selected input
#' @param years vector of years to choose from: c("2019", "2020", "2021", "2022", "2023")
#' @return enables user to choose a year from a drop-down menu
#' @export
selectYear <- function(inputId, label, years = c("2019", "2020", "2021", "2022", "2023")) {
  selectInput(inputId, label, choices = years)
}
devtools::install_github("asarafoglou-ptns/Sozugur_F1Analytics/F1Analytics")
library('F1Analytics')

#Run the app
shiny::shinyApp(ui = ui, server = server)

source("/Users/deniz/Desktop/Sozugur_F1Analytics/Sozugur_F1-Analytics/F1Analytics.R")
