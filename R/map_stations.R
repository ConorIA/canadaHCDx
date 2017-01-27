##' @title Map canadaHCD stations on an interactive map
##'
##' @description Show the stations of interest on an interactive map using Leaflet. Zoom levels are guessed based on an RStudio plot window.
##'
##' @param station character; one or more station ID numbers to show on the map.
##' @param zoom numeric; the level to zoom the map to.
##'
##' @importFrom leaflet "%>%" leaflet addTiles setView addMarkers
##' @importFrom tibble tibble
##'
##' @export
##'
##' @author Conor I. Anderson
##'
##' @examples
##' # Make a map of all the stations.
##' map_stations(station_data$StationID)
##' # Make a map of all the stations named "Yellowknife".
##' map_stations(find_station_adv(name = "Yellowknife"))
##' # Make a map of all stations within 50km of Toronto Station 5051.
##' map_stations(find_station_adv(target = 5051, dist = 0:50))

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

  if (nrow(poi) == 1L){
    lats <- poi$LatitudeDD
    lons <- poi$LongitudeDD
    latrng <- 0
  } else {
    hilat <- ceiling(max(poi$LatitudeDD))
    lolat <- floor(min(poi$LatitudeDD))
    hilon <- ceiling(max(poi$LongitudeDD))
    lolon <- floor(min(poi$LongitudeDD))
    lats <- (hilat + lolat)/2
    lons <- (hilon + lolon)/2
    latrng <- (hilat - lolat)
  }

  if (missing(zoom)) {
    zoomlevels <- tibble(range = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), zoom = c(10,8,7,7,7,6,6,6,5,5,5,5,5,5,5,5,4))
    zoom <- zoomlevels$zoom[which(zoomlevels$range == min(as.integer(latrng), 16L))]
  }

  leaflet() %>% addTiles() %>%
    setView(lng = lons, lat = lats, zoom = zoom)  %>%
    addMarkers(poi, lng = poi$LongitudeDD, lat = poi$LatitudeDD,
               popup = paste0(poi$StationID, " - ", poi$Name))
}
