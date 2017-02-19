library(gsheet)
library(dplyr)
library(radarchart)

## Read in data
url <- "https://docs.google.com/spreadsheets/d/1gq-DXkAf4QpZKcgQnABv634DKXjTCHepUi5rHw19Yeg/edit?usp=sharing"
dfData <- gsheet2tbl(url)

## Calculate means
zCols <- select(dfData, matches("Z[0-9]"))
uCols <- select(dfData, matches("U[0-9]"))
sCols <- select(dfData, matches("S[0-9]"))
vCols <- select(dfData, matches("V[0-9]"))

cleanCols <- function(x) {
  as.numeric(
    gsub(pattern = "[A-Z][a-z]*\\s\\(|\\)", replacement = "", x, ignore.case = FALSE, perl = FALSE,
                              fixed = FALSE, useBytes = FALSE)
  )
  }
zCols <- data.frame(apply(zCols[1:7],2, cleanCols))
uCols <- data.frame(apply(uCols[1:7],2, cleanCols))
sCols <- data.frame(apply(sCols[1:7],2, cleanCols))
vCols <- data.frame(apply(vCols[1:7],2, cleanCols))

dfMeans <- data.frame(Z = rowMeans(zCols), U = rowMeans(uCols), S = rowMeans(sCols), V = rowMeans(vCols))
row.names(dfMeans) <- dfData[[2]]

rowIx <- c(1:7)

## data must be in columns
scores <- t(dfMeans[rowIx,])
scores <- data.frame(labs = rownames(scores), scores)

chartJSRadar(scores = scores, maxScale = 3)
