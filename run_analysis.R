## Course:     Getting and Cleaning Data (getdata-030)
## Date:       24 July 2015
## Assignment: 1
## Script:     'run_analysis.R'

# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.

# Background:
#
# data set:    Human Activity Recognition Using Smartphones Data Set   
#
# source:      Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1), Xavier Parra(2)
#               1 - Smartlab - Non-Linear Complex Systems Laboratory, 
#                   DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy.
#               2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
#                   Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
#               activityrecognition@smartlab.ws 
#
# subjects:     a group of 30 volunteers within an age bracket of 19-48 years. 
#               Each person performed six activities 
#                   (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
#               wearing a smartphone (Samsung Galaxy S II) on the waist.
#
# measurements: 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz
#               fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window)
#               Butterworth low-pass filter (???) with 0.3 Hz cutoff frequency to remove gravitational force.
#
# Further Details:
#
#               For requirements and dependences see 'README.md' (or 'README.md.txt')
#

setwd("E:\\R_data\\Course3_Ass1")

library(dplyr)
library(stringr)
source("friendly.R")   # used for renaming variables

data.folder <- "UCI_HAR_Dataset"

#
# Stage 1 - Merge the training and the test sets to create one data set.
#

file.names <- paste0(".\\", data.folder, "\\features.txt", collapse="")
file.test <- paste0(".\\", data.folder, "\\test\\X_test.txt", collapse="") 
file.train <- paste0(".\\", data.folder, "\\train\\X_train.txt", collapse="") 

# read and merge data sets:
dat.names <- read.table(file.names)  #: read feature names
col.names <- dat.names[,2]           #: form vector of column names
dat.test <- read.table(file.test)
dat.train <- read.table(file.train)
dat <- rbind(dat.test, dat.train)
names(dat) <- col.names

#
# Stage 2 - Extract only the measurements on the mean and standard deviation for each measurement. 
#

# eliminate duplicate column names (alt: make.names(names=names(dat), unique=TRUE, allow_ = TRUE))
dat <- dat[!duplicated(names(dat))]

# select only the mean & sdev columns into the data subset:
dat.mean <- select(dat, contains("mean"))
dat.mean <- select(dat.mean, -contains("meanFreq"))   # remove the derived frequency-domain metrics 
dat.mean <- select(dat.mean, -contains(",gravity"))    # remove the derived gravity metrics 
dat.sdev <- select(dat, contains("std"))

# combine the mean & sdev subsets into one data.frame:
dat <- cbind(dat.mean, dat.sdev)

#
# Stage 3 - Use descriptive activity names to name the activities in the data set
#

# prepare activity names for use below:
file.activities <- paste0(".\\", data.folder, "\\activity_labels.txt", collapse="")
activities.df <- read.table(file.activities)
activities <- as.character(gsub("_", " ", tolower(activities.df[,2])))

# read activity codes from source data (expecting 1 per observation):
label.ids.test <- read.table(paste0(".\\", data.folder, "\\test\\y_test.txt", collapse=""))
label.ids.train <- read.table(paste0(".\\", data.folder, "\\train\\y_train.txt", collapse=""))
label.ids <- rbind(label.ids.test, label.ids.train)
if (length(label.ids[,1]) != length(dat[,1])) 
  { stop ("number of activity codes does not equal number of  observations") }
labels <- as.data.frame(activities[label.ids[,1]])
names(labels) <- c("activity")

dat <- cbind(labels, dat)

#
# Stage 4 - Appropriately label the data set with descriptive variable names. 
#
# read subject id codes from source data (expecting 1 per observation):
subject.ids.test <- read.table(paste0(".\\", data.folder, "\\test\\subject_test.txt", collapse=""))
subject.ids.train <- read.table(paste0(".\\", data.folder, "\\train\\subject_train.txt", collapse=""))
subject.ids <- as.data.frame(rbind(subject.ids.test, subject.ids.train))
if (length(subject.ids[,1]) != length(dat[,1])) 
  { stop ("number of subject id codes does not equal number of  observations") }
names(subject.ids) <- c("subject")

dat <- cbind(subject.ids, dat)

# convert to data frame table:
dat <- tbl_df(dat)

# copy the data set and rename the columns:
dat1 <- dat
newnames <- vapply(names(dat1), FUN = friendly.name, prefix = "", FUN.VALUE = character(1))
names(dat1) <- newnames

str(dat1)    #<: comment-out if output not desired !

#
# Stage 5 - From the data set in step 4, creates a second, independent tidy data set with the average 
#           of each variable for each activity and each subject.
#

# compute ensemble means and assign to new data frame table:
dat2 <- summarise_each(group_by(dat, activity, subject), funs(mean))

# make column names more meaningful and friendly:
newnames <- vapply(names(dat2), FUN = friendly.name, prefix = "ensemble", FUN.VALUE = character(1))
names(dat2) <- newnames

str(dat2)    #<: comment-out if output not desired !

#
# Output stage
#

write.table(dat2, file="tidydat.txt", row.name=FALSE)

