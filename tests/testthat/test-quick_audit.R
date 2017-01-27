library("testthat")
library("canadaHCDx")
indat <- canadaHCD::hcd_daily("1707", 1989:1990)

context("Test `quick_audit()`")

## test quick audit by year
test_that("quick_audit() can audit by year", {
  df <- quick_audit(indat, variables = c("MaxTemp", "MinTemp", "MeanTemp"), by = "year")
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "2 obs")
  expect_output(str(df), "4 variables")
  expect_equal(df$MaxTemp[2], 0.08219178)
})

## test quick audit by month
test_that("quick_audit() can audit by month", {
  df <- quick_audit(indat, variables = c("MaxTemp", "MinTemp", "MeanTemp"), by = "month")
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "24 obs")
  expect_output(str(df), "6 variables")
  expect_equal(df$MinTemp[18], 1)
})

## test quick_audit with missing variables and in reverse
test_that("quick_audit() can audit with missing variables", {
  df <- quick_audit(indat, reverse = TRUE)
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "2 obs")
  expect_output(str(df), "13 variables")
  expect_lt(df$MeanTemp[2], 1)
})

## test quick_audit fails if "year" or "month" not set correctly
test_that("quick_audit() will fail if `by` is a typo", {
  expect_error(quick_audit(indat, by = "mnoth"), "You must choose by \"month\", or by \"year\".", fixed=TRUE)
})
