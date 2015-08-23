############################################################################
## run_analysis.R
## this script is the recipe to tidy Samsung Galaxy S accelerometers measures
##
## @author: Eric P.
## @date: 2015-08-23
############################################################################

######################################
## Load packages & install any missing
if (!require("dplyr")) {
  install.packages("dplyr")
}
require("dplyr")

######################################
## Set directories and files path
trainNames <- "train"
testNames <- "test"

rootDir <- "UCI HAR Dataset" # change root dir if necessary
testDir <- paste(rootDir,testNames,sep = "/")
trainDir <- paste(rootDir,trainNames,sep = "/")

## common files
activity_labels_file <- paste(rootDir,"activity_labels.txt",sep = "/")
features_file <- paste(rootDir,"features.txt",sep = "/")

## training files
trainingSet_file <- paste(trainDir,"/X_", trainNames,".txt",sep = "")
trainingLabels_file <- paste(trainDir,"/y_", trainNames,".txt",sep = "")
trainingSubjects_file <- paste(trainDir,"/subject_", trainNames,".txt",sep = "")

##test files
testSet_file <- paste(testDir,"/X_", testNames,".txt",sep = "")
testLabels_file <- paste(testDir,"/y_", testNames,".txt",sep = "")
testSubjects_file <- paste(testDir,"/subject_", testNames,".txt",sep = "")

######################################
## retrieve features
features_df <- read.table(features_file,stringsAsFactors = FALSE,header = FALSE
                          ,colClasses = c("character"),col.names = c("col_nb","col_name"))
## formating column names to more descriptive measurements
features <- features_df$col_name # tolower(features_df$col_name)
features <-  gsub("\\(\\)|\\.|-", "", features)
features <-  gsub("Acc", "Accelerometer",features)
features <-  gsub("Gyro", "Gyroscope",features)
features <-  gsub("Mag", "Magnitude",features)
features <-  gsub("BodyBody", "Body",features)
features <-  gsub("mean", "Mean",features)
features <-  gsub("std", "Stdev",features)
features <-  gsub("^t", "time",features)
features <-  gsub("^f", "freq",features)
## list of mean/std measurements to select columns needed
featuresKept <- grep(pattern = "(mean|std)\\(\\)",x = features_df$col_name
                     ,ignore.case = TRUE,value = FALSE)


######################################
## retrieve activities
activity_labels_df <- read.table(activity_labels_file,stringsAsFactors = FALSE
                                 ,header = FALSE,colClasses = c("character")
                                 ,col.names = c("act_id","activity"))

######################################
## retrive training set, subjects and labels
trainingSet_df <- read.table(trainingSet_file,stringsAsFactors = FALSE,header = FALSE
                             ,colClasses = c("numeric"), col.names = features)
trainingLabels_df <- read.table(trainingLabels_file,stringsAsFactors = FALSE
                                ,header = FALSE,colClasses = c("character"), col.names = c("act_id"))
trainingSubjects_df <- read.table(trainingSubjects_file,stringsAsFactors = FALSE
                                ,header = FALSE,colClasses = c("numeric"), col.names = c("subject"))
## select only the desired columns
trainingSet_df <- select(trainingSet_df, featuresKept)
## join/merge data to retrieve activity label
trainingAct_df <- inner_join(x = trainingLabels_df,y = activity_labels_df,by = c("act_id"))

## combine the two data tables column-wise if the number of rows match
if (nrow(trainingSubjects_df) == nrow(trainingSet_df) &
    nrow(trainingAct_df) == nrow(trainingSet_df)) {
  trainingFullDS <- cbind.data.frame(trainingSubjects_df,trainingAct_df,trainingSet_df)
  rm(trainingSet_df,trainingLabels_df,trainingAct_df,trainingSubjects_df) # cleanup
} else {
  stop("Training subjects, label and set should have same number of rows")
}

######################################
## retrive test set, subjects and labels
testSet_df <- read.table(testSet_file,stringsAsFactors = FALSE,header = FALSE
                             ,colClasses = c("numeric"), col.names = features)
testLabels_df <- read.table(testLabels_file,stringsAsFactors = FALSE
                                ,header = FALSE,colClasses = c("character"), col.names = c("act_id"))
testSubjects_df <- read.table(testSubjects_file,stringsAsFactors = FALSE
                                  ,header = FALSE,colClasses = c("numeric"), col.names = c("subject"))
## select only the desired columns
testSet_df <- select(testSet_df, featuresKept)

## join/merge data to retrieve activity label
testAct_df <- inner_join(x = testLabels_df,y = activity_labels_df,by = c("act_id"))

## combine the two data tables column-wise
if (nrow(testSubjects_df) == nrow(testSet_df) & nrow(testAct_df) == nrow(testSet_df)) {
  testFullDS <- cbind.data.frame(testSubjects_df,testAct_df,testSet_df)
  rm(testSet_df,testLabels_df,testAct_df,testSubjects_df) # cleanup
} else {
  stop("Test subjects, label and set should have same number of rows")
}

######################################
## combine both datasets to an almost tidy dataset
trainingFullDS <- mutate(trainingFullDS,source_data="training"
                         ,activity=sub(pattern = "_",x = activity,replacement = " "))
testFullDS <- mutate(testFullDS,source_data="test"
                     ,activity=sub(pattern = "_",x = activity,replacement = " "))
## combine all datasets row-wise using position of columns
fullDS_df <- rbind(trainingFullDS,testFullDS)
rm(trainingFullDS,testFullDS) # cleanup
## for debug
fullDS <- arrange(fullDS_df,subject,activity,source_data)

######################################
## tidy data summarizing by subject and activity
by_subjectAct <- fullDS_df %>%
                  select(everything(), -(act_id), -(source_data)) %>% #keep only columns we want
                  group_by(subject, activity) %>% #group by keys "subject" and "activity"
                  summarise_each(funs(mean)) %>% #run mean function on all columns but the keys
                  arrange(subject,activity) #sort rows by the keys
## rename the tidy dataset columns to their new real meaning (not anymore values, but mean)
colnames(by_subjectAct) <- sub(x = sub(pattern = "^time"
                                    ,replacement = "meanOfTime",x = colnames(by_subjectAct))
                               ,pattern = "^freq",replacement = "meanOfFreq")

######################################
## write tidy data to ouput file
write.table(by_subjectAct, "tidy.txt", row.name=FALSE)
#write.table(fullDS, "full_dataset.txt", row.name=FALSE) #debug

