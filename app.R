## LIBRARIES

library(sf)
library(ggplot2)
library(tmap)
library(tmaptools)
library(leaflet)
library(dplyr)
library(viridis)
library(readr)
library(utils)
library(raster)
library(tmap)
library(shiny)
library(bslib)
library(shinyjs)

## DATA BASES IN GOOGLE SHEETS

# Bases de datos
rutas <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQWRGbbRlcV4z7jSyRk7XppiPZrYi7dZNeiRXlecqb362arymXz8AuR5FXbkITzYnpZceWGJgJGwa0p/pub?gid=1678194350&single=true&output=csv")
promovidos <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTl1sgZNKEWnuLCRqy4BxLRV2LUTUh-3B8We6yz4ZL9RWigsi8NMyG1Z4-RZTVDboDoiD9TJCcI7yzl/pub?gid=0&single=true&output=csv")

# Capa shp
shp_mineral <- read_sf(dsn = "seccionHidalgo", layer = "SeccionMineral")
casillas <- read_sf(dsn = "seccionHidalgo", layer = "casillas")

# Alteraciones a la capa
shp_mineral <- shp_mineral %>% 
  dplyr::select(seccion, MunicipioN)

shp_mineral <- promovidos %>% 
  left_join(shp_mineral, .)

casillas <- casillas %>% 
  left_join(rutas, by = "seccion")

opciones <- shp_mineral$MunicipioN

#### UI ####
ui <- fluidPage(
  theme = bs_theme(version = 4, bootswatch = "simplex"),
  tags$style(type = "text/css", "html, body {width:100%; height:100%} #map{height:80vh !important;}"),
    tabsetPanel(
    tabPanel("PROMOVIDOS", 
    # Application title
    titlePanel(h1( img(src = "JM.jpg", height = 94, width = 186),),windowTitle = "Electoral Analytics Dashboard"), hr(), 

    # Sidebar with a slider input for number of bins
        # Show a plot of the generated distribution
          fluidRow(
            width = 7,h5("INNOVA", style='color:#B3282D'), leafletOutput("map_1"), selectInput(inputId = "select_1", label = "", selected = "MINERAL DE LA REFORMA", choices = unique(opciones))),
            
    ),
    tabPanel("CASILLAS", h3(img(src = "JM.jpg", height = 94, width = 186)) ,DT::dataTableOutput("ziptable"))
    ))

#### SERVER ####

server <- function(input, output) {
  
    output$map_1 <- renderLeaflet({
      tm <- shp_mineral %>% 
        filter(MunicipioN == input$select_1) %>%
        tm_shape() +
        tm_polygons(alpha = .05, id = "seccion", popup.vars = c("Lista nominal" = "Lista nominal", "Promovidos" = "Cantidad")) +
        tm_basemap("OpenStreetMap") +
        tm_shape(casillas) +
        tm_dots(id = "Localidad", size = .09, clustering = F, col = "REF", style = "pretty", popup.vars = c("Enlace" = "Enlace", "Cel" = "Celular", "Abogado" = "Abogado", "Tel" = "CelularA"), legend.show = FALSE) 
      
      tmap_leaflet(tm)
    })
    
    
  
    output$ziptable <- DT::renderDataTable({
      tabla <- rutas %>% 
        dplyr::select(REF, seccion, Localidad, RUTA)
      
      
      DT::datatable(tabla, options = list(pageLength = 50))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
