d.admit <- read.csv("(4)logistic_regression_admission.csv")
logr <- glm(admit ~ gre+gpa+rank, data=d.admit, family=binomial("logit"))
summary(logr)

d.brand <- read.csv("(4)logistic_regression_brandchoice.csv", header=TRUE, sep=',')
head(d.brand)
library(mlogit)
