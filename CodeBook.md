---
title: "Getting and Cleaning Data Coursera Project CodeBook"
author: "eph04"
date: "2015-08-23"
output:
  html_document:
    keep_md: yes
---

## Project Description
The purpose of this project is to collect, merge and tidy some data comming from the accelerometers of the Galaxy S phone during two experiments of multiple observations done by 30 subjects on 6 different activities. The measurement of type *mean* and *standard* deviation need to be summarized by their mean (33 variables * 2 measurement types = 66 columns to retrieve).

As per the README.txt file provided with the data, here is the data origin:

*The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

A complement of information on the input files can be found at the following link:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## Study design and data processing

#### Collection of the raw data

The data used as input for this project can be retrieved using the following uri:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

According to the *features_info.txt* file provided in the zip file:

*The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.*

*Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).*

*Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).*

*These signals were used to estimate variables of the feature vector for each pattern*

The signal data collected are (Acc stands for Accelerometer, Gyro/Gyroscope,Mag/Magnitude):

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions (each axe is a different measurement which is why there are **33 signal observed**).

The set of variables that were estimated from these signals are: 

- ***mean(): Mean value, used in the project***
- ***std(): Standard deviation, used in the project***
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

#### Notes on the original (raw) data 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## Creating the tidy datafile
[See the README file provided for more precise information](./README.md)

#### Guide to create the tidy data file
To create the tidy data set:

1. Create a folder for the project
2. Download the data from the uri provided above into the created folder
3. Unzip the data into the folder. It will create a "UCI HAR Dataset" folder
4. Copy the run_analysis.R into the project folder (not into the "UCI HAR Dataset" one)
5. Set the working directory to the project folder
6. Source the run_analysis.R in R or RStudio console
7. The tidy.txt data file created inside the project folder contains the tidy data

#### Cleaning of the data
The cleaning process is as follows:

1. Retrieve all features and activities
2. Clean the feature names from useless characters ().-
3. Rewrite the variable names using human readable words (Acc to Accelerometer)
4. Create a filter list containing only mean() and std() variables
5. Merge Subject, Activities and Measurement data for both *train* and *test* experiments
6. Merge *train* and *test* experiments data

## Description of the variables in the tiny.txt file

#### Dimensions of the dataset
As previously mentionned, 66 measurements (**33 signal observed** times 2 variable types *mean* and *std*) needs to be retrieved and summarized using the mean function by **subject (30)** and **activities (6)**. 

Using a **wide format** (each measurement is in a column of the observation row) for the output, it should be of dimension:

30 subjects * 6 activities x 66 measurements mean + 2 attributes (subject id and activity name)

Output dimensions: table of 180 rows and 68 columns

#### Attributes

The two attributes on which the tidy data set has been aggregated and summarized are the **subject id** (numeric) and the **activity name** (character).

There are 30 subjects for the experiments, numbered from 1 to 30.

There are 6 activities, WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING and LAYING.

#### Variables

All variables are of numeric class (calculated mean of variables) except for the two first which are the attributes of character class.

