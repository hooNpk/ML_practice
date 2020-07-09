library(entropy)
d.music <- read.csv("(6)CART_music.csv")
test1 <- d.music[1:26, 3]
test2 <- d.music[27:54, 3]

myInfoEntropy <- function(cl.1, cl.2){
  
  cl.1.prob <- 0
  cl.2.prob <- 0
  cl.1.entropy <- 0
  cl.2.entropy <- 0
  
  for(class in unique(cl.1)){
    cl.1.prob <- length(cl.1[cl.1==class])/length(cl.1)
    cl.1.entropy <- cl.1.entropy-(cl.1.prob*log2(cl.1.prob))
  }
  #print(cl.1.entropy)
  for(class in unique(cl.2)){
    cl.2.prob <- length(cl.2[cl.2==class])/length(cl.2)
    cl.2.entropy <- cl.2.entropy-(cl.2.prob*log2(cl.2.prob))
  }
  #print(cl.2.entropy)
  sum.entropy <- (length(cl.1)/(length(cl.1)+length(cl.2)))*cl.1.entropy+(length(cl.2)/(length(cl.1)+length(cl.2)))*cl.2.entropy
  return(sum.entropy)
}

print(myInfoEntropy(test1, test2))
entropy.empirical(table(test1)/length(test1), unit="log2")


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
    print(t.var)
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

a <- mySplit(d.music[, 4:8], d.music[, 2])
