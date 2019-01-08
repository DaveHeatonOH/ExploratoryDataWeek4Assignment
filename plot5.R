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
motorVehicleData <- subset(NEI, NEI$SCC %in% SCCOnRoad$SCC & fips == "24510")


## Look to see if there is any massive change in the number of records for each year.
## If not we can try and aggregate the data to compare it it like the earlier plots
hist(motorVehicleData$year)

summary(motorVehicleData$Emissions)

## Shows some increase in records across the years but not massivly so if we aggreagate the total emissions
## across each year to see what happens.

plot1Data <- aggregate(list(total.emissions = motorVehicleData$Emissions), list(year = motorVehicleData$year), sum) ## Get total emissions by year
plot2Data <- aggregate(list(mean.emissions = motorVehicleData$Emissions), list(year = motorVehicleData$year), mean, na.rm = T) ## Get mean emissions by year
plot3Data <- aggregate(list(median.emissions = motorVehicleData$Emissions), list(year = motorVehicleData$year), median, na.rm = T) ## Get median emissions by year

plot1 <- ggplot(plot1Data, aes(x = year, y = total.emissions, group = 1)) +
        geom_line() + 
        geom_point() +
        xlab("Year") + 
        ylab("Total Emissions (tons)") +
        labs(title = "Total Emissions by Year - Baltimore \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))

plot2 <- ggplot(plot2Data, aes(x = year, y = mean.emissions, group = 1)) +
        geom_line() + 
        geom_point() +
        xlab("Year") + 
        ylab("Mean Emissions (tons)") +
        labs(title = "Mean Emissions by Year - Baltimore \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))

plot3 <- ggplot(plot3Data, aes(x = year, y = median.emissions, group = 1)) +
        geom_line() + 
        geom_point() +
        xlab("Year") + 
        ylab("Median Emissions (tons)") +
        labs(title = "Median Emissions by Year - Baltimore \nMotor Vehicle Sources") +
        theme(plot.title = element_text(hjust = 0.5))

## Now we know the number of observations increases but we can also see the emissions decrease over time.

## Create a PNG
png("plot5.png", width = 1016, height = 656, units = "px")

lay <- rbind(c(1,2), c(3,3))

grid.arrange(grobs = list(plot1, plot2, plot3), layout_matrix = lay)

## Close the PNG device

dev.off()

