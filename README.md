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
The second part of the assignment is to create a second, independent tidy data set with the average of each variable for each activity and each subject. In general, one can use `sapply()` to apply a function over a vector, but `colMeans()` is typically preferred for performance reasons. 

Left open in the assignment is the specific format of the finished data set. One potential approach is to create a list of two data frames, one for the averages of the subjects and the other for the averages of the activities; however, since the variables against which the averages are calculated are identical across both, I considered this unnecessarily complex from the point of an end-consumer of the data and opted instead to name the vectors in the data frame appropriately. This is of course known as a [wide data set](http://en.wikipedia.org/wiki/Wide_and_Narrow_Data). 

To calculate the averages for each subject and activity, we first subset the data to the appropriate selection. We do this with a line such as the following:

```
dataset.subject <- subset(dataset, subset=dataset$subject==id)
```

This creates a separate data frame that just contains the rows where the subject matches the selected id. Next we use the aforementioned `colmeans()` function to calculate the means for each of the variables, and add that as an additional column to the data frame.

```
subject.averages <- cbind(subject.averages, colMeans(dataset.subject[3:68]))
```

Note that we can discard columns 1 and 2, since they contain the subject and the activity themselves - the selectors that we're using to subset the data. 

Again, we take care to name the columns - for the subjects, we use the format `subject.xx` where `xx` is the numeric ID of the subject; for the activities, we use the labels themselves, e.g. `"WALKING"` or `"STANDING"`.

We bind the two intermediate objects `subject.averages` and `activity.averages` into a single wide data frame and then write to disk. 

The interested reader could use the `read.table()` function to load the `dataset` and `averages` data sets back from disk; the `View()` function from the `utils` package may then be used to invoke a spreadsheet-style data viewer on the object.