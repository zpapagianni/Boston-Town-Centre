Housing Data
================

## Introduction

According to the
documentation(<https://search.r-project.org/CRAN/refmans/spData/html/boston.html>),this
dataset contains housing data that was collected as part of the 1970
census of Boston, Massachusetts.The data frame has 506 rows and 20
columns and it contains the corrected data from the Harrison and
Rubinfeld (1978) data.Each observation (row) in the dataset contains a
collection of statistics corresponding to a single census ‘tract’ (a
small geographic region containing multiple houses, defined specifically
for a census). Some notes are that that MEDV is censored, in that median
values at or over USD 50,000 are set to USD 50,000.

In this study we will consider the spatial distribution of the CMEDV
variable. This variable corresponds to the median value (in USD 000s) of
owner-occupied housing in each census tract. Each tract is also
associated with a point location; geographic coordinates for this point
(measured in decimal degrees latitude and longitude), as well as the
town in which it is located (within the Greater Boston area), are
provided for each observation.

We are going to derive a smaller dataframe from the above data set that
contains only the variables TOWN, LON, LAT and CMEDV:

-   TOWN a factor with levels given by town names.
-   LON a numeric vector of tract point longitudes in decimal degrees.
-   LAT a numeric vector of tract point latitudes in decimal degrees.
-   CMEDV a numeric vector of corrected median values of owner-occupied
    housing in USD 1000.

### Analysis of data

First, we read the boston data file from spData package in R and select
the columns of interest. From Table 1, we can see that the variable TOWN
is a factor with 92 levels. We also check for the existence of missing
values. As we can observe in the table below there are no missing values
to report in the data.
<table>
<caption>
The first rows of the dataset, boston.c
</caption>
<thead>
<tr>
<th style="text-align:center;">
TOWN
</th>
<th style="text-align:center;">
LON
</th>
<th style="text-align:center;">
LAT
</th>
<th style="text-align:center;">
CMEDV
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Nahant
</td>
<td style="text-align:center;">
-70.96
</td>
<td style="text-align:center;">
42.26
</td>
<td style="text-align:center;">
24.0
</td>
</tr>
<tr>
<td style="text-align:center;">
Swampscott
</td>
<td style="text-align:center;">
-70.95
</td>
<td style="text-align:center;">
42.29
</td>
<td style="text-align:center;">
21.6
</td>
</tr>
<tr>
<td style="text-align:center;">
Swampscott
</td>
<td style="text-align:center;">
-70.94
</td>
<td style="text-align:center;">
42.28
</td>
<td style="text-align:center;">
34.7
</td>
</tr>
<tr>
<td style="text-align:center;">
Marblehead
</td>
<td style="text-align:center;">
-70.93
</td>
<td style="text-align:center;">
42.29
</td>
<td style="text-align:center;">
33.4
</td>
</tr>
<tr>
<td style="text-align:center;">
Marblehead
</td>
<td style="text-align:center;">
-70.92
</td>
<td style="text-align:center;">
42.30
</td>
<td style="text-align:center;">
36.2
</td>
</tr>
</tbody>
</table>
<table>
<caption>
Number of missing values
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:center;">
x
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
TOWN
</td>
<td style="text-align:center;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
LON
</td>
<td style="text-align:center;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
LAT
</td>
<td style="text-align:center;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
CMEDV
</td>
<td style="text-align:center;">
0
</td>
</tr>
</tbody>
</table>

## Visualisation

We are going to visualize the coordinates using ggplot. We can see that
we can’t derive any information from the plot below so we will need to
incorporate maps into our analysis.
<img src="Boston-Housing-Data_files/figure-gfm/Fig1-1.png" title="\label{fig:fig1}Coordinates" alt="\label{fig:fig1}Coordinates" style="display: block; margin: auto;" />

In the map below , we can already see that the points on the map
representing the the latitudes and longitudes, are not matching the
towns.

    ## Assuming "lon" and "lat" are longitude and latitude, respectively

<img src="maps.png" title="Coordinates on map" alt="Coordinates on map" width="70%" />

In order to be sure, we are going to zoom in and in fact we can clearly
see that some of the towns appear on the water.

    ## Assuming "lon" and "lat" are longitude and latitude, respectively

<img src="mapszoom.png" title="Coordinates on map" alt="Coordinates on map" width="70%" />

Finally we analyse our data further by inspecting individual towns on
Google Maps and in particular Cambridge. First we search for the right
coordinates on Google Maps and add them to our map. The blue dot
represents the correct coordinates, while the green dot shows the
coordinates in our data. We can clearly see that there is a significant
difference between the two.

    ## Assuming "LON" and "LAT" are longitude and latitude, respectively

<img src="Boston-Housing-Data_files/figure-gfm/Cambridge map-1.png" title="Zoom on map" alt="Zoom on map" width="70%" /><img src="cambridgemap.png" title="Zoom on map" alt="Zoom on map" width="70%" />

## Coordinates correction

In order to correct the data, we suppose that all coordinates are
shifted by a certain amount. We assume that there are *n*<sub>*j*</sub>
observations in town *j*, and for each observation *k* in town *j*,we
denote the longitudinal coordinate as $x\_{j,k} , k = 1,, n_j $. Then we
assume:

*x*<sub>*j*, *k*</sub> = *T**C*<sub>*j*</sub><sup>(*x*)</sup> + *Δ*<sub>*j*, *k*</sub><sup>(*x*)</sup>
where *T**C*<sub>*j*</sub><sup>(*x*)</sup> is the longitudinal
coordinate of the center of town j, and
*Δ*<sub>*j*, *k*</sub><sup>(*x*)</sup> is the displacement of
observation *k* in town *j* from the town center.We also assume that the
latitudinal coordinates (which we denote *y*<sub>*j*, *k*</sub>) satisfy
a similar relationship. The suggested systematic error is therefore such
that
(*T**C*<sub>*j*</sub><sup>(*x*)</sup>,*T**C*<sub>*j*</sub><sup>(*y*)</sup>)
has been misspecified for *j* = 1, …, *n* where n is the number of
towns.

To find the displacement, we are going to use the correct center
coordinates for each town in Boston that exist in the file
BostonTownCentres.csv. First we are going to have a quick look at the
data. Note: We can see that the towns in this instance are of type
character.

    ## Rows: 92 Columns: 3

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): town
    ## dbl (2): lat, lon

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

