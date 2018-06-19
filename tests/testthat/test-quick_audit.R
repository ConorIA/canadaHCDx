library("testthat")
library("canadaHCDx")
indat <- canadaHCD::hcd_daily("1707", 1989:1990)

context("Test `quick_audit()`")

## test quick audit by year and return percent missing values
test_that("quick_audit() can audit by year", {
  df <- quick_audit(indat, variables = c("MaxTemp", "MinTemp", "MeanTemp"), by = "year")
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "2 obs")
  expect_output(str(df), "4 variables")
  expect_equal(df$`MaxTemp pct NA`[2], 8.219178)
})

## test quick audit by month and return number of missing values
test_that("quick_audit() can audit by month", {
  df <- quick_audit(indat, variables = c("MaxTemp", "MinTemp", "MeanTemp"), by = "month", report = "n")
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "24 obs")
  expect_output(str(df), "9 variables")
  expect_equal(df$`MinTemp tot NA`[18], 30)
})

## test quick_audit with missing variables and in reverse
test_that("quick_audit() can audit with missing variables", {
  df <- quick_audit(indat, reverse = TRUE)
  expect_that(df, is_a("tbl_df"))
  expect_output(str(df), "2 obs")
  expect_output(str(df), "13 variables")
  expect_lt(df$`MeanTemp pct present`[2], 100)
})

## test quick_audit warns if "year" or "month" not set correctly
test_that("quick_audit() will fail if `by` is a typo", {
  expect_warning(quick_audit(indat, by = "mnoth"), "By was neither \"month\" nor \"year\". Defaulting to year.", fixed = TRUE)
})
