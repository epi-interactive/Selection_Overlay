##################################
# Created by EPI-interactive
# 27 Feb 2020
# https://www.epi-interactive.com
##################################


  library(shiny)
  library(shinyjs)
  
  #Libraries used for the data
  library(sf)
  library(spData)
  library(readxl)
  
  # Libraries for the visualisations
  library(DT)
  library(leaflet)
  library(plotly)

  #Selection tool functionality
  source("EPISelect.R")
  source("EPISelect_server.R")

  
  server <- function(input, output, session) {
    
    # Loading the data and creating the data structure
    includedData <- st_read(system.file("shapes/world.gpkg", package = "spData"))
    excludedData <- includedData[0, ]
    
    # We keep the data in a reactiveValues so that the outputs will update when it changes
    RV <- reactiveValues(inc = includedData, exc = excludedData)
    
    callModule(EPISelect, "data", RV)
    
    observeEvent(input$show, {
      showModal(EPISelectUI(
        id = "data",
        modalTitle = "Countries of the World",
        includeTitle = "Included Countries",
        excludeTitle = "Excluded Countries"
      ))
    })
    
    
    ##### Output code, not related to selection modal #####
    
    # World map
    world_map_details <- reactive({
      
      bins <- c(
        seq(from = 0, to = 100000, by = 20000),
        seq(from = 100001, to = 1000000, by = 200000),
        seq(from = 1000001, to = 10000000, by = 2000000),
        seq(from = 10000001, to = 100000000, by = 20000000),
        seq(from = 100000001, to = 1000000000, by = 200000000),
        Inf
      )
      pal <- colorBin("Greens", domain = RV$inc$pop, bins = bins)
      
      leaflet(
        options = leafletOptions(minZoom = 1.5, zoomControl = FALSE)) %>%
        addTiles() %>%
        addPolygons(
          layerId = RV$inc$iso_a2,
          data = RV$inc,
          color = "#dddddd",
          weight = 2,
          smoothFactor = 0.5,
          opacity = 1,
          fillOpacity = 0.6,
          fillColor = ~pal(pop)
        )
    })
    output$world_map <- renderLeaflet(world_map_details())
    
    
    # Data table
    world_table_details <- reactive({
      datatable(data = select(as.data.frame(RV$inc), iso_a2, name_long, continent, pop),
                rownames = FALSE, colnames = c("ISO Tag", "Name", "Continent", "Population"))
    })
    output$world_chart <- DT::renderDataTable(world_table_details())
  }
  
  
  # The UI components of the page
  
  ui <- fluidPage(
    tagList(
      useShinyjs(),
      tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css")
    ),
    fluidRow(class="header-row",
        h1("Selection Overlay"),
        tags$img(src="images/Epi_Logo.png", width= "200px", height = "30px")
    ),
    fluidRow(class="main",
      actionButton("show", strong("Open Selection Modal")),
      div(
        column(6,
            DT::dataTableOutput("world_chart")
        ),
        column(6,
            leafletOutput("world_map", height="481px")
        )
      )
    )
  )

  shinyApp(ui = ui, server = server)
