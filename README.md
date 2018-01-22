# canadaHCDx: An expansion to provide additional functions for the [`canadaHCD`](https://github.com/gavinsimpson/canadaHCD) package


[![build status](https://gitlab.com/ConorIA/canadaHCDx/badges/master/build.svg)](https://gitlab.com/ConorIA/canadaHCDx/pipelines) [![Build status](https://ci.appveyor.com/api/projects/status/meb87c4uik14wcyj?svg=true)](https://ci.appveyor.com/project/ConorIA/canadahcdx) [![codecov](https://codecov.io/gl/ConorIA/canadaHCDx/branch/master/graph/badge.svg)](https://codecov.io/gl/ConorIA/canadaHCDx)


Environment and Climate Change Canada (ECCC) provides archival climate data for a [wealth of climate stations](ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv) across the country. This data is available for download on the ECCC [data portal](http://climate.weather.gc.ca/). This website is useful for browsing data, and is convenient for downloading short periods of data. However, if you are seeking a 30-year baseline, the manual download of the necessary data can become very tedious. In that regard, ECCC also provides a bulk download function to make acquiring that data a little bit easier. While the process is much simpler than it has been in the past, one still must put in a little leg work to: 

1) Identify the station of interest
2) Find the correct data set
3) Download the relevant data files
4) Process the files into workable data sets

