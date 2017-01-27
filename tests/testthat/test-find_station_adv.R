library("testthat")
library("canadaHCDx")

context("Test `find_station_adv()`")

## test finding a station by name
test_that("find_station_adv() can locate a station by name", {
  df <- find_station_adv("Yellowknife")
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_that(df, is_a("data.frame"))
  expect_equal(nrow(df), 6L)
})

## test finding a station by baseline
test_that("find_station_adv() can locate a station by baseline", {
  df <- find_station_adv(baseline = 1840:2015)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_that(df, is_a("data.frame"))
  expect_equal(nrow(df), 1L)
})

## test finding a station by province
test_that("find_station_adv() can locate a station by province", {
  df <- find_station_adv(province = "ON")
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_that(df, is_a("data.frame"))
  expect_equal(nrow(df), 1624L)
})

## test finding a station by distance
test_that("find_station_adv() can locate a station by distance", {
  df <- find_station_adv(target = 5051, dist = 0:10)
  expect_that(df, is_a("hcd_station_list"))
  expect_that(df, is_a("tbl_df"))
  expect_that(df, is_a("data.frame"))
  expect_equal(nrow(df), 41L)
})
