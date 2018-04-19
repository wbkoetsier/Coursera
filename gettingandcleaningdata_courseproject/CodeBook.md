# Getting And Cleaning Data Course Project Code Book #
WBKoetsier 22 MAR 2015 <br />
https://github.com/wbkoetsier/gettingandcleaningdata_courseproject

## Files in this repo ##
This repo contains 3 files:

- README.md describes the script, it's dependencies and how to run it (and urges you to read this code book).
- CodeBook.md is this file, describing the data in detail.
- run_analysis.R is the script this is all about.

## Objective ##
This project is the final project for the Coursera/Johns Hopkins course 'Getting And Cleaning Data'. The main objective for this project is 'to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis' (taken from the course project assignment and submission page).

## The project assignment ##
The project assignment boils down to writing a script, a code book explaining the data and the script and a short README to get started. These files should be stored in a Git repo.

## The data ##
The data used was collected from wearables, in this case the accelerometers from the Samsung Galaxy S smartphone. For this assignment, it's not important what data this is exactly. The data set has been chosen by the course instructors, probably because students can meet the assignment objective well using this particular data.

But tidying and analysing data always requires careful examination of the given data. So a full explanation on how and why the data were obtained can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Summarising, 30 subjects wore a phone and performed six different activities like standing and walking. The data were then collected from the phones. The data, including amongst others gyroscope and gravity measurements, was normalised such that all values are between
-1 and 1.

The complete (normalised) dataset is available here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
It includes the phone measurements divided into a train and test set (this is a standard procedure when data is used for machine learning), identifiers for activities and separate lists for which subject's phone produced which values (train and test). The measurements (called features) are explained in a separate info file.

The contents of the data zip file are:

```
    UCI HAR Dataset
      activity_labels.txt
      features_info.txt
      features.txt
      README.txt
      test/
        Inertial Signals/
        subject_test.txt
        X_test.txt
        y_test.txt
      train/
        Inertial Signals/
        subject_train.txt
        X_train.txt
        y_train.txt
```

The inertial signals are not used in this project.

-  features.txt is a list of all 561 feature (measurement) names, character. Note: there are duplicate names!
-  features_info.txt explais these in detail
-  activity_labels.txt lists class labels and matching activities, in total 6 different activities, numeric and character
-  train/test X data: actual data, 561 columns (features or measurements), 7352/2947 observations
-  train/test y data: labels (activities 1-6) for X, numeric, 7352/2947 observations
-  Total number of observations: 10299
-  subject_train/test.txt: which person was observed (7352/2947 observations for 30 subjects), numeric

## The run_analysis.R script ##
Detailed information about the script, it's dependencies and how to run it can de found in this repo's README file.

## The output data ##
The output data, means_data.txt, has 68 columns and 180 rows. The first column, 'Activity', is the activity text label, for example 'WALKING'. The second column, 'SubjectID', is the subject ID number. These numbers range from 1 to 30, each subject his/her own unique ID. All other columns are the calculated means: for each combination of subject and activity there are 66 means. A mean for each feature. I kept the original feature names, since these names were already chosen carefully and are descriptive for these data. For more info on these names, check features\_info.txt in the original data set.

Note: I should have put the subject ID before the activity label, saw that too late.

## Tips for viewing the data ##
The dplyr package has two handy features for this.

- View(my_data) will open a new window displaying tabular data like a spreadsheet. Originally from package utils.
- printing a data frame, either a normal one or a dplyr tbl_df, doesn't print the entire dataset, but rather prints a head of 10 lines and as many columns that will fit the screen. After that, it print which values it hasn't printed. Below an example of the means\_data, just before it is written to file.

