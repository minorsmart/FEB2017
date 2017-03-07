library(gsheet)
library(dplyr)
library(radarchart)
library(ggplot2)
library(reshape2)

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
    gsub(pattern = "[A-Z][a-z]*\\s\\(|\\)", replacement = "", x)
  )
}

zCols <- data.frame(apply(zCols,2, cleanCols))
uCols <- data.frame(apply(uCols,2, cleanCols))
sCols <- data.frame(apply(sCols,2, cleanCols))
vCols <- data.frame(apply(vCols,2, cleanCols))

dfMeans <- data.frame(Z = rowMeans(zCols), U = rowMeans(uCols), S = rowMeans(sCols), V = rowMeans(vCols))
newMeans <- cbind(dfData[2],dfMeans)
meltMeans <- melt(newMeans)

ggplot(meltMeans) +
  geom_point(aes(x = Naam.deelnemer, y = value, col = variable, fill = variable)) +
  theme(axis.text.x = element_text(angle=45))

ggplot(meltMeans) +
  geom_col(aes(x = Naam.deelnemer, y = value, col = variable, fill = variable)) +
  theme(axis.text.x = element_text(angle=90))
  
rowIx <- c(1:7)

## data must be in columns, transposed
scores <- t(dfMeans[rowIx,])
scores <- data.frame(labs = rownames(scores), scores)

chartJSRadar(scores = scores, maxScale = 3)



