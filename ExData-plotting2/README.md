# ExData_Plotting2
Plotting Assignment 2 for Exploratory Data Analysis

--originally a repo forked from rdpeng--

## Goal of this repo
This assignment is part of the Coursera course '[Exploratory Data Analysis](https://www.coursera.org/course/exdata)' (part 4 of the [Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1)). This repo is not needed to complete this assignment, but Git is a great way to keep and share my work for the course. Repo contents below, followed by the assignment details (copy-paste from the course), and my notes at the bottom.

## Repo contents
The scripts were written and tested on Kubuntu 15.04 using R 3.1.2. The [main script](main.R) loads libraries and data and then calls the plot scripts (./plot1.R, ./plot2.R, etc.) for all questions, creating all png files in the same directory. Assumes the data are in the same directory (see also ./main.R), data not included in this repo.

Note that the plot scripts should contain loading libraries and data according to the assignment. I add this when I submit the scripts.

## Assignment (original text)
### Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

### Data

The data for this assignment are available from the course web site as a single zip file:

- [Data for Peer Assessment](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip) [29Mb]

The zip file contains two files:

PM2.5 Emissions Data (`summarySCC_PM25.rds`): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

```
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```

- `fips`: A five-digit number (represented as a string) indicating the U.S. county
- `SCC`: The name of the source as indicated by a digit string (see source code classification table)
- `Pollutant`: A string indicating the pollutant
- `Emissions`: Amount of PM2.5 emitted, in tons
- `type`: The type of source (point, non-point, on-road, or non-road)
- `year`: The year of emissions recorded

Source Classification Code Table (`Source_Classification_Code.rds`): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source "10100101" is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".

You can read each of the two files using the `readRDS()` function in R. For example, reading in each file can be done with the following code:

```
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

as long as each of those files is in your current working directory (check by calling dir() and see if those files are in the listing).

### Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999-2008. You may use any R package you want to support your analysis.

#### Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the **base** plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

2. Have total emissions from PM2.5 decreased in the **Baltimore City**, Maryland (`fips == "24510"`) from 1999 to 2008? Use the **base** plotting system to make a plot answering this question.

3. Of the four types of sources indicated by the `type` (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for **Baltimore City**? Which have seen increases in emissions from 1999-2008? Use the **ggplot2** plotting system to make a plot answer this question.

4. Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

5. How have emissions from motor vehicle sources changed from 1999-2008 in **Baltimore City**?

6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in **Los Angeles County**, California (`fips == "06037"`). Which city has seen greater changes over time in motor vehicle emissions?

#### Making and Submitting Plots

For each plot you should

1. Construct the plot and save it to a **PNG** file.

2. Create a separate R code file (`plot1.R`, `plot2.R`, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You must also include the code that creates the PNG file. Only include the code for a single plot (i.e. `plot1.R` should only include code for producing `plot1.png`)

3. Upload the PNG file on the Assignment submission page

4. Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.

## Personal notes
### On the data
- Rds file: Rds stores a single R object. See also: http://stackoverflow.com/questions/21370132/r-data-formats-rdata-rda-rds-etc
- In R, `> format(object.size(NEI), units = "auto")` shows the NEI object (main data) is 648.7 Mb, the source classification code object is 3.6 Mb.
- Not immediately relevant for these plots and the goal of this excercise, but the emission data are in 'tons'. What is a ton exactly?

### Accessing the data
I'll use [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) for data manipulation, as taught in the third course in the specialization, '[Getting And Cleaning Data](https://www.coursera.org/course/getdata)':

```
install.packages("dplyr")
```

### ggplot2
* Please check http://docs.ggplot2.org/current/index.html
* use the png device instead of ggsave, because ggsave causes scaling and size issues and the solution is so easy: create plot and save to object, open png device, print plot, dev.off().

### On plot 3
There are many possibilities to create such a graph. For example, I could have normalised the data first to deal with outliers and the difference between large and small emetting sources. I could have created some sort of scatterplot of all data points for each year and add a regression line. I could have plotted the totals like I did, but instead of connecting the points with lines add a linear model. I followed plots 1 and 2 and kept it simple, excercising the use of ggplot2.

### On plot 4
In the real world, I'd go back to the client to find out what they really meant by 'coal combustion-related sources'. For this script, the goal is to learn how to create an exploratory graph. The exact details of the data are not that important.

I used regex 'Coal' case sensitive on the Sort.Names column. That column seems to combine and abbreviate the four SCC.Level columns. I get a list of 230 different sources with 208 distinct Short.Name descriptions.

I did this because:

- this assignment is about the plotting, not about getting the correct subset of data. If it were about the subsetting, I would try much harder to find a good description of the SCC table, try to find out what is meant exactly (in detail) by 'coal combustion related', go over all descriptions, talk to the client some more about this, etc.
- grepping 'comb' finds all cobustion types like gas, oils and wood
- grepping coal case insensitive also finds charcoal, which is not coal
- the EI.Sector column could contain coal combustion related sources without using the word coal, for example in sector 'Mobile - Commercial Marine Vessels' I find coal driven ships. (wow, really? Military even?)
- the four SCC.Level columns do not seem contain any relevant info that is not in the Short.Name column (I could be wrong, but again... not the goal of this assignment). To look at this try:

```
scc_tbldf %>%
  filter(SCC.Level.One == 'External Combustion Boilers') %>% # as an example
  select(Short.Name, SCC.Level.One, SCC.Level.Two, SCC.Level.Three, SCC.Level.Four) %>%
  View()
```

For plotting, see 'On plot 3'.

I used dplyr::semi_join, see https://cran.r-project.org/web/packages/dplyr/vignettes/two-table.html, which is the most computationally expensive operation in all these scripts (the semi_joins in the other 2 plot scripts seem to be much faster).

### On plot 5
So... Summarising...

For this plot, the same goes as for plots 3 and 4:

- The goal of this question is to learn how to create an exploratory graph, not how to dive deep into a data source.
- In the real world, I would:
  - talk to client to find out exactly what vehicles they want (Cars? Ships? Plains? Trains? This is also a non-native English speaker language issue)
  - also, does this include for example 'auto repair shop' sources, or 'construction vehicle traffic'? Or tire wear, or only exhaust?
  - get into the code book manually and determine which sources apply
  - normalise the data to account for outliers and differences in source size (a Hummer is supposed to emit more fine particles than a Prius)
- For now, I determine what I will grep from which column in the SCC table and plot toal emissions per year

According to Wikipedia, a motor vehicle is a 'self-propelled road vehicle, commonly wheeled, that does not operate on rails, such as trains or trams.' I will assume that 'motor vehicle sources' include all sources within one of the 7 EI sectors starting with 'Mobile - Non-Road' and 'Mobile - On-Road'. Quickly scanning the short names of these sources shows me that these sources also include for example totals, tire wear, generator sets, welding machines, mining signal signs, etc. To stick with this assignments goal, I'll leave it at this and use all sources in these 7 sectors. 
(check that:
`s <- tbl_df(SCC) %>% select(EI.Sector, Short.Name) %>% filter(grepl("Mobile - .*-Road", EI.Sector)) %>% write.csv("road.csv", quote=F, row.names=F)`
)

### On plot 6
I plot the emissions in a different colour for each fips, instead of using facets. I do not use log for emissions, because the emissions from Balstimore are much higher than LA. I can now look at the absolute difference between years and see which fips has the bigger change.