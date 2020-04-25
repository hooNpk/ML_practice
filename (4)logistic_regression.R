
#***Binary Logistic Regression


d.admit <- read.csv("(4)logistic_regression_admission.csv")
logr <- glm(admit ~ gre+gpa+rank, data=d.admit, family=binomial("logit"))
summary(logr)

#***Nominal Logistic Regression
#ln(P_j/P_J) = exp(alpha_j + beta_j * X)

d.brand <- read.csv("(4)logistic_regression_brandchoice.csv", header=TRUE, sep=',')
head(d.brand)
library(mlogit) #need installation >install.packages(mlogit)
#d.brand$brand <- as.factor(d.brand$brand)
#d.brand$brand

d.brand$brand <- factor(d.brand$brand)
td.brand <- mlogit.data(d.brand, varying=NULL, choice="brand", shape="wide")
head(td.brand)
nlogr <- mlogit(brand~1|female+age, data=td.brand, reflevel="1")
summary(nlogr)