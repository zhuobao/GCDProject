## run_analysis.R
## course project of "Getting and Cleaning Data"

## =====  Outlines =================

# 1, Merges the training and the test sets to create one data set.
# 2, Extracts only the measurements on the mean and standard deviation for 
#   each measurement. 
# 3, Uses descriptive activity names to name the activities in the data set
# 4, Appropriately labels the data set with descriptive variable names. 
# 5, From the data set in step 4, creates a second, independent tidy data 
#   set with the average of each variable for each activity and each subject.

##======  Data Read and Preparation ================

## Dataset read-in and preparation
rm(list=ls())  ## clear
cwd="C:/working_files/p2_data_scientist/a3_getting_and_/data/UCI_HAR_Dataset"
setwd(cwd)

### read in the activity labels
actvLbls <- read.table("activity_labels.txt", sep=" ", nrows=-1, header=F,
                        strip.white=T)
names(actvLbls) <- c("activityLabel", "activityName")

### read in the feature labels
ftrLbls <- read.table("features.txt", sep=" ", nrows=-1, header=F,
                       strip.white=T)
names(ftrLbls) <- c("featureLabel", "featureName")

### read in the test datasets
setwd(cwd)
setwd("./test")
tstLbls <- read.table("y_test.txt", sep="", nrows=-1, header=F,
                       strip.white=T)
tstSubj <- read.table("subject_test.txt", sep="", nrows=-1, header=F,
                      strip.white=T)
tstSet <- read.table("x_test.txt", sep="", nrows=-1, header=F,
                     strip.white=F)

### read in the train datasets
setwd(cwd)
setwd("./train")
trnLbls <- read.table("y_train.txt", sep="", nrows=-1, header=F,
                       strip.white=T)
trnSubj <- read.table("subject_train.txt", sep="", nrows=-1, header=F,
                      strip.white=T)
trnSet <- read.table("X_train.txt", sep="", nrows=-1, header=F,
                     strip.white=F)

##==========  Datasets Merging  ====================

## Merges the training and the test sets to create one data set.

### combine the train and test datasets
Set <- rbind(tstSet, trnSet)
names(Set) <- ftrLbls$featureName

Subj <- rbind(tstSubj, trnSubj)
names(Subj) <- c("subjectLabel")

Lbls <- rbind(tstLbls, trnLbls)
names(Lbls) <- c("activityLabel")

### merge the activity label and name
LblNms <- merge(Lbls, actvLbls, 
                by.x="activityLabel", by.y="activityLabel", all.x=T)

### final combination
harSet <- cbind(LblNms, Subj, Set)


##============  variable extraction ==================
## Extracts only the measurements on the mean and standard deviation for 
## each measurement. 

### generate the list for variables name containing "mean()" and "std()"
### from the feature label list
ftrLst <- c()
for(i in 1:nrow(ftrLbls)){
    if(grepl("(mean|std)[(][)]", ftrLbls[i,2])) {ftrLst<- c(ftrLst, c(i))}
}

extHarSet <- harSet[, c(c(1, 2, 3), ftrLst+3)]

## ============ Give activity names ===================
## 3, Uses descriptive activity names to name the activities in the data set

print extHarSet$activityName

#### since row name can only be unique, so a variable "activityName" is 
#### assigned at the beginning


## ============ Give Labels to variables  ==============
## 4, Appropriately labels the data set with descriptive variable names. 

#### using descriptive feature names for variables names
names(extHarSet) <- c("activityLabel", "activityName", "subjectLabel", 
                      as.vector(ftrLbls[ftrLst, 2]))

## ============ Average variable on activity and subject  ====

## 5, From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

### prepare the names of final variables
### by adding "mean" at the end
namelist <- names(extHarSet)
meanname <- c("idx",namelist[3], namelist[1:2], 
              paste(namelist[4:length(namelist)], "mean", sep="-"))

### prepare the one-demension aggregation index
extHarSet$idx <- 10000+extHarSet$activityLabel*100+extHarSet$subjectLabel
namelist <- names(extHarSet)

### aggregate the subject label
gHarSet <- ddply(extHarSet, .(idx), summarize, temp=mean(subjectLabel, na.rm=T))
tempset <- ddply(extHarSet, .(idx), summarize, actvLbl=mean(activityLabel, na.rm=T))
atnm <- merge(tempset, actvLbls, by.x="actvLbl", by.y="activityLabel", all.x=T)
refmt <- cbind(gHarSet, tempset$actvLbl, atnm$activityName)

lnm <- length(namelist) 
for(i in 4:(lnm-1)){
    ## using name as a pointer, "V" is the target
    nlist <- c(rep("a", i-1), "v", rep("a",lnm-i-1 ), "idx")
    names(extHarSet) <- nlist
    ## averaging for each measurement variables on index
    tempset <- ddply(extHarSet, .(idx), summarize, V=mean(v, na.rm=T))
    ## collect result
    refmt <- cbind(refmt, tempset$V)
}
names(extHarSet) <- namelist
names(refmt) <- meanname

## ================ layout the dataset ===================
## write the data out
write.table(refmt, "subj_actv_measure_mean.csv", row.name=F)


