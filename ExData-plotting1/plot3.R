# Coursera Exploratory Data Analysis - Course Project 1 #
## Plot 2 ##

# I downloaded the data (in my working directory) using:
# $ wget https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# $ mv exdata%2Fdata%2Fhousehold_power_consumption.zip exdata_data_household_power_consumption.zip
# $ unzip exdata_data_household_power_consumption.zip

# I created a subset of the data using:
# $ awk '/^[1|2]\/2\/2007;/' household_power_consumption.txt > Feb2007subset.txt
# This subset contains 2880 rows and no header

# This script uses 2 libraries:
library(dplyr) # for subsetting data
library(lubridate) # for coercing date and time values

# Read in the data in R
feb07 <- tbl_df(read.table("Feb2007subset.txt",
                           sep = ";",
                           col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
                                         "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                           colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")))

# Subset the data using dplyr methods
plot3_data <- feb07 %>%
              mutate(DateTime = dmy_hms(paste(Date, Time))) %>%
              select(DateTime, Sub_metering_1, Sub_metering_2, Sub_metering_3)

# open png device
png(filename = "plot3.png")

# create plot, with annotation
# for bg transperancy choices, see the plot1 code
plot(plot3_data$DateTime, plot3_data$Sub_metering_1, type = "l",
     main = "",
     xlab = "",
     ylab = "Energy sub metering")
lines(plot3_data$DateTime, plot3_data$Sub_metering_2, type = "l", col = "red")
lines(plot3_data$DateTime, plot3_data$Sub_metering_3, type = "l", col = "blue")
# add legend
legend("topright", legend = colnames(plot3_data)[2:4], col = c("black", "red", "blue"), lty = 1)

# always device off
dev.off()
