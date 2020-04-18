## YOUR SOLUTION HERE

# author: YOUR NAME
# date: THE DATE

"This script is the main file that creates a Dash app for cm110 on the gapminder dataset.

Usage: app.R
"

## Load libraries
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)

source('dash_functions.R')
source('dash_components.R')

## Specify layout elements

div_header <- htmlDiv(
	list(heading_title,
			 heading_subtitle
	), ## Add this property after your list of components
	style = list(
		backgroundColor = '#009410', ## COLOUR OF YOUR CHOICE
		textAlign = 'center',
		color = 'white',
		margin = 0,
		marginTop = 0
	)
)

div_sidebar <- htmlDiv(
	list(htmlLabel('Select y-axis metric:'),
			 htmlBr(),
			 yaxisDropdown,
			 htmlLabel('Select y scale : '),
			 htmlBr(),
			 logbutton,
			 sources
	), style = list('background-color' = '#BBCFF1',
									'padding' = 10,
									'flex-basis' = '20%')
)

div_main <- htmlDiv(
	list(graph,
			 graph_country
	)
)

## Create Dash instance

app <- Dash$new()

## Specify App layout

app$layout(
	div_header,
	htmlDiv(
		list(
			div_sidebar,
			div_main
		), style = list('display' = 'flex',
										'justify-content' = 'center')
	)
)

## App Callbacks

# app$callback(
# 	#update figure of gap-graph
# 	output=list(id = 'gap-graph', property='figure'),
# 	#based on values of year, continent, y-axis components
# 	params=list(input(id = 'y-axis', property='value'),
# 							input(id = 'yaxis-type', property='value')),
# 	#this translates your list of params into function arguments
# 	function(yaxis_value, yaxis_scale) {
# 		make_plot(yaxis_value, yaxis_scale)
# 	})
# 
# ## Updates our second graph using linked interactivity
# app$callback(output = list(id = 'gap-graph-country', property = 'figure'),
# 						 params = list(input(id='y-axis', property='value'),
# 						 							# Here's where we check for graph interactions!
# 						 							input(id='gap-graph', property='clickData')),
# 						 function(yaxis_value, clickData) {
# 						 	# clickData contains $x, $y and $customdata
# 						 	# you can't access these by gapminder column name!
# 						 	country_name = clickData$points[[1]]$customdata
# 						 	make_country_graph(country_name, yaxis_value)
# 						 })

## Run app

app$run_server(debug=TRUE)

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")
