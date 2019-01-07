## Set Working Directory
setwd("C:/Users/dave_/OneDrive/GitHub/Coursera/Exploratory Data Analysis/ExploratoryDataWeek4Assignment")

getwd()

## Unzip file

# Create variable to hold information about the file to be unzipped
zipF <- paste(getwd(),"exdata_data_NEI_data.zip",sep = "/")
unzip(zipF) # Unzip it in working directoy

## Check file names in working directory
dir()

## Read in the two tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset to just Baltimore
blt <- subset(NEI, fips == "24510")

## Sum up the total emissions for each individual year to plot on a chart (question says total emissions)
polYear <- with(blt, tapply(Emissions, year, sum, na.rm = T))

## Create a variable for each of the years to plot on the chart
years <- unique(blt$year)

## Create a PNG
png("plot2.png", width = 867, height = 558, units = "px")

## Plot the chart and add a linear regression line to show the trend
plot(years, polYear, pch = 20, cex = 2, main = "Total Emissions By Year for Baltimore Area (24510)", xlab = "Year", ylab = "Total Emissions (tons)")
abline(lm(polYear ~ years), col = "red", lwd = 2)

## Close the PNG device

dev.off()
