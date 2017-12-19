library(shiny)
library(miniUI)
library(leaflet)
library(ggplot2)
library(ggmap)
library(dplyr)


## Read data
dfRenkum <- read.csv("Renkum.csv")
grpRenkum <- group_by(dfRenkum, BU_NAAM)
tblRenkum <- summarise(grpRenkum,
                         AANT_INW = mean(AANT_INW),
                         P_65_EO_JR = mean(P_65_EO_JR),
                         AANTAL_HH = mean(AANTAL_HH),
                         P_LAAGINKP = mean(P_LAAGINKP),
                         INK_ONTV = mean(INK_ONTV)
                        )
clrs <- nrow(tblRenkum)

ui <- miniPage(
  gadgetTitleBar("Wijkgegevens Gemeente Renkum"),
  miniTabstripPanel(
    miniTabPanel("Parameters", icon = icon("sliders"),
                 miniContentPanel(
                   tags$p("Kies een variabele en klik daarna op één van de tabs om de data te bekijken."),
                   tags$hr(),
                   selectInput(inputId = "var", "Variabele", c("AANT_INW", "P_65_EO_JR", "AANTAL_HH", "P_LAAGINKP", "INK_ONTV"), "AANT_INW"),
                   tags$div(
                     tags$hr(),
                     tags$p("Databron: ",
                            tags$a(href = "https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische%20data/wijk-en-buurtkaart-2016", target = "_blank", "CBS Wijk- en buurtkaart 2016")
                            ),
                     tags$p("By: ",
                            tags$a(href = "https://www.linkedin.com/in/witektenhove/", target = "_blank",
                                   tags$img(src = "me.png", width = "42", height = "42")
                                   )
                     )
                   )
                 )
    ),
    miniTabPanel("Chart", icon = icon("area-chart"),
                 miniContentPanel(
                   plotOutput("bar", height = "100%")
                 )
    ),
    miniTabPanel("Map", icon = icon("map-o"),
                 miniContentPanel(padding = 0,
                                  plotOutput("map", height = "100%")
                 )
    ),
    miniTabPanel("Data", icon = icon("table"),
                 miniContentPanel(
                   DT::dataTableOutput("table")
                 )
    )
  )
)

server <- function(input, output, session) {
  
  filldata <- reactive({input$var})  
  
  output$bar <- renderPlot({
    
    ggplot(tblRenkum, aes_string(x = "BU_NAAM", y = filldata(), fill="rainbow(clrs)")) + geom_bar(stat = "identity") + theme(legend.position="none") + coord_flip()
    
 
   })
  
  output$map <- renderPlot({
    
    withProgress(message = 'Making plot', value = 0, {
  
      n <- 3
      
      
    ## Plot data
    mapCenter <- geocode("Doorwerth")
    Renkum <- get_map(c(lon=mapCenter$lon, lat=mapCenter$lat),zoom = 12)#, maptype = "terrain", source="google")
    
    incProgress(1/n, detail = paste("Doing part", 1))
    
    RenkumMap <- ggmap(Renkum)
    
    incProgress(2/n, detail = paste("Doing part", 2))
    
    RenkumMap <- RenkumMap +
      geom_polygon(aes_string(x="long", y="lat", group="group", fill=filldata()),
                   size=.2 ,color='black', data=dfRenkum, alpha=0.5) +
      scale_fill_gradient(low = "green", high = "red")
    
    incProgress(3/n, detail = paste("Doing part", 3))
    
    })
    RenkumMap
  })
  
  output$table <- DT::renderDataTable({
    tblRenkum
  })
  
  observeEvent(input$done, {
    stopApp(TRUE)
  })
}

shinyApp(ui, server)