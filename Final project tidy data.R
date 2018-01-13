#url for project
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download file
download.file(url, destfile = "HairData.zip")
#unzip folder
unzip("HairData.zip", list = TRUE)

#read the features file
library(dplyr)
library(data.table)
features_file <- read.table("UCI HAR Dataset/features.txt")

#reading in the rest of the files
activitys_names <- read.table("UCI HAR Dataset/activity_labels.txt ")
features_train <- read.table("UCI HAR Dataset/train/X_train.txt")
activitys_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
bodyAccX_train <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
bodyAccY_train <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
bodyAccZ_train <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
bodyGyroX_train <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
bodyGyroY_train <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
bodyGyroZ_train<-read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
totalAccX_train<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
totalAccY_train<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
totalAccZ_train<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
features_test<-read.table("UCI HAR Dataset/test/X_test.txt")
activitys_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subjects_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
bodyAccX_test<-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
bodyAccY_test<-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
bodyAccZ_test<-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
bodyGyroX_test<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
bodyGyroY_test<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
bodyGyroZ_test<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")
totalAccX_test<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
totalAccY_test<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
totalAccZ_test<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")
#rename colomuns in features train
names(features_train) <- features_file$V2
#rename colomuns in features test
names(features_test) <- features_file$V2
#rename colomun in activitys train
names(activitys_train) <- "activitys"
#rename colomun in activitys test
names(activitys_test) <- "activitys"
#rename colomun in subject train
names(subjects_train) <- "subject"
#rename colomun in subject test
names(subjects_test) <- "subject"
# combine subject and activity sets with train
sub_act_feat_train = cbind(subjects_train,activitys_train,features_train)
# combine subject and activity sets with test
sub_act_feat_test = cbind(subjects_test,activitys_test,features_test)
#merge train and test
subActFeatures_both <- rbind(sub_act_feat_train,sub_act_feat_test)
#extract mean and standard deviation
subActMeanStd_both <- subActFeatures_both%>%select(matches('mean|std'))
#descriptive names
# turn activities & subjects into factors
subActFeatures_both$activitys <- factor(subActFeatures_both$activitys, levels = activitys_names[,1], labels = activitys_names[,2])
subActFeatures_both$subject <- as.factor(subActFeatures_both$subject)

allData.melted <- melt(subActFeatures_both, id = c("subject", "activitys"))
allData.mean <- dcast(allData.melted, subject + activitys ~ variable, mean)

#tidy data
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)