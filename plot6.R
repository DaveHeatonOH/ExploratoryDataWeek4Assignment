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
library(gridExtra)

## Read in the two tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(SCC)

## Get the SCC codes for On Road - Motor Vehicles
SCCOnRoad <- SCC[grep("Mobile - On-Road", SCC$EI.Sector),]

## Limit the data to just motor vehicles for baltimore
motorVehicleDataBalt <- subset(NEI, NEI$SCC %in% SCCOnRoad$SCC & fips == "24510")

## Limit the data to just motor vehicles for LA
motorVehicleDataLA <- subset(NEI, NEI$SCC %in% SCCOnRoad$SCC & fips == "06037")


## Look to see if there is any massive change in the number of records for each year.
## If not we can try and aggregate the data to compare it it like the earlier plots
hist(motorVehicleDataBalt$year)
hist(motorVehicleDataLA$year)

summary(motorVehicleDataBalt$Emissions)
summary(motorVehicleDataLA$Emissions)

## Shows some increase in records across the years but not massivly so if we aggreagate the total emissions
## across each year to see what happens.

baltMean <- aggregate(list(mean.emissions = motorVehicleDataBalt$Emissions), list(year = motorVehicleDataBalt$year), mean, na.rm = T) ## Get mean emissions by year
laMean <- aggregate(list(mean.emissions = motorVehicleDataLA$Emissions), list(year = motorVehicleDataLA$year), mean, na.rm = T) ## Get mean emissions by year

balMedian <- aggregate(list(median.emissions = motorVehicleDataBalt$Emissions), list(year = motorVehicleDataBalt$year), median, na.rm = T) ## Get median emissions by year
laMedian <- aggregate(list(median.emissions = motorVehicleDataLA$Emissions), list(year = motorVehicleDataLA$year), median, na.rm = T) ## Get median emissions by year




## Create the various plots for each metric by Area
plot1 <- ggplot(baltMean, aes(x = year, y = mean.emissions, group = 1)) +
        geom_line() + 
        geom_point() +
        xlab("Year") + 
        ylab("Mean Emissions (tons)") +
        labs(title = "Mean Emissions by Year - Baltimore \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))

plot2 <- ggplot(laMean, aes(x = year, y = mean.emissions, group = 1)) +
        geom_line() + 
        geom_point() +
        xlab("Year") + 
        ylab("Mean Emissions (tons)") +
        labs(title = "Mean Emissions by Year - LA \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))

plot3 <- ggplot(balMedian, aes(x = year, y = median.emissions, group = 1)) +
        geom_line() +
        geom_point() +
        xlab("Year") + 
        ylab("Median Emissions (tons)") +
        labs(title = "Median Emissions by Year - Baltimore \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))
        
plot4 <- ggplot(laMedian, aes(x = year, y = median.emissions, group = 1)) +
        geom_line() +
        geom_point() +
        xlab("Year") + 
        ylab("Median Emissions (tons)") +
        labs(title = "Median Emissions by Year - LA \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))

## Now we know the number of observations increases but we can also see the emissions decrease over time.

## Create a PNG
png("plot6.png", width = 1016, height = 656, units = "px")

grid.arrange(plot1, plot2, plot3, plot4, nrow = 2)

## Close the PNG device

dev.off()

