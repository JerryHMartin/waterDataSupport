#' getUSGSHUC
#'
#' This function retrieves information on the hydraullic unit code 
#' given a USGS monitoring station ID.
#' 
#'
#' Much of this code was drawn from this source.
#' http://cyberhelp.sesync.org/leaflet-in-R-lesson/course/archive.html
#'
#' @param siteID the USGS site identified for stream flow analysis
#' @keywords USGS
#' @examples
#'
#' getUSGSHUC("02131000")
#' 
#' @export
#' 

getUSGSHUC <- function(siteID, plotmap = TRUE, zoomFactor = 10){
  
  require(waterData, quietly = TRUE)
  require(sp, quietly = TRUE)
  require(rgdal, quietly = TRUE)
  require(leaflet, quietly = TRUE)
  
  watershedInfo <- rbind(wIgroup1, wIgroup2, wIgroup3)
  
  stationInfo <- siteInfo(siteID)
  
  coords <- as.data.frame(cbind(stationInfo$lng, 
                                stationInfo$lat)) 
  
  points <- SpatialPoints(coords)
  proj4string(points) <- proj4string(watershedInfo)
  
  result <- over(points, watershedInfo)
  
  
  HUCCode <- as.character(result$HUC_CODE) #Hydraullic Unit Code
  HUCName <- as.character(result$HUC_NAME) #Hydraullic Unit Code
    
  if(plotmap == TRUE){
    
    nhd_wms_url <- 
      "https://basemap.nationalmap.gov/arcgis/services/USGSTopo/MapServer/WmsServer"
    
    watershedOfInterest <- 
      watershedInfo[watershedInfo$HUC_CODE == HUCCode,]
    
    map <- leaflet()
    map <- addProviderTiles(map, providers$OpenStreetMap)
    map <- setView(map,
                   lng = stationInfo$lng, 
                   lat = stationInfo$lat, 
                   zoom = zoomFactor) 
    map <- addWMSTiles(map, nhd_wms_url, layers = "0")
    map <- addPolygons(map, 
                       data = watershedOfInterest, 
                       fillOpacity = .2, 
                       weight = 1)
    map <- addMarkers(map,
                      lng = stationInfo$lng, 
                      lat = stationInfo$lat, 
                      popup = HUCName)
    print(map)
  }
  
  
  return(list(
    code = HUCCode,
    name = HUCName,
    latitude = stationInfo$lat,
    longitude = stationInfo$lng))
  
}
