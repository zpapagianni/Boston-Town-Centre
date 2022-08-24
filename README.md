# Boston-Town-Centre

## Description
 
We consider the data contained within the dataframe boston.c, which is provided as part of the spData package in R. This dataset contains housing data that was collected as part of the 1970 census of Boston, Massachusetts. Each observation (row) in the dataset contains a collection of statistics corresponding to a single census ‘tract’ (a small geographic region containing multiple houses, defined specifically for a census).
This project will consider the spatial distribution of the CMEDV variable. This variable corresponds to the median value (in USD 000s) of owner-occupied housing in each census tract. Each tract is also associated with a point location; geographic coordinates for this point (measured in decimal degrees latitude and longitude), as well as the town in which it is located (within the Greater Boston area), are provided for each observation.

It has been suggested that the coordinates provided in boston.c contain a systematic error, with all observations in each town being mislocated by a fixed distance (in a fixed direction). As a result we need to correct the the coordinates.

## Setup
* See [Boston-Housing-Data.md](./Boston-Housing-Data.md) for the report of the project.
* See [Boston-Housing-Data.R](./Boston-Housing-Data.R) for code.
* See [Boston-Housing-Data.Rmd](./Boston-Housing-Data.R) for Rmarkdown.