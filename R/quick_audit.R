#' @title Perform a quick audit for missing values at a given station
#'
#' @description Returns a tibble with the percentage or number of missing values at a station for a given year or year-month and variables.
#'
#' @param datain A \code{tbl_df} containing the data to process
#' @param variables numeric or character; by default, all variables will be included. Pass a numeric vector to specify columns to include, or pass a character vector to try to match column names.
#' @param by character; whether values should be reported annually (\code{by = "year"}), or monthly (\code{by = "month"})
#' @param report character; whether values should be reported as percentage missing (\code{report = "pct"}) or as number of missing values (\code{report = "n"})
#' @param reverse Boolean; if \code{TRUE}, will show percentage present instead of percentage missing (only applies if \code{report = "pct"})
#'
#' @importFrom tibble tibble add_column
#' @importFrom zoo as.yearmon
#'
#' @export
#'
#' @author Conor I. Anderson
#'
#' @examples
#' city <- hcd_daily(5051, 1981:2010)
#' quick_audit(city, "MaxTemp", by = "year", reverse = TRUE)
#' quick_audit(city, "MaxTemp", by = "month", report = "n")

quick_audit <- function(datain, variables, by = "year", report = "pct", reverse = FALSE) {

  dat <- datain

  if (by != "month" && by != "year") {
    warning("By was neither \"month\" nor \"year\". Defaulting to year.")
  }

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
    ctl <- 1
    metric <- "present"
  } else {
    ctl <- 0
    metric <- "NA"
  }

  years <- min(format(dat$Date, format = "%Y")):max(format(dat$Date, format = "%Y"))

  if (by == "month") {
    months <- min(format(dat$Date, format = "%m")):max(format(dat$Date, format = "%m"))
    yearmons <- apply(expand.grid(sprintf("%02d", months), years), 1,
                      function(x) paste(x[2], x[1], sep = "-"))
    out <- tibble(`Year-month` = yearmons)
    timestep <- yearmons
  } else {
    out <- tibble(Year = years)
    timestep <- years
  }

    for (var in variables) {
      integrity <- missingvec <- consecNAvec <- NULL
      for (t in timestep) {
        colname <- colnames(dat)[var]
        if (by == "month") {
          timely <- dat[format(dat$Date, format = "%Y-%m") == t, ]
        } else {
          timely <- dat[format(dat$Date, format = "%Y") == t, ]
        }
        obs <- nrow(timely)
        missing <- sum(is.na(timely[[var]]))
        if (report == "pct") {
          integrity <- c(integrity, as.numeric(abs(ctl - (missing / obs)) * 100))
        } else {
          missingvec <- c(missingvec, as.integer(missing))
          consecNA <- rle(is.na(timely[[var]]))
          consecNA <- max(consecNA$lengths[consecNA$values], 0)
          consecNAvec <- c(consecNAvec, as.integer(consecNA))
        }
      }
      if (report == "pct") {
        out <- add_column(out, integ = integrity)
        names(out)[which(names(out) == "integ")] <- paste(colname, "pct", metric)
      } else {
        out <- add_column(out, consec = consecNAvec, rand = missingvec)
        names(out)[which(names(out) == "consec")] <- paste(colname, "consec NA")
        names(out)[which(names(out) == "rand")] <- paste(colname, "tot NA")
      }

    }
    if (by == "month") {
      out$`Year-month` <- as.yearmon(out$`Year-month`)
      out <- add_column(out, Year = format(out$`Year-month`, format = "%Y"),
                        Month = format(out$`Year-month`, format = "%m"),
                        .before = 1)
    }

  return(out)
}
