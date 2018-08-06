#' Get Watershed of USGS Station
#'
#' Given a USGS site this function retrieves the watershed polygon 
#'
#' @param siteID USGS station ID
#' @param printMap if TRUE this function prints a leaflet map and appends it to the output
#' @param exportMap if TRUE this function appends the leaflet map to the output without printing it
#'
#' @return a list of watershed properties
#' \item{name name}{description name of the watershed}
#' \item{name HUC}{description hydraullic unit code of watershed}
#' \item{name stationName}{description name of the USGS station} 
#' \item{name stationID}{description ID of the USGS station} 
#' \item{name stationLatitude}{description Latitude coordinate of USGS station}
#' \item{name stationLongitude}{description Longitude coordinate of USGS station}
#' \item{name polygon}{description polygon(SpatialPolygonsDataFrame) describing the watershed}
#' @export
#'
#' @examples
#' 
#' watershed <- getWatershedOfStation("02131000", printMap = TRUE)
#' 
#' 
getWatershedOfStation <- function(siteID, 
                                  printMap = FALSE,
                                  exportMap = FALSE) {
  
  require(waterData, quietly = TRUE)
  require(sp, quietly = TRUE)
  
  stationInfo <- siteInfo(siteID) 
  watershedInfo <- getWatershedInfo()
  
  pointUSGSStation <- spatialPointsLatLng(
    stationInfo$lat, stationInfo$lng, watershedInfo)
  
  #get polygon surrounding the USGS station
  watershedUSGS <- over(pointUSGSStation, watershedInfo)
  
  HUCCode <- as.character(watershedUSGS$HUC_CODE) #Hydraullic Unit Code 
  
  polygon <- droplevelsPolygon(
    watershedInfo[watershedInfo$HUC_CODE == HUCCode,])

  returnList <- list(
    name = as.character(watershedUSGS$HUC_NAME),
    HUC = HUCCode,
    stationName = stationInfo$staname,
    stationID = stationInfo$staid,
    stationLatitude = stationInfo$lat,
    stationLongitude = stationInfo$lng,
    polygon = polygon
  )

  if (printMap == TRUE | exportMap == TRUE){
 
    mapWatershed(watershedPolygon = watershed$polygon, 
                 USGSstationLatitude = watershed$stationLatitude,
                 USGSstationLongitude = watershed$stationLongitude,
                 zoomFactor = 8,
                 printMap = printMap) 

    returnList$leafletMap <- leafletMap
  }

  return(returnList)
}