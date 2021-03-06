#' @title Find a Historical Climate Data station (advanced)
#'
#' @description Search for stations in the Historical Climate Data inventory name, available data, and/or distance to a target.
#'
#' @param name character; optional character vector or a regular expression to be matched against known station names. See \code{\link{grep}} for details.
#' @param ignore.case logical; by default the search for station names is not case-sensitive.
#' @param glob logical; use wildcards in station name as detailed in \code{link{glob2rx}}.
#' @param province character; optional character string to filter by a given province. Use full name or two-letter code, e.g. ON for Ontario.
#' @param baseline vector; optional vector with a start and end year for a desired baseline.
#' @param type character; period columns to return. \code{NULL} (default) returns hourly, daily, and monthly.
#' @param duplicates Boolean; if TRUE, will attempt to provide combinations of stations (at the same coordinates) that provide enough baseline data.
#' @param target numeric; optional numeric value of the target (reference) station, or a vector of length 2 containing latitude and longitude (in that order).
#' @param dist numeric; vector with a range of distance from the target in km. Only used if a target is specified. (default is 0:100)
#' @param sort Boolean; if TRUE (default), will sort the resultant table by distance from `target`. Only used if a target is specified.
#' @param assume_yes Boolean; whether we should assume yes before downloading index from Environment and Climate Change Canada.
#' @param ... Additional arguments passed to \code{\link{grep}}.
#'
#' @return A \code{tbl_df}, containing details of any matching HCD stations.
#'
#' @importFrom dplyr "%>%" all_vars arrange filter filter_at group_by matches mutate rowwise select tally vars
#' @importFrom geosphere distGeo
#' @importFrom rlang .data
#' @importFrom utils glob2rx
#'
#' @export
#'
#' @author Conor I. Anderson
#'
#' @examples
#' # Find all stations with names beginning in  "Reg".
#' find_station("Reg*", glob = TRUE)
#'
#' # Find stations named "Yellowknife", with hourly data available from 1971 to 2000.
#' find_station("Yellowknife", baseline = c(1971, 2000), type = "hourly")
#'
#' # Find all stations between 0 and 100 km from Station No. 5051.
#' find_station(target = 5051, dist = 0:100)

