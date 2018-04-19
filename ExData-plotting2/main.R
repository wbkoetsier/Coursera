# Coursera Exploratory Data Analysis course project 2
# main script

## load libraries ##
print("Load 'dplyr' library")
library("dplyr")
print("Load 'ggplot2' library")
library("ggplot2")
# print("Load 'grid' library")
# library("grid") # needed for unit in facet spacing


## load data ##
# download using
# $ wget https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# $ unzip exdata%2Fdata%2FNEI_data.zip
# assuming you download and stay in the repo root dir ExData_Plotting2

print("Load NEI data (~650 MB)")
# from assignment text:
# "PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year."
NEI <- readRDS("summarySCC_PM25.rds")

print("Load SCC data")
# from assignment text:
# 'Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.'
# 'This table' is also a data.frame.
SCC <- readRDS("Source_Classification_Code.rds")

print("Done loading data")

# plot 1
print("Create plot 1...")
source("./plot1.R")

# plot 2
print("Create plot 2...")
source("./plot2.R")

# plot 3
print("Create plot 3...")
source("./plot3.R")

# plot 4
print("Create plot 4...")
source("./plot4.R")

# plot 5
print("Create plot 5...")
source("./plot5.R")

# plot 6
print("Create plot 6...")
source("./plot6.R")

# print("Done creating plots, exit")