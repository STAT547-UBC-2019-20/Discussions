## Script to check Dash installation

library(testthat)

expect_equal(as.character(packageVersion('plotly')),'4.9.2', 
						info="Please update or install `plotly` to v4.9.2 or newer")

expect_equal(as.character(packageVersion('dash')),'0.3.1', 
						info="Please update or install `dash` to v0.3.1 or newer")

expect_equal(as.character(packageVersion('dashCoreComponents')),'1.8.0',
						 info="Please update or install `dashCoreComponents` to v1.8.0 or newer")

expect_equal(as.character(packageVersion('dashHtmlComponents')),'1.0.2', 
						 info="Please update or install `dashHtmlComponents` to v1.0.2 or newer` ", 
)

library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

print('Congratulations! You have successfully installed and loaded all required packages and libraries. You are ready to create Dash apps!')