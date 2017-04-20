# Required pakacges
library(syuzhet)
library(ggplot2)
library(plotly)

# Read in survey data
survDF <- read.csv("Survey.csv", stringsAsFactors = FALSE)[,-1]

# Loop through responses and assess sentiment scores
n <- 1
sentDF <- NULL
for(s in survDF) {
  print(n)
  str(s)
  responseVec <- s
  catVec <- rep(colnames(survDF)[n], length(s))
  sentVec <- get_sentiment(responseVec)
  tempDF <- data.frame(Response = responseVec, Category = catVec, Sentiment = sentVec)
  sentDF <- rbind(sentDF, tempDF)
  n <- n + 1
}

p <- ggplot(sentDF, aes(Category, Sentiment) ) +
  geom_point()
ggplotly(p)