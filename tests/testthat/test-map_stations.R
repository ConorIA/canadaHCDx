library("testthat")
library("canadaHCDx")
df <- find_station("Yellowknife")

context("Test `map_stations()`")

## test a map of one station
test_that("map_stations() can map a single station", {
  map_stations(5051)
})

## test a map of one searched stations
test_that("map_stations() can map a station search result", {
  map_stations(df)
})

