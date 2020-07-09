#Training Set
n<-100
x<-matrix(rnorm(2*n*2), ncol=2)
x[1:n, 1] <- x[1:n, 1]+2
x[1:n, 2] <- x[1:n, 2]-2
y <- c(rep(1,n), rep(2,n))
x.train <- data.frame(x1=x[,1], x2=x[,2], y=y)
plot(x.train[,1], x.train[,2], xlab="x1", ylab="x2", type="n")
points(x.train[y==1, 1], x.train[y==1, 2], pch="1")
points(x.train[y==2, 1], x.train[y==2, 2], pch="2")

#Test Set
m <- round(n*0.3)
x <- matrix(rnorm(2*m*2), ncol=2)
x[1:m, 1] <- x[1:m, 1]+2
x[1:m, 2] <- x[1:m, 2]-2
y <- c(rep(1,m), rep(2,m))
x.test <- data.frame(x1=x[,1], x2=x[,2], y=y)

#Classification Tree
#Fit a decision tree
library(rpart)
x.rp <- rpart(x.train[,3]~., x.train[, -3], method="class")
a <- table(x.train[,3], predict(x.rp, x.train[, -3], type="class"))
train.err <- (sum(a)-sum(diag(a)))/sum(a)
b <- table(x.test[,3], predict(x.rp, x.test[,-3], type="class"))
test.err <- (sum(b)-sum(diag(b)))/sum(b)

x.rp
