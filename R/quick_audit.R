##' @title Perform a quick audit for missing values at a given station
##'
##' @description Returns a tibble with the proportion of missing values at a station for a given year and variables.
##'
##' @param datain A \code{tbl_df} containing the data to process
##' @param variables numeric or character; By default, all variables will be included. Pass a numeric vector to specify columns to include, or pass a character vector to try to match column names.
##' @param by character; whether values should be reported annually (\code{by = year}), or monthly (\code{by = month}). 
##' @param reverse Boolean; if true, will show proportion present instead of proportion missing.
##'
##' @importFrom tibble tibble add_column
##' @importFrom zoo as.yearmon
##'
##' @export
##'
##' @author Conor I. Anderson
##'
##' @examples
##'
##' \dontrun{
##' city <- hcd_daily(5051, 1981:2010)
##' quick_audit(city, "MaxTemp", by = "year", reverse = TRUE)
##' }
##'

quick_audit <- function(datain, variables, by = "year", reverse = FALSE) {
  
  dat <- datain
  
  if (missing(variables)) {
    variables <- 2:ncol(dat)
  } else {
    if (inherits(variables, "character")) {
      for (var in seq_along(variables)) {
        variables[var] <- as.numeric(grep(variables[var], names(dat), ignore.case = TRUE))
      }
    }
    variables <- as.numeric(variables)
  }
  
  if (reverse) {
    ctl = 1
  } else {
    ctl = 0
  }
  
  years <- min(format(dat$Date, format = "%Y")):max(format(dat$Date, format = "%Y"))
  
  if (by == "month") {
    months <- min(format(dat$Date, format = "%m")):max(format(dat$Date, format = "%m"))
    yearmons <- apply(expand.grid(sprintf("%02d", months), years), 1, function(x) paste(x[2], x[1], sep = "-"))
    
    out <- tibble(`Year-month` = yearmons)
    
    for (var in variables) {
      integrity <- NULL
      for (yearmon in yearmons) {
        colname <- colnames(dat)[var]
        yearmonly <- dat[format(dat$Date, format = "%Y-%m") == yearmon,]
        obs <- nrow(yearmonly)
        missing <- sum(is.na(yearmonly[[var]]))
        integrity <- c(integrity, abs(ctl-(missing/obs)))
      }
      out <- add_column(out, newcol = integrity)
      names(out)[which(names(out) == "newcol")] <- colname
    }
    out$`Year-month` <- as.yearmon(out$`Year-month`)
    out <- add_column(out, Year = format(out$`Year-month`, format = "%Y"), Month = format(out$`Year-month`, format = "%m"), .before = 1)
  } else {
    if (by == "year") {
      out <- tibble(Year = years)
      
      for (var in variables) {
        integrity <- NULL
        for (year in years) {
          colname <- colnames(dat)[var]
          yearly <- dat[format(dat$Date, format = "%Y") == year,]
          obs <- nrow(yearly)
          missing <- sum(is.na(yearly[[var]]))
          integrity <- c(integrity, abs(ctl-(missing/obs)))
        }
        out <- add_column(out, newcol = integrity)
        names(out)[which(names(out) == "newcol")] <- colname
      }
    } else {
      stop("You must choose by \"month\", or by \"year\".")
    }
  }
  
  return(out)
}
