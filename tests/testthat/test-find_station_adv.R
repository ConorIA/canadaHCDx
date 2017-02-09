library("testthat")
library("canadaHCDx")

context("Test `find_station_adv()`")

## test finding a station by name with regex
test_that("find_station_adv() can locate a station by name regex", {
  df <- find_station_adv("Yell*", glob = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "9 obs")
  expect_output(str(df), "5 variables")
})

## test finding a station by baseline
test_that("find_station_adv() can locate a station by baseline", {
  df <- find_station_adv(baseline = 1840:2015, duplicates = TRUE)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "1 obs")
  expect_output(str(df), "7 variables")
})

## test finding a station by province
test_that("find_station_adv() can locate a station by province", {
  df <- find_station_adv(province = "ON")
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "1624 obs")
  expect_output(str(df), "5 variables")
})

## test finding a station by distance from target
test_that("find_station_adv() can locate a station by distance from target", {
  df <- find_station_adv(target = 5051, dist = 0:10)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "41 obs")
  expect_output(str(df), "6 variables")
})

## test finding a station by distance from coordinates
test_that("find_station_adv() can locate a station by distance for coordinates", {
  df <- find_station_adv(target = c(43.7860, -79.1873), dist = 0:5)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "8 obs")
  expect_output(str(df), "6 variables")
})

## find_station_adv should fail if we spell the province incorrectly
test_that("find_station_adv() can locate a station by distance for coordinates", {
  expect_error(find_station_adv(province = "Qwebek"), "No data found for that province. Did you spell it correctly?", fixed=TRUE)
})

## find_station_adv should fail if we use a bad province code
test_that("find_station_adv() can locate a station by distance for coordinates", {
  expect_error(find_station_adv(province = "NO"), "Incorrect province code provided.", fixed=TRUE)
})
