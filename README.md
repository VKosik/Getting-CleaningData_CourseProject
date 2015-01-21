#  Getting-CleaningData_CourseProject
##  Coursera Course Project for G&amp;C data course

* Since I have also included comments directly in the code I will try to be very brief
* First I have loaded and paired all the datasets based on rbind (binding by rows)
* Then I have prepared a nice clean features dataset which I have then used for subsetting and further development of our desired data set (used mostly gsub, grep, etc)
* Fixed the activity label data
* Used cbind to combine all previous dataset into one pile that was ready to be used for 5th step
* used dplyr to merge and summarize data based on mean values for each combination of subject ~ activity
* used write.thx command to save both datasets (with mean values and without) for our assignment the main dataset is with the means, named as GroupedDataMeans.txt dim = 180 observations 68variables
