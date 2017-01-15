# canadaHCDx: An expansion to provide additional functions for the [`canadaHCD`](https://github.com/gavinsimpson/canadaHCD) package
Conor I. Anderson  
January 15, 2017  



Environment and Climate Change Canada (ECCC) provides archival climate data for a [wealth of climate stations](ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv) across the country. This data is available for download on the ECCC [data portal](http://climate.weather.gc.ca/) [-@environment_and_climate_change_canada_historical_2016]. This website is useful for browsing data, and is convenient for downloading short periods of data. However, if you are seeking a 30-year baseline, the manual download of the necessary data can become very tedious. In that regard, ECCC also provides a bulk download function to make acquiring that data a little bit easier. While the process is much simpler than it has been in the past, one still must put in a little leg work to: 

1) Identify the station of interest
2) Find the correct data set
3) Download the relevant data files
4) Process the files into workable data sets

To overcome these limitations, Gavin L. Simpson [-@simpson_canadahcd_2016] has written a package for R, which performs the above processes with minimal user input. The [`canadaHCD`](https://github.com/gavinsimpson/canadaHCD) package is a very useful tool, however, I noticed that there were a couple of features missing that I needed for my personal workflow. This repository provides a small expansion for the `canadaHCD` package. It adds additional search options. In this README, I will strive to outline the basic functionality of both the original package and my expansion.

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

<!--html_preserve--><div id="htmlwidget-d7324d2a11e6bc5d1aab" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-d7324d2a11e6bc5d1aab">{"x":{"calls":[{"method":"addTiles","args":["http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap\u003c/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA\u003c/a>"}]},{"method":"addMarkers","args":[[43.87,43.75,43.78,43.78,43.78,43.88,43.87,43.88,43.9,43.86,43.82,43.72,43.72,43.87,43.78,43.85,43.8,43.68,43.68,43.83,43.84,43.82,43.67,43.7,43.72,43.72,43.87,43.7,43.9,43.92,43.75,43.67,43.67,43.9,43.86,43.86,43.86,43.91,43.72,43.8,43.9,43.91,43.7,43.87,43.67,43.78,43.8,43.8,43.95,43.77,43.75,43.94,43.68,43.77,43.93],[-79.25,-79.31,-79.32,-79.32,-79.33,-79.25,-79.28,-79.27,-79.18,-79.31,-79.34,-79.32,-79.32,-79.3,-79.35,-79.05,-79.35,-79.27,-79.27,-79.35,-79.03,-79.01,-79.28,-79.33,-79.35,-79.35,-79.04,-79.34,-79.07,-79.12,-79.38,-79.32,-79.32,-79.05,-79.37,-79.37,-79.37,-79.06,-79.38,-79.4,-79.04,-79.32,-79.37,-79.38,-79.35,-79.42,-79.42,-79.42,-79.13,-79.42,-79.42,-79.08,-79.38,-79.43,-79.33],null,{"Name":["MARKHAM MOE","PA ATMOS NORTH YORK","TORONTO BRIDLEWOOD","TORONTO CASTLEMERE","TORONTO DON MILLS","MARKHAM","MARKHAM MTRCA","MARKHAM 2","GREEN RIVER","PA MONOPOLY PROPERTY MANAGEMENT","PA MARKHAM NORTH TOYOTA","TORONTO BERMONDSEY","TORONTO VICTORIA","UNIONVILLE OWRC","TORONTO SENECA HILL","PICKERING","TORONTO DUNN LORING WOOD","PA SCARBOROUGH TORONTO HUNT","TORONTO FALLINGBROOK","MARKHAM WATERWORKS","PA AJAX VILLAGE CHRYSLER","PA AJAX WATER SUPPLY","TORONTO BALMY BEACH","TORONTO EAST YORK","TORONTO BROADWAY","TORONTO LESLIE EGLINTON","PA AJAX COMMUNITY CENTRE","TORONTO EAST YORK DUSTAN","GREENWOOD MTRCA","BROUGHAM","TORONTO YORK MILLS","TORONTO ASHBRIDGES BAY","TORONTO GREENWOOD","PICKERING AUDLEY","TORONTO BUTTONVILLE A","TORONTO BUTTONVILLE A","TORONTO BUTTONVILLE A","PA AJAX PAO TAU","TORONTO SUNNYBROOK","TORONTO LLOYDMINSTER","PA AJAX WINTERMERE SOD","PA ANGUS GLEN GOLF CLUB","TORONTO LEASIDE S","GORMLEY ARDENLEE","TORONTO BROADVIEW","TORONTO NEWTONBROOK","THORNHILL GRANDVIEW","TORONTO NEWTON","TORONTO NEW INT'L A","TORONTO WILLOWDALE","TORONTO GLENDALE","PA ATMOS CLAREMONT","TORONTO DEER PARK","TORONTO STUART AVENUE","UNIONVILLE"],"Province":["ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO","ONTARIO"],"ClimateID":["6154992","6156136","6158408","6158M1K","6158420","6154987","6154990","6154988","6153011","6156180","6156165","6158385","6158780","6159060","61587PG","6156513","6158480","6156172","6158536","6154994","6156153","6156155","6158381","6158505","61584J2","6158732","6156150","6158751","6153020","6151000","615HHDF","6158370","6158575","6156515","6158409","6158410","615HMAK","6156152","6158779","6158734","6156154","6156186","6158730","6152953","6158412","6158753","6158255","6158752","6158749","6158830","6158550","6156132","6158417","6158778","6159058"],"StationID":[4967,53258,5062,5040,5067,4964,4966,4965,4929,52725,52700,5056,5118,5138,5088,5001,5071,52641,5075,4968,52702,52701,5054,5072,5059,5096,52703,45967,4930,4880,4840,5053,5078,5002,54239,53678,4841,52705,5117,5098,52704,52638,5095,4928,5063,5107,5049,5106,5105,5123,5076,52737,5065,5116,5137],"WMOID":[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,71639,71639,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],"TCID":[null,"A6T",null,null,null,null,null,null,null,"Z2E","L2F",null,null,null,null,null,null,"L2A",null,null,"L3B","L3A",null,null,null,null,"L3C",null,null,null,null,null,null,null,"YKZ","YKZ","YKZ","L3E",null,null,"L3D","Z3E",null,null,null,null,null,null,null,null,null,"A3T",null,null,null],"LatitudeDD":[43.87,43.75,43.78,43.78,43.78,43.88,43.87,43.88,43.9,43.86,43.82,43.72,43.72,43.87,43.78,43.85,43.8,43.68,43.68,43.83,43.84,43.82,43.67,43.7,43.72,43.72,43.87,43.7,43.9,43.92,43.75,43.67,43.67,43.9,43.86,43.86,43.86,43.91,43.72,43.8,43.9,43.91,43.7,43.87,43.67,43.78,43.8,43.8,43.95,43.77,43.75,43.94,43.68,43.77,43.93],"LongitudeDD":[-79.25,-79.31,-79.32,-79.32,-79.33,-79.25,-79.28,-79.27,-79.18,-79.31,-79.34,-79.32,-79.32,-79.3,-79.35,-79.05,-79.35,-79.27,-79.27,-79.35,-79.03,-79.01,-79.28,-79.33,-79.35,-79.35,-79.04,-79.34,-79.07,-79.12,-79.38,-79.32,-79.32,-79.05,-79.37,-79.37,-79.37,-79.06,-79.38,-79.4,-79.04,-79.32,-79.37,-79.38,-79.35,-79.42,-79.42,-79.42,-79.13,-79.42,-79.42,-79.08,-79.38,-79.43,-79.33],"Latitude":[435200000,434517700,434700000,434700000,434700000,435300000,435200000,435300000,435400000,435127000,434901000,434300000,434300000,435200000,434700000,435100000,434800000,434100000,434100000,435000000,435029700,434922000,434000000,434200000,434300000,434300000,435155800,434148030,435400000,435500000,434500000,434000000,434000000,435400000,435139000,435139000,435144000,435424300,434300000,434800000,435356500,435429800,434200000,435200000,434000000,434700000,434800000,434800000,435700000,434600000,434500000,435609800,434100000,434600000,435600000],"Longitude":[-791500000,-791853200,-791900000,-791900000,-792000000,-791500000,-791700000,-791600000,-791100000,-791829600,-792033810,-791900000,-791900000,-791800000,-792100000,-790300000,-792100000,-791614900,-791600000,-792100000,-790130500,-790025500,-791700000,-792000000,-792100000,-792100000,-790209900,-792019014,-790400000,-790700000,-792300000,-791900000,-791900000,-790300000,-792207000,-792207000,-792212000,-790327500,-792300000,-792400000,-790217200,-791923400,-792200000,-792300000,-792100000,-792500000,-792500000,-792500000,-790800000,-792500000,-792500000,-790505400,-792300000,-792600000,-792000000],"Elevation":[175.3,178,182.9,184.4,null,195.1,167.6,199.6,190.5,176.5,187.5,138.4,121.9,173.7,189,91.4,175.3,133.5,129.5,182.9,114.5,92.5,99.1,121.9,139,133.3,117.5,125,128,198.1,153.3,74.1,99.1,109.7,198.1,198.1,198.1,148.5,157,167.6,124.5,230.5,137.2,198.1,99.1,182.9,199.3,198.1,262.7,190.5,137.2,167,143.6,190.5,236.2],"FirstYear":[1961,2014,1967,1971,1963,1957,1964,1959,1953,2014,2014,1973,1957,1970,1973,1965,1965,2014,1957,1961,2014,2014,1953,1951,1981,1985,2014,2007,1960,1965,1973,1958,1966,1958,2016,2015,1986,2014,1962,1968,2014,2014,1951,1974,1955,1953,1965,1971,1973,1953,1958,2014,1890,1959,1960],"LastYear":[1980,2015,1980,1980,1966,1972,1979,1965,1957,2015,2015,1984,1961,1970,1987,1976,1975,2015,1976,1979,2015,2015,1956,1957,1988,1987,2015,2015,1993,1975,1987,1997,1981,1985,2017,2017,2015,2015,1993,1969,2015,2015,1956,1994,1961,1955,2007,1975,1976,1970,1969,2015,1933,1963,1974],"HourlyFirstYr":[null,2014,null,null,null,null,null,null,null,2014,2014,null,null,null,null,null,null,2014,null,null,2014,2014,null,null,null,null,2014,null,null,null,null,null,null,null,2016,2015,1986,2014,null,null,2014,2014,null,null,null,null,null,null,1973,null,null,2014,null,null,null],"HourlyLastYr":[null,2015,null,null,null,null,null,null,null,2015,2015,null,null,null,null,null,null,2015,null,null,2015,2015,null,null,null,null,2015,null,null,null,null,null,null,null,2017,2017,2015,2015,null,null,2015,2015,null,null,null,null,null,null,1976,null,null,2015,null,null,null],"DailyFirstYr":[1961,null,1967,1971,1963,1957,1964,1959,1953,null,null,1973,1957,1970,1973,1965,1965,null,1957,1961,null,null,1953,1951,1981,1985,null,2007,1960,1965,1973,1958,1966,1958,null,2015,1986,null,1962,1968,null,null,1951,1974,1955,1953,1965,1971,1973,1953,1958,null,1890,1959,1960],"DailyLastYr":[1980,null,1980,1980,1966,1972,1979,1965,1957,null,null,1984,1961,1970,1987,1976,1975,null,1976,1979,null,null,1956,1957,1988,1987,null,2015,1993,1975,1987,1997,1981,1985,null,2017,2015,null,1993,1969,null,null,1956,1994,1961,1955,2007,1975,1976,1970,1969,null,1933,1963,1974],"MonthlyFirstYr":[1961,null,1967,1971,1963,1957,1964,1959,1953,null,null,1973,1957,1970,1973,1965,1965,null,1957,1961,null,null,1953,1951,null,1985,null,null,1960,1965,1973,1958,1966,1958,null,null,1986,null,1962,1968,null,null,1951,1974,1955,1954,1965,1971,1973,1953,1958,null,1890,1959,1960],"MonthlyLastYr":[1980,null,1980,1980,1966,1972,1979,1965,1957,null,null,1984,1961,1970,1987,1976,1975,null,1976,1979,null,null,1955,1957,null,1987,null,null,1993,1975,1987,1997,1981,1985,null,null,2014,null,1993,1969,null,null,1956,1994,1961,1955,2006,1975,1976,1970,1969,null,1933,1963,1974]},null,{"clickable":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},["4967 - MARKHAM MOE","53258 - PA ATMOS NORTH YORK","5062 - TORONTO BRIDLEWOOD","5040 - TORONTO CASTLEMERE","5067 - TORONTO DON MILLS","4964 - MARKHAM","4966 - MARKHAM MTRCA","4965 - MARKHAM 2","4929 - GREEN RIVER","52725 - PA MONOPOLY PROPERTY MANAGEMENT","52700 - PA MARKHAM NORTH TOYOTA","5056 - TORONTO BERMONDSEY","5118 - TORONTO VICTORIA","5138 - UNIONVILLE OWRC","5088 - TORONTO SENECA HILL","5001 - PICKERING","5071 - TORONTO DUNN LORING WOOD","52641 - PA SCARBOROUGH TORONTO HUNT","5075 - TORONTO FALLINGBROOK","4968 - MARKHAM WATERWORKS","52702 - PA AJAX VILLAGE CHRYSLER","52701 - PA AJAX WATER SUPPLY","5054 - TORONTO BALMY BEACH","5072 - TORONTO EAST YORK","5059 - TORONTO BROADWAY","5096 - TORONTO LESLIE EGLINTON","52703 - PA AJAX COMMUNITY CENTRE","45967 - TORONTO EAST YORK DUSTAN","4930 - GREENWOOD MTRCA","4880 - BROUGHAM","4840 - TORONTO YORK MILLS","5053 - TORONTO ASHBRIDGES BAY","5078 - TORONTO GREENWOOD","5002 - PICKERING AUDLEY","54239 - TORONTO BUTTONVILLE A","53678 - TORONTO BUTTONVILLE A","4841 - TORONTO BUTTONVILLE A","52705 - PA AJAX PAO TAU","5117 - TORONTO SUNNYBROOK","5098 - TORONTO LLOYDMINSTER","52704 - PA AJAX WINTERMERE SOD","52638 - PA ANGUS GLEN GOLF CLUB","5095 - TORONTO LEASIDE S","4928 - GORMLEY ARDENLEE","5063 - TORONTO BROADVIEW","5107 - TORONTO NEWTONBROOK","5049 - THORNHILL GRANDVIEW","5106 - TORONTO NEWTON","5105 - TORONTO NEW INT'L A","5123 - TORONTO WILLOWDALE","5076 - TORONTO GLENDALE","52737 - PA ATMOS CLAREMONT","5065 - TORONTO DEER PARK","5116 - TORONTO STUART AVENUE","5137 - UNIONVILLE"],null,null]}],"setView":[[43.5,-79.5],7,[]],"limits":{"lat":[43.67,43.95],"lng":[-79.43,-79.01]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

# Disclaimer

The package outlined in this document is published under the GNU General Public License, version 2 (GPL-2.0). The GPL is an open source, copyleft license that allows for the modification and redistribution of original works. This license is what makes it perfectly legal for me to build upon Simpson's work and modify it as I see fit. It is important to note, however, that programs licensed under the GPL come with NO WARRANTY. In our case, a simple R package isn't likely to blow up your computer or kill your cat. Nonetheless, it is always a good idea to pay attention to what you are doing, to ensure that you have downloaded the correct data, and that everything looks ship-shape. 

# What to do if something doesn't work

If you run into an issue while you are using the package, you can email me and I can help you troubleshoot the issue. However, if the issue is related to the package code and not your own fault, you should contribute back to the open source community by reporting the issue. If the issue is in one of the basic `canadaHCD` functions, report the issue on [GitHub](https://github.com/gavinsimpson/canadaHCD). If your issue is with one of my extended functions, report the issue to me here on [GitLab](https://gitlab.com/ConorIA/canadaHCDx).

If that seems like a lot of work, just think about how much work it would have been to do all the work this package does for you, or how much time went in to writing these functions!

# References
