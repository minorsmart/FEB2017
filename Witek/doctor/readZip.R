library(caTools)
library(biglm)
library(caret)

temp <- tempfile()
download.file("https://github.com/minorsmart/FEB2017/blob/master/Witek/doctor/No-show-Issue-Comma-300k.csv.zip?raw=true",temp)
data <- read.csv(unz(temp, "No-show-Issue-Comma-300k.csv"))
unlink(temp)

str(data)
summary(data)
data$Status <- (data$Status == "Show-Up")*1
data <- data[,-c(3,4)]
data$spl <- sample.split(data$Status, SplitRatio=0.75)
train <- subset(data, data$spl==TRUE)
test <- subset(data, data$spl==FALSE)


model <- glm (Status ~ . -spl, data = train, family = binomial)
summary(model)
test$predict <- predict(model, newdata=test, type='response')
test$predictb <- ifelse(test$predict > 0.66,1,0)
misClasificError <- mean(test$predictb != test$Status)
print(paste('Accuracy',1-misClasificError))

print(confusionMatrix(test$predictb, test$Status))

