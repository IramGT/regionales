## LIBRARIES

library(sf)
library(ggplot2)
library(dplyr)
library(viridis)
library(readr)
library(utils)
library(raster)
library(shiny)
library(bslib)
library(shinyjs)
library(DT)

## DATA BASES IN GOOGLE SHEETS

# Bases de datos
# Bases de datos
apertura <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vR1-BBWqR9tyQj_0wwHWHjARTz0v05lI76IpW8UgaANIIV1hUWqiNk7dA_oe6iAxg4NCbElQmf-YS8S/pub?gid=0&single=true&output=csv")
regionales <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQNLM1VSYbgRVGvPP4QN6RNKFqPOCRMvPc5c68VTqbG_Vw1aewQNcuIRsBalswHAM6dnFcZQF7rDz6z/pub?gid=0&single=true&output=csv")

#### UI ####
ui <- fluidPage(
  theme = bs_theme(version = 4, bootswatch = "simplex"),
  tags$style(type = "text/css", "html, body {width:100%; height:100%} #map{height:80vh !important;}"),
    tabsetPanel(
    tabPanel("REGIONALES", DT::dataTableOutput("ziptable1")),
    tabPanel("CASILLAS",DT::dataTableOutput("ziptable2"))
    ))

#### SERVER ####

server <- function(input, output) {
  
    output$ziptable1 <- DT::renderDataTable({
      tabla <- regionales 
      
      DT::datatable(tabla, options = list(pageLength = 50))
    })
    
    output$ziptable2 <- DT::renderDataTable({
      tabla <- apertura 
      
      DT::datatable(tabla, options = list(pageLength = 50), escape = FALSE)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
