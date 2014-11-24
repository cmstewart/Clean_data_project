# This script:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# setwd to directory where data has been d/led and unzipped
setwd("/Users/christopherstewart/Desktop/_Coursera_data_science/getdata/project")

# read in / organize / merge data
activity_labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

data = rbind(train, test)

# fetch means and SDs, remove other data, add column names to data set
data_sub <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[data_sub,]
data_sub <- c(data_sub, 562, 563)
data <- data[,data_sub]
colnames(data) <- c(features$V2, "Activity", "Subject")
colnames(data) <- tolower(colnames(data))

# finally, loop through subsetted data to rename variables 
act = 1
for (act_name in activity_labels$V2) {
  data$activity <- gsub(act, act_name, data$activity)
  act <- act + 1
}

# make factor variables factors
data$activity <- as.factor(data$activity)
data$subject <- as.factor(data$subject)

# put everything together
final = aggregate(data, by=list(subject = data$subject, activity = data$activity), mean)
final[,90] = NULL
final[,89] = NULL
write.table(final, "final_product.txt", row.name = FALSE, sep="\t")
