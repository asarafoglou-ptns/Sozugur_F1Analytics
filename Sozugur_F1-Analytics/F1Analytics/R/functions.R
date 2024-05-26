#' @title Select Year
#' @description this function selects years 2019, 2020, 2021, 2022 and 2023 out of the years between 1950-2023
#' @param inputId input slot that will be used to access the value
#' @param label label for the selected input
#' @param years vector of years to choose from: c("2019", "2020", "2021", "2022", "2023")
#' @return enables user to choose a year from a drop-down menu
#' @example from a drop down menu, users will be given options of years 2019,2020,2021,2022,2023 and will be asked to select a year
#' selectYear <- function(inputId, label, years = c("2019", "2020", "2021", "2022", "2023")) {
#'   selectInput(inputId, label, choices = years)
#' }
#' @export
selectYearUI <- function(outputId) {
  uiOutput(outputId)
}

#' @title Select Circuit
#' @description this function fetches circuits that were involved in the races in the selected year of previous function in the ui
#' @param outputId the output slot that will be used to show the UI on the server side
#' @return ui output that gets filled with a select input on the server side, in a drop down menu
#' @example from a drop down menu, users will be given options of the circutis that were involved in the selected year from previous function
#' @export
selectCircuitUI <- function(outputId) {
  uiOutput(outputId)
}
#' @title Select Driver
#' @description this function fetches drivers that participated in the race selected depending on the selected year and circuit of previous function
#' @param outputId output slot that will be used to show the ui on the server side
#' @return enables user to choose a driver from a drop-down menu
#' @example from a drop down menu, users will be given options of the drivers that participated in the selected race based on the previous functions
#' @export
selectDriverUI <- function(outputId) {
  uiOutput(outputId)
}
#' @references Ergast. (2023). Formula 1 2023 driver standings [Data set]. Retrieved from http://ergast.com/api/f1/2023/driverStandings.json
