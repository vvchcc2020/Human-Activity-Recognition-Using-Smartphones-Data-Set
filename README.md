# Task

#Experiment 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
Taken from : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# What we have
- 'README.txt' : About code used and general information 
- 'Code Book' : Variables in the data set 
- 'run_analysis' : R code used

#What we use 
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

from: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Code explained 

## Test Upload

```{r setup, include=FALSE}
test_X<-read.table('test/X_test.txt')
test_y<- read.table('test/y_test.txt')
test_s<-read.table('test/subject_test.txt')
test <- cbind(test_X,test_y)
colnames(test)<-c(1:562)
```
##Train upload
```{r setup, include=FALSE}
train_X<-read.table('train/X_train.txt')
train_y<- read.table('train/y_train.txt')
train_s<-read.table('train/subject_train.txt')
train <- cbind(train_X,train_y)
colnames(train)<-c(1:562)
```
##  1. Merge datasets
```{r setup, include=FALSE}
datos<-rbind(train,test)
subject <- rbind(test_s,train_s)
features <- read.table("features.txt")
colnames(datos)<-features$V2
```

## 2. Extract only mean or std for each measurement
```{r setup, include=FALSE}
datos<-datos[,grepl("mean|std",features$V2)]
```

## 3. Uses descriptive activity names to name the activities in the data set
```{r setup, include=FALSE}
nom<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")


datos[,80]<-factor(datos[,80],labels = nom)
datos <- cbind(datos,subject)
colnames(datos)[c(80,81)]<-c("act","ind")
```

## 4. Appropriately labels the data set with descriptive variable names.
```{r setup, include=FALSE}
colnames(datos) <- gsub("^t","Time",colnames(datos))
colnames(datos)<-gsub("Acc", "Acceleration", colnames(datos))
colnames(datos)<-gsub("^f", "Frequency", colnames(datos))
colnames(datos)<-gsub("BodyBody", "Body", colnames(datos))
colnames(datos)<-gsub("-mean()", "mean", colnames(datos), ignore.case = TRUE)
colnames(datos)<-gsub("-std()", "std", colnames(datos), ignore.case = TRUE)
colnames(datos)<-gsub("-freq()", "frequency", colnames(datos), ignore.case = TRUE)
```


##5.  From the data set in step 4, creates a second, independent tidy data 
set with the average of each variable for each activity and each subject.
```{r setup, include=FALSE}
dos<-aggregate(. ~act + ind, datos, mean)  
write.table(dos,"final.txt",row.name=FALSE)
```
