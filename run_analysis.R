#run_analysis.R
# 
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
    if (ncol(testData) != ncol(trainData)){stop( "columns in sets not equal")}
    dataSet<-rbind(testData,trainData)
    rm(testData)
    rm(trainData)
    setwd(home)
    features <- read.table("features.txt")
    headings<- c(as.character(features$V2),"subject")
    colnames(dataSet)<-headings
  
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
    meanStdData<-dataSet[,grep("mean|std|subject", names(dataSet))]
    rm(dataSet)
# 3. Use descriptive activity names to name the activities in the data set

    setwd(home)
    labels<-read.table("activity_labels.txt") # labels 
  
  # input relevant data from train folder
    setwd("train")
    subjectTraining<-read.table("subject_train.txt") 
    activityTrain<- read.table("y_train.txt")
    setwd(home)
  
  # input relevant data from test folder
    setwd("test")
    subjectTesting<-read.table("subject_test.txt")
    activityTest<- read.table("y_test.txt")
    setwd(home)
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
    temp<-gsub("[[:punct:]]","",names(meanStdData)) #remove punctuation characters
    temp<-gsub("mean", "Mean",temp)
    temp<-gsub("std", "Std",temp)
    temp<-gsub("^t","time",temp) # make [t]ime more meaningful
    temp<-gsub("^f","freq",temp) # make [f]requency more meaningful
    names(meanStdData)<- paste(temp)
  
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
  data<-meanStdData[order(meanStdData$subject,meanStdData$activity),]
  #check no missing values
  if (sum(!(complete.cases(data))) != 0){ 
    stop( "missing values")}
  #melt data
  library(reshape2)
  melt1<-melt(data,id=c("activity","subject"))
  #cast 2 sets variable by activity and variable by subject then merge them
  activitySet<-dcast(melt1, variable~activity,mean)
  subjectSet<-dcast(melt1, variable~subject,mean)
  summaryTable<-merge(activitySet, subjectSet, by= "variable" )
  # Now fix the titles
  tempNames<-paste(gsub("_","",names(summaryTable)))
  tempNames<-paste(tolower(names(summaryTable)))
  for (n in 8:37){ tempNames[n]<-paste("subject",tempNames[n],sep="")}
  names(summaryTable)<-paste(tempNames)
  #...and finally, save the final data table as a text file called "tidyData2.txt
  write.table(summaryTable, file="tidyData2.txt", sep=" ",row.names=FALSE)
  
  #an alternative...
  #write.csv(summaryTable, file="tidyData2.csv",row.names=FALSE)
  

  
  