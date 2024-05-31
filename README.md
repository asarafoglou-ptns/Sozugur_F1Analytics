# Sozugur_F1Analytics
This is an R package to view Formula 1 analytics in a fun and visualized way.

In order for the app to work, you need to:
1)
library(shiny)
library(shinythemes)
library(httr)
library(purrr)
library(readr)
library(htmltools)
library(shinydashboard)

2) Install the app from github
devtools::install_github("asarafoglou-ptns/Sozugur_F1Analytics/Sozugur_F1-Analytics/F1Analytics")
library('F1Analytics')

3) run these codes
devtools::source_url("https://raw.githubusercontent.com/asarafoglou-ptns/Sozugur_F1Analytics/main/Sozugur_F1-Analytics/F1Analytics/F1_code.R")
shiny::shinyApp(ui = ui, server = server)
