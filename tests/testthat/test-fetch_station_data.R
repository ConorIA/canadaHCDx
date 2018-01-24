library("testthat")
library("canadaHCDx")
library("storr")

context("Test `get_station_data()`")

cache_dir <- rappdirs::user_cache_dir("canadaHCDx")
st <- storr::storr_rds(cache_dir)
st$clear()

## test download of a new data set
test_that("fetch_station_data() can download station data", {
  canadaHCDx:::get_station_data(TRUE)
})

st$set("last_mod",  "2018-01-01 00:00:00 EST")

## test GDD calculation
test_that("fetch_station_data() detects outdated station data", {
  canadaHCDx:::get_station_data(TRUE)
})