#***Naive Bayes Classification

library(e1071)
library(mlbench)

data("HouseVotes84")
head(HouseVotes84, 10)

model <- naiveBayes(Class ~., data=HouseVotes84)
pred <- predict(model, HouseVotes84[, -1], method="class")

table(HouseVotes84[,1], pred)
