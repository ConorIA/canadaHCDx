##' @title Map canadaHCD stations on an interactive map
##'
##' @description Show the stations of interest on an interactive map using Leaflet. Zoom levels are guessed based on an RStudio plot window.
##'
##' @param station character; one or more station ID numbers to show on the map, or a table output by \code{\link{find_station}}.
##' @param zoom numeric; the level to zoom the map to.
##' @param type character; either "osm" for OpenStreetMap tiles, or "sentinel" for cloudless satellite by EOX IT Services GmbH (\url{https://s2maps.eu}).
##'
##' @importFrom dplyr "%>%" filter
##' @importFrom leaflet addCircleMarkers addMarkers addTiles addWMSTiles leaflet leafletCRS leafletOptions setView WMSTileOptions
##' @importFrom rlang .data
##' @importFrom tibble tibble
##'
##' @export
##'
##' @author Conor I. Anderson
##'
##' @examples
##' # Make a map of all the stations named "Yellowknife".
##' map_stations(find_station(name = "Yellowknife"))
##' # Make a map of all stations within 50km of Toronto Station 5051.
##' map_stations(find_station(target = 5051, dist = 0:50))

map_stations <- function(station, zoom, type = "osm") {

  if (!inherits(station, "data.frame")) {
    station_data <- get_station_data(quiet = TRUE)
    
    if (any(!station %in% station_data$StationID)) {
      stop("One or more requested stations invalid.")
    }
    
    station <- filter(station_data, .data$StationID %in% station)
  }
  
  station <- filter(station, !is.na(.data$LatitudeDD) & !is.na(.data$LongitudeDD))
  
  hilat <- ceiling(max(station$LatitudeDD))
  lolat <- floor(min(station$LatitudeDD))
  lats <- (hilat + lolat)/2
  lons <- (ceiling(max(station$LongitudeDD)) + floor(min(station$LongitudeDD)))/2
  latrng <- (hilat - lolat)
  if (missing(zoom)) {
    zoomlevels <- tibble(range = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16), zoom = c(10,8,7,7,7,6,6,6,5,5,5,5,5,5,5,5,4))
    zoom <- zoomlevels$zoom[which(zoomlevels$range == min(as.integer(latrng), 16L))]
  }

  map <- if (type == "sentinel") {
    leaflet(station, options = leafletOptions(crs = leafletCRS("L.CRS.EPSG4326"))) %>%
      setView(lng = lons, lat = lats, zoom = zoom) %>%
      addWMSTiles(
        "https://tiles.maps.eox.at/wms?service=wms",
        layers = "s2cloudless",
        options = WMSTileOptions(format = "image/jpeg"),
        attribution = "Sentinel-2 cloudless - https://s2maps.eu by EOX IT Services GmbH (Contains modified Copernicus Sentinel data 2016 & 2017)"
      )
  } else {
    if (type != "osm") warning("Unrecognized map type. Defaulting to osm.")
    leaflet(station) %>%
      addTiles() %>%
      setView(lng = lons, lat = lats, zoom = zoom)
  }
  
  map <- map %>%
    addMarkers(lng = ~LongitudeDD, lat = ~LatitudeDD,
               label = paste0(station$StationID, " - ", station$Name, " @ ",
                              station$LatitudeDD, ", ", station$LongitudeDD))
  
  # Add a target if it exists
  target <- c(attr(station, "target_lon"), attr(station, "target_lat"))
  if (!is.null(target)) {
    map <- map %>% addCircleMarkers(lng = target[1], lat = target[2],
                                    color = "red", label = paste0("Target: ", target[2],
                                                                  ", ", target[1]))
  }
  
  map  
}
