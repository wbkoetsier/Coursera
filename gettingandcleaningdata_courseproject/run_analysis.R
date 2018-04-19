### run_analysis.R
# This script calculates the mean for each feature, grouped by activity
# and subject.
# The data used is collected from wearables, in this case the
# accelerometers from the Samsung Galaxy S smartphone. A full
# explanation on how and why the data were obtained can be found:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Summarising, 30 subjects wore a phone and performed six different
# activities like standing and walking. The data were then collected
# from the phones. The data, including amongst others gyroscope and
# gravity measurements, was normalised such that all values are between
# -1 and 1.
# The complete (normalised) dataset is available here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# It includes the phone measurements divided into a train and test set
# (the purpose of that  is to use the data for machine learning),
# identifiers for activities and separate lists for which subject's
# phone produced which values (train and test). The measurements
# (called features) are explained in a separate info file.

### It's a function, so we can source
run_analysis <- function() {

### libraries
print('Attempting to load package dplyr. If this fails, R will throw an error and the script will stop. You then probably have to install dplyr. You can accomplish this by running (in R): install.packages("dplyr")')
library(dplyr)

### Check working directory
# Since I'm not sure what exactly is meant by 'as long as the Samsung
# data is in your working directory', I'll add a quick check to see
# if 'activity_labels.txt' is in the current working directory. If
# not, checks if there is a directory called 'UCI HAR Dataset' (note
# the spaces, this is what the directory was called after running
# unzip on the original zip file). If there is, change working
# directory to it. If not, print a message about setting the correct
# working directory.
print("Checking working directory...")
if (!"activity_labels.txt" %in% dir()) { 
  if ("UCI HAR Dataset" %in% dir() ) {
    print("Found a file called 'UCI HAR Dataset', trying to change working dir to there. Execution of the script will stop if this doesn't work. In that case, change to the directory containing the Samsung data ('UCI HAR Dataset') and try again.")
    setwd("UCI HAR Dataset")
  } else {
    stop("I can't find 'activity_labels.txt' file nor a file (directory) called 'UCI HAR Dataset'. I am assuming the working directory is incorrect. Please change it (using setwd() from within R or run the R CMD from the appropriate directory) and try again.")
  }
}
print(paste("Current working directory is:", getwd(), ", moving on"))
### End Check working directory
#####################################################################

### Read in train and test data
# X_train and X_test do not have a header (nor row names). The contents
# are numeric. The sep is " " a space.
# read.table using colClasses=numeric will read in the numbers as they
# are. However, when printed, precision seems to have been lost. This is
# not the case. It is merely what 'you' set as default number of digits
# to print in your options (?options). To check, try something like
# 'print(mydata, digits=10)'.
# Directly convert the table to dplyr data frame.
print("Read in X data and concatenate")
train <- tbl_df(read.table("./train/X_train.txt", colClasses = "numeric"))
test  <- tbl_df(read.table("./test/X_test.txt", colClasses = "numeric"))

# concatenate X_train and X_test into a data frame with 561 columns
# and 10299 rows
X_data <- bind_rows(train, test)

# cleanup train and test data frames
rm(train, test)
### End Read in train and test data
#####################################################################

### Add feature names to data
# Read in features.txt into a data frame with 2 columns and 561 rows and
# use the 2nd column as column names for X_data.
# The default colClass for read.table is character, but extracting the
# features column produces a factor, so coerce.
print("Read in features and use as column names for X")
features <- tbl_df(read.table("features.txt"))
feature_names <- as.character(features$V2) # need this vector later on too
colnames(X_data) <- feature_names
### End Add feature names to data
#####################################################################

### Select mean() and std() columns from data
# Select columns based on grep -e "mean()" -e "std()" features.txt
#     Why 'mean()' and 'std()'? The assignment was unclear on what
#      exactly is 'Extracts only the measurements on the mean and
#      standard deviation for each measurement'. From the estimated
#      set of variables (features_info.txt) only three are related to
#      mean and standard deviation:
#       mean(): Mean value
#       std(): Standard deviation
#       meanFreq(): Weighted average of the frequency components to
#        obtain a mean frequency
#     The mean() and std() variables apply to all data. The meanFreq()
#      variable, according to features_info.txt, applies only to the
#      frequency domain signals. So even though it is a mean, I have
#      excluded it.
# Important to note: there are duplicate column names! select() can't
# handle those for some reason, so I'll use grep instead to create a
# vector of wanted column names. Next, I still can't use select()
# because the names contain invalid characters. This causes select()
# to throw 'Error: found duplicated column name'.
# Specifically tell grep that I want a ( directly after mean|std. It
# didn't work as expected otherwise.
columns_to_select <- feature_names[grep("(mean|std).{0}\\(\\)", feature_names)]
mean_std_X_data <- X_data[, columns_to_select]
# clean up
rm(X_data, features, feature_names, columns_to_select)
### End Select mean() and std() columns from data
#####################################################################

### Add activity and subject labels to the data

# Read in y_train.txt and y_test.txt
print("Read in y data and concatenate")
train <- tbl_df(read.table("./train/y_train.txt", colClasses = "numeric"))
test  <- tbl_df(read.table("./test/y_test.txt", colClasses = "numeric"))
# Concatenate the y data (the activity labels for the X data) into a
# data frame with 1 column and 10299 rows
y_data <- bind_rows(train, test)

# Read in activity text labels into a data frame with 2 columns and
# 6 rows
print("Read in activity labels")
activity_labels <- tbl_df(read.table("activity_labels.txt", colClasses = "character"))

# Change the y_data numbers into activity text labels using factors.
# Credit goes to David Hood, per his mtcars example in
# https://class.coursera.org/getdata-012/forum/thread?thread_id=189
y_data$V1 <- as.factor(y_data$V1)
levels(y_data$V1) <- activity_labels$V2
# and cleanup
rm(activity_labels)

# Read in subject labels
print("Read in subject labels and concatenate")
train <- tbl_df(read.table("./train/subject_train.txt", colClasses = "numeric"))
test  <- tbl_df(read.table("./test/subject_test.txt", colClasses = "numeric"))
# Concat like before
subject_data <- bind_rows(train, test)

# Bind y_data and subject_data to the X data
# For some reason bind_cols() drops tbl_df, despite what the manual
# says.
mean_std_X_data_complete <- tbl_df(bind_cols(y_data, subject_data, mean_std_X_data))

# Change the column names for the activity and subject columns
names(mean_std_X_data_complete)[1:2] <- c("Activity", "SubjectID")

### End Add activity and subject labels to the data
#####################################################################

### Calculate variable averages
# Calculate the mean for each variable (column) for all combibinations
# of activity and subject (producing 6*30=180 rows with 68 columns:
# activity, subject and mean for each of the 66 variables)
# First group the data by activity and subject, then apply
# summarise_each to calculate the mean over the remaining (that is,
# not the grouped activity and subject columns) columns.
print("Group data and calculate means")
means <- mean_std_X_data_complete %>%
  group_by(Activity, SubjectID) %>%
  summarise_each(funs(mean))

### End Calculate variable averages
#####################################################################

### Write averages data to file
# Write the new data frame to a .txt file with write.table using
# row.names=FALSE
print("Write new data to file: ./means_data.txt")
write.table(means, "means_data.txt", row.names=FALSE, quote=FALSE)

print("Script ends here")
}
