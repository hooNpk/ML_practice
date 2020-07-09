myknn <- function(train, test, cl, k=3, method=1){
  d.train <- cbind(cl, train)
  predict.test <- c()
  for ( i in 1:nrow(test)){#test frame의 각 row에 대해서 반복문
    #***Get Distance from test row vector
    d.train.distance <- cbind(cl, train)
    row.test <- test[i, ]
    distance.vector <- c()
    for ( j in 1:nrow(d.train)){
      distance <- sqrt(sum((d.train[j, -1]-row.test)^2))
      distance.vector <- c(distance.vector, distance)
    }
    d.train.distance <- cbind(d.train.distance, distance.vector)
    d.train.distance <- d.train.distance[c(order(distance.vector)), ]
    
    #Set for how many each variable value's 
    num.type <- nlevels(cl)
    col.set <- c(rep(0, times=num.type))
    count.value = data.frame(levels(cl), col.set) 
    
    #***Voting
    if(method==1){
      for ( z in 1:k){
        count.value[count.value[, 1]==d.train.distance[z, 1], 2] <- count.value[count.value[, 1]==d.train.distance[z, 1], 2]+1
      }      
    }
    if(method==2){
      for ( z in 1:k){
        count.value[count.value[, 1]==d.train.distance[z, 1], 2] <- count.value[count.value[, 1]==d.train.distance[z, 1], 2]+(1/d.train.distance[z, ncol(d.train.distance)])
      }      
    }
    count.value <- count.value[c(order(-count.value[, 2])), ]
    predict.test <- c(predict.test, as.character(count.value[1, 1]))
  }
  predicted.class <- as.factor(predict.test)
  return(predicted.class)
}

myNaiveBayes <- function(train, cl){
  #***Priors
  priors <- c()
  unique.cl <- unique(cl)
  unique.cl <- unique.cl[order(unique.cl)]
  for (class in unique.cl){
    print(class)
    priors <- c(priors, length(cl[cl==class])/length(cl))
  }
  names(priors) <- unique.cl
  
  #***Conditionaly Probability
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
}

myInfoEntropy <- function(cl.1, cl.2){
  
  cl.1.prob <- 0
  cl.2.prob <- 0
  cl.1.entropy <- 0
  cl.2.entropy <- 0
  
  for(class in unique(cl.1)){
    cl.1.prob <- length(cl.1[cl.1==class])/length(cl.1)
    cl.1.entropy <- cl.1.entropy-(cl.1.prob*log2(cl.1.prob))
  }
  for(class in unique(cl.2)){
    cl.2.prob <- length(cl.2[cl.2==class])/length(cl.2)
    cl.2.entropy <- cl.2.entropy-(cl.2.prob*log2(cl.2.prob))
  }
  sum.entropy <- (length(cl.1)/(length(cl.1)+length(cl.2)))*cl.1.entropy+(length(cl.2)/(length(cl.1)+length(cl.2)))*cl.2.entropy
  return(sum.entropy)
}

mySplit <- function(dt, cl){
  dt.left <- 0
  dt.right <- 0
  cl.left <- 0
  cl.right <- 0
  
  #***Split
  variables <- factor(colnames(dt))
  variables.num <- length(variables)
  data.bind <- cbind(cl, dt)
  data.row.num <- dim(dt)[1]
  
  minInfo.value <-10
  min.data.bind.left <- 0
  min.data.bind.right <- 0
  
  for( t.var in variables){
    data.bind.temp <- data.bind[c(order(dt[, t.var])),]
    for( i in 1:(data.row.num-1)){
      dt.left <- data.bind.temp[1:i, ]
      dt.right <- data.bind.temp[(i+1):data.row.num, ]
      cl.left <- dt.left[, 1]
      cl.right <- dt.right[, 1]
      temp.ent <- myInfoEntropy(cl.left, cl.right)
      if(minInfo.value>temp.ent){
        min.data.bind.left <- dt.left
        min.data.bind.right <- dt.right
        minInfo.value <- temp.ent
      }
    }
  }
  rownames(min.data.bind.left) <- NULL
  rownames(min.data.bind.right) <- NULL
  t1 <- list(min.data.bind.left[, 2:(variables.num+1)], min.data.bind.left[, 1])
  t2 <- list(min.data.bind.right[, 2:(variables.num+1)], min.data.bind.right[, 1])
  return(list(t1, t2))  
}
