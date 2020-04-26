#***CART : Classification And Regression Tree
#Splitting Criteria and Pruning

library(rpart)
d.music <- read.csv("(6)CART_music.csv")
head(d.music)


m.rp <- rpart(Type~LVar+LAve+LMax+LFEner+LFreq, data=d.music, method="class")
plot(m.rp)
text(m.rp)
pred.y <- predict(m.rp, d.music[,-c(1:3)], type="class")
cfm <- table(d.music$Type, pred.y)
