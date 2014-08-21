# run_analysis.R | last updated: 8/20/2014 | Tim Sneath <tim@sneath.org>

# 1. Load and Cleanse Data ----------------------------------------------------

## First load the metadata (labels that describe each variable)
activity.labels <- read.table("activity_labels.txt", 
                              col.names=c("id", "label"), 
                              stringsAsFactors=FALSE)
features        <- read.table("features.txt", 
                              col.names=c("id", "variable"), 
                              stringsAsFactors=FALSE)

## Do a little tidy up work on the features object to turn it into a 
## well-formatted character vector. We choose to retain the period (.) delimiter
## between components of the variable for ease of recognition and later parsing.
features <- features$variable
features <- gsub("\\(\\)", "", features) # remove all instances of () 
features <- gsub("\\-", "\\.", features) # replace - with .

## Now load the raw observations
x.train        <- read.table("train/X_train.txt", col.names=features)
y.train        <- read.table("train/Y_train.txt", col.names="activity")
subject.train  <- read.table("train/subject_train.txt", col.names="subject")
x.test         <- read.table("test/X_test.txt", col.names=features)
y.test         <- read.table("test/Y_test.txt", col.names="activity")
subject.test   <- read.table("test/subject_test.txt", col.names="subject") 

## Subset the data - to include only the mean and standard deviation for each 
## measurement. In this exercise, we interpret the assignment as only including 
## mean() and std(), and excluding meanFreq(), and so we use the grepl() 
## function to create a logical selection vector that can be used to subset only
## the relevant column names. We could subset the data later, but it seems
## advisable to discard all unnecessary data from memory as quickly as possible.
column.selection <- grepl("mean|std", features) & 
                    !grepl("meanFreq", features)

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
dataset$activity <- factor(dataset$activity, labels=activity.labels$label, 
                           ordered=FALSE)

## Clear up all the intermediate objects from the global environment, leaving
## just the tidied data frame
rm(activity.labels, features)
rm(x.train, y.train, subject.train)
rm(x.test, y.test, subject.test)
rm(column.selection)
rm(train, test)

## Write the initial tidy dataset to file
write.table(dataset, file="tidy.txt", row.names=FALSE)

# 2. Calculate Averages from Data Set ----------------------------------------

## Use the aggregate() function to compute summary statistics based on 
## (subject, activity) 
averages <- aggregate(dataset[3:68], by=list(subject=dataset$subject, 
                                             activity=dataset$activity), mean)

## For completeness, write the averages dataset to file
write.table(averages, file="averages.txt", row.names=FALSE)
