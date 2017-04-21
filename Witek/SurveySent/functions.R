build_sentiment <- function(survDF) {

# Required pakacges
library(syuzhet)

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
return(sentDF)
}