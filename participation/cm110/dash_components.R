## Assign components to variables

heading_title <- htmlH1('Gapminder Dash Demo')
heading_subtitle <- htmlH2('Looking at country data interactively')

### Create the dropdown
yaxisDropdown <- dccDropdown(
	id = "y-axis",
	options = map(
		1:nrow(yaxisKey), function(i){
			list(label=yaxisKey$label[i], value=yaxisKey$value[i])
		}),
	value = "gdpPercap"
)

### Create the button 
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

### Create graph components

graph_country <- dccGraph(
	id = 'gap-graph-country',
	figure=make_country_graph() # gets initial data using argument defaults
)

sources <- dccMarkdown("[Data Source](https://cran.r-project.org/web/packages/gapminder/README.html)")
