# Coursera Exploratory Data Analysis course project 2
# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

# See details in plot 5. This time, repeat for LA and use different colours to plot.
# I plot the emissions in a different colour for each fips. I do not use log for emissions, because the emissions from Balstimore are much higher than LA. I can now look at the absolute difference between years and see which fips has the bigger change.

# Subset SCC table to include only the Mobile - [NO|o]n-Road' sectors
# coerce SCC column to charcter for semi_join operation
mvs <- tbl_df(SCC) %>%
  select(SCC, EI.Sector) %>%
  filter(grepl("Mobile - .*-Road", EI.Sector)) %>%
  mutate_each(funs(as.character), SCC)

# Subset NEI table to find emissions from the filtered sources, for Baltimore City (fips == "24510") and LA County (fips == "06037")
nei_subset <- tbl_df(NEI) %>%
  select(SCC, fips, Emissions, year) %>%
  filter(fips %in% c("24510", "06037")) %>%
  semi_join(mvs, by = "SCC")

# Plot emissions by year

# Change fips labels for graph labels
nei_subset <- nei_subset %>% mutate_each(funs(factor), fips)
levels(nei_subset$fips) <- c("Baltimore City", "LA County")

# open png device rather than ggsave at the end to avoid scaling and size issues
png("./plot6.png")

# Group data by year and summarise to get totals.
# Initialise plot with year on x axis and total emissions on y axis
# store plot in object to prevent autoprinting
p <- nei_subset %>%
  group_by(year, fips) %>%
  summarise(totalEmissions = sum(Emissions)) %>%
# use log to be able to compare between graohs
ggplot(aes(x = year, y = totalEmissions)) +
# add geom layers: points and connecting lines, each fips another color
geom_point(aes(color = fips)) + geom_line(aes(color = fips)) +
# add plot title
ggtitle(
  expression(
    atop("Plot 6: total PM2.5 emissions for motor vehicle sources\nin Baltimore City, Maryland and Los Angeles County, California", 
    atop("for 'Exploratory Data Analysis' course project 2"))
  )) +
# add custom ylab
ylab("Total amount of PM2.5 emitted (tons)") +
# change x axis ticks and labels. Could've used c(1999, 2002, 2005, 2008) but I like it dynamic!
scale_x_continuous(name = "Year", breaks = as.numeric(levels(as.factor(nei_subset$year))))

# print plot to png device
print(p)

# always...
dev.off()
