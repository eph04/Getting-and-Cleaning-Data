# Getting and Cleaning Data Coursera Project

## Project context

One of the most exciting areas in all of data science right now is wearable computing.
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

Here is an interesting post on those devices: <http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand>

As per the README.txt file provided with the data, here is the data origin:

*The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

*The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.*

## Project purpose

#### Tidy data

The purpose of this project is to collect, merge and tidy some data comming from the accelerometers of the Galaxy S phone. Those data are spread across multiple files that need to be joined and merged.

The basic principals of tidy data are:

1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

#### Tasks

Create one R script called run_analysis.R that does the following:

* Merges the training and the test sets to create one data set. Those two data sets are composed of 3 different input files containing measures, acitivities and subject id.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names. 
* From the data set in the last step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Then the script should be uploaded to github along this readme file and the data codebook (containing the data set description).

## Input Data

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

A full description is available at the site where the data was obtained:

  <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

  <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

In the zipped folder are 2 common data sets as well as two subfolder ("train" an "test") containing data for the two experiments. An additionnal file features_info.txt gives a full description of all measurements given.

#### features.txt	
List of the 561 measurements taken by the phone on two columns: column 1 is the id and column 2 is the label of the measurement.

#### activity_labels.txt
List of the 6 activities tracked by the phone on two columns: column 1 is the id and column 2 is the activity label which may contain underscore to separate words

#### < train | test >/subject_< train | test >.txt
List of the 30 subjects who performed the activity for each window sample on one column.

#### < train | test >/X_< train | test >.txt
Complete set of the 561 measurements for each observed experiment on one of the six activities for a specific person. One row correspond to 561 measurements for one activity survey for one person.

#### < train | test >/y_< train | test >.txt	
List of the activities corresponding to each row of data in the test measurement X_< train | test >.txt file.

#### Notes
- The files contained into the < train | test >/Inertial Signals/ subfolders are of no use in this particular project
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

#### License
*Use of this dataset in publications must be acknowledged by referencing the following publication:*

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

*This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.*

*Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.*

## Tiding data

#### Merging data
Data must be merged at two levels:

- Columns containing *Measurements* must be merged column-wise with both *subject* and *activity* lists
- Rows from both *test* and *train* experiments needs to be row-wisely merged

#### Calculating the average
The averaging method used in this tidy data set is the arithmetic average or *mean*.

#### Measurements names
Tidy data needs self-explanatory variables in order to be of better use during future analysis.

In the input dataset are some typo errors (BodyBody instead of Body), useless characters (like parentheses, hyphen or dots) that need to be corrected.

I addition some abbreviations needs to be converted into human-readable format:

- Acc to Accelerometer
- Gyro to Gyroscope
- Mag to Magnitude
- mean to Mean
- std to Stdev (standard deviation)

Plus

- leadind "t" to time
- leading "f" to freq (frenquecy)

After calculating the mean of each measurement, value columns are renamed as:

- leadind "time" to meanOfTime
- leading "freq" to meanOfFreq

#### Measurements needed for the project
Mean and standard deviations measurements needs to be retrieved. According to the *features_info.txt* file describing the input data set measurements, 33 variables are collected during the experiment. With two types of measurements needed, we need to retrieve 66 columns for the tidy data.

#### Activities names
Activities with multiple words have those words separated by underscores which should be replaced by spaces.

#### Output data
As previously mentionned, 66 measurements needs to be retrieved and summarized using the mean function by subject (30) and activities (6). 

Using a **wide format** (each measurement is in a column of the observation row) for the output, it should be of dimension:

30 subjects * 6 activities x 66 measurements mean + 2 attributes (subject id and activity name)

Output: table of 180 rows and 68 columns

Using a **long format** for the output, the dimensions should be:

30 subjects * 6 activities * 66 measurements mean x measurement label + measurement mean and 2 attributes (subject id, activity name)

Output: table of 11880 rows and 4 columns

***Here I used a wide format for the tidy data, so the output is of dimension 180x68***

#### Script process
Here is a pseudo-code relating how the data is processed to a tidy set.

1. Load packages & install any missing
2. Set directories and files path
3. Retrieve features data, name correctly the columns, column class "character"
4. Format columns names to more descriptive measurements names according to previous rules
5. Create a list of mean/std measurements columns to select the columns needed later
6. Retrieve activities data, name correctly the columns, column class "character"
7. Retrive training measurement set, subjects and labels
    1. Use the feature data retrieved previously as column names, column class "numeric"
    2. Select only the desired columns
    3. Merge data to retrieve activity label using a join between labels file and activity list
    4. Combine the *subject* and *activities* data tables column-wise to the measurement data if the number of rows match
8. Repeat step 7 for the test measurement files
9. Combine row-wisely using position of columns both *train* and *test* datasets to an almost tidy dataset
10. Tidy data summarizing by subject and activity
    1. Group by *subject* and *activities*
    2. Calculate the mean for each other column
    3. Order rows by the keys
11. Rename the tidy dataset columns to their new real meaning (not anymore values, but mean)
12. Write tidy data to ouput file

## Data CodeBook

The complete [CodeBook](./CodeBook.md) (**CodeBook.md**) for the **tidy.txt** is available in this GitHub repo, check it out!

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

It will install automatically all mendatory packages (dplyr here) if needed.

## Files created

Running the script will produce a **tidy.txt** file directly into the working directory.
This file is the result of the last step listed above. A sample of this file is currently in the github repo.

A *full_dataset.txt* file corresponding to the preceding step (before aggregating) can also be generated by uncommenting some lines.



