# Coursera Exploratory Data Analysis course project 2
# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City,
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting
# system to make a plot answering this question.

# using dplyr

# subset the data:
# 1. select columns first to decrease table size: fips, emissions and year
# 2. filter rows:
#   - all rows are pollutant type PM25-PRI
#   - all rows are one of the desired years
#   - NAs aren't summed so don't have to be filtered out
#   - but this time we want only fips == "24510"
# 3. group the data by year
# 4. summarise the total emissions per year into new column
nei_subset <- tbl_df(NEI) %>%
  select(fips, Emissions, year) %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(totalEmissions = sum(Emissions))

# plot total emissions per year using base plotting system:
# 1. open png device
png(filename = "plot2.png")

# 2. adjust left margin to fit the large emission numbers
# margins: c(bottom, left, top, right), defaults are c(5, 4, 4, 2) + 0.1
par(mar = c(5, 6, 4, 2) + 0.1)

# 3. plot total emissions by year
nei_subset %>% plot(type = "b",
                    pch = 19,
                    xlab = "Year",
                    ylab = "Total amount of PM2.5 emitted (tons)",
                    axes = FALSE, # supress axes entirely
                    ann = FALSE # supress all annotation
                   )
# 4. add axes and axis labels
# add x axis
axis(1, at = nei_subset$year)
title(xlab = "Year")

# add y axis
# 'las': tick labels for y axis are normally printed vertically, but because the numbers are large they overlap. 1=always horizontal, see ?par
# 'mgp': move ylabel (defaults to 3, 1, 0), see ?par
axis(2, at = nei_subset$totalEmissions, las = 1)
title(ylab = "Total amount of PM2.5 emitted (tons)", mgp = c(5, 1, 0))

# 5. add overall title
title(main = "Plot 2: total PM2.5 emissions for Baltimore City, Maryland")
mtext("for 'Exploratory Data Analysis' course project 2")
# always dev off
dev.off()
                  

