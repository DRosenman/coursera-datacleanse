# Coursera Course Project: Getting and Cleaning Data

## Introduction
The script in this repository takes raw data collected from the accelerometers from the Samsung Galaxy S smartphone and performs some basic cleansing work to tidy the dataset and prepare it for analysis. It subsequently creates a second dataset of averages from the original dataset, as a demonstration of how to manipulate the accelerometer data. 

Per the course assignment, a full description of the data is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The source data was originally downloaded and unzipped from this location on August 17th 2014:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Tidying the raw data set
The initial data is relatively well-formatted; it can be read directly into R through the `read.table()` function without requiring additional manipulation. I took the opportunity to name some of the column names at this stage to make it easy to refer to them later in the code, using `gsub()` to format the feature variables in particular.

While in general one might avoid discarding data when creating a tidy data set, the assignment calls for only the mean and standard deviation variables to be maintained. This leaves the student with an open question: should the variables pertaining to mean frequency also be discarded? I have interpreted the question in a fairly literal form, so I chose to discard these ones also. I use the `grepl()` function to create a logical selection vector that can be applied to subset the data, as follows:

```
column.selection <- grepl("mean|std", features) & 
                    !grepl("meanFreq", features)

x.train <- subset(x.train, select=column.selection)
x.test  <- subset(x.test, select=column.selection)
```

The remainder of the tidy phase of the code is mostly dedicated to binding the eight different sources of data together into a data frame named `dataset`, per this diagram [provided by David Hood](https://class.coursera.org/getdata-006/forum/thread?thread_id=43#comment-603):
![diagram showing how the eight different raw files are fitted together](https://coursera-forum-screenshots.s3.amazonaws.com/ab/a2776024af11e4a69d5576f8bc8459/Slide2.png). We also apply factors to the subject and activity fields, for example:

```
dataset$activity <- factor(dataset$activity, labels=activity.labels$label, ordered=FALSE)
```

Lastly, we write the tidy dataset to disk as `tidy.txt` and then clear the various intermediate variables created during the construction of the `dataset` data frame, using the `rm()` function. 

## Calculating averages of the raw data
The second part of the assignment is to create a second, independent tidy data set with the average of each variable for each activity and each subject. 

My original version of this assignment was ludicrously laborious because I'd missed out on the power of the `aggregate()` function. Here is the original:

```
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

averages <- cbind(subject.averages, activity.averages)
```

Two basic errors:

1. First, I'd misinterpreted the assignment initially as requiring means of the activities and also means of the subjects, rather than a data set that combined the two together. I thus had a data set of 30 subjects + 6 activities. It was only later that I realized from reading around in the forums that the problem author was rather expecting all permutations of (subject, activity) - i.e. 30 * 6 = 180 rather than 30 + 6 = 36. 

2. I started working on this before I'd really taken the time to understand the rich functions available for summarizing data tables. Once I discovered the aggregate function, I realized that this could be completed with just one line. 

The final solution I opted for is therefore:
```
averages <- aggregate(dataset[3:68], by=list(subject=dataset$subject, 
                                             activity=dataset$activity), mean)
```

which is both far more compact and I suspect more performant.

Note that we can discard the first two columns, since they contain the subject and the activity themselves - the selectors that we're using to subset the data - hence we use `dataset[3:68]` for the input to `aggregate()`

## Last Things
The interested reader could use the `read.table()` function to load the `dataset` and `averages` data sets back from disk; the `View()` function from the `utils` package may then be used to invoke a spreadsheet-style data viewer on the object.