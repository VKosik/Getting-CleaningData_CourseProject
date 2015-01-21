setwd("D:/DataScience/GettingCleaningData/CourseProject")# setting up desired working directory
library(dplyr) # group, summarize
library(tidyr) # if you don't know why or you have forgotten use ?gather command

url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./dataset.zip")
unzip("dataset.zip")

# reading the datasets
subjectTrain <- read.table("./dataset/train/subject_train.txt")
yTrain       <- read.table("./dataset/train/y_train.txt")
xTrain       <- read.table("./dataset/train/X_train.txt")

subjectTest  <- read.table("./dataset/test/subject_test.txt")
yTest        <- read.table("./dataset/test/y_test.txt")
xTest        <- read.table("./dataset/test/X_test.txt")
# binding the couples (x+x, y+y, subject+subject together by rows, to understand why it is important to know what datasets contain what information)
joinX        <- rbind(xTrain, xTest)
joinY        <- rbind(yTrain, yTest)
joinSubject  <- rbind(subjectTrain, subjectTest); names(joinSubject)  <- "subject"
# the features dataset is a standalone type among the 7files and requires special approach to obtain the mean and s.d. for each measurement
features     <- read.table("./dataset/features.txt")
head(features) # as you can see 1st column is pointless, thus, subsetting and removing right away it is very viable and smart approach
features     <- features[,2]

meanSD       <- grep("mean\\(\\)|std\\(\\)", features[,2]) # this creates a vector of numbers showing where the mean/std is (which row) that will be used to subset 

joinX        <- joinX[, meanSD] # here we go subsetting the only mean/std measurements and we only got 66 columns now

names(joinX) <- features[meanSD, 2]# this is necessary cause without it the columns are named just V1, V2, V32, etc...
names(joinX) <- gsub("\\(\\)", "", names(joinX)) # removes "()"
names(joinX) <- gsub("-", "", names(joinX))# removes "-"
names(joinX) <- tolower(names(joinX))
names(joinX) <- gsub("mean","Mean", names(joinX));names(joinX)  <- gsub("std","Std", names(joinX)) # mean to Mean, std to Std


activity     <- read.table("./dataset/activity_labels.txt")
activity     <- activity[,2]
activity     <- tolower(activity)
activity     <- gsub("_", "", activity)
activityL    <- activity[joinY[, 1]]
joinY[,1]    <- activityL
names(joinY) <- "activity"

ReadyData    <- cbind(joinX, joinY, joinSubject) #creates dataset that is ready to be used for last step of subsetting and analysis
write.table(ReadyData, "ReadyData.txt", row.name = FALSE)

GroupedMeansData  <- group_by(ReadyData, activity, subject) %>% summarise_each(funs(mean)) # instead of horribly long loops one can simply use summarize function that comes with dplyr
write.table(GroupedMeansData, "GroupedMeansData.txt", row.name = FALSE)