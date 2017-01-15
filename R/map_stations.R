##' @title Map canadaHCD stations on an interactive map
##'
##' @description Show the stations of interest on an interactive map using Leaflet. Zoom levels are guessed based on an RStudio plot window.
##'
##' @param station character; one or more station ID numbers to show on the map.
##' @param zoom numeric; the level to zoom the map to.
##'
##' @importFrom leaflet "%>%" leaflet addTiles setView addMarkers
##'
##' @export
##'
##' @author Conor I. Anderson
##'
##' @examples
##' # Make a map of all the stations.
##' \dontrun{map_stations(station_data$StationID)}
##' # Make a map of all the stations named "Yellowknife".
##' \dontrun{map_stations(find_station(name = "Yellowknife"))}
##' # Make a map of all stations within 50km of Toronto Station 5051.
##' \dontrun{map_stations(find_station_adv(target = 5051, maxdist = 50))}

map_stations <- function(station, zoom) {

  if (inherits(station, "data.frame")) {
    station <- station$StationID
  }

  station <- as.character(station)

  poi <- NULL
  for (i in station) {
    row <- which(as.character(station_data$StationID) == i)
    if (!is.na(station_data$LatitudeDD[row]) && !is.na(station_data$LongitudeDD)[row]) {
      poi <- c(poi, row)
    }
  }
  poi <- station_data[poi,]

  hilat <- ceiling(max(poi$LatitudeDD))
  lolat <- floor(min(poi$LatitudeDD))
  hilon <- ceiling(max(poi$LongitudeDD))
  lolon <- floor(min(poi$LongitudeDD))
  lats <- (hilat + lolat)/2
  lons <- (hilon + lolon)/2

  if (missing(zoom)) {
    latrng <- (hilat - lolat)
    if (latrng >= 16) {
      zoom = 4
    } else if (latrng >= 8) {
      zoom = 5
    } else if (latrng >= 5) {
      zoom = 6
    } else if (latrng >= 2) {
      zoom = 7
    } else if (latrng == 1) {
      zoom = 8
    } else zoom = 10
  }

  leaflet() %>% addTiles() %>%
    setView(lng = lons, lat = lats, zoom = zoom)  %>%
    addMarkers(poi, lng = poi$LongitudeDD, lat = poi$LatitudeDD,
               popup = paste0(poi$StationID, " - ", poi$Name))
}
