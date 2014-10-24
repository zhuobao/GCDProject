---
title: "Code Book"
subtitle: "Getting and Cleaning Data Course Project"
date: "Wednesday, October 22, 2014"
output: html_document
---


####*Abstract*: 
##### The "Code book" describes the original data sources, data variables and the final layout data and variables. All format/type transformations and data clean up procedures will also be included here.

### Original Data Files
The original data files are from three folders:  

#### 1. Labels files

The "Label" files are located in the parent folder "/UCI_HAR_Dataset/". They are:

- **activity_labels.txt**  
  Of totally **six** activities, the activity class labels (numeric) and their real activity name (character) are linked with each other.

- **features.txt**  
  List of all meansurement features. These features are combinations of sensor signals (body acceleration, gravity acceleration, body gyroscopes, ...) and post-signal-capture procedures (mean, std, .... ).
  
#### 2. "Test" data files

The "Test" data files are located in the folder "/UCI_HAR_Dataset/test":

- **X_test.txt**   
 Totally 2947 aggregated testing measurements for each of the 561 measurement features (rows=2974, columns=561). the measurement feature columns are following the order defined by the feature order in "features.txt" 


- **y_test.txt**
 Totally 2947 rows of testing "activity label" records. Detail of "activity label" is available in the **activity_labels.txt**. 


- **subject_tst.txt**
Totally 2947 rows of testing "subject label" records. There are totally 30 different measuring subjects. In test, 9 subjects (persons) are included.

#### 3. "Train" data files

The "Train" data files are located in the folder "/UCI_HAR_Dataset/train":

- **X_train.txt**   
 Totally 7352 aggregated training measurements for each of the 561 measurement features (rows=7352, columns=561). the measurement feature columns are following the order defined by the feature order in "features.txt" 


- **y_test.txt**
 Totally 7352 rows of training "activity label" records. Detail of "activity label" is available in the **activity_labels.txt**. 


- **subject_tst.txt**
Totally 7352 rows of training "subject label" records. There are totally 30 different measuring subjects. In training bucket, 21 subjects (persons) are included.

#### Notes:

More details of origin data are available in "/UCI_HAR_Dataset/README.txt" and "/UCI_HAR_Dataset/features_info.txt" docs.

### Final Layout Variables

The final dataset is obtained from the "sum" of the training and testing data. It contains 35 rows, which are unique activity and subject combinations, and 70 variables including the indexing variable, subject labels, activity labels and activity names:

**idx**: the unique values indexing the combination of activities of each measure subjects (person). The index is generated using the formula

```
idx = 10000 + activityLabel*100 + subjectLabel
```
Since it is a unique combination, it is also used in averaging measurements for each activities and subjects as the "group by variable". This method generate 1 dimension data.frame layout, easy for data re-combination and saved tons of computation time on reshaping data.

**subjectLabel**: the label for each subject (person). There are totally 30 subjects and they are labelled from 1 to 30.

**activityLabel**: the label for activities that each subject performed, like sitting and walking. There are totally 6 different activities. 


```
##   activityLabel       activityName
## 1             1            WALKING
## 2             2   WALKING_UPSTAIRS
## 3             3 WALKING_DOWNSTAIRS
## 4             4            SITTING
## 5             5           STANDING
## 6             6             LAYING
```

**activityName**: the name of activities that each subject performed.

**averaged signal estimates**: The rest 66 variables are the averged measured signal estimated variables. Below are the examples of the variable names:

```
"tBodyAcc-mean()-X-mean"
"tBodyAcc-mean()-Y-mean"          
"tBodyAcc-mean()-Z-mean"
"tBodyAcc-std()-X-mean"           
"tBodyAcc-std()-Y-mean"
"tBodyAcc-std()-Z-mean"       
...
```
All Features are normalized and bounded within [-1,1]. Hence, average feature values are within [-1,1].
The names are composed with **four** parts:   
1. the first part is the signal type:  

```
tBodyAcc: time domain body accelerometer signal
tGravityAcc: time domain gravity accelerometer signal
tBodyAccJerk: time domain body accelerometer jerk signal
tBodyGyro: time domain body gyroscope signal
tBodyGyroJerk: time domain body gyroscope jerk signal
tBodyAccMag: time domain body accelerometer signal Euclidean norm
tGravityAccMag: time domain gravity accelerometer signal magnitude (norm)
tBodyAccJerkMag: time domain body accelerometer jerk signal magnitude (norm) 
tBodyGyroMag: time domain body gyroscope signal magnitude (norm) 
tBodyGyroJerkMag: time domain body gyro jerk signal magnitude (norm)
fBodyAcc: frequency domain body accelerometer signal
fBodyAccJerk: frequency domain body accelerometer jerk signal
fBodyGyro: frequency domain body gyroscope signal
fBodyAccMag: frequency domain body accelerometer signal magnitude (norm)
fBodyAccJerkMag: frequency domain body accelerometer jerk signal magnitude (norm)
fBodyGyroMag: frequency domain body gyroscope signal magnitude (norm)
fBodyGyroJerkMag: frequency domain body gyroscope jerk signal magnitude (norm)
```   
2. the second part is the signal estimation methods:   

