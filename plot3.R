## Set Working Directory
setwd("C:/Users/dave_/OneDrive/GitHub/Coursera/Exploratory Data Analysis/ExploratoryDataWeek4Assignment")

## Unzip file

# Create variable to hold information about the file to be unzipped
zipF <- paste(getwd(),"exdata_data_NEI_data.zip",sep = "/")
unzip(zipF) # Unzip it in working directoy

## Check file names in working directory
dir()

## Read in the two tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load the GGPLOT2 Library
library(ggplot2)
library(gridExtra)
library(dplyr)

## Create a subset of each set to create a separate chart

## Subset to just Baltimore Point
bltPoint <- subset(NEI, fips == "24510" & type == "POINT")

## Subset to just Baltimore Non Point
bltNonPoint <- subset(NEI, fips == "24510" & type == "NONPOINT")

## Subset to just Baltimore On-Road
bltRoad <- subset(NEI, fips == "24510" & type == "ON-ROAD")

## Subset to just Baltimore Non-Road
bltNonRoad <- subset(NEI, fips == "24510" & type == "NON-ROAD")

## Very quick look over each one - we want to see if there are any unusual numbers

## Point
summary(bltPoint$Emissions)

bltPoint %>%
        select(Emissions, year) %>%
        aggregate(list(bltPoint$year), median)

## Non Point
summary(bltNonPoint$Emissions)
bltNonPoint %>%
        select(Emissions, year) %>%
        aggregate(list(bltNonPoint$year), median)

## On-Road
summary(bltRoad$Emissions)
bltRoad %>%
        select(Emissions, year) %>%
        aggregate(list(bltRoad$year), median)

## Non-Road
summary(bltNonRoad$Emissions)
bltNonRoad %>%
        select(Emissions, year) %>%
        aggregate(list(bltNonRoad$year), median)

## Notes
## No NAs in any emissions. quite low numbers may be difficult to see any pattern in the plot so may have to 
## run as log10 to try and see the pattern better (if there is one)

## Run a ggplot with stat for median on each dataset to see if there is an increase or decrease

## Point
ggplot(bltPoint, aes(x = year, y = Emissions)) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1)

## Non Point
ggplot(bltNonPoint, aes(x = year, y = Emissions)) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1)

## Road
ggplot(bltRoad, aes(x = year, y = Emissions)) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1)

## Non-Road
ggplot(bltNonRoad, aes(x = year, y = Emissions)) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1)


## As suspected the numbers are quite low, so difficult to dechipher a pattern, re-run with log10

## Point
point <- ggplot(bltPoint, aes(x = year, y = log10(Emissions))) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1) +
        geom_smooth(method = "lm") + 
        labs(title = "Emissions in Baltimore - Point")

## Non Point
nonPoint <- ggplot(bltNonPoint, aes(x = year, y = log10(Emissions))) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1) +
        geom_smooth(method = "lm") + 
        labs(title = "Emissions in Baltimore - Non-Point")

## Road
road <- ggplot(bltRoad, aes(x = year, y = log10(Emissions))) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1) +
        geom_smooth(method = "lm") + 
        labs(title = "Emissions in Baltimore - On-Road")

## Non-Road
nonRoad <- ggplot(bltNonRoad, aes(x = year, y = log10(Emissions))) +
        geom_point() +
        stat_summary(fun.y = median, geom = "line", lwd=1) +
        geom_smooth(method = "lm") + 
        labs(title = "Emissions in Baltimore - Non-Road")

## In each case here, the 0's are removed - we were aware of this issue before we started.
## However a pattern does appear more prominent here

## Now arrange the 4 charts into 1 single place


## Create a PNG
png("plot3.png", width = 1016, height = 656, units = "px")

## Plot the chart and add a linear regression line to show the trend
grid.arrange(point, nonPoint, road, nonRoad)

## Close the PNG device

dev.off()
