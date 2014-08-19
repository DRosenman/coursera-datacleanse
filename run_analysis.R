# Tidy data - in this section of the R script, we load and cleanse the data

## First load the metadata (labels that describe each variable)
activity.labels <- read.table("activity_labels.txt", 
                              col.names=c("id", "label"), 
                              stringsAsFactors=FALSE)
features        <- read.table("features.txt", 
                              col.names=c("id", "variable"), 
                              stringsAsFactors=FALSE)

## Now load the raw observations
x.train        <- read.table("train/X_train.txt", col.names=features$variable)
y.train        <- read.table("train/Y_train.txt", col.names="activity")
subject.train  <- read.table("train/subject_train.txt", col.names="subject")
x.test         <- read.table("test/X_test.txt", col.names=features$variable)
y.test         <- read.table("test/Y_test.txt", col.names="activity")
subject.test   <- read.table("test/subject_test.txt", col.names="subject") 

## Subset the data - to include only the mean and standard deviation for each 
## measurement. In this exercise, we interpret the assignment as only including 
## mean() and std(), and excluding meanFreq(), and so we use the grepl() 
## function to create a logical selection vector that can be used to subset only
## the relevant column names. We could subset the data later, but it seems
## advisable to discard all unnecessary data from memory as quickly as possible.
column.selection <- grepl("mean|std", features$variable) & 
                    !grepl("meanFreq", features$variable)

x.train <- subset(x.train, select=column.selection)
x.test  <- subset(x.test, select=column.selection)

## Order columns - subject, activity, data variables
train <- cbind(subject.train, y.train, x.train)
test  <- cbind(subject.test,  y.test,  x.test)

## Put train and test data together, and add factors to the subject and activity
## variables. NB The variables are renamed to satisfy assignment objective #4 on
## import, using the col.names argument. Further clean-up on the variable names
## is of course possible at this stage, but I made the decision that further
## renaming is risky: if the dataset is changed to add additional variables, for
## example, then the R script here may fail. In addition, the variables are
## well-documented here and in other locations on the web.
dataset <- rbind(train, test)
dataset$subject  <- factor(dataset$subject)
dataset$activity <- factor(dataset$activity, labels=activity.labels$label, ordered=FALSE)

## Clear up all the intermediate objects from the global environment, leaving
## just the tidied data frame
rm(activity.labels, features)
rm(x.train, y.train, subject.train)
rm(x.test, y.test, subject.test)
rm(column.selection)
rm(train, test)

## Write the initial tidy dataset to file
write.table(dataset, file="tidy.txt", row.names=FALSE)

## Now create a second, independent tidy data set with the average of each 
## variable for each activity and each subject. Can either use sapply or 
## colMeans, but the latter is preferred for performance reasons. There are 
## multiple approaches to this; I originally used a list with two separate data 
## frames, but ultimately settled for a single data frame with appropriate row
## names and column headers.
subject.averages <- data.frame(row.names=names(dataset[3:68]))
subjects <- as.numeric(levels(dataset$subject))
for (id in subjects) {
   dataset.subject <- subset(dataset, subset=dataset$subject==id)
   subject.averages <- cbind(subject.averages, colMeans(dataset.subject[3:68]))
   colnames(subject.averages)[id] <- paste("subject", id, sep=".")
}

activity.averages <- data.frame(row.names=names(dataset[3:68]))
activities <- levels(factor(dataset$activity))
for (act in activities) {
   dataset.activity <- subset(dataset, subset=dataset$activity==act)
   activity.averages <- cbind(activity.averages, colMeans(dataset.activity[3:68]))
}
colnames(activity.averages) <- activities

## Put them together into a single data frame
averages <- cbind(subject.averages, activity.averages)

## and tidy up again
rm(subject.averages, activity.averages)
rm(dataset.subject, dataset.activity)
rm(subjects, activities)
rm(id, act)

## For completeness, write the averages dataset to file
write.table(averages, file="averages.txt", row.names=FALSE)
