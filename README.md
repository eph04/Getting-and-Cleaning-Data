# Getting and Cleaning Data Coursera Project Repo

## Project context

One of the most exciting areas in all of data science right now is wearable computing.
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

  <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

  <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

## Project purpose

Create one R script called run_analysis.R that does the following:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in the last step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Run the script

* Create a folder for the project.
* Download the file "getdata_projectfiles_UCI HAR Dataset.zip" from the link above into the created folder and unzip it (it should create a "UCI HAR Dataset" subfolder)
* To run the script, put the run_analysis.R file in the same root folder
* Then set working directory as follows:

```{r}
setwd(<ENTER HERE THE FULL PATH TO THE FOLDER>)
```

* The script can then ben run by sourcing it:

```{r}
source("run_analysis.R")
```

It will install automatically all mendatory packages (data.table, plyr, dplyr and reshape2) if needed.

## Files created

Running the script will produce a **tidy.txt** file directly into the working directory.
This file is the result of the last step listed above. 

A *full_dataset.txt* file corresponding to the preceding step (before aggregating) is also available.

## Data CodeBook

The complete CodeBook (**CodeBook.md**) for the **tidy.txt** is available in this GitHub repo, check it out!


