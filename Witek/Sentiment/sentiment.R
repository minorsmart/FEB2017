library(pattern.nlp)
library(googleVis)
library(plotly)

rawData <- read.csv("survey.csv", stringsAsFactors = FALSE)
newNames <- c(
  "Verwachtingen",
  "Studiebelasting",
  "Verbanden",
  "Pluspunten",
  "Activiteiten",
  "Activeren",
  "Bijdrage"
)
colnames(rawData) <- newNames
  

## Function reading text vector. Returns sentiment data frame
read_sentiments <- function(vector, label) {
  
  tempDF <- NULL
  
  for (n in vector) {
    x <- pattern_sentiment(n, language = "dutch")
    x <- cbind(x, label)
    tempDF <- rbind(tempDF, x)
    
  }
  return(tempDF)
}

sentDF <- NULL

for (m in 2:dim(rawData)[2]) {
  x <- read_sentiments(rawData[,m], newNames[m-1])
  sentDF <- rbind(sentDF, x)
}

sentDF$id <- sapply(sentDF$id,function(x) gsub("\\. ","\\.<br>",as.character(x)))

pal <- rainbow(dim(rawData)[2]-1)
plot_ly(sentDF, x = sentDF$polarity, y = sentDF$subjectivity, text = paste("Tekst: ", sentDF$id),
        mode = "markers", color = sentDF$label, colors = pal) %>%
  layout(autosize = F, width = 500, height = 500)

