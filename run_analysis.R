# Test Upload
test_X<-read.table('test/X_test.txt')
test_y<- read.table('test/y_test.txt')
test_s<-read.table('test/subject_test.txt')
test <- cbind(test_X,test_y)
colnames(test)<-c(1:562)

#Train upload
train_X<-read.table('train/X_train.txt')
train_y<- read.table('train/y_train.txt')
train_s<-read.table('train/subject_train.txt')
train <- cbind(train_X,train_y)
colnames(train)<-c(1:562)

#  1. Merge datasets
datos<-rbind(train,test)
subject <- rbind(test_s,train_s)
features <- read.table("features.txt")
colnames(datos)<-features$V2

# 2. Extract only mean or std for each measurement
datos<-datos[,grepl("mean|std",features$V2)]

# 3. Uses descriptive activity names to name the activities in the data set
nom<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

datos[,80]<-factor(datos[,80],labels = nom)
datos <- cbind(datos,subject)
colnames(datos)[c(80,81)]<-c("act","ind")

# 4. Appropriately labels the data set with descriptive variable names.
colnames(datos) <- gsub("^t","Time",colnames(datos))
colnames(datos)<-gsub("Acc", "Acceleration", colnames(datos))
colnames(datos)<-gsub("^f", "Frequency", colnames(datos))
colnames(datos)<-gsub("BodyBody", "Body", colnames(datos))
colnames(datos)<-gsub("-mean()", "mean", colnames(datos), ignore.case = TRUE)
colnames(datos)<-gsub("-std()", "std", colnames(datos), ignore.case = TRUE)
colnames(datos)<-gsub("-freq()", "frequency", colnames(datos), ignore.case = TRUE)


# From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.
dos<-aggregate(. ~act + ind, datos, mean)  
write.table(dos,"final.txt",row.name=FALSE)
