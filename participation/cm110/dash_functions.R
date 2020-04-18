suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(tidyverse))
library(gapminder)

# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("GDP Per Capita", "Life Expectancy", "Population"),
									 value = c("gdpPercap", "lifeExp", "pop"))

## Make plot

make_plot <- function(yaxis = "gdpPercap",
											scale = "linear"){
	
	# gets the label matching the column value
	y_label <- yaxisKey$label[yaxisKey$value==yaxis]
	
	#filter our data based on the year/continent selections
	data <- gapminder
	# make the plot!
	
	### the customdata mapping adds country to the tooltip and allows
	# its selection using clickData.
	
	p <- ggplot(data, aes(x = year, y = !!sym(yaxis), 
												colour = continent, 
												customdata=country)) +
		geom_jitter(alpha=0.6) +
		scale_color_manual(name = 'Continent', values = continent_colors) +
		scale_x_continuous(breaks = unique(data$year))+
		xlab("Year") +
		ylab(y_label) +
		ggtitle(paste0("Change in ", y_label, " over time (Scale : ", scale, ")")) +
		theme_bw()
	
	if (scale == 'log'){
		p <- p + scale_y_continuous(trans='log10')
	}
	
	ggplotly(p) %>%
		### this is optional but changes how the graph appears on click
		# more layout stuff: https://plotly-r.com/improving-ggplotly.html
		layout(clickmode = 'event+select')
	
}

### Create the line graph

make_country_graph <- function(country_select="Canada",
															 yaxis="gdpPercap"){
	
	# gets the label matching the column value
	y_label <- yaxisKey$label[yaxisKey$value==yaxis]
	
	#filter our data based on the year/continent selections
	data <- gapminder %>%
		filter(country == country_select)
	
	# make the plot
	p <- ggplot(data, aes(x=year, y=!!sym(yaxis), colour=continent)) +
		geom_line() +
		scale_color_manual(name="Continent", values=continent_colors) +
		scale_x_continuous(breaks = unique(data$year))+
		xlab("Year") +
		ylab(y_label) +
		ggtitle(paste0("Change in ", y_label, " Over Time: ", 
									 country_select)) +
		theme_bw()
	
	ggplotly(p)
}
