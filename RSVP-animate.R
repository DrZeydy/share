# Animated plot of RSVPs for the annual Analytics>Forward event
# by Zeydy Ortiz, Ph. D. - March 5, 2019

# Make sure the plotting packages are installed
install.packages("ggplot2")
install.packages("gganimate")
install.packages("gifski") # renderer for gganimate

library(ggplot2)
library(ggthemes)
library(gganimate)

# RSVP data was collected and pre-processed by Rick Pack
# In particular, he calculated:
# days_to_event: number of days before the annual event
# dates_yes_cumsum: total number of Yes RSVPs as of days_to_event before the event
# yes_year: year of the event for the series

fileURL <- "https://raw.githubusercontent.com/RickPack/AnalyticsForward_2019/master/AnalyticsForward_Registrations.csv"
RSVPdata <- read.csv(file=fileURL)


# static version of the chart
g <- ggplot(RSVPdata, aes(x=days_to_event, y=dates_yes_cumsum, color=factor(yes_year))) + 
  scale_x_reverse() + # needed to reverse the x axis to have 0 at the end of the axis (right side)
  geom_line(size=1) + 
  labs(title="Analytics>Forward RSVPs per year", color="Year",
       x="Days to the event", y="Total YES RSVPs", caption="Source: @rick_pack2 - RSVPs as of 3/4/2019") +
  # theme settings
  theme_minimal (base_size=16) +
    theme(plot.title=element_text())+theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    theme(legend.position="bottom")

# Calculating the range for the x axis
# Hack to make sure animation from left to right 
starting <- max(RSVPdata$days_to_event)
ending <- min(RSVPdata$days_to_event)

# Animation settings from http://lenkiefer.com/2019/01/13/go-go-animate/
anim <- g +  aes(label=yes_year) + geom_text(size=5) + theme(legend.position="none") +
  transition_reveal(days_to_event, range=c(starting, ending))

# use end_pause=20 to hold last frame for 20 frames (~2 seconds)
animate(anim, end_pause=20, width=800, height=600)
anim_save(file="AF_RSVP.gif", animation = last_animation())