| Variable name | Description |
|---|---------|
| subject | Experiment's subject id |
| activity | Activity name |
| meanOfTimeBodyAccelerometerMeanX | Mean of means of the time dimension on the body measured by the accelerometer on axis X |
| meanOfTimeBodyAccelerometerMeanY | Mean of means of the time dimension on the body measured by the accelerometer on axis Y |
| meanOfTimeBodyAccelerometerMeanZ | Mean of means of the time dimension on the body measured by the accelerometer on axis Z |
| meanOfTimeBodyAccelerometerStdevX | Mean of standard deviation of the time dimension on the body measured by the accelerometer on axis X |
| meanOfTimeBodyAccelerometerStdevY | Mean of standard deviation of the time dimension on the body measured by the accelerometer on axis Y |
| meanOfTimeBodyAccelerometerStdevZ | Mean of standard deviation of the time dimension on the body measured by the accelerometer on axis Z |
| meanOfTimeGravityAccelerometerMeanX | Mean of means of the time dimension on the gravity measured by the accelerometer on axis X |
| meanOfTimeGravityAccelerometerMeanY | Mean of means of the time dimension on the gravity measured by the accelerometer on axis Y |
| meanOfTimeGravityAccelerometerMeanZ | Mean of means of the time dimension on the gravity measured by the accelerometer on axis Z |
| meanOfTimeGravityAccelerometerStdevX | Mean of standard deviation of the time dimension on the gravity measured by the accelerometer on axis X |
| meanOfTimeGravityAccelerometerStdevY | Mean of standard deviation of the time dimension on the gravity measured by the accelerometer on axis Y |
| meanOfTimeGravityAccelerometerStdevZ | Mean of standard deviation of the time dimension on the gravity measured by the accelerometer on axis Z |
| meanOfTimeBodyAccelerometerJerkMeanX | Mean of Jerk means of the time dimension on the body measured by the accelerometer on axis X |
| meanOfTimeBodyAccelerometerJerkMeanY | Mean of Jerk means of the time dimension on the body measured by the accelerometer on axis Y |
| meanOfTimeBodyAccelerometerJerkMeanZ | Mean of Jerk means of the time dimension on the body measured by the accelerometer on axis Z |
| meanOfTimeBodyAccelerometerJerkStdevX | Mean of Jerk standard deviation of the time dimension on the body measured by the accelerometer on axis X |
| meanOfTimeBodyAccelerometerJerkStdevY | Mean of Jerk standard deviation of the time dimension on the body measured by the accelerometer on axis Y |
| meanOfTimeBodyAccelerometerJerkStdevZ | Mean of Jerk standard deviation of the time dimension on the body measured by the accelerometer on axis Z |
| meanOfTimeBodyGyroscopeMeanX | Mean of means of the time dimension on the body measured by the gyroscope on axis X |
| meanOfTimeBodyGyroscopeMeanY | Mean of means of the time dimension on the body measured by the gyroscope on axis Y |
| meanOfTimeBodyGyroscopeMeanZ | Mean of means of the time dimension on the body measured by the gyroscope on axis Z |
| meanOfTimeBodyGyroscopeStdevX | Mean of standard deviation of the time dimension on the body measured by the gyroscope on axis X |
| meanOfTimeBodyGyroscopeStdevY | Mean of standard deviation of the time dimension on the body measured by the gyroscope on axis Y |
| meanOfTimeBodyGyroscopeStdevZ | Mean of standard deviation of the time dimension on the body measured by the gyroscope on axis Z |
| meanOfTimeBodyGyroscopeJerkMeanX | Mean of Jerk means of the time dimension on the body measured by the gyroscope on axis X |
| meanOfTimeBodyGyroscopeJerkMeanY | Mean of Jerk means of the time dimension on the body measured by the gyroscope on axis Y |
| meanOfTimeBodyGyroscopeJerkMeanZ | Mean of Jerk means of the time dimension on the body measured by the gyroscope on axis Z |
| meanOfTimeBodyGyroscopeJerkStdevX | Mean of Jerk standard deviation of the time dimension on the body measured by the gyroscope on axis X |
| meanOfTimeBodyGyroscopeJerkStdevY | Mean of Jerk standard deviation of the time dimension on the body measured by the gyroscope on axis Y |
| meanOfTimeBodyGyroscopeJerkStdevZ | Mean of Jerk standard deviation of the time dimension on the body measured by the gyroscope on axis Z |
| meanOfTimeBodyAccelerometerMagnitudeMean | Mean of means magnitude of the time dimension on the body measured by the accelerometer |
| meanOfTimeBodyAccelerometerMagnitudeStdev | Mean of standard deviation magnitude of the time dimension on the body measured by the accelerometer |
| meanOfTimeGravityAccelerometerMagnitudeMean | Mean of means magnitude of the time dimension on the gravity measured by the accelerometer |
| meanOfTimeGravityAccelerometerMagnitudeStdev | Mean of standard deviation magnitude of the time dimension on the gravity measured by the accelerometer |
| meanOfTimeBodyAccelerometerJerkMagnitudeMean | Mean of Jerk means magnitude of the time dimension on the body measured by the accelerometer |
| meanOfTimeBodyAccelerometerJerkMagnitudeStdev | Mean of Jerk standard deviation magnitude of the time dimension on the body measured by the accelerometer |
| meanOfTimeBodyGyroscopeMagnitudeMean | Mean of means magnitude of the time dimension on the body measured by the gyroscope |
| meanOfTimeBodyGyroscopeMagnitudeStdev | Mean of standard deviation magnitude of the time dimension on the body measured by the gyroscope |
| meanOfTimeBodyGyroscopeJerkMagnitudeMean | Mean of Jerk means magnitude of the time dimension on the body measured by the gyroscope |
| meanOfTimeBodyGyroscopeJerkMagnitudeStdev | Mean of Jerk standard deviation magnitude of the time dimension on the body measured by the gyroscope |
| meanOfFreqBodyAccelerometerMeanX | Mean of means of the frequency dimension on the body measured by the accelerometer on axis X |
| meanOfFreqBodyAccelerometerMeanY | Mean of means of the frequency dimension on the body measured by the accelerometer on axis Y |
| meanOfFreqBodyAccelerometerMeanZ | Mean of means of the frequency dimension on the body measured by the accelerometer on axis Z |
| meanOfFreqBodyAccelerometerStdevX | Mean of standard deviation of the frequency dimension on the body measured by the accelerometer on axis X |
| meanOfFreqBodyAccelerometerStdevY | Mean of standard deviation of the frequency dimension on the body measured by the accelerometer on axis Y |
| meanOfFreqBodyAccelerometerStdevZ | Mean of standard deviation of the frequency dimension on the body measured by the accelerometer on axis Z |
| meanOfFreqBodyAccelerometerJerkMeanX | Mean of Jerk means of the frequency dimension on the body measured by the accelerometer on axis X |
| meanOfFreqBodyAccelerometerJerkMeanY | Mean of Jerk means of the frequency dimension on the body measured by the accelerometer on axis Y |
| meanOfFreqBodyAccelerometerJerkMeanZ | Mean of Jerk means of the frequency dimension on the body measured by the accelerometer on axis Z |
| meanOfFreqBodyAccelerometerJerkStdevX | Mean of Jerk standard deviation of the frequency dimension on the body measured by the accelerometer on axis X |
| meanOfFreqBodyAccelerometerJerkStdevY | Mean of Jerk standard deviation of the frequency dimension on the body measured by the accelerometer on axis Y |
| meanOfFreqBodyAccelerometerJerkStdevZ | Mean of Jerk standard deviation of the frequency dimension on the body measured by the accelerometer on axis Z |
| meanOfFreqBodyGyroscopeMeanX | Mean of means of the frequency dimension on the body measured by the gyroscope on axis X |
| meanOfFreqBodyGyroscopeMeanY | Mean of means of the frequency dimension on the body measured by the gyroscope on axis Y |
| meanOfFreqBodyGyroscopeMeanZ | Mean of means of the frequency dimension on the body measured by the gyroscope on axis Z |
| meanOfFreqBodyGyroscopeStdevX | Mean of standard deviation of the frequency dimension on the body measured by the gyroscope on axis X |
| meanOfFreqBodyGyroscopeStdevY | Mean of standard deviation of the frequency dimension on the body measured by the gyroscope on axis Y |
| meanOfFreqBodyGyroscopeStdevZ | Mean of standard deviation of the frequency dimension on the body measured by the gyroscope on axis Z |
| meanOfFreqBodyAccelerometerMagnitudeMean | Mean of means magnitude of the frequency dimension on the body measured by the accelerometer |
| meanOfFreqBodyAccelerometerMagnitudeStdev | Mean of standard deviation magnitude of the frequency dimension on the body measured by the accelerometer |
| meanOfFreqBodyAccelerometerJerkMagnitudeMean | Mean of Jerk means magnitude of the frequency dimension on the body measured by the accelerometer |
| meanOfFreqBodyAccelerometerJerkMagnitudeStdev | Mean of Jerk standard deviation magnitude of the frequency dimension on the body measured by the accelerometer |
| meanOfFreqBodyGyroscopeMagnitudeMean | Mean of means magnitude of the frequency dimension on the body measured by the giroscope |
| meanOfFreqBodyGyroscopeMagnitudeStdev | Mean of standard deviation magnitude of the frequency dimension on the body measured by the giroscope |
| meanOfFreqBodyGyroscopeJerkMagnitudeMean | Mean of Jerk means magnitude of the frequency dimension on the body measured by the giroscope |
| meanOfFreqBodyGyroscopeJerkMagnitudeStdev | Mean of Jerk standard deviation magnitude of the frequency dimension on the body measured by the giroscope |




