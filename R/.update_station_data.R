.update_station_data <- function() {
  f <- tempfile()
  curl::curl_download("ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv", f)
  library(readr)
  station_data <- read_csv(f, col_types =
                                    cols(`DLY First Year` = col_integer(),
                                    Latitude = col_integer()), skip = 3)
  names(station_data) <- c("Name", "Province", "ClimateID", "StationID", "WMOID",
                           "TCID", "LatitudeDD", "LongitudeDD", "Latitude", "Longitude",
                           "Elevation", "FirstYear", "LastYear", "HourlyFirstYr", "HourlyLastYr",
                           "DailyFirstYr", "DailyLastYr", "MonthlyFirstYr", "MonthlyLastYr")
  station_timestamp <- gsub(" UTC", "", gsub("Modified Date: ", "", read_lines(f, n_max = 1)))
  save(station_data, station_timestamp, file = "R/sysdata.rda")
}
