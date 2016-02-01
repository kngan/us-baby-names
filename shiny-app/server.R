# install packages and load
library(data.table)
library(ggplot2)
library(maps)
library(shiny)

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
state_to_abbrev <- fread("state_to_abbrev.txt")
all_states_w_abbrev <- merge(all_states, state_to_abbrev, by="region")

# TODO: normalize by births that year
# TODO: pick "both" for gender
# TODO: select a name
# TODO: scales weird when some states are blank?
# TODO: dark is high, light is low

# Define server logic required to draw a map
shinyServer(function(input, output) {
  
  # Expression that generates a map The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  # pick a name and a year and a gender
  picked_name <- "Sara"
  picked_sex <- "F"
  selected_name_and_yr <- reactive(subset(dt, name==picked_name & year==input$picked_year & sex==picked_sex))
  total <- reactive(merge(all_states_w_abbrev, selected_name_and_yr, by="state"))
  
  # plot
  # sort so plots without the lines in the map
  total <- reactive(total[order(total$order),])
  p <- reactive(ggplot())
  p <- reactive(p + geom_polygon(data=total, aes(x=long, y=lat, group = group, fill=total$count),colour="Black"
  ) + scale_fill_distiller(palette="Blues") +  guides(fill = guide_legend(reverse = TRUE)))
  P1 <- reactive(p + theme_bw()  + labs(fill = "New Births" 
                               ,title = paste("Count of Name",picked_name,"(",picked_sex,") in",input$picked_year), x="", y=""))
  
  output$mapPlot <- renderPlot({
    P1
  })
  
})