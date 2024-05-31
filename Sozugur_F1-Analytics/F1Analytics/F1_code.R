library(shiny)
library(shinythemes)
library(httr)
library(purrr)
library(readr)
library(htmltools)
library(shinydashboard)

# ui
ui <- dashboardPage(
  dashboardHeader(title = "Formula 1 Visualized", titleWidth = 250),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Select Options", tabName = "select_options", icon = icon("sliders-h")),
      selectInput("selectYear", "Select Year", choices = c("2020", "2021", "2022", "2023")),
      selectInput("selectCircuit", "Select Circuit", choices = NULL),
      selectInput("selectDriver", "Select Driver", choices = NULL)
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML("
      .skin-blue .main-header .logo {
        background-color: #C41E3A;
        font-weight: bold;
      }
      .skin-blue .main-header .logo:hover {
        background-color: #C41E3A;
      }
      .skin-blue .main-header .navbar {
        background-color: #C41E3A;
      }
      .content-wrapper, .right-side {
        background-color: #ffffff;
      }
      .box.box-solid.box-primary>.box-header {
        color: #fff;
        background: #C41E3A;
      }
      .box.box-solid.box-primary {
        border: 1px solid #C41E3A;
      }
      .selectize-input, .selectize-dropdown {
        background-color: #f5f5f5;
        border: 1px solid #cccccc;
      }
    "))),
    tabBox(
      id = "mainTabs", width = 12,
      tabPanel("Home", 
               h3("Welcome to the Formula 1 Visualized 101!"),
               p("Please select a year, circuit and driver to get started."),
      ),
      tabPanel("Circuits", 
               conditionalPanel(
                 condition = "input.selectCircuit != ''",
                 fluidRow(
                   box(
                     title = "Circuit Information", status = "primary", solidHeader = TRUE, width = 12,
                     htmlOutput("circuitInfo")
                   ),
                   uiOutput("circuitImage")
                 )
               )),
      tabPanel("Race Results", 
               conditionalPanel(
                 condition = "input.selectCircuit != '' && input.selectYear != ''",
                 fluidRow(
                   box(
                     title = "Race Results", status = "primary", solidHeader = TRUE, width = 12,
                     tableOutput("raceResultsTable")
                   )
                 )
               )),
      tabPanel("Drivers",
               conditionalPanel(
                 condition = "input.selectDriver != ''", 
                 fluidRow(
                   box(
                     title = "Driver Profile", status = "primary", solidHeader = TRUE, width = 12,
                     htmlOutput("driverProfile")
                   ),
                   box(
                     title = "Meme of the Driver", status = "primary", solidHeader = TRUE, width = 12,
                     uiOutput("driverMeme")
                   )
                 )
               )
      )
    )
  )
)


