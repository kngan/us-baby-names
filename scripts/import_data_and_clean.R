# install packages and load
install.packages("data.table")
install.packages("ggplot2")
install.packages("maps")

library(data.table)
library(ggplot2)
library(maps)

# import all state level data
files = list.files(pattern="*.TXT")
dt = do.call(rbind, lapply(files, fread))

# name variables and change to factors
names(dt) <- c("state", "sex", "year", "name", "count")
dt$sex <- as.factor(dt$sex)
dt$year <- as.factor(dt$year)
dt$name <- as.factor(dt$name)

# import state data for mapping and merge abbreviations on
all_states <- map_data("state")
all_states_w_abbrev <- merge(all_states, state_to_abbrev, by="region")

# pick a name and a year and a gender
picked_name <- "Alia"
picked_year <- 1980
picked_sex <- "F"
selected_name_and_yr <- subset(dt, name==picked_name & year==picked_year & sex==picked_sex)
total <- merge(all_states_w_abbrev, selected_name_and_yr, by="state")

# plot
# sort so plots without the lines in the map
total <- total[order(total$order),]
p <- ggplot()
p <- p + geom_polygon(data=total, aes(x=long, y=lat, group = group, fill=total$count),colour="white"
) + scale_fill_continuous(low = "thistle2", high = "darkred", guide="colorbar")
P1 <- p + theme_bw()  + labs(fill = "New Births" 
                             ,title = paste("Count of Name",picked_name,"(",picked_sex,") in",picked_year), x="", y="")
P1 + scale_y_continuous(breaks=c()) + scale_x_continuous(breaks=c()) + theme(panel.border =  element_blank())

# TODO: normalize?
# TODO: pick "both" for gender
# TODO: scales weird when some states are blank?
