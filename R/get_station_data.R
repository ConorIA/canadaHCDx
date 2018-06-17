#' Get latest Environment and Climate Change Canada Station Data
#' 
#' @importFrom curl curl curl_download
#' @importFrom rappdirs user_cache_dir
#' @importFrom readr read_csv read_lines
#' @importFrom storr storr_rds
#'
#' @keywords internal
#'

get_station_data <- function(assume_yes = FALSE) {
  
  fetch_station_data <- function(key, namespace) {
    tab <- file.path("ftp://client_climate@ftp.tor.ec.gc.ca",
                     "Pub/Get_More_Data_Plus_de_donnees",
                     "Station%20Inventory%20EN.csv")
    f <- tempfile("station_data_")
    on.exit(file.remove(f))
    dat <- try(curl_download(tab, f))
    if (inherits(dat, "try-error")) {
      stop("Error downloading file")
    }
    station_data <- read_csv(f, skip = 3)
    names(station_data) <-
      c(
        "Name",
        "Province",
        "ClimateID",
        "StationID",
        "WMOID",
        "TCID",
        "LatitudeDD",
        "LongitudeDD",
        "Latitude",
        "Longitude",
        "Elevation",
        "FirstYear",
        "LastYear",
        "HourlyFirstYr",
        "HourlyLastYr",
        "DailyFirstYr",
        "DailyLastYr",
        "MonthlyFirstYr",
        "MonthlyLastYr"
      )
    station_timestamp <-
      gsub(" UTC", "", gsub("Modified Date: ", "", read_lines(f, n_max = 1)))
    class(station_data) <- c("hcd_station_list", class(station_data))
    station_data
  }
  
  fetch_table_attributes <- function() {
    con <- curl("ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/")
    dat <- try(readLines(con), silent = TRUE)
    close(con)
    if (inherits(dat, "try-error")) {
      stop(paste("We encountered an error while querying table attributes:",
                 attr(dat, "condition")))
    }
    inven <- grep("Station Inventory EN.csv", dat, value = TRUE)
    mat <- gregexpr("[A-Z][a-z]{2}[ 0-9:]{9}", inven)
    mod_time <- strptime(substr(inven, mat[[1]][1],
                    mat[[1]][1] + attributes(mat[[1]])$match.length - 1),
             "%b %d %H:%M")
    mat <- gregexpr("\\w[0-9]+\\w", inven)
    size <- format(structure(as.integer(substr(inven, mat[[1]][1],
                          mat[[1]][1] + attributes(mat[[1]])$match.length - 1)),
                          class="object_size"), units="auto")
    list("mod_time" = mod_time, "size" = size)
  }
  
  cache_station_data <- function(mod_time) {
    st$set("last_mod", mod_time)
    st$set("station_data", eval(fetch_station_data()))
  }
  
  cache_dir <- user_cache_dir("canadaHCDx")
  st <- storr_rds(cache_dir)
  
  tab_attrs <- try(fetch_table_attributes(), silent = TRUE)
  if (inherits(tab_attrs, "try-error")) {
    stop(paste("We cannot connect to Environment Canada's FTP site:",
               attr(tab_attrs, "condition")))
  } else {
  
    if (!st$exists("station_data")) {
      print(paste0(">>> We don't have a local copy of the station data index ",
                   "from Environment and Climate Change Canada. Do you want to ",
                   "download this data now? (", tab_attrs$size, ")"))
      if (assume_yes || !(readline(">>> Proceed? (Y/n) ") %in% c("n", "N"))) {
        cache_station_data(tab_attrs$mod_time)
      } else {
        stop("No data to search through.")
      }
    } else {
      cached_mod <- st$get("last_mod")
      if (!identical(tab_attrs$mod_time, cached_mod)) {
        print(paste0(">>> There is a newer copy of the station data index from ",
                     "Environment and Climate Change Canada available. Do you ",
                     "want to download this data now? (", tab_attrs$size, ")"))
        if (assume_yes || !(readline(">>> Proceed? (Y/n) ") %in% c("n", "N"))) {
          cache_station_data(tab_attrs$mod_time)
        }
      }
    }
  
    st$get("station_data")
  }
}