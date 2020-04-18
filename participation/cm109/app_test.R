# author: YOUR NAME
# date: THE DATE

"This script is the main file that creates a Dash app for cm109 on the gapminder dataset.

Usage: app.R
"

## Load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)

## Make plot

make_plot <- function(yaxis = "gdpPercap",
											scale = "linear"){
	
	# gets the label matching the column value
	y_label <- yaxisKey$label[yaxisKey$value==yaxis]
	
	#filter our data based on the year/continent selections
	data <- gapminder
	# make the plot!
	p <- ggplot(data, aes(x = year, y = !!sym(yaxis), colour = continent)) +
		geom_jitter(alpha = 0.6) +
		scale_color_manual(name = 'Continent', values = continent_colors) +
		scale_x_continuous(breaks = unique(data$year))+
		xlab("Year") +
		ylab(y_label) +
		ggtitle(paste0("Change in ", y_label, " over time (Scale : ", scale, ")")) +
		theme_bw()
	
	if (scale == 'log'){
		p <- p + scale_y_continuous(trans='log10')
	}
	# passing c("text") into tooltip only shows the contents of 
	ggplotly(p, tooltip = c("text"))
}

## Assign components to variables

heading_title <- htmlH1('Gapminder Dash Demo')
heading_subtitle <- htmlH2('Looking at country data interactively')

# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("GDP Per Capita", "Life Expectancy", "Population"),
									 value = c("gdpPercap", "lifeExp", "pop"))
#Create the dropdown
yaxisDropdown <- dccDropdown(
	id = "y-axis",
	options = map(
		1:nrow(yaxisKey), function(i){
			list(label=yaxisKey$label[i], value=yaxisKey$value[i])
		}),
	value = "gdpPercap"
)

#Create the button 
logbutton <- dccRadioItems(
	id = 'yaxis-type',
	options = list(list(label = 'Linear', value = 'linear'),
								 list(label = 'Log', value = 'log')),
	value = 'linear'
)

graph <- dccGraph(
	id = 'gap-graph',
	figure=make_plot() # gets initial data using argument defaults
)

sources <- dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)")

## Create Dash instance

app <- Dash$new()

## Specify App layout

app$layout(
	htmlDiv(
		list(
			heading_title,
			heading_subtitle,
			#selection components
			htmlLabel('Select y-axis metric:'),
			yaxisDropdown,
			htmlIframe(height=15, width=10, style=list(borderWidth = 0)), #space
			htmlLabel('Select y scale : '),
			logbutton,
			#graph
			graph,
			htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
			sources
		)
	)
)

## App Callbacks

app$callback(
	#update figure of gap-graph
	output=list(id = 'gap-graph', property='figure'),
	#based on values of year, continent, y-axis components
	params=list(input(id = 'y-axis', property='value'),
							input(id = 'yaxis-type', property='value')),
	#this translates your list of params into function arguments
	function(yaxis_value, yaxis_scale) {
		make_plot(yaxis_value, yaxis_scale)
	})

## Run app

app$run_server()

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")