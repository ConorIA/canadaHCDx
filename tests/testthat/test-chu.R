library("testthat")
library("canadaHCDx")
df <- hcd_daily(4656, 1981)

context("Test `chu()`")

## test CHU calculation
test_that("chu() can report CHUs", {
  out <- chu(df, report = "chu")
  expect_identical(names(out)[14], "CHU")
  expect_that(out, is_a("tbl_df"))
  expect_output(str(out), "365 obs")
  expect_output(str(out), "14 variables")
})

## test GDD calculation
test_that("chu() can report GDDs", {
  out <- chu(df, report = "gdd", tbase = 10)
  expect_identical(names(out)[14], "GDD")
  expect_that(out, is_a("tbl_df"))
  expect_output(str(out), "365 obs")
  expect_output(str(out), "14 variables")
})

## should fail if we don't pass it a data frame
test_that("chu() fails when passed a vector", {
  expect_error(chu(1:5, report = "foo"), "Input data must be a data frame.", fixed = TRUE)
})

## should fail when no correct report value requested
test_that("chu() fails when no correct report value is requested", {
  expect_error(chu(df, report = "foo"), "We can only calculate CHUs and GDDs. Please check your report argument.", fixed = TRUE)
})
