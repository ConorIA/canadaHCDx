library("testthat")
library("canadaHCDx")
df <- find_station("Yellowknife")

context("Test `map_stations()`")

## test a map of one station
test_that("map_stations() can map a single station", {
  map <- map_stations(5051)
  expect_that(map, is_a("leaflet"))
  expect_that(map, is_a("htmlwidget"))
})

## test a map of one searched stations
test_that("map_stations() can map a station search result", {
  map <- map_stations(df)
  expect_that(map, is_a("leaflet"))
  expect_that(map, is_a("htmlwidget"))
})