<table>
<caption>
Correct coordinates for each town in Boston
</caption>
<thead>
<tr>
<th style="text-align:center;">
town
</th>
<th style="text-align:center;">
lat
</th>
<th style="text-align:center;">
lon
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Arlington
</td>
<td style="text-align:center;">
42.41537
</td>
<td style="text-align:center;">
-71.15644
</td>
</tr>
<tr>
<td style="text-align:center;">
Ashland
</td>
<td style="text-align:center;">
42.26066
</td>
<td style="text-align:center;">
-71.46413
</td>
</tr>
<tr>
<td style="text-align:center;">
Bedford
</td>
<td style="text-align:center;">
42.49173
</td>
<td style="text-align:center;">
-71.28179
</td>
</tr>
<tr>
<td style="text-align:center;">
Belmont
</td>
<td style="text-align:center;">
42.39593
</td>
<td style="text-align:center;">
-71.17867
</td>
</tr>
<tr>
<td style="text-align:center;">
Beverly
</td>
<td style="text-align:center;">
42.55843
</td>
<td style="text-align:center;">
-70.88005
</td>
</tr>
</tbody>
</table>

next we’re using an appropriate mutating join to combine the two data
sets.We check and observe that the number of columns in `boston.c`
doesn’t match the number of columns in the new data frame.We find that
the missing data corresponds to Saugus, which is spelled as Sargus in
boston.c. As a result, we correct the instances of Sargus and join the
corrected data frame with BostonTownCentres.This time the column match.

    ## [1] FALSE

    ## [1] "Sargus"

    ## [1] TRUE

Next we’re going to visualise the correct coordinates.We can alredy
observe that there are no points on water and they seem to match the
towns on the map.

    ## Assuming "lon" and "lat" are longitude and latitude, respectively

<img src="correctmap.png" title="Correct coordinates on map" alt="Correct coordinates on map" width="70%" />
We’re going to zoom into an area to check if everything is in order.

    ## Assuming "lon" and "lat" are longitude and latitude, respectively

<img src="Boston-Housing-Data_files/figure-gfm/unnamed-chunk-8-1.png" title="Zoom on correct coordinates on map" alt="Zoom on correct coordinates on map" width="70%" /><img src="mapszoomcorrect.png" title="Zoom on correct coordinates on map" alt="Zoom on correct coordinates on map" width="70%" />

\###Correct coordinates In order to fix our data set, we need replace
the centroid for each town (i.e. for *j* = 1, …, *n*) of the
*n*<sub>*j*</sub> boston.c locations with the true town center. First,
we are going to find the centroid in our dataset by grouping the data by
town and finding the mean longitude and latitude. Then we calculate the
displacement as so:
*x*<sub>*j*, *k*</sub> = *T**C*<sub>*j*</sub><sup>(*x*)</sup> + *Δ*<sub>*j*, *k*</sub><sup>(*x*)</sup> ⇒ *Δ*<sub>*j*, *k*</sub><sup>(*x*)</sup> = *x*<sub>*j*, *k*</sub> − *T**C*<sub>*j*</sub><sup>(*x*)</sup>
In the equation above, *x*<sub>*j*, *k*</sub> is known and is equal to
the coordinates in boston.c and *T**C*<sub>*j*</sub><sup>(*x*)</sup> was
calculated above as the mean lon and lat. After, we add the displacement
of each town to the centroids contained in BostonTownCentres.csv and
create a new dataframe containing two columns with the true coordinates
for each observation. Hence we add to the above combined dataframe.
<img src="Boston-Housing-Data_files/figure-gfm/unnamed-chunk-9-1.png" title="Final maps" alt="Final maps" width="70%" /><img src="finalmap.png" title="Final maps" alt="Final maps" width="70%" /><img src="Boston-Housing-Data_files/figure-gfm/unnamed-chunk-9-3.png" title="Final maps" alt="Final maps" width="70%" /><img src="finalmapszoom.png" title="Final maps" alt="Final maps" width="70%" />

### Visualisation

Finally, we construct a visualisation that shows the spatial
distribution of the median value of owner-occupied housing in Greater
Boston in 1970. In this instance, we are going to use ggmap.We observe
that for some towns have only one observation so we can’t create
polygons.

    ## Source : https://maps.googleapis.com/maps/api/staticmap?center=42.36008,-71.05888&zoom=10&size=640x640&scale=2&maptype=terrain&key=xxx-0NQyKizPR9jdAYCfTiyB5IhVfbdU2xI

<img src="Boston-Housing-Data_files/figure-gfm/unnamed-chunk-10-1.png" width="70%" />
