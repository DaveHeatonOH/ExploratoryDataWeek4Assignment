## Set Working Directory
setwd("C:\Users\dave_\OneDrive\GitHub\Coursera\Exploratory Data Analysis\ExploratoryDataWeek4Assignment")

## Unzip file

# Create variable to hold information about the file to be unzipped
zipF <- paste(getwd(),"exdata_data_NEI_data.zip",sep = "/")
unzip(zipF) # Unzip it in working directoy

## Check file names in working directory
dir()

