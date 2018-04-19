# Coursera Exploratory Data Analysis course project 2
# Question 3
# Of the four types of sources indicated by the type (point, nonpoint,
# onroad, nonroad) variable, which of these four sources have seen
# decreases in emissions from 1999–2008 for Baltimore City? Which have
# seen increases in emissions from 1999–2008? Use the ggplot2 plotting
# system to make a plot answer this question.
#
# Baltimore City: fips == "24510"
# types: "NONPOINT", "NON-ROAD", "ON-ROAD",  "POINT"

# using dplyr

# subset the data:
# 1. select columns first to decrease table size: fips, type, emissions and year
# 2. filter rows:
#   - all rows are pollutant type PM25-PRI
#   - all rows are one of the desired years
#   - NAs aren't summed so don't have to be filtered out
#   - but this time we want only fips == "24510"
# 3. group the data by year, then by type
# 4. summarise the total emissions per year into new column
nei_subset <- tbl_df(NEI) %>%
  select(fips, type, Emissions, year) %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(totalEmissions = sum(Emissions))

# open png device rather than ggsave at the end to avoid scaling and size issues
png("./plot3.png")

# initialise plot with year on x axis and total emissions on y axis
# store plot in object to prevent autoprinting
p <- nei_subset %>% ggplot(aes(x = year, y = totalEmissions)) +
# add geom layers: points and connecting lines
geom_point() + geom_line() +
# add plot title
ggtitle(
  expression(
    atop("Plot 3: total PM2.5 emissions for Baltimore City, Maryland", 
    atop("for 'Exploratory Data Analysis' course project 2"))
  )) +
# add custom ylab
ylab("Total amount of PM2.5 emitted (tons)") +
# add facet: 4 rows, 1 col, facet per type, dynamic ylim
facet_grid(type ~ ., scale = "free_y") +
# change x axis ticks and labels. Could've used c(1999, 2002, 2005, 2008) but I like it dynamic!
scale_x_continuous(name = "Year", breaks = as.numeric(levels(as.factor(nei_subset$year))))

# print plot to png device
print(p)

# always...
dev.off()
