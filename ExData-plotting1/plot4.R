# Coursera Exploratory Data Analysis - Course Project 1 #
## Plot 2 ##

# I downloaded the data (in my working directory) using:
# $ wget https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# $ mv exdata%2Fdata%2Fhousehold_power_consumption.zip exdata_data_household_power_consumption.zip
# $ unzip exdata_data_household_power_consumption.zip

# I created a subset of the data using:
# $ awk '/^[1|2]\/2\/2007;/' household_power_consumption.txt > Feb2007subset.txt
# This subset contains 2880 rows and no header

# for plot background transparency: see comments in the other plots

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
plot_data <- feb07 %>%
             mutate(datetime = dmy_hms(paste(Date, Time))) %>%
             select(-Global_intensity)


# open png device
png(filename = "plot4.png")

# adjust mfrow parameter to create 2 rows, 2 columns
par(mfrow = c(2, 2))

# create plots and annotations

# top left
plot(plot_data$datetime, plot_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

# top right
plot(plot_data$datetime, plot_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# bottom left
plot( plot_data$datetime, plot_data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(plot_data$datetime, plot_data$Sub_metering_2, type = "l", col = "red")
lines(plot_data$datetime, plot_data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = colnames(plot_data)[6:8], col = c("black", "red", "blue"), lty = 1, bty = "n")

# bottom right
plot(plot_data$datetime, plot_data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

# always device off
dev.off()
