#Formula 1 App
#Deniz Sözügür
#open related packages
install.packages(c("shiny", "shinythemes", "httr", "purrr", "readr", "htmltools", "shinydashboard"))
library(shiny)
library(shinythemes)
library(httr)
library(purrr)
library(readr)
library(htmltools)
library(shinydashboard)

#Install the app
devtools::install_github("asarafoglou-ptns/Sozugur_F1Analytics/Sozugur_F1-Analytics/F1Analytics")
library('F1Analytics')

#Run the app
devtools::source_url("https://raw.githubusercontent.com/asarafoglou-ptns/Sozugur_F1Analytics/main/Sozugur_F1-Analytics/F1Analytics/F1_code.R")
shiny::shinyApp(ui = ui, server = server)
