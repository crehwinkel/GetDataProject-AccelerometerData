
# Read all the data in
setwd("C:/Users/crehwinkel/My Documents/DataScience/GettingData/Project/UCI HAR Dataset/train")

trainx <- read.table("X_train.txt", header=FALSE, stringsAsFactors=FALSE)
trainy <- read.table("y_train.txt", header=FALSE, stringsAsFactors=FALSE)
subtrain  <- read.table("subject_train.txt", header=FALSE, stringsAsFactors=FALSE)

features <- read.table("../features.txt", header=FALSE, stringsAsFactors=FALSE)

setwd("C:/Users/crehwinkel/My Documents/DataScience/GettingData/Project/UCI HAR Dataset/test")

testx <- read.table("X_test.txt", header=FALSE, stringsAsFactors=FALSE)
testy <- read.table("y_test.txt", header=FALSE, stringsAsFactors=FALSE)
subtest  <- read.table("subject_test.txt", header=FALSE, stringsAsFactors=FALSE)
setwd("../")
actlabels <- read.table("activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
actlabels[[2]] <- tolower(actlabels[[2]])

# row bind the data measurements together
alldata<-rbind(trainx, testx)
collabels <- features[[2]]
colnames(alldata) <- collabels      # add the column names to the data
names(alldata) <- gsub("[()]", "", names(alldata))
names(alldata) <- gsub("Mean", "mean", names(alldata))


install.packages("dplyr")
library(dplyr)
#only keep columns that have mean or std in them
lv <- grepl( "mean" , names( alldata ) ) | grepl( "std", names(alldata))

somedata <- alldata[ , lv]    # somedata has columns with only mean or std

#get activity lists together
activcolumn <- rbind(trainy, testy)     #create the activity column

activcolumn[[1]] <- mapvalues(activcolumn[[1]], from = actlabels[[1]], to=actlabels[[2]])
colnames(activcolumn) <- c("Activity")   #name the column Activity
tdata <- cbind(activcolumn, somedata)  # column bind to data to add activity 

#get ID lists together
idcolumn <- rbind(subtrain, subtest)
colnames(idcolumn) <- c("ID")    #name the column ID
tdata <- cbind(idcolumn, tdata)  #column bind ID to the data

names(tdata) <- gsub(",", "", names(tdata))  #clean up column labels
names(tdata) <- gsub("-", "", names(tdata))

#Create tidy data set for Step 5 of requirements
enddata <- tdata %>% group_by(Activity, ID) %>% summarise_each(funs(mean))

write.table(enddata, file = "avgAllDataProjectGetData.txt", row.name = FALSE)
