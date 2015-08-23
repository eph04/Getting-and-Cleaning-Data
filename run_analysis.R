# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set. => OK
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. => OK
# 3. Uses descriptive activity names to name the activities in the data set => OK????
# 4. Appropriately labels the data set with descriptive variable names. => OK????
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable
# for each activity and each subject.
#

# 'features_info.txt': Shows information about the variables used on the feature vector.
#
# 'features.txt': List of all features.
#
# 'activity_labels.txt': Links the class labels with their activity name.
#
# 'train/X_train.txt': Training set.
#
# 'train/y_train.txt': Training labels.
#
# 'test/X_test.txt': Test set.
#
# 'test/y_test.txt': Test labels.
#
# The following files are available for the train and test data. Their descriptions are equivalent.
#
# 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample.
# Its range is from 1 to 30.


######################################
## Load packages
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("plyr")) {
  install.packages("plyr")
}
if (!require("dplyr")) {
  install.packages("dplyr")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("plyr")
require("dplyr")
require("reshape2")

######################################
## Set directories and files path
trainNames <- "train"
testNames <- "test"

rootDir <- "UCI HAR Dataset"
testDir <- paste(rootDir,testNames,sep = "/")
trainDir <- paste(rootDir,trainNames,sep = "/")

activity_labels_file <- paste(rootDir,"activity_labels.txt",sep = "/")
features_file <- paste(rootDir,"features.txt",sep = "/")

trainingSet_file <- paste(trainDir,"/X_", trainNames,".txt",sep = "")
trainingLabels_file <- paste(trainDir,"/y_", trainNames,".txt",sep = "")
trainingSubjects_file <- paste(trainDir,"/subject_", trainNames,".txt",sep = "")

testSet_file <- paste(testDir,"/X_", testNames,".txt",sep = "")
testLabels_file <- paste(testDir,"/y_", testNames,".txt",sep = "")
testSubjects_file <- paste(testDir,"/subject_", testNames,".txt",sep = "")

######################################
## retrieve features
features_df <- read.table(features_file,stringsAsFactors = FALSE,header = FALSE
                          ,colClasses = c("character"),col.names = c("col_nb","col_name"))
features_df <- data.table(features_df)
## formating column names
features <- tolower(sub(features_df$col_name, pattern = "\\(\\)",replacement = ""))
## list of mean/std measurements
featuresKept <- grep(pattern = "(mean|std)\\(\\)",x = features_df$col_name
                                 ,ignore.case = TRUE,value = FALSE)


######################################
## retrieve activities
activity_labels_df <- read.table(activity_labels_file,stringsAsFactors = FALSE
                                 ,header = FALSE,colClasses = c("character"),col.names = c("act_id","act_label"))
activity_labels_df <- data.table(activity_labels_df)

######################################
## retrive training set, subjects and labels
trainingSet_df <- read.table(trainingSet_file,stringsAsFactors = FALSE,header = FALSE
                             ,colClasses = c("numeric"), col.names = features)
trainingLabels_df <- read.table(trainingLabels_file,stringsAsFactors = FALSE
                                ,header = FALSE,colClasses = c("character"), col.names = c("act_id"))
trainingSubjects_df <- read.table(trainingSubjects_file,stringsAsFactors = FALSE
                                ,header = FALSE,colClasses = c("numeric"), col.names = c("subject"))
trainingSet_df <- select(data.table(trainingSet_df), featuresKept)
trainingLabels_df <- data.table(trainingLabels_df)
trainingSubjects_df <- data.table(trainingSubjects_df)

## join/merge data to retrieve activity label
trainingAct_df <- plyr::join(x = trainingLabels_df,y = activity_labels_df
                             ,by = c("act_id"), type = "left", match = "all")
trainingAct_df <- data.table(trainingAct_df)

## combine the two data tables column-wise
if (nrow(trainingSubjects_df) == nrow(trainingSet_df) & nrow(trainingAct_df) == nrow(trainingSet_df)) {
  trainingFullDS <- cbind.data.frame(trainingSubjects_df,trainingAct_df,trainingSet_df)
  rm(trainingSet_df,trainingLabels_df,trainingAct_df,trainingSubjects_df)
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
testSet_df <- select(data.table(testSet_df), featuresKept)
testLabels_df <- data.table(testLabels_df)
testSubjects_df <- data.table(testSubjects_df)

## join/merge data to retrieve activity label
testAct_df <- plyr::join(x = testLabels_df,y = activity_labels_df
                         ,by = c("act_id"), type = "left", match = "all")
testAct_df <- data.table(testAct_df)

## combine the two data tables column-wise
if (nrow(testSubjects_df) == nrow(testSet_df) & nrow(testAct_df) == nrow(testSet_df)) {
  testFullDS <- cbind.data.frame(testSubjects_df,testAct_df,testSet_df)
  rm(testSet_df,testLabels_df,testAct_df,testSubjects_df)
} else {
  stop("Test subjects, label and set should have same number of rows")
}

######################################
## combine both datasets
trainingFullDS <- mutate(trainingFullDS,source_data="training")
testFullDS <- mutate(testFullDS,source_data="test")

fullDS_df <- rbindlist(list(trainingFullDS,testFullDS),use.names = FALSE,fill = FALSE)
rm(trainingFullDS,testFullDS)

by_subjectAct <- fullDS_df %>%
                  select(everything(), -(act_id), -(source_data)) %>%
                  group_by(subject, act_label) %>%
                  summarise_each(funs(mean)) %>%
                  arrange(subject,act_label)