To overcome these limitations, Gavin L. Simpson has written a package for R, which performs the above processes with minimal user input. The [`canadaHCD`](https://github.com/gavinsimpson/canadaHCD) package is a very useful tool, however, I noticed that there were a couple of features missing that I needed for my personal workflow. This repository provides a small expansion for the `canadaHCD` package. It adds additional search options. In this README, I will strive to outline the basic functionality of both the original package and my expansion.

# Installing

Most R packages are installed from the Comprehensive R Archive Network (CRAN). `canadaHCD`, however, remains under development and is not hosted on the CRAN. Its source code is freely available on [GitHub](https://github.com/), so we can harness the wonderful `remotes` package to install it. You may also require the "`git2r`" package to access the git repository. 

For you convenience, I have written a quick script that will install `remotes`, `git2r`, `canadaHCD`, `canadaHCDx`, and all dependencies. If you would rather install these components individually, take a look at the script to see which commands to run. 

```r
source("https://gitlab.com/ConorIA/canadaHCDx/raw/master/install_canadaHCDx.R")
```
_Note that the above script can also be used to keep `remotes`, `canadaHCD` and `canadaHCDx` up to date._

Once the packages have installed, load `canadaHCDx` by:

```r
library(canadaHCDx) #canadaHCDx will load canadaHCD automatically
```

# Basic functions

Simpson (2016) has already outlined the basic functions of this package in great detail on the [README](https://github.com/gavinsimpson/canadaHCD/blob/master/README.md) for his GitHub repository. However, I will include a basic overview of the functions in this README.

## Station search

To search for a station by name, use the `find_station()` function. For instance, to search for a station with the word 'Toronto' in the station name, use the following code:


```r
find_station("Toronto")
```

```
## # A tibble: 93 x 5
##    Name                                    Province StationID Latit… Long…
##    <chr>                                   <chr>        <int>  <dbl> <dbl>
##  1 PA TORONTO INTERNATIONAL TRAP AND SKEET ONTARIO      52731   44.2 -79.7
##  2 PA TORONTO NORTH YORK MOTORS            ONTARIO      52678   43.7 -79.5
##  3 PA SCARBOROUGH TORONTO HUNT             ONTARIO      52641   43.7 -79.3
##  4 PA TORONTO HYUNDAI                      ONTARIO      52640   43.7 -79.4
##  5 TORONTO                                 ONTARIO       5051   43.7 -79.4
##  6 TORONTO CITY                            ONTARIO      31688   43.7 -79.4
##  7 TORONTO CITY CENTRE                     ONTARIO      48549   43.6 -79.4
##  8 TORONTO AGINCOURT                       ONTARIO       5052   43.8 -79.3
##  9 TORONTO ASHBRIDGES BAY                  ONTARIO       5053   43.7 -79.3
## 10 TORONTO BALMY BEACH                     ONTARIO       5054   43.7 -79.3
## # ... with 83 more rows
```

Note that the `tibble` object (a special sort of `data.frame`) won't print more than the first 10 rows by default. To see all of the results, you can wrap the command in `View()` so that it becomes `View(find_station("Toronto"))`.

Note that you can also use wildcards as supported by the `glob2rx()` from the `utils` package by passing the argument `glob = TRUE`, as in the following example.


```r
find_station("Tor*", glob = TRUE)
```

```
## # A tibble: 94 x 5
##    Name                   Province     StationID LatitudeDD LongitudeDD
##    <chr>                  <chr>            <int>      <dbl>       <dbl>
##  1 TORRENS LO             ALBERTA           2440       54.3      -120  
##  2 TORQUAY                SASKATCHEWAN      3034       49.1      -104  
##  3 TORONTO                ONTARIO           5051       43.7      - 79.4
##  4 TORONTO CITY           ONTARIO          31688       43.7      - 79.4
##  5 TORONTO CITY CENTRE    ONTARIO          48549       43.6      - 79.4
##  6 TORONTO AGINCOURT      ONTARIO           5052       43.8      - 79.3
##  7 TORONTO ASHBRIDGES BAY ONTARIO           5053       43.7      - 79.3
##  8 TORONTO BALMY BEACH    ONTARIO           5054       43.7      - 79.3
##  9 TORONTO BEACON ROAD    ONTARIO           5055       43.8      - 79.3
## 10 TORONTO BERMONDSEY     ONTARIO           5056       43.7      - 79.3
## # ... with 84 more rows
```

## Download data

Once you have found your station of interest, you can download hourly, daily and monthly data using the `hcd_hourly()`, `hcd_daily()`, and `hcd_monthly()` functions, respectively. Look at the documentation for each function by typing a question mark, followed by the function name, or using the `help()` function. For instance, to find out what arguments the `hcd_daily()` function takes, type `?hcd_daily` or `help(hcd_daily)`.

If I wanted to download daily data for Toronto City (station no. 5051) from 1971 to 2000, I could use: 


```r
city <- hcd_daily(5051, 1971:2000)
```

```r
city
```

```
## # A tibble: 10,958 x 13
##    Stati… Date       MaxTemp MinTemp MeanTe… Heat… Cool… Tota… Tota… Tota…
##     <int> <date>       <dbl>   <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1   5051 1971-01-01  -0.600 -10.0    - 5.30  23.3     0 0     0     0.300
##  2   5051 1971-01-02   3.30  - 8.90   - 2.80  20.8     0 0     0     0    
##  3   5051 1971-01-03   2.20    0        1.10  16.9     0 0.800 2.80  5.60 
##  4   5051 1971-01-04   6.70  - 0.600    3.10  14.9     0 5.30  0     5.30 
##  5   5051 1971-01-05  -0.600 - 3.30   - 2.00  20.0     0 0     0     0    
##  6   5051 1971-01-06  -4.40  - 8.90   - 6.70  24.7     0 0     0     0    
##  7   5051 1971-01-07  -5.60  -11.7    - 8.70  26.7     0 0     0     0    
##  8   5051 1971-01-08  -6.10  -13.9    -10.0   28.0     0 0     2.30  2.30 
##  9   5051 1971-01-09  -1.10  - 8.30   - 4.70  22.7     0 0     0.300 0.300
## 10   5051 1971-01-10   0.600 - 5.60   - 2.50  20.5     0 0     0     0    
## # ... with 10,948 more rows, and 3 more variables: GroundSnow <int>,
## #   MaxGustDir <int>, MaxGustSpeed <chr>
```


Make sure to use the assignment operator (`<-`) to save the data into an R object, otherwise the data will just print out to the console, and won't get saved anywhere in the memory. 

# Extra functions in the expansion pack

Users of the `canadaHCD` package can largely avoid using the Environment and Climate Change Canada website to acquire climate data, however, there were a few search features on the ECCC website that weren't available in the installed package. 

## Caching and maintaining a list of stations

This package will download the official Environment and Climate Change Canada [station inventory table](ftp://ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/). This means that changes to station codes or the like won't leave you scratching your head. The inventory in the main `canadaHCD` package, on the other hand, hasn't been updated in some time.

## Advanced search

This packages masks `find_station()` from `canadaHCD` with a version that includes the ability to search for stations by name (as per the original), but adds filters to search by province, by a given baseline period, and by proximity to another station or a vector of coordinates. You can use any combination of these four filters in your search. There are a few mandatory arguments for each filter. For instance, if you are searching for a certain baseline period, you must also include the type of data you are looking for (hourly, daily, or monthly; defaults to daily). The function is fully documented, so take a look at `?find_station`. Let's look at some examples.

### Find all stations in the province of Ontario

```r
find_station(province = "ON")
```

```
## # A tibble: 1,626 x 5
##    Name                  Province StationID LatitudeDD LongitudeDD
##    <chr>                 <chr>        <int>      <dbl>       <dbl>
##  1 ATTAWAPISKAT          ONTARIO       3913       52.9       -82.4
##  2 ATTAWAPISKAT A        ONTARIO      52918       52.9       -82.4
##  3 BIG TROUT LAKE A      ONTARIO      49488       53.8       -89.9
##  4 BIG TROUT LAKE        ONTARIO       3914       53.8       -89.9
##  5 BIG TROUT LAKE READAC ONTARIO      10804       53.8       -89.9
##  6 BIG TROUT LAKE        ONTARIO      50857       53.8       -89.9
##  7 CENTRAL PATRICIA      ONTARIO       3915       51.5       -90.2
##  8 DONA LAKE             ONTARIO       3916       51.4       -90.1
##  9 EAR FALLS             ONTARIO       3917       50.6       -93.2
## 10 EAR FALLS (AUT)       ONTARIO      27865       50.6       -93.2
## # ... with 1,616 more rows
```
### Find stations named "Toronto", with hourly data available from 1971 to 2000

```r
find_station("Toronto", baseline = 1971:2000, type = "hourly")
```

```
## # A tibble: 2 x 7
##   Name                              Province Stat… Lati… Long… Hour… Hour…
##   <chr>                             <chr>    <int> <dbl> <dbl> <int> <int>
## 1 TORONTO ISLAND A                  ONTARIO   5085  43.6 -79.4  1957  2006
## 2 TORONTO LESTER B. PEARSON INT'L A ONTARIO   5097  43.7 -79.6  1953  2013
```
### Find all stations between 0 and 100 km from Station No. 5051

```r
find_station(target = 5051, dist = 0:100)
```

```
## # A tibble: 506 x 6
##    Name                           Province StationID Latitu… Longit…  Dist
##    <chr>                          <chr>        <int>   <dbl>   <dbl> <dbl>
##  1 TORONTO                        ONTARIO       5051    43.7   -79.4  0   
##  2 TORONTO CITY                   ONTARIO      31688    43.7   -79.4  0   
##  3 TORONTO DEER PARK              ONTARIO       5065    43.7   -79.4  1.96
##  4 PA MATTAMY ATHLETIC CENTRE     ONTARIO      52723    43.7   -79.4  1.96
##  5 TORONTO SHERBOURNE             ONTARIO       5089    43.6   -79.4  3.29
##  6 PA DUFFERIN AND ST. CLAIR CIBC ONTARIO      53838    43.7   -79.4  3.41
##  7 TORONTO BROADVIEW              ONTARIO       5063    43.7   -79.4  4.03
##  8 TORONTO LEASIDE S              ONTARIO       5095    43.7   -79.4  4.12
##  9 TORONTO NORTHCLIFFE            ONTARIO       5108    43.7   -79.4  4.18
## 10 TORONTO CITY CENTRE            ONTARIO      48549    43.6   -79.4  4.44
## # ... with 496 more rows
```
### Find all stations that are within 5 km of UTSC campus

```r
find_station(target = c(43.7860, -79.1873), dist = 0:5)
```

```
## # A tibble: 8 x 6
##   Name                                Province StationID Lati… Long…  Dist
##   <chr>                               <chr>        <int> <dbl> <dbl> <dbl>
## 1 PA U OF T SCARBOROUGH TENNIS CENTRE ONTARIO      52724  43.8 -79.2 0.701
## 2 TOR SCARBOROUGH COLLEGE             ONTARIO       5091  43.8 -79.2 0.889
## 3 TORONTO HIGHLAND CREEK              ONTARIO       5080  43.8 -79.2 1.54 
## 4 TORONTO WEST HILL                   ONTARIO       5120  43.8 -79.2 2.26 
## 5 TORONTO MALVERN                     ONTARIO       5099  43.8 -79.2 3.77 
## 6 TORONTO METRO ZOO                   ONTARIO       5102  43.8 -79.2 3.82 
## 7 TORONTO CURRAN HALL                 ONTARIO       5064  43.8 -79.2 4.13 
## 8 ROUGE HILLS                         ONTARIO       5024  43.8 -79.1 4.87
```

### Identify stations that have changed name and ID

There have been a number of cases where the same station has changed name and ID over its history. In this case, filtering by baseline might exclude these stations. If you would like the `find_station_adv()` function to try to identify these cases, pass `duplicates = TRUE` to the function. The function will report any combination for which the coordinates are the same, and which, together, provide sufficient baseline data. 


```r
find_station(baseline = 1981:2010, target = 5051, dist = 0:10, duplicates = TRUE)
```

```
## Note: In addition to the stations found, the following combinations may provide sufficient baseline data.
## 
## ## Combination 1 at coordinates 43.67, -79.4 
## 
## 5051: TORONTO
## 31688: TORONTO CITY
## 
## ## Combination 2 at coordinates 43.63, -79.4 
## 
## 5085: TORONTO ISLAND A
## 5086: TORONTO IS A (AUT)
## 30247: TORONTO CITY CENTRE
## 48549: TORONTO CITY CENTRE
```

```
## # A tibble: 1 x 8
##   Name    Province StationID LatitudeDD LongitudeDD DailyFi… DailyL…  Dist
##   <chr>   <chr>        <int>      <dbl>       <dbl>    <int>   <int> <dbl>
## 1 TORONTO ONTARIO       5051       43.7       -79.4     1840    2017     0
```

## Map function

Sometimes a long list of stations is hard to visualize spatially. To overcome this, I added a third function, which takes a list of stations and shows them on a map powered by the [Leaflet](http://leafletjs.com/) library. The map function is even smart enough to take a search as its list of stations as per the example below. Unfortuntely, this does not render properly on GitLab.

### Show a map of all stations that are between 10 and 20 km of UTSC campus

```r
map_stations(find_station(target = c(43.7860, -79.1873), dist = 10:20), zoom = 6)
```

## Quick audit

The `quick_audit()` function will return a tibble listing the percentage or number of missing values for a station. For now, it has only been tested with daily data. The following code will return the percentage of missing values at Yellowknife Hydro:


```r
yh <- hcd_daily(1707, 1981:2010)
```

```r
quick_audit(yh, c("MaxTemp", "MinTemp", "MeanTemp"))
```

```
## # A tibble: 30 x 4
##     Year `MaxTemp pct NA` `MinTemp pct NA` `MeanTemp pct NA`
##    <int>            <dbl>            <dbl>             <dbl>
##  1  1981             8.22             8.22              8.22
##  2  1982             8.49             8.49              8.49
##  3  1983             0                0                 0   
##  4  1984             0                0                 0   
##  5  1985            33.7             33.7              33.7 
##  6  1986            33.2             33.2              33.2 
##  7  1987             8.49             8.49              8.49
##  8  1988            50.3             50.3              50.3 
##  9  1989           100              100               100   
## 10  1990             8.22             8.22              8.22
## # ... with 20 more rows
```

Use `report = "n"` to show the _number_ of missing values. Use `by = "month"` to show missing data by month instead of year. To show the number of missing values at Toronto Pearson Airport in 1993:


```r
pears <- hcd_daily(5097, 1993)
```

```r
quick_audit(pears, "MeanTemp", by = "month", report = "n")
```

```
## # A tibble: 12 x 5
##    Year  Month `Year-month`  `MeanTemp consec NA` `MeanTemp tot NA`
##    <chr> <chr> <S3: yearmon>                <int>             <int>
##  1 1993  01    Jan 1993                         1                 2
##  2 1993  02    Feb 1993                         1                 2
##  3 1993  03    Mar 1993                         1                 4
##  4 1993  04    Apr 1993                         2                 7
##  5 1993  05    May 1993                         1                 2
##  6 1993  06    Jun 1993                         1                 2
##  7 1993  07    Jul 1993                         1                 1
##  8 1993  08    Aug 1993                         1                 1
##  9 1993  09    Sep 1993                         4                10
## 10 1993  10    Oct 1993                         2                10
## 11 1993  11    Nov 1993                         3                 9
## 12 1993  12    Dec 1993                         2                 5
```

# Disclaimer

The package outlined in this document is published under the GNU General Public License, version 3 (GPL-3.0). The GPL is an open source, copyleft license that allows for the modification and redistribution of original works. This license is what makes it perfectly legal for me to build upon Simpson's work and modify it as I see fit. It is important to note, however, that programs licensed under the GPL come with NO WARRANTY. In our case, a simple R package isn't likely to blow up your computer or kill your cat. Nonetheless, it is always a good idea to pay attention to what you are doing, to ensure that you have downloaded the correct data, and that everything looks ship-shape. 

# What to do if something doesn't work

If you run into an issue while you are using the package, you can email me and I can help you troubleshoot the issue. However, if the issue is related to the package code and not your own fault, you should contribute back to the open source community by reporting the issue. If the issue is in one of the basic `canadaHCD` functions, report the issue on [GitHub](https://github.com/gavinsimpson/canadaHCD). If your issue is with one of my extended functions, report the issue to me here on [GitLab](https://gitlab.com/ConorIA/canadaHCDx).

If that seems like a lot of work, just think about how much work it would have been to do all the work this package does for you, or how much time went in to writing these functions!
