#' mapWatershed
#' 
#' This is a raw method of plotting a watershed.  This function is internal
#' as too many details need to be specified to get this function to work.
#'
#' @param watershedPolygon a spatialPoints class defining the polygon of the watershed
#' @param USGSstationLatitude the latitude coordinate of the USGS station
#' @param USGSstationLongitude the longitude coordinate of the USGS station
#' @param NOAAstationsLatitude the latitude coordinates of the NOAA stations on the watershed
#' @param NOAAstationsLongitude the longitude coordinates of the NOAA stations on the watershed
#' @param USGSStationName the name of the USGS station
#' @param NOAAStationsName the name of the NOAA station
#' @param watershedMap the map of the watershed
#' @param zoomFactor the factor which to zoom in on a map
#' @param printMap set printMap to TRUE to output a map. This may not work in R markdown.
#'
#' @keywords internal
#' @return a leaflet map of the watershed
#' @export
#'
#' 
#'         
mapWatershed <- function(watershedPolygon, 
                         USGSstationLatitude,
                         USGSstationLongitude,
                         NOAAstationsLatitude = NULL,
                         NOAAstationsLongitude = NULL,
                         USGSStationName = "",
                         NOAAStationsNames = "",
                         watershedMap = NULL,
                         zoomFactor = 10,
                         printMap = FALSE) {
  
  require(leaflet, quietly = TRUE)
  
  if (is.null(watershedMap)) watershedMap <- leaflet()
  
  
  iconDischargeStation <- makeAwesomeIcon(icon = 'info',
                                          library = "fa",
                                          markerColor = 'red', 
                                          iconColor = 'black')
  
  iconPrecipitationStation <- makeAwesomeIcon(icon = 'tint', 
                                              markerColor = 'blue', 
                                              iconColor = 'black')
  
  watershedMap <-  addProviderTiles(watershedMap, providers$OpenStreetMap)
  
  watershedMap <- setView(watershedMap,
                          lng = USGSstationLongitude, 
                          lat = USGSstationLatitude, 
                          zoom = zoomFactor) 
  
  watershedMap <- addWMSTiles(watershedMap, 
                              waterData_URL$National_Hydrography_Dataset, 
                              layers = "0")
  
  
  watershedMap <- addPolygons(watershedMap, 
                              data = watershedPolygon, 
                              fillOpacity = .2, 
                              weight = 1)
  
  
  watershedMap <- addAwesomeMarkers(watershedMap,
                                    lng = USGSstationLongitude, 
                                    lat = USGSstationLatitude, 
                                    popup = paste(1:length(NOAAStationsNames),
                                          "NOAA Precipitation Station", 
                                                    NOAAStationsNames),
                                    icon = iconDischargeStation)
  
  if(!is.null(NOAAstationsLongitude) & !is.null(NOAAstationsLatitude)){
    
    watershedMap <- addAwesomeMarkers(watershedMap,
                                      lng = NOAAstationsLongitude, 
                                      lat = NOAAstationsLatitude,                             
                                      popup = paste("NOAA Precipitation Station", 
                                                    NOAAStationsNames),
                                      icon = iconPrecipitationStation) 
  }
  
  if (printMap == TRUE) {print(watershedMap)} 
  
  return(watershedMap)
  
}
