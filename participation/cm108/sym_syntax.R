library(tidyverse)
library(gapminder)

make_plot <- function(yaxis = "gdpPercap"){
	
	yaxisKey <- tibble(label = c("GDP Per Capita", "Life Expectancy", "Population"),
										 value = c("gdpPercap", "lifeExp", "pop"))
	
	# gets the label matching the column value
	y_label <- yaxisKey$label[yaxisKey$value==yaxis]
	
	#filter our data based on the year/continent selections
	data <- gapminder
	
	p <- ggplot(data, aes(x = year, y = !!sym(yaxis), colour = continent,
												text = paste('continent: ', continent,
																		 '</br></br></br> Year:', year,
																		 '</br></br> GDP:', gdpPercap))) +
		geom_jitter(alpha = 0.6) +
		scale_color_manual(name = 'Continent', values = continent_colors) +
		scale_x_continuous(breaks = unique(data$year))+
		xlab("Year") +
		ylab(y_label) +
		theme_bw()
}

make_plot()

