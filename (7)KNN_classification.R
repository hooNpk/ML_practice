#***KNN Classification (K-Nearest Neighbor)


d.music <- read.csv("(6)CART_music.csv", header=TRUE, sep=",")
d.music <- d.music[, -c(1,2)]
d.music[ ,2:6] <- scale(d.music[, 2:6])
library(class)

d.rock <- d.music[d.music$Type=="Rock", ]
d.classic <- d.music[d.music$Type=="Classical", ]

d.rock.train <- d.rock[1:21, ]
d.rock.test <- d.rock[22:30, ]
d.classic.train <- d.classic[1:16, ]
d.classic.test <- d.classic[17:24, ]

d.train <- rbind(d.rock.train, d.classic.train)
d.test <- rbind(d.rock.test, d.classic.test)

pred.test <- knn(d.train[, -1], d.test[, -1], d.train$Type, 5)
table(d.test$Type, pred.test)
