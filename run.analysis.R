library(reshape2)


###download and unzip the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileUrl, "FinalProject")
unzip(FinalProject)

###Read activity labels and features
activityLabelsDS <- read.table("activity_labels.txt")
activityLables <- as.character(activityLabelsDS[,2])
featuresDS <- read.table("features.txt")
features <- as.character(featuresDS[,2])

###Extract only data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features)
featuresNames <- features[featuresWanted]

###read our data sets (train and test)
trainDS <- read.table("train\\X_train.txt")[featuresWanted]
trainActLabels <- read.table("train\\Y_train.txt")
trainSubjects <- read.table("train\\subject_train.txt")
trainDF <- cbind(trainSubjects,trainActLabels, trainDS)

testDS <- read.table("test\\X_test.txt")[featuresWanted]
testActLabels <- read.table("test\\Y_test.txt")
testSubjects <- read.table("test\\subject_test.txt")
testDF <- cbind(testSubjects, testActLabels, testDS)

###merge datasets and labels
Data <- rbind(trainDF, testDF)
colnames(Data) <- c("subject", "activity", featuresNames)

###turn activities & subjects into factors
factor(Data$activity, levels=activityLabelsDS[,1], activityLables)
factor(Data$subject)

###melt and decast
dataMelted <- melt(Data, id=c("subject", "activity"))
dataDecast <- dcast(dataMelted, subject+activity ~ variable, mean)

write.table(dataDecast, "tide.txt", row.names=FALSE, quote=FALSE)


