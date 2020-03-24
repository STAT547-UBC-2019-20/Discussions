library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")
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
# Use a function make_plot() to create the graph
make_plot <- function(yaxis = "gdpPercap"){
	
	# gets the label matching the column value
	y_label <- yaxisKey$label[yaxisKey$value==yaxis]
	
	#filter our data based on the year/continent selections
	data <- gapminder
	# make the plot!
	# on converting yaxis string to col reference (quosure) by `!!sym()`
	# see: https://github.com/r-lib/rlang/issues/116#issuecomment-298969559
	#
	# `sym()` turns strings (or list of strings) to symbols (https://www.rdocumentation.org/packages/rlang/versions/0.2.2/topics/sym)
	#
	# `paste` concatenates vectors after converting to characters (https://www.rdocumentation.org/packages/base/versions/3.6.1/topics/paste)
	
	p <- ggplot(data, aes(x = year, y = !!sym(yaxis), colour = continent,
												text = paste('continent: ', continent,
																		 '</br></br></br> Year:', year,
																		 '</br></br></br> GDP:', gdpPercap))) +
		geom_jitter(alpha = 0.6) +
		scale_color_manual(name = 'Continent', values = continent_colors) +
		scale_x_continuous(breaks = unique(data$year))+
		xlab("Year") +
		ylab(y_label) +
		ggtitle(paste0("Change in ", y_label, " Over Time")) +
		theme_bw()
	
	# passing c("text") into tooltip only shows the contents of 
	ggplotly(p, tooltip = c("text"))
}
# Now we define the graph as a dash component using generated figure
graph <- dccGraph(
	id = 'gap-graph',
	figure=make_plot() # gets initial data using argument defaults
)

keys <- c(2:8)
vals <- c(2:8)

v1 <- c(0,3,4,7.65,10)
v2 <- c("0F", "3F", "4F", "7.5F", "10F")
names_keyvals <- setNames(as.list(v1),v2) #setNames(as.list(keys),as.character(vals))

slider <- dccSlider(
	min = 0,
	max = 9,
	marks = lapply(1:10, function(x){paste("Label", x)}),
	value = 5,
)

app$layout(
	htmlDiv(
		list(
			htmlH1('Gapminder Dash Demo'),
			htmlH2('Looking at country data interactively'),
			#selection components
			htmlLabel('Select y-axis metric:'),
			yaxisDropdown,
			#graph and table
			graph,
			slider,
			htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
			dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)"),
			dccMarkdown("![](https://upload.wikimedia.org/wikipedia/commons/c/c5/En-wikipedia.jpg)"),
			htmlImg(src='/Users/fmoosvi/Sync/mds/Discussions/participation/cm108/screen.png')
		)
	)
)
app$callback(
	#update figure of gap-graph
	output=list(id = 'gap-graph', property='figure'),
	#based on values of year, continent, y-axis components
	params=list(input(id = 'y-axis', property='value')),
	#this translates your list of params into function arguments
	function(yaxis) {
		make_plot(yaxis)
	})
app$run_server()