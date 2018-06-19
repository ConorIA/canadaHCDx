if (getRversion() >= "2.15.1") utils::globalVariables(c("."))

# Reexport canadaHCD functions
#' @importFrom canadaHCD hcd_daily
#' @export
canadaHCD::hcd_daily
#' @importFrom canadaHCD hcd_download
#' @export
canadaHCD::hcd_download
#' @importFrom canadaHCD hcd_hourly
#' @export
canadaHCD::hcd_hourly
#' @importFrom canadaHCD hcd_monthly
#' @export
canadaHCD::hcd_monthly
#' @importFrom canadaHCD hcd_url
#' @export
canadaHCD::hcd_url
#' @importFrom canadaHCD read_hcd
#' @export
canadaHCD::read_hcd
