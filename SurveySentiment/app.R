library(shiny)
library(syuzhet)
source("functions.R")

# Define UI for application that draws a histogram
ui<- shinyUI(pageWithSidebar(
  headerPanel("CSV File Upload Demo"),
  
  sidebarPanel(
    #Selector for file upload
    fileInput('datafile', 'Choose CSV file',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    
    #The action button prevents an action firing before we're ready
    actionButton("getgeo", "Get geodata")
    
  ),
  mainPanel(
    tableOutput("filetable"),
    tableOutput("senttable")
  )
))

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
    #build_sentiment(filedata())
  })
  
  #This previews the CSV data file
  output$filetable <- renderTable({
    filedata()
  })
  output$senttable <- renderTable({
    survdata()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

