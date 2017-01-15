# canadaHCDx: An expansion to provide additional functions for the [`canadaHCD`](https://github.com/gavinsimpson/canadaHCD) package



Environment and Climate Change Canada (ECCC) provides archival climate data for a [wealth of climate stations](ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv) across the country. This data is available for download on the ECCC [data portal](http://climate.weather.gc.ca/). This website is useful for browsing data, and is convenient for downloading short periods of data. However, if you are seeking a 30-year baseline, the manual download of the necessary data can become very tedious. In that regard, ECCC also provides a bulk download function to make acquiring that data a little bit easier. While the process is much simpler than it has been in the past, one still must put in a little leg work to: 

1) Identify the station of interest
2) Find the correct data set
3) Download the relevant data files
4) Process the files into workable data sets

To overcome these limitations, Gavin L. Simpson has written a package for R, which performs the above processes with minimal user input. The [`canadaHCD`](https://github.com/gavinsimpson/canadaHCD) package is a very useful tool, however, I noticed that there were a couple of features missing that I needed for my personal workflow. This repository provides a small expansion for the `canadaHCD` package. It adds additional search options. In this README, I will strive to outline the basic functionality of both the original package and my expansion.

# Installing

Most R packages are installed from the Comprehensive R Archive Network (CRAN). `canadaHCD`, however, remains under development and is not hosted on the CRAN. Its source code is freely available on [GitHub](https://github.com/), so we can harness the wonderful `devtools` package to install it:

First, install the `devtools` package if you don't have it already

```r
install.packages("devtools", repos = "https://cran.rstudio.com/")
```

Next, install the `canadaHCD` package, and install this expansion pack. The first line will install the original package. The second line will install this expansion.


```r
devtools::install_github("gavinsimpson/canadaHCD")
devtools::install_git("https://gitlab.com/ConorIA/canadaHCDx.git")
```
Finally, load the packages

```r
library(canadaHCDx) #canadaHCDx will lead canadaHCD automatically
```

# Basic functions

Simpson (2016) has already outlined the basic functions of this package in great detail on the [README](https://github.com/gavinsimpson/canadaHCD/blob/master/README.md) for his GitHub repository. However, I will include a basic overview of the functions in this README.

## Station search

To search for a station by name, use the `find_station()` function. For instance, to search for a station with the word 'Toronto' in the station name, use the following code:


```r
find_station("Toronto")
```

```
## # A tibble: 117 × 5
##                                       Name Province StationID LatitudeDD
##                                     <fctr>   <fctr>    <fctr>      <dbl>
## 1                              TORONTO RSB  Ontario     10673      43.65
## 2  PA TORONTO INTERNATIONAL TRAP AND SKEET  Ontario     52731      44.19
## 3             PA TORONTO NORTH YORK MOTORS  Ontario     52678      43.72
## 4              PA SCARBOROUGH TORONTO HUNT  Ontario     52641      43.68
## 5                       PA TORONTO HYUNDAI  Ontario     52640      43.70
## 6                                  TORONTO  Ontario      5051      43.67
## 7                        TORONTO  WX RADIO  Ontario     30204      43.64
## 8                  TORONTO SOLAR RADIATION  Ontario     41863      43.67
## 9                             TORONTO CITY  Ontario     31688      43.67
## 10                     TORONTO CITY CENTRE  Ontario     48549      43.63
## # ... with 107 more rows, and 1 more variables: LongitudeDD <dbl>
```

Note that the `tibble` object (a special sort of `data.frame`) won't print more than the first 10 rows by default. To see all of the results, you can wrap the command in `View()` so that it becomes `View(find_station("Toronto"))`.

## Download data

Once you have found your station of interest, you can download hourly, daily and monthly data using the `hcd_hourly()`, `hcd_daily()`, and `hcd_monthly()` functions, respectively. Look at the documentation for each function by typing a question mark, followed by the function name, or using the `help()` function. For instance, to find out what arguments the `hcd_daily()` function takes, type `?hcd_daily` or `help(hcd_daily)`.

If I wanted to download daily data for Toronto City (station no. 5051) from 1971 to 2000, I could use: 


```r
city <- hcd_daily(5051, 1971:2000)
```

Make sure to use the assignment operator (`<-`) to save the data into an R object, otherwise the data will just print out to the console, and won't get saved anywhere in the memory. 

# Extra functions in the expansion pack

Users of the `canadaHCD` package can largely avoid using the Environment and Climate Change Canada website to acquire climate data, however, there were a few search features on the ECCC website that weren't available in the installed package. 

## Advanced search

The `find_station_adv()` function adds the ability to search for stations by name (as per the original), by a given baseline period, and by proximity to another station or a vector of coordinates. You can use any combination of these three filters in your search. There are a few mandatory arguments for each filter. For instance, if you are searching for a certain baseline period, you must also include the type of data you are looking for (hourly, daily, or monthly). The function is fully documented, so take a look at `?find_station_adv`. Let's look at some examples.

### Find all stations containing "Toronto" in their name

```r
find_station_adv("Toronto")
```

```
## # A tibble: 93 × 5
##                                       Name Province StationID LatitudeDD
##                                      <chr>    <chr>     <int>      <dbl>
## 1  PA TORONTO INTERNATIONAL TRAP AND SKEET  ONTARIO     52731      44.19
## 2             PA TORONTO NORTH YORK MOTORS  ONTARIO     52678      43.72
## 3              PA SCARBOROUGH TORONTO HUNT  ONTARIO     52641      43.68
## 4                       PA TORONTO HYUNDAI  ONTARIO     52640      43.70
## 5                                  TORONTO  ONTARIO      5051      43.67
## 6                             TORONTO CITY  ONTARIO     31688      43.67
## 7                      TORONTO CITY CENTRE  ONTARIO     48549      43.63
## 8                        TORONTO AGINCOURT  ONTARIO      5052      43.78
## 9                   TORONTO ASHBRIDGES BAY  ONTARIO      5053      43.67
## 10                     TORONTO BALMY BEACH  ONTARIO      5054      43.67
## # ... with 83 more rows, and 1 more variables: LongitudeDD <dbl>
```
### Find stations named "Toronto", with hourly data available from 1971 to 2000

```r
find_station_adv("Toronto", baseline = c(1971, 2000), type = "hourly")
```

```
## # A tibble: 2 × 7
##                                Name Province StationID LatitudeDD
##                               <chr>    <chr>     <int>      <dbl>
## 1                  TORONTO ISLAND A  ONTARIO      5085      43.63
## 2 TORONTO LESTER B. PEARSON INT'L A  ONTARIO      5097      43.68
## # ... with 3 more variables: LongitudeDD <dbl>, HourlyFirstYr <int>,
## #   HourlyLastYr <int>
```
### Find all stations between 0 and 100 km from Station No. 5051

```r
find_station_adv(target = 5051, mindist = 0, maxdist = 100)
```

```
## # A tibble: 506 × 6
##                              Name Province StationID LatitudeDD
##                             <chr>    <chr>     <int>      <dbl>
## 1                         TORONTO  ONTARIO      5051      43.67
## 2                    TORONTO CITY  ONTARIO     31688      43.67
## 3               TORONTO DEER PARK  ONTARIO      5065      43.68
## 4      PA MATTAMY ATHLETIC CENTRE  ONTARIO     52723      43.66
## 5              TORONTO SHERBOURNE  ONTARIO      5089      43.65
## 6  PA DUFFERIN AND ST. CLAIR CIBC  ONTARIO     53838      43.68
## 7               TORONTO BROADVIEW  ONTARIO      5063      43.67
## 8               TORONTO LEASIDE S  ONTARIO      5095      43.70
## 9             TORONTO NORTHCLIFFE  ONTARIO      5108      43.68
## 10            TORONTO CITY CENTRE  ONTARIO     48549      43.63
## # ... with 496 more rows, and 2 more variables: LongitudeDD <dbl>,
## #   Dist <dbl>
```
### Find all stations that are within 10 km of UTSC campus

```r
find_station_adv(target = c(43.7860, -79.1873), mindist = 0, maxdist = 5)
```

```
## # A tibble: 8 × 6
##                                  Name Province StationID LatitudeDD
##                                 <chr>    <chr>     <int>      <dbl>
## 1 PA U OF T SCARBOROUGH TENNIS CENTRE  ONTARIO     52724      43.78
## 2             TOR SCARBOROUGH COLLEGE  ONTARIO      5091      43.78
## 3              TORONTO HIGHLAND CREEK  ONTARIO      5080      43.78
## 4                   TORONTO WEST HILL  ONTARIO      5120      43.77
## 5                     TORONTO MALVERN  ONTARIO      5099      43.80
## 6                   TORONTO METRO ZOO  ONTARIO      5102      43.82
## 7                 TORONTO CURRAN HALL  ONTARIO      5064      43.75
## 8                         ROUGE HILLS  ONTARIO      5024      43.80
## # ... with 2 more variables: LongitudeDD <dbl>, Dist <dbl>
```

## Station search GUI

Sometimes, no matter how versatile one's search function is, it is far easier to just mouse through a table and find the data that one needs. To make this "mousing" just a little easier, I have included a Shiny data table to help with navigating the list of stations. Call the table up by running `find_station_GUI()` with no arguments. 

This table is also fully compatible with the advanced search function. To use a filtered list of stations with the Shiny table, first use the assignment operator to save your search results to an object called `customtable`, then run `find_station_GUI()`. To remove the filter, you can use `rm(customtable)`.

## Map function

Sometimes a long list of stations is hard to visualize spatially. To overcome this, I added a third function, which takes a list of stations and shows them on a map powered by the [Leaflet](http://leafletjs.com/) library. The function is even smart enough to take a search as its list of stations as per the example below.

### Show a map of all stations that are between 10 and 20 km of UTSC campus

```r
map_stations(find_station_adv(target = c(43.7860, -79.1873), mindist = 10, maxdist = 20), zoom = 7)
```

# Disclaimer

The package outlined in this document is published under the GNU General Public License, version 2 (GPL-2.0). The GPL is an open source, copyleft license that allows for the modification and redistribution of original works. This license is what makes it perfectly legal for me to build upon Simpson's work and modify it as I see fit. It is important to note, however, that programs licensed under the GPL come with NO WARRANTY. In our case, a simple R package isn't likely to blow up your computer or kill your cat. Nonetheless, it is always a good idea to pay attention to what you are doing, to ensure that you have downloaded the correct data, and that everything looks ship-shape. 

# What to do if something doesn't work

If you run into an issue while you are using the package, you can email me and I can help you troubleshoot the issue. However, if the issue is related to the package code and not your own fault, you should contribute back to the open source community by reporting the issue. If the issue is in one of the basic `canadaHCD` functions, report the issue on [GitHub](https://github.com/gavinsimpson/canadaHCD). If your issue is with one of my extended functions, report the issue to me here on [GitLab](https://gitlab.com/ConorIA/canadaHCDx).

If that seems like a lot of work, just think about how much work it would have been to do all the work this package does for you, or how much time went in to writing these functions!