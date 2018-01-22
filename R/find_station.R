##' @title Find a Historical Climate Data station (advanced)
##'
##' @description Search for stations in the Historical Climate Data inventory name, available data, and/or distance to a target.
##'
##' @param name character; optional character string or a regular expression to be matched against known station names. See \code{\link{grep}} for details.
##' @param ignore.case logical; by default the search for station names is not case-sensitive.
##' @param glob logical; use wildcards in station name as detailed in \code{link{glob2rx}}.
##' @param province character; optional character string to filter by a given province. Use full name or two-letter code, e.g. ON for Ontario.
##' @param baseline vector; optional vector with a start and end year for a desired baseline.
##' @param type character; type of data to search for. Only used if a baseline is specified. Defaults to "hourly".
##' @param duplicates Boolean; if TRUE, will attempt to provide combinations of stations (at the same coordinates) that provide enough baseline data.
##' @param target numeric; optional numeric value of the target (reference) station, or a vector of length 2 containing latitude and longitude (in that order).
##' @param dist numeric; vector with a range of distance from the target in km. Only used if a target is specified. (default is 0:100)
##' @param sort Boolean; if TRUE (default), will sort the resultant table by distance from `target`. Only used if a target is specified.
##' @param assume_yes Boolean; whether we should assume yes before downloading index from Environment and Climate Change Canada.
##' @param ... Additional arguments passed to \code{\link{grep}}.
##'
##' @return A \code{tbl_df}, containing details of any matching HCD stations.
##'
##' @importFrom geosphere distGeo
##' @importFrom utils glob2rx
##'
##' @export
##'
##' @author Conor I. Anderson
##'
##' @examples
##' # Find all stations with names beginning in  "Reg".
##' find_station("Reg*", glob = TRUE)
##'
##' # Find stations named "Yellowknife", with hourly data available from 1971 to 2000.
##' find_station("Yellowknife", baseline = c(1971, 2000), type = "hourly")
##'
##' # Find all stations between 0 and 100 km from Station No. 5051.
##' find_station(target = 5051, dist = 0:100)
##'

find_station <- function(name = NULL, ignore.case = TRUE, glob = FALSE, province = NULL, baseline = NULL, type = "daily", duplicates = FALSE, target = NULL, dist = 0:100, sort = TRUE, assume_yes = FALSE, ...) {

  station_data <- try(get_station_data(assume_yes))
  if(inherits(station_data, "try-error")) {
    stop("We can't search without data to search through!")
  }
  
  
  # If `name` is not NULL, filter by name
  if (!is.null(name)) {
    if (glob) {
      name <- glob2rx(name)
    }
    take <- grep(name, station_data$Name, ignore.case = ignore.case, ...)
  } else {
    take <- 1:nrow(station_data)
  }

  # Next, set the data we are interested in, if necessary
  if (!is.null(baseline)) {
    if (length(baseline) < 2 | baseline[1] > baseline[length(baseline)]) stop("error: check baseline format")
    if (type == "hourly") data_vars <- c("HourlyFirstYr", "HourlyLastYr")
    if (type == "daily") data_vars <- c("DailyFirstYr", "DailyLastYr")
    if (type == "monthly") data_vars <- c("MonthlyFirstYr", "MonthlyLastYr")
  } else {
    data_vars <- NULL
  }

  # Make a table with the info we want
  vars_wanted <- c("Name", "Province", "StationID", "LatitudeDD", "LongitudeDD", data_vars)
  df <- station_data[take, vars_wanted]

  # If `province` is not NULL, we will filter by province
  if (!is.null(province)) {
    # Identify all stations outside of our baseline
    if (nchar(province) == 2L) {
      province <- levels(as.factor(station_data$Province))[which(c("AB", "BC", "MB", "NB", "NL", "NT", "NS", "NU", "ON", "PE", "QC", "SK", "YT") == province)]
      if (length(province) == 0L) {
        stop("Incorrect province code provided.")
      }
    }
    province <- toupper(province)
    df <- df[df$Province == province,]
    if (nrow(df) == 0) {
      stop("No data found for that province. Did you spell it correctly?")
    }
  }

  # If `target` is not NULL, filter by distance to target
  if (!is.null(target)) {
    if (length(target) == 1L) {
      p1 <- c(station_data$LongitudeDD[grep(paste0("\\b", as.character(target), "\\b"), station_data$StationID)], station_data$LatitudeDD[grep(paste0("\\b", as.character(target), "\\b"), station_data$StationID)])
    }
    else if (length(target) == 2L) {
      p1 <- c(target[2], target[1])
    } else stop("error: check target format")
    df$Dist <- rep(NA, nrow(df))
    for (j in 1:nrow(df)) {
      df$Dist[j] <- (distGeo(p1, c(df$LongitudeDD[j], df$LatitudeDD[j]))/1000)
    }
    df <- df[(!is.na(df$Dist) & (df$Dist >= min(dist)) & (df$Dist <= max(dist))),]
    if (sort == TRUE) df <- df[order(df$Dist),]
  }

  # If `baseline` is not NULL, filter by available data
  if (!is.null(baseline)) {
    index = NULL
    # Identify all stations outside of our baseline
    for (i in 1:nrow(df)) {
      if (is.na(df[i,6]) | df[i,6] > baseline[1]) index <- c(index, i)
      else if (is.na(df[i,7]) | df[i,7] < baseline[length(baseline)]) index <- c(index, i)
    }

    # Remind users that stations for which the ID has changed might not be detected
    if (duplicates == TRUE) {
      coords <- paste0(df$LatitudeDD, ", ", df$LongitudeDD)
      coords <- unique(coords[duplicated(coords)])
      printed <- NULL
      for (coord in coords) {
        dups <- df[paste0(df$LatitudeDD, ", ", df$LongitudeDD) == coord,]
        if (sort == TRUE) dups <- dups[order(dups$StationID),]
        if (!is.na(min(dups[6])) & min(dups[6]) <= baseline[1]  & !is.na(max(dups[7])) & max(dups[7] >= baseline[length(baseline)])) {
          if (is.null(printed)) {
            cat("Note: In addition to the stations found, the following combinations may provide sufficient baseline data.\n\n")
            printed <- 1
            combo <- 1
          }
          cat("## Combination", combo, "at coordinates", coord, "\n\n")
          cat(paste0(dups$StationID, ": ", dups$Name, "\n"), "\n", sep = "")
          combo <- combo + 1
        }
      }
    }

    # Delete those stations
    if (!is.null(index)) df <- df[-index,]
  }

  class(df) <- c("hcd_station_list", class(df))
  df
}
