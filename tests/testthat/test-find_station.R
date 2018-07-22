library("testthat")
library("canadaHCDx")

context("Test `find_station()`")

## test finding a station by name with regex
test_that("find_station() can locate a station by name regex", {
  df <- find_station("Yell*", glob = TRUE, assume_yes = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "8 obs")
  expect_output(str(df), "7 variables")
})

## test finding a station by baseline
test_that("find_station() can locate a station by baseline", {
  df <- find_station(baseline = 1840:2015, duplicates = TRUE, assume_yes = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "1 obs")
  expect_output(str(df), "7 variables")
})

## test finding a station by province
test_that("find_station() can locate a station by province", {
  df <- find_station(province = "ON", assume_yes = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "16[0-9]{2} obs")
  expect_output(str(df), "7 variables")
})

## test finding a station by distance from target
test_that("find_station() can locate a station by distance from target", {
  df <- find_station(target = 5051, dist = 0:10, assume_yes = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "42 obs")
  expect_output(str(df), "8 variables")
})

## test finding a station by distance from coordinates
test_that("find_station() can locate a station by distance for coordinates", {
  df <- find_station(target = c(43.7860, -79.1873), dist = 0:5, assume_yes = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "8 obs")
  expect_output(str(df), "8 variables")
})

## find_station should fail if we spell the province incorrectly
test_that("find_station() fails if provice is incorrect", {
  expect_error(find_station(province = "Qwebek", assume_yes = TRUE), "One or more province name(s) incorrect.", fixed = TRUE)
})

## find_station should fail if we use a bad province code
test_that("find_station() fails if provice code is incorrect", {
  expect_error(find_station(province = "NO", assume_yes = TRUE), "Incorrect province code(s) provided.", fixed = TRUE)
})
