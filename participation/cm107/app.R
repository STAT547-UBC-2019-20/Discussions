## YOUR SOLUTION HERE

# author: Firas Moosvi
# date: 2020-03-17

"This script is the main file that creates a Dash app.

Usage: app.R
"

# 1. Load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(tidyverse)
library(plotly)

make_plot <- function() {
	# add a ggplot
	plot <- mtcars %>% 
		ggplot() + 
		theme_bw() +
		geom_point(aes(x = mpg, y = hp) ) + 
		labs(x = 'Fuel efficiency (mpg)',
				 y = 'Horsepower (hp)') + 
		ggtitle(("Horsepower and Fuel efficiency for "))
	
	ggplotly(plot)
}


# 2. Create Dash instance

app <- Dash$new()

# 3. Specify App layout
app$layout(
	htmlDiv(
		list(
			htmlH1('Hello world!! Dash application'),
			htmlH2('This is a subheading'),
			dccGraph(id='mtcars',figure = make_plot())
		)
	)
)


# 4. Run app

app$run_server()

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")