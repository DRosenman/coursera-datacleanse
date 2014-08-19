## Code Book for Tidy Dataset
Variable | Definition
-------- | ----------
subject | numeric indicator in the range [1:30] representing the individual wearing the smartphone
activity | activity performed: one of "LAYING", STANDING", "SITTING", WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS"

The following variables correspond to the variables in features_info.txt of the original dataset:
tbodyAcc.mean...X
tbodyAcc.mean...Y
tbodyAcc.mean...Z
tbodyAcc.std...X
tbodyAcc.std...Y
tbodyAcc.std...Z
tGravityAcc.mean...X
tGravityAcc.mean...Y
tGravityAcc.mean...Z
tGravityAcc.std...X        
tGravityAcc.std...Y
tGravityAcc.std...Z
tBodyAccJerk.mean...X
tBodyAccJerk.mean...Y      
tBodyAccJerk.mean...Z
tBodyAccJerk.std...X
tBodyAccJerk.std...Y
tBodyAccJerk.std...Z       
tBodyGyro.mean...X
tBodyGyro.mean...Y
tBodyGyro.mean...Z
tBodyGyro.std...X          
tBodyGyro.std...Y
tBodyGyro.std...Z
tBodyGyroJerk.mean...X
tBodyGyroJerk.mean...Y     
tBodyGyroJerk.mean...Z
tBodyGyroJerk.std...X
tBodyGyroJerk.std...Y
tBodyGyroJerk.std...Z      
tBodyAccMag.mean..
tBodyAccMag.std..
tGravityAccMag.mean..
tGravityAccMag.std..       
tBodyAccJerkMag.mean..
tBodyAccJerkMag.std..
tBodyGyroMag.mean..
tBodyGyroMag.std..         
tBodyGyroJerkMag.mean..
tBodyGyroJerkMag.std..
fBodyAcc.mean...X
fBodyAcc.mean...Y
fBodyAcc.mean...Z
fBodyAcc.std...X 
fBodyAcc.std...Y 
fBodyAcc.std...Z 
fBodyAccJerk.mean...X 
fBodyAccJerk.mean...Y 
fBodyAccJerk.mean...Z 
fBodyAccJerk.std...X 
fBodyAccJerk.std...Y 
fBodyAccJerk.std...Z 
fBodyGyro.mean...X
fBodyGyro.mean...Y         
fBodyGyro.mean...Z
fBodyGyro.std...X
fBodyGyro.std...Y
fBodyGyro.std...Z          
fBodyAccMag.mean..
fBodyAccMag.std..
fBodyBodyAccJerkMag.mean..
fBodyBodyAccJerkMag.std..  
fBodyBodyGyroMag.mean..
fBodyBodyGyroMag.std..
fBodyBodyGyroJerkMag.mean..
fBodyBodyGyroJerkMag.std..

## Code Book for Averages Dataset
Variable | Definition
-------- | ----------
subject.xx | averages of individual wearing the device, where xx is a numeric indicator in the range [1:30] representing the id of the individual
WALKING | averages of all individuals engaged in level walking activity
WALKING_UPSTAIRS | averages of all individuals engaged in walking upstairs activity
WALKING_DOWNSTAIRS | averages of all individuals engaged in walking downstairs activity
SITTING | averages of all individuals engaged in sitting activity
STANDING | averages of all individuals engaged in standing activity
LAYING | averages of all individuals engaged in laying activity