find_station <- function(name = NULL, ignore.case = TRUE, glob = FALSE,
                         province = NULL, baseline = NULL, type = "daily",
                         duplicates = FALSE, target = NULL, dist = 0:100,
                         sort = TRUE, assume_yes = FALSE, ...) {

  filt <- get_station_data(assume_yes, quiet = TRUE)
  
  # These seem to be erroneous coords for 20 stations
  filt$LatitudeDD[filt$LatitudeDD == 40] <- NA
  filt$LongitudeDD[filt$LongitudeDD == -50] <- NA
  
  # If `name` is not NULL, filter by name
  if (!is.null(name)) {
    if (glob) name <- glob2rx(name)
    if (length(name) > 1) name <- paste(name, collapse = "|")
    filt <- filter(filt, grepl(name, .data$Name,
                               ignore.case = ignore.case, ...))
  }
  
  # If `province` is not NULL, we will filter by province
  if (!is.null(province)) {
    p_codes <- c("AB", "BC", "MB", "NB", "NL", "NT", "NS", "NU", "ON", "PE",
                 "QC", "SK", "YT")
    # Identify all stations outside of our baseline
    if (all(nchar(province) == 2L)) {
      if (!all(province %in% p_codes)) stop("Incorrect province code(s) provided.")
      province <- levels(as.factor(filt$Province))[which(p_codes %in% toupper(province))]
    }
    if (!all(province %in% filt$Province)) stop("One or more province name(s) incorrect.")
    filt <- filter(filt, toupper(.data$Province) %in% toupper(province))
    if (nrow(filt) == 0) {
      stop("No data found for that province. Did you spell it correctly?")
    }
  }
  
  # Next, set the data we are interested in, if necessary
  if (!is.null(baseline)) {
    if (baseline[1] > baseline[length(baseline)]) stop("Baseline not chronological.")
    if (is.null(type)) {
      warning("We need to know the data type. Baseline ignored.")
      baseline <- NULL
    }
  }
  
  if (!is.null(type)) {
    if (any(!type %in% c("hourly", "daily", "monthly"))) {
      warning("One of more types invalid. Omitting.")
      type <- type[type %in% c("hourly", "daily", "monthly")]
    }
    if (!is.null(baseline) & length(type) > 1) {
      warning("We can only filter by one type at a time. Baseline ignored.")
      baseline <- NULL
    }
    data_vars <- NULL
    if ("hourly" %in% type) data_vars <- c(data_vars, "HourlyFirstYr", "HourlyLastYr")
    if ("daily" %in% type) data_vars <- c(data_vars, "DailyFirstYr", "DailyLastYr")
    if ("monthly" %in% type) data_vars <- c(data_vars, "MonthlyFirstYr", "MonthlyLastYr")
  } else {
    data_vars <- c("HourlyFirstYr", "HourlyLastYr", "DailyFirstYr", "DailyLastYr", "MonthlyFirstYr", "MonthlyLastYr")
  }

  
  # Make a table with the info we want
  vars_wanted <- c("Name", "Province", "StationID", "LatitudeDD", "LongitudeDD", data_vars)
  filt <- select(filt, vars_wanted)
  
  # If `target` is not NULL, filter by distance to target
  if (!is.null(target)) {
    p1 <- switch(length(target),
                 unlist(select(filter(filt, .data$StationID == target), .data$LongitudeDD, .data$LatitudeDD)),
                 c(target[2], target[1]))
    if (length(p1) == 0) stop("No appropriate coordinates found. Check your target.")
    filt <- rowwise(filt) %>%
      mutate(Dist = distGeo(p1, c(.data$LongitudeDD, .data$LatitudeDD)) / 1000) %>%
      filter(.data$Dist >= min(dist) & .data$Dist <= max(dist))
    if (sort == TRUE) filt <- arrange(filt, .data$Dist)
    attr(filt, "target_lon") <- p1[1]
    attr(filt, "target_lat") <- p1[2]
  }
  
  # If `baseline` is not NULL, filter by available data
  if (!is.null(baseline)) {
    
    inside <- filter_at(filt, vars(matches(data_vars[1])), all_vars(. <= min(baseline))) %>%
      filter_at(vars(matches(data_vars[2])), all_vars(. >= max(baseline)))
    
    # Keep a record of the stations that are outside of our baseline
    outside <- filter(filt, !(.data$StationID %in% inside$StationID))
    filt <- inside
    
    # Remind users that stations for which the ID has changed might not be detected
    if (duplicates == TRUE) {
      coords <- outside %>% group_by(.data$LatitudeDD, .data$LongitudeDD) %>% tally %>% filter(.data$n > 1)
      printed <- NULL
      for (rw in 1:nrow(coords)) {
        dups <- filter(outside, .data$LatitudeDD == coords$LatitudeDD[rw] & .data$LongitudeDD == coords$LongitudeDD[rw])
        if (isTRUE(sort)) dups <- arrange(dups, .data$StationID)
        if (!is.na(min(dups[6])) & min(dups[6]) <= min(baseline) & !is.na(max(dups[7])) & max(dups[7] >= max(baseline))) {
          if (is.null(printed)) {
            cat("Note: In addition to the stations found, the following",
                "combinations may provide sufficient baseline data.\n\n")
            printed <- 1
            combo <- 1
          }
          cat(">> Combination", combo, "at coordinates", coords$LatitudeDD[rw],
              coords$LongitudeDD[rw], "\n\n")
          cat(paste0(dups$StationID, ": ", dups$Name, "\n"), "\n", sep = "")
          combo <- combo + 1
        }
      }
    }
  }
  
  class(filt) <- c("hcd_station_list", class(filt))
  filt
}
