# Required pakacges
library(syuzhet)
library(ggplot2)
library(plotly)

# Read in survey data
survDF <- read.csv("Survey.csv", stringsAsFactors = FALSE)

# Loop through responses and assess sentiment scores
n <- 1
sentDF <- NULL
idVec <- as.factor(survDF[[1]])
for(s in survDF[-1]) {
  print(n)
  str(s)
  responseVec <- s
  catVec <- rep(colnames(survDF[-1])[n], length(s))
  sentVec <- get_sentiment(responseVec)
  tempDF <- data.frame(ID = idVec, Response = responseVec, Category = catVec, Sentiment = sentVec)
  sentDF <- rbind(sentDF, tempDF)
  n <- n + 1
}

p <- ggplot(sentDF, aes(Category, Sentiment, colour = ID) ) +
  geom_point(aes(alpha = 0.5, text = paste("'",Response,"'"))) +
  scale_fill_brewer(palette="Accent") +
  theme(legend.position='none')
ggplotly(p)

plot_ly(sentDF, type = "scatter", x = ~Category, y = ~Sentiment, color = ~ID,
        size = 10, text = ~paste("'",Response,"'"))
