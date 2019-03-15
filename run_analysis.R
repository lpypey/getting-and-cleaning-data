##############################################################################
#
# FILE
#   run_analysis.R
#
# OVERVIEW
#   Using data collected from the accelerometers from the Samsung Galaxy S 
#   smartphone, work with the data and make a clean data set, outputting the
#   resulting tidy data to a file named "tidy_data.txt".
#   See README.md for details.
#

##############################################################################
# STEP 1 - Get the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##############################################################################


# download zip file containing data if it hasn't already been downloaded
zipfileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "UCI HAR Dataset.zip"

if (!file.exists(zipfile)) {
        download.file(zipfileUrl, zipfile, mode = "wb")
}

# unzip zipfile containing data if data directory doesn't already exist
dataset <- "UCI HAR Dataset"
if (!file.exists(dataset)) {
        unzip(zipfile)
}


##############################################################################
# STEP 2 - Read data (Check folder UCI HAR Dataset)
##############################################################################

# read training data

trainingSubjects <- read.table(file.path(dataset, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataset, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataset, "train", "y_train.txt"))

# read test data
testSubjects <- read.table(file.path(dataset, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataset, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataset, "test", "y_test.txt"))

# read features, don't convert text labels to factors
features <- read.table(file.path(dataset, "features.txt"), as.is = TRUE)
## note: feature names (in features[, 2]) are not unique
##       e.g. fBodyAcc-bandsEnergy()-1,8

# read activity labels
activities <- read.table(file.path(dataset, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")


##############################################################################
# Step 3 - Merge the training and the test data  to create one data table
##############################################################################

# concatenate individual data tables to make single data table
humanActivity <- rbind(
        cbind(trainingSubjects, trainingValues, trainingActivity),
        cbind(testSubjects, testValues, testActivity)
)


# assign column names
colnames(humanActivity) <- c("subject", features[, 2], "activity")


##############################################################################
# Step 4 - Extract only the measurements on the mean and standard deviation
#          for each measurement
##############################################################################

# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

# ... and keep data in these columns only
humanActivity <- humanActivity[, columnsToKeep]



##############################################################################
# Step 5 - Use descriptive activity names to name the activities in the data
#          set
##############################################################################

# replace activity values with named factor levels
humanActivity$activity <- factor(humanActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])

##############################################################################
# Step 6 - Appropriately label the data set with descriptive variable names
##############################################################################

# get column names
humanActivityCols <- colnames(humanActivity)

# remove special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expand abbreviations and clean up names
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

# correct typo
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
colnames(humanActivity) <- humanActivityCols

##############################################################################
# Step 5 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject
#        - load dplyr to call required functions
##############################################################################

library(dplyr)

# group by subject and activity and summarise using mean
humanActivityMeans <- humanActivity %>% 
        group_by(subject, activity) %>%
        summarise_all(funs(mean))


# output to file "tidydata.txt"
write.table(humanActivityMeans, "tidydata.txt", row.names = FALSE, 
            quote = FALSE)




