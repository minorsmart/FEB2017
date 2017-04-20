build_sentiment <- function(survDF) {

# Required pakacges
library(syuzhet)

# Loop through responses and assess sentiment scores
n <- 1
sentDF <- NULL
survDF <- survDF[,-1]
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
return(sentDF)
}