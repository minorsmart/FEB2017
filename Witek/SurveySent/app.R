library(shiny)
library(miniUI)
library(plotly)
library(ggplot2)
library(ggthemes)
source("functions.R")

# Define UI
ui <- miniPage(
  headerPanel("EIB Survey"),
  gadgetTitleBar("EIB Survey Sentiment Analysis"),
  miniTabstripPanel(
    miniTabPanel("Upload", icon = icon("upload"),
                 miniContentPanel(
                   #Selector for file upload
                   fileInput('datafile', 'Choose CSV file',
                             accept=c('text/csv', 'text/comma-separated-values,text/plain')),
                   
                   #The action button prevents an action firing before we're ready
                   actionButton("getsent", "Get sentiments"),
                   tags$hr(),
                   DT::dataTableOutput("filetable")
                   
                 )
    ),
    miniTabPanel("Visualization", icon = icon("line-chart"),
                 miniContentPanel(padding = 0,
                                  plotlyOutput("plot")
                 )
                 
    ),
    miniTabPanel("Data", icon = icon("table"),
                 miniContentPanel(
                   DT::dataTableOutput("senttable")
                 )
    )
    
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  #This function is repsonsible for loading in the selected file
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    read.csv(infile$datapath, stringsAsFactors = FALSE)
  })
  
  
  
  survdata <- reactive({
    build_sentiment(filedata())
  })
  
  #This previews the CSV data file
  output$filetable <- DT::renderDataTable({
    filedata()
  })
  
  output$senttable <- DT::renderDataTable({
    if (input$getsent == 0) return(NULL)
    survdata()
  })
  
  output$plot <- renderPlotly({
    if (input$getsent == 0) return(NULL)
    {
      plot_ly(survdata(), type = "scatter", x = ~Category, y = ~Sentiment, color = ~ID,
              marker = list(size = 30), text = ~paste("'",Response,"'"), showlegend = FALSE)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)



