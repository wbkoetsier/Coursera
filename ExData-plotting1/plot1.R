# Coursera Exploratory Data Analysis - Course Project 1 #
## Plot 1 ##
# I completed course project 1 a couple of months ago while enrolled in this course. I then had to give up
# and unenrolled. I am re-taking this class and obviously re-using these plots.

# I downloaded the data (in my working directory) using:
# $ wget https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# $ mv exdata%2Fdata%2Fhousehold_power_consumption.zip exdata_data_household_power_consumption.zip
# $ unzip exdata_data_household_power_consumption.zip

# I created a subset of the data using:
# $ awk '/^[1|2]\/2\/2007;/' household_power_consumption.txt > Feb2007subset.txt
# This subset contains 2880 rows and no header

# Read in the data in R
feb07 <- read.table("Feb2007subset.txt",
                    sep = ";",
                    col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
                                  "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                    colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# open png device
png(filename = "plot1.png")

# create historgram, with annotation
# I tried 'bg = "transparent"', and with par()$bg is also set to transparent, I seem to get a white background anyway. Since it is
# not required, I will not look into it any further.
hist(feb07$Global_active_power,
     col = "red",
     bg = "transparent",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)") # ylab already has meaningful default

# always device off
dev.off()
