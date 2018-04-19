# Coursera Exploratory Data Analysis course project 2
# Question 4
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

# In the real world, I'd go back to the client to find out what they really
# meant by 'coal combustion-related sources'. For this script, the goal is
# to learn how to create an exploratory graph. The exact details of the data
# are not that important.
# 
# I used regex 'Coal' case sensitive on the Sort.Names column. That column seems to combine and abbreviate the four SCC.Level columns. I get a list of 230 different sources with 208 distinct Short.Name descriptions.
# 
# I did this because:
# - this assignment is about the plotting, not about getting the correct subset of data. If it were about the subsetting, I would try much harder to find a good description of the SCC table, try to find out what is meant exactly (in detail) by 'coal combustion related', go over all descriptions, talk to the client some more about this, etc.
# - grepping 'comb' finds all cobustion types like gas, oils and wood
# - grepping coal case insensitive also finds charcoal, which is not coal
# - the EI.Sector column could contain coal combustion related sources without using the word coal, for example in sector 'Mobile - Commercial Marine Vessels' I find coal driven ships. (wow, really? Military even?)
# - the four SCC.Level columns do not seem contain any relevant info that is not in the Short.Name column (I could be wrong, but again... not the goal of this assignment). To look at this try:
# scc_tbldf %>%
#   filter(SCC.Level.One == 'External Combustion Boilers') %>% # as an example
#   select(Short.Name, SCC.Level.One, SCC.Level.Two, SCC.Level.Three, SCC.Level.Four) %>%
#   View()

# Subset the SCC table to get the sources related to coal combustion:
# 1. select only the SCC and Short.Name columns
# 2. filter all rows that contain (case sensitive) 'Coal' in the Short.Name column
# 3. The SCC column is a factor, but in the NEI table it's character. Coerce the SCC table, because it's the smallest and we don't need a factor here. Also, semi_join by itself warned that it coerced to character.
ccrs <- tbl_df(SCC) %>%
  select(SCC, Short.Name) %>%
  filter(grepl("Coal", Short.Name)) %>%
  mutate_each(funs(as.character), SCC)

# Subset the NEI table to find emissions from the filtered sources
# 1. Select columns: we need SCC, Emissions and year.
# 2. join the two tables by SCC column (https://cran.r-project.org/web/packages/dplyr/vignettes/two-table.html, this is also the most expensive computation in this script)
NEI_subset <- tbl_df(NEI) %>%
  select(SCC, Emissions, year) %>%
  semi_join(ccrs, by = "SCC")

# result:
# > system.time(NEI_subset <- tbl_df(NEI) %>% select(SCC, Emissions, year) %>% semi_join(ccrs, by = "SCC"))
#    user  system elapsed 
# 170.736   0.092 169.197 
# subset 52,711 records, 174 distinct SCC's in NEI_subset

# Plot emissions by year
# I chose to interpret this question like the first 3: look at the total emissions. In the real world, I'd look into data normalisation methods to deal with outliers. For now, I want one point for each year
# This makes the code the same as for plot 3, minus the facetting by type.

# open png device rather than ggsave at the end to avoid scaling and size issues
png("./plot4.png")

# Group data by year and summarise to get totals.
# Initialise plot with year on x axis and total emissions on y axis
# store plot in object to prevent autoprinting
p <- NEI_subset %>%
  group_by(year) %>%
  summarise(totalEmissions = sum(Emissions)) %>%
ggplot(aes(x = year, y = totalEmissions)) +
# add geom layers: points and connecting lines
geom_point() + geom_line() +
# add plot title
ggtitle(
  expression(
    atop("Plot 4: total PM2.5 emissions for coal combustion-related\nsources across the US", 
    atop("for 'Exploratory Data Analysis' course project 2"))
  )) +
# add custom ylab
ylab("Total amount of PM2.5 emitted (tons)") +
# change x axis ticks and labels. Could've used c(1999, 2002, 2005, 2008) but I like it dynamic!
scale_x_continuous(name = "Year", breaks = as.numeric(levels(as.factor(NEI_subset$year))))

# print plot to png device
print(p)

# always...
dev.off()
