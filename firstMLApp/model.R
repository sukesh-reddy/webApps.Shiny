########################
# Modelling iris data
########################

# loading Libraries
library(RCurl)
library(randomForest)
library(caret)

# loading iris data
data("iris")

# Perform random splitting of the data set
trainingIndexes <- createDataPartition(iris$Species,p=0.8,list=F)
trainingSet <- iris[trainingIndexes,]
testData <- iris[-trainingIndexes,]

model <- randomForest(Species~.,data=trainingSet,ntree=500,mtry=4,importance=T)

saveRDS(model,'model.rds')
