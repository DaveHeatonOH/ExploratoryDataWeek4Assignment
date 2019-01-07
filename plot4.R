## Set Working Directory
setwd("C:/Users/dave_/OneDrive/GitHub/Coursera/Exploratory Data Analysis/ExploratoryDataWeek4Assignment")

## Unzip file

# Create variable to hold information about the file to be unzipped
zipF <- paste(getwd(),"exdata_data_NEI_data.zip",sep = "/")
unzip(zipF) # Unzip it in working directoy

## Check file names in working directory
dir()

## Load the GGPLOT2 Library
library(ggplot2)

## Read in the two tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Get a list of the SCC values which contain Coal (using level 3)
coalData <- SCC[grep("Coal", SCC$SCC.Level.Three, ignore.case = T),]

## Create a subset of the data which is limited to just coal based sources
NEICoal <- subset(NEI, NEI$SCC %in% coalData$SCC)

# Get the years
years <- unique(NEICoal$year)

ggplot(NEICoal, aes(x = year, y = Emissions)) +
        geom_point()
