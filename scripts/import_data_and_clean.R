# install packages and load
install.packages("data.table")
library(data.table)

# import all state level data
dt = do.call(rbind, lapply(files, fread))

# name variables and change to factors
names(dt) <- c("state", "sex", "year", "name", "count")
dt$state <- as.factor(dt$state)
dt$sex <- as.factor(dt$sex)
dt$year <- as.factor(dt$year)
dt$name <- as.factor(dt$name)

