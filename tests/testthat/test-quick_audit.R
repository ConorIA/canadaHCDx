library("testthat")
library("canadaHCDx")

context("Test `quick_audit()`")

## test quick audit by year
test_that("quick_audit() can audit by year", {
  skip_on_cran()
  df <- canadaHCD::hcd_daily("1707", 1989:1990)
  df2 <- quick_audit(df, variables = c("MaxTemp", "MinTemp", "MeanTemp"), by = "year")
  expect_that(df2, is_a("tbl_df"))
  expect_identical(nrow(df2), 2L)
  expect_identical(ncol(df2), 4L)
  expect_equal(df2$MaxTemp[2], 0.08219178)
})

## test quick audit by month
test_that("quick_audit() can audit by month", {
  skip_on_cran()
  df <- canadaHCD::hcd_daily("1707", 1989:1990)
  df2 <- quick_audit(df, variables = c("MaxTemp", "MinTemp", "MeanTemp"), by = "month")
  expect_that(df2, is_a("tbl_df"))
  expect_identical(nrow(df2), 24L)
  expect_identical(ncol(df2), 6L)
  expect_equal(df2$MinTemp[18], 1)
})