```
mean(): mean value
std(): standard deviation value
```   
3. the third part is the 3-axis Euclidean signal components    

```
X, Y, Z
```   
4. the fourth part is the "mean", indicating that average value for each activity and subject combination is calculated and taken.

For the full list of the variables names, please see the Appendix at the end of the file. 

### The transformation methods used
1 *activity labels*, *activity names*, *subject labels* and signal measurement datasets are put into one dataset using ```cbind``` function.   
2. The test dataset and train dataset are combined into one dataset using```rbind```
3. activity (labels) and subject (labels) are combined into on variable "idx" using the formula   
```
idx = 10000 + activityLabel*100 + subjectLabel
```   
to facilitate fast grouping calculation and easy data collection.

4. Averaged value of measured signal estimations (e.g. "tBodyAcc-mean()-Y-mean") are calculated using ```mean``` function grouping on each unique "idx" values, which is equivalent to grouping on (**activityLabel**+**subjectLabel**)  

### Appendix:
#### 1. Full list of variable names


```
##  [1] "idx"                              "subjectLabel"                    
##  [3] "activityLabel"                    "activityName"                    
##  [5] "tBodyAcc-mean()-X-mean"           "tBodyAcc-mean()-Y-mean"          
##  [7] "tBodyAcc-mean()-Z-mean"           "tBodyAcc-std()-X-mean"           
##  [9] "tBodyAcc-std()-Y-mean"            "tBodyAcc-std()-Z-mean"           
## [11] "tGravityAcc-mean()-X-mean"        "tGravityAcc-mean()-Y-mean"       
## [13] "tGravityAcc-mean()-Z-mean"        "tGravityAcc-std()-X-mean"        
## [15] "tGravityAcc-std()-Y-mean"         "tGravityAcc-std()-Z-mean"        
## [17] "tBodyAccJerk-mean()-X-mean"       "tBodyAccJerk-mean()-Y-mean"      
## [19] "tBodyAccJerk-mean()-Z-mean"       "tBodyAccJerk-std()-X-mean"       
## [21] "tBodyAccJerk-std()-Y-mean"        "tBodyAccJerk-std()-Z-mean"       
## [23] "tBodyGyro-mean()-X-mean"          "tBodyGyro-mean()-Y-mean"         
## [25] "tBodyGyro-mean()-Z-mean"          "tBodyGyro-std()-X-mean"          
## [27] "tBodyGyro-std()-Y-mean"           "tBodyGyro-std()-Z-mean"          
## [29] "tBodyGyroJerk-mean()-X-mean"      "tBodyGyroJerk-mean()-Y-mean"     
## [31] "tBodyGyroJerk-mean()-Z-mean"      "tBodyGyroJerk-std()-X-mean"      
## [33] "tBodyGyroJerk-std()-Y-mean"       "tBodyGyroJerk-std()-Z-mean"      
## [35] "tBodyAccMag-mean()-mean"          "tBodyAccMag-std()-mean"          
## [37] "tGravityAccMag-mean()-mean"       "tGravityAccMag-std()-mean"       
## [39] "tBodyAccJerkMag-mean()-mean"      "tBodyAccJerkMag-std()-mean"      
## [41] "tBodyGyroMag-mean()-mean"         "tBodyGyroMag-std()-mean"         
## [43] "tBodyGyroJerkMag-mean()-mean"     "tBodyGyroJerkMag-std()-mean"     
## [45] "fBodyAcc-mean()-X-mean"           "fBodyAcc-mean()-Y-mean"          
## [47] "fBodyAcc-mean()-Z-mean"           "fBodyAcc-std()-X-mean"           
## [49] "fBodyAcc-std()-Y-mean"            "fBodyAcc-std()-Z-mean"           
## [51] "fBodyAccJerk-mean()-X-mean"       "fBodyAccJerk-mean()-Y-mean"      
## [53] "fBodyAccJerk-mean()-Z-mean"       "fBodyAccJerk-std()-X-mean"       
## [55] "fBodyAccJerk-std()-Y-mean"        "fBodyAccJerk-std()-Z-mean"       
## [57] "fBodyGyro-mean()-X-mean"          "fBodyGyro-mean()-Y-mean"         
## [59] "fBodyGyro-mean()-Z-mean"          "fBodyGyro-std()-X-mean"          
## [61] "fBodyGyro-std()-Y-mean"           "fBodyGyro-std()-Z-mean"          
## [63] "fBodyAccMag-mean()-mean"          "fBodyAccMag-std()-mean"          
## [65] "fBodyBodyAccJerkMag-mean()-mean"  "fBodyBodyAccJerkMag-std()-mean"  
## [67] "fBodyBodyGyroMag-mean()-mean"     "fBodyBodyGyroMag-std()-mean"     
## [69] "fBodyBodyGyroJerkMag-mean()-mean" "fBodyBodyGyroJerkMag-std()-mean"
```


