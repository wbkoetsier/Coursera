# Coursera Exploratory Data Analysis course project 2
# Question 5
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# For this plot, the same goes as for plots 3 and 4:
# - The goal of this question is to learn how to create an exploratory graph, not how to dive deep into a data source.
# - In the real world, I would:
#   - talk to client to find out exactly what vehicles they want (Cars? Ships? Plains? Trains? This is also a non-native English speaker language issue)
#   - also, does this include for example 'auto repair shop' sources, or 'construction vehicle traffic'? Or tire wear, or only exhaust?
#   - get into the code book manually and determine which sources apply
#   - normalise the data to account for outliers and differences in source size (a Hummer is supposed to emit more fine particles than a Prius)
# - For now, I determine what I will grep from which column in the SCC table and plot toal emissions per year
# 
# According to Wikipedia, a motor vehicle is a 'self-propelled road vehicle, commonly wheeled, that does not operate on rails, such as trains or trams.' I will assume that 'motor vehicle sources' include all sources within one of the 7 EI sectors starting with 'Mobile - Non-Road' and 'Mobile - On-Road'. Quickly scanning the short names of these sources shows me that these sources also include for example totals, tire wear, generator sets, welding machines, mining signal signs, etc. To stick with this assignments goal, I'll leave it at this and use all sources in these 7 sectors. 
# (check that:
# s <- tbl_df(SCC) %>% select(EI.Sector, Short.Name) %>% filter(grepl("Mobile - .*-Road", EI.Sector)) %>% write.csv("road.csv", quote=F, row.names=F)
# )

# Subset SCC table to include only the Mobile - [NO|o]n-Road' sectors
# coerce SCC column to charcter for semi_join operation
mvs <- tbl_df(SCC) %>%
  select(SCC, EI.Sector) %>%
  filter(grepl("Mobile - .*-Road", EI.Sector)) %>%
  mutate_each(funs(as.character), SCC)

# Subset NEI table to find emissions from the filtered sources, for Baltimore City (fips == "24510")
nei_subset <- tbl_df(NEI) %>%
  select(SCC, fips, Emissions, year) %>%
  filter(fips == "24510") %>%
  semi_join(mvs, by = "SCC")

# Plot emissions by year

# open png device rather than ggsave at the end to avoid scaling and size issues
png("./plot5.png")

# Group data by year and summarise to get totals.
# Initialise plot with year on x axis and total emissions on y axis
# store plot in object to prevent autoprinting
p <- nei_subset %>%
  group_by(year) %>%
  summarise(totalEmissions = sum(Emissions)) %>%
ggplot(aes(x = year, y = totalEmissions)) +
# add geom layers: points and connecting lines
geom_point() + geom_line() +
# add plot title
ggtitle(
  expression(
    atop("Plot 5: total PM2.5 emissions for motor vehicle sources\nin Baltimore City, Maryland", 
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
