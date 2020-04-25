
d.c <- read.csv("(5)logistic_regression_cancer.csv")
head(d.c)
table(d.c$y)
#Stratified random partition -> Preserve the original class distribution
#Considering stratified preparing training/test datasets



##Divide Training/Test data preserving its distribution
d.c.ben <- d.c[d.c$y=='benign', ]
d.c.mal <- d.c[d.c$y=='malignant', ]

#shuffling
nr.ben <- nrow(d.c.ben)
nr.mal <- nrow(d.c.mal)
d.c.ben <- d.c.ben[sample(nr.ben), ]
d.c.mal <- d.c.mal[sample(nr.mal), ]

#stratified partition
d.c.ben.train <- d.c.ben[1:round(nr.ben*0.7), ]
d.c.ben.test <- d.c.ben[(round(nr.ben*0.7)+1):nr.ben, ]
d.c.mal.train <- d.c.mal[1:round(nr.mal*0.7), ]
d.c.mal.test <- d.c.mal[(round(nr.mal*0.7)+1):nr.mal, ]
d.c.train <- rbind(d.c.ben.train, d.c.mal.train)
d.c.test <- rbind(d.c.ben.test, d.c.mal.test)

table(d.c.train$y)
table(d.c.test$y)

logr <- glm(y~., data=d.c.train, family=binomial("logit"))
summary(logr)


#***Confusion Matrix
#Training and Testing : Validation
pred.y.train <- round(predict(logr, newdata=d.c.train, type="response"))
cm.train <- table(d.c.train$y, pred.y.train)
cm.train

pred.y.test <- round(predict(logr, newdata=d.c.test, type="response"))
cm.test <- table(d.c.test$y, pred.y.test)
cm.test

acc.train <- sum(diag(cm.train))/sum(cm.train)
acc.train

acc.test <- sum(diag(cm.test))/sum(cm.test)
acc.test
