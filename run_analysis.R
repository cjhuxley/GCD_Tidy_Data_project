#To be run_analysis.R
#Download files
# Merges the training and the test sets to create one data set.Includes addition of a column to indicate 
# if it is test or train data.
#
setwd("C:/Users/Chris/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
#add activity labels
activity<-read.table("activity_labels.txt")
setwd("train")
trainData<-read.table("X_train.txt")
setwd("C:/Users/Chris/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
setwd("test")
testData<-read.table("X_test.txt")
subject<-read.table("subject_test.txt") # test subject labels
testOrTrain<-rep("test",2947)#test lables for testOrTrain column

testData2<-cbind(testOrTrain, subject, testData)
testOrTrain<-rep("train",7352) #train lables for testOrTrain column
subject<-read.table("subject_train.txt") # train subject labels
trainData2<-cbind(testOrTrain,subject,trainData)
#add activity labels
# Merge training and test data into "dataSet"
dataSet<-rbind(testData2,trainData2)

# Add titles to trainData and add subject id 
  #Deal with test labels as they are already open
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 