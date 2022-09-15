# Boston-Town-Centre

## Description
We consider the data contained within the dataframe boston.c, which is provided as part of the spData package in R.According to the [documentation](https://search.r-project.org/CRAN/refmans/spData/html/boston.html),this dataset contains housing data that was collected as part of the 1970 census of Boston, Massachusetts.Each observation (row) in the dataset contains a collection of statistics corresponding to a single census ‘tract’ (a small geographic region containing multiple houses, defined specifically for a census).
This project will consider the spatial distribution of the CMEDV variable. This variable corresponds to the median value (in USD 000s) of owner-occupied housing in each census tract. Each tract is also associated with a point location; geographic coordinates for this point (measured in decimal degrees latitude and longitude), as well as the town in which it is located (within the Greater Boston area), are provided for each observation.

We are going to derive a smaller dataframe from the above data set that contains only the variables TOWN, LON, LAT and CMEDV:

* TOWN a factor with levels given by town names.(92 towns)
* LON a numeric vector of tract point longitudes in decimal degrees.
* LAT a numeric vector of tract point latitudes in decimal degrees.
* CMEDV a numeric vector of corrected median values of owner-occupied housing in USD 1000.

It has been suggested that the coordinates provided in boston.c contain a systematic error, with all observations in each town being mislocated by a fixed distance (in a fixed direction). As a result we need to correct the the coordinates.
The corrected data from the Harrison and Rubinfeld (1978) are contained in a data frame, which is comprised by 506 rows and 20 columns.Each observation (row) in the dataset contains a collection of statistics corresponding to a single census ‘tract’ (a small geographic region containing multiple houses, defined specifically for a census). Some notes are that that MEDV is censored, in that median values at or over USD 50,000 are set to USD 50,000. 

The project is divided into two sections:
* Exploratory data analysis
* Visualisation
* Coordinates correction

Here are the important files (the remaining files should be ignored):

* [Boston-Housing-Data.md](./Boston-Housing-Data.md): The github markdown document which contain the detailed step of the above analysis.
* [Boston-Housing-Data.Rmd](./Boston-Housing-Data.Rmd):The rmarkdown file that contains the detailed step of the spatial data analysis and correction.
* [Boston-Housing-Data.R](./Boston-Housing-Data.R): Contains the code that was used for the analysis.
* [boston_towns.csv](./boston_towns.csv): Input data.

## Environment

* [Rstudio]([https://www.rstudio.com/])

## Requirements

* [R version 4.1.1 (2021-08-10)](https://www.r-project.org/)

## Dependencies

Choose the latest versions of any of the dependencies below:
* dplyr
* ggplot2
* tidyverse
* spData
* ggmap
* maps
* ggcorrplot
* mapview
* leaflet
* viridis

## License

MIT. See the LICENSE file for the copyright notice.
