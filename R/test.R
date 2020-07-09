d.music <- read.csv("(6)CART_music.csv", header=TRUE, sep=",")
d.music <- d.music[, -c(1,2)]
d.music[ ,2:6] <- scale(d.music[, 2:6])
d.rock <- d.music[d.music$Type=="Rock", ]
d.classic <- d.music[d.music$Type=="Classical", ]
d.rock.train <- d.rock[1:21, ]
d.rock.test <- d.rock[22:30, ]
d.classic.train <- d.classic[1:16, ]
d.classic.test <- d.classic[17:24, ]
d.train <- rbind(d.rock.train, d.classic.train)
d.test <- rbind(d.rock.test, d.classic.test)
train <- d.train[, -1]
test <- d.test[, -1]
cl <- d.train[, 1]
k<-5
method <- 2

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
  
  #***TODO***d.train.weight
  
  #Set for how many each variable value's 
  num.type <- nlevels(cl)
  col.set <- c(rep(0, times=num.type))
  count.value <- data.frame(levels(cl), col.set) 
  
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
as.factor(predict.test)