```
    > means
    Source: local data frame [180 x 68]
    Groups: Activity

       Activity SubjectID tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
    1   WALKING         1         0.2773308       -0.01738382        -0.1111481
    2   WALKING         2         0.2764266       -0.01859492        -0.1055004
    3   WALKING         3         0.2755675       -0.01717678        -0.1126749
    4   WALKING         4         0.2785820       -0.01483995        -0.1114031
    5   WALKING         5         0.2778423       -0.01728503        -0.1077418
    6   WALKING         6         0.2836589       -0.01689542        -0.1103032
    7   WALKING         7         0.2755930       -0.01865367        -0.1109122
    8   WALKING         8         0.2746863       -0.01866289        -0.1072521
    9   WALKING         9         0.2785028       -0.01808920        -0.1108205
    10  WALKING        10         0.2785741       -0.01702235        -0.1090575
    ..      ...       ...               ...               ...               ...
    Variables not shown: tBodyAcc-std()-X (dbl), tBodyAcc-std()-Y (dbl),
      tBodyAcc-std()-Z (dbl), tGravityAcc-mean()-X (dbl), tGravityAcc-mean()-Y
      (dbl), tGravityAcc-mean()-Z (dbl), tGravityAcc-std()-X (dbl),
      tGravityAcc-std()-Y (dbl), tGravityAcc-std()-Z (dbl), tBodyAccJerk-mean()-X
      (dbl), tBodyAccJerk-mean()-Y (dbl), tBodyAccJerk-mean()-Z (dbl),
      tBodyAccJerk-std()-X (dbl), tBodyAccJerk-std()-Y (dbl), tBodyAccJerk-std()-Z
      (dbl), tBodyGyro-mean()-X (dbl), tBodyGyro-mean()-Y (dbl), tBodyGyro-mean()-Z
      (dbl), tBodyGyro-std()-X (dbl), tBodyGyro-std()-Y (dbl), tBodyGyro-std()-Z
      (dbl), tBodyGyroJerk-mean()-X (dbl), tBodyGyroJerk-mean()-Y (dbl),
      tBodyGyroJerk-mean()-Z (dbl), tBodyGyroJerk-std()-X (dbl),
      tBodyGyroJerk-std()-Y (dbl), tBodyGyroJerk-std()-Z (dbl), tBodyAccMag-mean()
      (dbl), tBodyAccMag-std() (dbl), tGravityAccMag-mean() (dbl),
      tGravityAccMag-std() (dbl), tBodyAccJerkMag-mean() (dbl),
      tBodyAccJerkMag-std() (dbl), tBodyGyroMag-mean() (dbl), tBodyGyroMag-std()
      (dbl), tBodyGyroJerkMag-mean() (dbl), tBodyGyroJerkMag-std() (dbl),
      fBodyAcc-mean()-X (dbl), fBodyAcc-mean()-Y (dbl), fBodyAcc-mean()-Z (dbl),
      fBodyAcc-std()-X (dbl), fBodyAcc-std()-Y (dbl), fBodyAcc-std()-Z (dbl),
      fBodyAccJerk-mean()-X (dbl), fBodyAccJerk-mean()-Y (dbl),
      fBodyAccJerk-mean()-Z (dbl), fBodyAccJerk-std()-X (dbl), fBodyAccJerk-std()-Y
      (dbl), fBodyAccJerk-std()-Z (dbl), fBodyGyro-mean()-X (dbl),
      fBodyGyro-mean()-Y (dbl), fBodyGyro-mean()-Z (dbl), fBodyGyro-std()-X (dbl),
      fBodyGyro-std()-Y (dbl), fBodyGyro-std()-Z (dbl), fBodyAccMag-mean() (dbl),
      fBodyAccMag-std() (dbl), fBodyBodyAccJerkMag-mean() (dbl),
      fBodyBodyAccJerkMag-std() (dbl), fBodyBodyGyroMag-mean() (dbl),
      fBodyBodyGyroMag-std() (dbl), fBodyBodyGyroJerkMag-mean() (dbl),
      fBodyBodyGyroJerkMag-std() (dbl)
```

## End code book ##



