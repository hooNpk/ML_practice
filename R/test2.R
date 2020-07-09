library(mlbench)
data("HouseVotes84")
HouseVotes84 <- na.omit(HouseVotes84)
train <- HouseVotes84[ , -1]
cl <- HouseVotes84[, 1]

priors <- c()
unique.cl <- unique(cl)
unique.cl <- unique.cl[order(unique.cl)]
for (class in unique.cl){
  print(class)
  priors <- c(priors, length(cl[cl==class])/length(cl))
}
names(priors) <- unique.cl

cond.prob <- list()
for(i in 1:dim(train)[2]){
  class.values <- train[, i]
  unique.class.values <- unique(class.values)
  unique.class.values <- na.omit(unique.class.values)
  unique.class.values <- unique.class.values[order(unique.class.values)]
  
  probability.matrix <- matrix(rep(NA), nrow=length(priors), ncol=length(unique.class.values))
  colnames(probability.matrix) <- unique.class.values
  rownames(probability.matrix) <- unique.cl
  
  for( value in unique.class.values){
    #value
    matrix.col <- c()
    for( class in unique.cl){
      class.df <- data.frame(cl, class.values)
      class.value.inclass <- class.df[class.df[, 1]==class, ]
      class.value.inclass <- na.omit(class.value.inclass)
      #class.value.inclass
      prob <- (dim(class.value.inclass[class.value.inclass[, 2]==value, ])[1]+1)/(dim(class.value.inclass)[1]+length(unique.cl))
      matrix.col <- c(matrix.col, prob)
    }
    probability.matrix[, value]<- matrix.col
  }
  cond.prob[[i]] <- probability.matrix
}
return(list(priors, cond.prob))
