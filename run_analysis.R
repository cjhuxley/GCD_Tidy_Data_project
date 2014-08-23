#run_analysis.R

# 1. Merges the training and the test sets to create one data set.
  
  home<-getwd() #Assume the R file is in "UCI HAR Dataset" folder
  
  #load activity labels
  activity<-read.table("activity_labels.txt")
  
  
  #load training data then test data and add subject ID to each
    setwd("train")
    trainData<-read.table("X_train.txt")
    subject<-read.table("subject_train.txt") # train subject labels
    trainData<-cbind(trainData,subject)
    setwd(home)
    setwd("test")
    testData<-read.table("X_test.txt")
    subject<-read.table("subject_test.txt") # test subject labels
    testData<-cbind(testData,subject)
  
  # Merge training and test data into "dataSet" and add titles
    dataSet<-rbind(testData,trainData)
    setwd(home)
    features <- read.table("features.txt")
    headings<- c(as.character(features$V2),"subject")
    colnames(dataSet)<-headings

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
    meanStdData<-dataSet[,grep("mean|std|subject", names(dataSet))]

# 3. Use descriptive activity names to name the activities in the data set

    setwd(home)
    labels<-read.table("activity_labels.txt") # labels 
  
  # input relevant data from train folder
    setwd("train")
    subjectTraining<-read.table("subject_train.txt") 
    activityTrain<- read.table("y_train.txt")
    setwd("C:/Users/Chris/Desktop/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
  
  # input relevant data from test folder
    setwd("test")
    subjectTesting<-read.table("subject_test.txt")
    activityTest<- read.table("y_test.txt")
  
  # bind subject and activity data
    subjects<-rbind(subjectTraining,subjectTesting)
    activityNums<-rbind(activityTrain,activityTest)
  
  #use sapply and gsub to replace numbers with labels
    for (i in 1:nrow(labels)){
      activityNums<-as.data.frame(sapply(activityNums,gsub,pattern= i, replacement=labels[i,2]))
      
    }
    activity<-activityNums
    meanStdData<-cbind(meanStdData,activity)
    names(meanStdData)[81]<-paste("activity") # add descriptive label to column

# 4.Appropriately labels the data set with descriptive variable names. 
# remove 
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 