# Server
server <- function(input, output, session) {
  
  observeEvent(input$selectYear, {
    res <- GET(paste0("http://ergast.com/api/f1/", input$selectYear, "/circuits.json"))
    data <- content(res, "parsed")
    circuit_ids <- sapply(data$MRData$CircuitTable$Circuits, function(x) x$circuitId)
    circuit_names <- sapply(data$MRData$CircuitTable$Circuits, function(x) x$circuitName)
    names(circuit_ids) <- circuit_names
    updateSelectInput(session, "selectCircuit", choices = circuit_ids)
  })
  
  observeEvent(input$selectCircuit, {
    # Fetch drivers for the selected year and circuit
    res <- GET(paste0("http://ergast.com/api/f1/", input$selectYear, "/circuits/", input$selectCircuit, "/drivers.json"))
    data <- content(res, "parsed")
    drivers <- sapply(data$MRData$DriverTable$Drivers, function(x) paste(x$givenName, x$familyName))
    driver_ids <- sapply(data$MRData$DriverTable$Drivers, function(x) x$driverId)
    names(driver_ids) <- drivers
    updateSelectInput(session, "selectDriver", choices = driver_ids)
  })
  
  # Display the selected circuit's information and URL from CSV
  output$circuitInfo <- renderUI({
    req(input$selectCircuit)
    
    selected_circuit <- circuits_data[circuits_data$circuitRef == input$selectCircuit, ]
    
    if (nrow(selected_circuit) > 0) {
      HTML(paste(
        "Country: ", selected_circuit$country, "<br/>",
        "Location: ", selected_circuit$location, "<br/>",
        "Latitude: ", selected_circuit$lat, "<br/>",
        "Longitude: ", selected_circuit$lng, "<br/>",
        "Altitude: ", selected_circuit$alt, "<br/>"
      ))
    } else {
      "Circuit information not available"
    }
  })
  
  output$circuitImage <- renderUI({
    req(input$selectCircuit)
    
    selected_circuit <- circuits_data[circuits_data$circuitRef == input$selectCircuit, ]
    
    if (nrow(selected_circuit) > 0) {
      svg_url <- as.character(selected_circuit$imageURL)
      html_widget <- tags$iframe(src = svg_url, width = "100%", height = "600px")
      browsable(html_widget)
    } else {
      tags$p("Circuit image URL not available")
    }
  })
  
  # Display driver profile based on the selected driver
  output$driverProfile <- renderUI({
    req(input$selectDriver)
    
    res <- GET(paste0("http://ergast.com/api/f1/drivers/", input$selectDriver, ".json"))
    data <- content(res, "parsed")
    driver <- data$MRData$DriverTable$Drivers[[1]]
    
    if (!is.null(driver)) {
      HTML(paste(
        "Name: ", driver$givenName, " ", driver$familyName, "<br/>",
        "Date of Birth: ", driver$dateOfBirth, "<br/>",
        "Nationality: ", driver$nationality, "<br/>",
        "Permanent Number: ", ifelse(is.null(driver$permanentNumber), "N/A", driver$permanentNumber), "<br/>"
      ))
    } else {
      "Driver profile not available"
    }
  })
  
  # Display driver meme based on the selected driver
  output$driverMeme <- renderUI({
    req(input$selectDriver)
    
    selected_driver <- drivers_memes[drivers_memes$driverRef == input$selectDriver, ]
    if (nrow(selected_driver) > 0) {
      meme_url <- as.character(selected_driver$memes)
      html_widget <- tags$iframe(src = meme_url, width = "100%", height = "700px")
      browsable(html_widget)
    } else {
      meme_url <- "https://www.reddit.com/media?url=https%3A%2F%2Fi.redd.it%2F9wypzo9v5zla1.jpg"
      html_widget <- tags$iframe(src = meme_url, width = "100%", height = "700px")
      browsable(html_widget)
    }
  })
  
  # Display race results
  output$raceResultsTable <- renderTable({
    req(input$selectCircuit, input$selectYear)
    
    res <- GET(paste0("http://ergast.com/api/f1/", input$selectYear, "/circuits/", input$selectCircuit, "/results.json"))
    data <- content(res, "parsed")
    
    if (!is.null(data$MRData$RaceTable$Races[[1]]$Results)) {
      race_results <- data$MRData$RaceTable$Races[[1]]$Results
      results_df <- data.frame(
        Position = sapply(race_results, function(x) x$position),
        Driver = sapply(race_results, function(x) paste(x$Driver$givenName, x$Driver$familyName)),
        Constructor = sapply(race_results, function(x) x$Constructor$name),
        Time = sapply(race_results, function(x) ifelse(is.null(x$Time), "N/A", x$Time$time)),
        Status = sapply(race_results, function(x) x$status)
      )
      return(results_df)
    } else {
      return(data.frame(
        Position = "N/A",
        Driver = "N/A",
        Constructor = "N/A",
        Time = "N/A",
        Status = "N/A"
      ))
    }
  })
}

# Run the app
shinyApp(ui = ui, server = server)
