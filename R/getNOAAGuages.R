#' getNOAAGuages
#'
#' This function retrieves information on the hydraullic unit code 
#' given a USGS monitoring station ID.
#' 
#'
#' Much of this code was drawn from this source.
#' http://cyberhelp.sesync.org/leaflet-in-R-lesson/course/archive.html
#'
#' @param siteID the USGS site identified for stream flow analysis
#' @param plotmap TRUE if output plot is desired
#' @param zoomFactor the zoom factor of the output plot
#' @keywords USGS
#' @examples
#'
#' getNOAAGuages("02131000")
#' 
#' @export
#' 

getNOAAGuages <- function(siteID, 
                          plotmap = TRUE, 
                          zoomFactor = 10, 
                          limitToWatershed = TRUE,
                          #limitToHigherelevations = TRUE,
                          getElevations = TRUE,
                         leafletmap = NULL){
  
  require(waterData, quietly = TRUE)
  require(sp, quietly = TRUE)
  require(rgdal, quietly = TRUE)
  require(leaflet, quietly = TRUE)
  require(geosphere, quietly = TRUE)
  require(elevatr, quietly = TRUE)
  require(rnoaa, quietly = TRUE)
  
  spatialPointsLatLng <- function(latitude, 
                                  longitude, 
                                  proj4stringAttributes = NULL){
    
    returnSp <- SpatialPoints(data.frame(cbind(longitude, latitude)))
    
    if (!is.null(proj4stringAttributes)){
      proj4string(returnSp) <- proj4string(proj4stringAttributes)
    } 
    
    return(returnSp)
  }
  
  
  # assemble the informaiton on watershed boundaries
  watershedInfo <- rbind(wIgroup1, wIgroup2, wIgroup3)
  
  stationInfo <- siteInfo(siteID) # get station information
 
  pointUSGSStation <- spatialPointsLatLng(stationInfo$lat, 
                                          stationInfo$lng,
                                          watershedInfo)
  
  watershedUSGS <- over(pointUSGSStation, watershedInfo)
  
  HUCCode <- as.character(watershedUSGS$HUC_CODE) #Hydraullic Unit Code
  HUCName <- as.character(watershedUSGS$HUC_NAME) 
  
  watershedOfInterest <- watershedInfo[watershedInfo$HUC_CODE == HUCCode,]
  
  # locate nearest NOAA stations
  
  # use the diagonal of the bounding box to limit distance
  boundingBox <- bbox(watershedOfInterest)
  diagonalDistance <- distHaversine(c(boundingBox[1],boundingBox[2]),
                                    c(boundingBox[3],boundingBox[4])) / 1000
  # convert from m to km
  nearby_NOAA_stations <-  meteo_nearby_stations(
    lat_lon_df = data.frame(id = HUCName, 
                            latitude = stationInfo$lat, 
                            longitude = stationInfo$lng), 
    station_data = NOAAstations,
    radius = diagonalDistance, 
    var = c("PRCP", "TMAX", "TMIN", "TAVG"),
    year_min = 1800, year_max = 2018)
  
  
  #Update Output Value
  outputValue <- data.frame(
    longitude = nearby_NOAA_stations[[HUCName]]$longitude,
    latitude = nearby_NOAA_stations[[HUCName]]$latitude,
    id = nearby_NOAA_stations[[HUCName]]$id,
    name = nearby_NOAA_stations[[HUCName]]$name,
    distance = nearby_NOAA_stations[[HUCName]]$distance
  )
  
  pointsNOAAStations <- spatialPointsLatLng(
    nearby_NOAA_stations[[HUCName]]$latitude, 
    nearby_NOAA_stations[[HUCName]]$longitude, 
    proj4stringAttributes = watershedOfInterest)

  # see if NOAA points are on watershed

  pointsWithinUSGSWatershed <- over(pointsNOAAStations, watershedOfInterest)
  ispointWithinUSGSWatershed <- !sapply(pointsWithinUSGSWatershed$HUC_CODE, is.na)

  NOAA_stations_within_watershed <- 
    as.data.frame(nearby_NOAA_stations[[HUCName]])[ispointWithinUSGSWatershed,]
    
  pointsNOAAStationsWatershed <- spatialPointsLatLng(
    NOAA_stations_within_watershed$latitude, 
    NOAA_stations_within_watershed$longitude, 
    proj4stringAttributes = watershedOfInterest)
  
  # Get elevation points (no more than necissary)
  if (limitToWatershed){
    outputValue <- data.frame(
      longitude = NOAA_stations_within_watershed$longitude,
      latitude = NOAA_stations_within_watershed$latitude,
      id = NOAA_stations_within_watershed$id,
      name = NOAA_stations_within_watershed$name,
      distance = NOAA_stations_within_watershed$distance)
    if (getElevations){
      elevations <- get_elev_point(
        pointsNOAAStationsWatershed, src = "epqs")
      outputValue$elevations <- elevations$elevation
    }
  } else {
    if (getElevations){
      elevations <- get_elev_point(pointsNOAAStations, src = "epqs")
      outputValue$elevations <- elevations$elevation
    }
    outputValue$inWatershed <- ispointWithinUSGSWatershed
  }
 
   
  # if (limitToHigherelevations){
  # 
  #   stationElevation <- get_elev_point(pointUSGSStation, src = "epqs")
  #   
  #   outputValue <- outputValue[outputValue$elevations > stationElevation$elevation,]
  # 
  #   
  # }
  
  

  
  if(plotmap == TRUE){
    
    nhd_wms_url <- 
      "https://basemap.nationalmap.gov/arcgis/services/USGSTopo/MapServer/WmsServer"
    
    
    iconDischargeStation <- makeAwesomeIcon(icon = 'info',
                                            library = "fa",
                                            markerColor = 'red', 
                                            iconColor = 'black')
    
    iconPrecipitationStation <- makeAwesomeIcon(icon = 'tint', 
                                                markerColor = 'blue', 
                                                iconColor = 'black')
    if (is.null(leafletmap)){
         map <- leaflet()
      } else {
         map <- leafletmap
      }
    
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
    map <- addAwesomeMarkers(map,
                             lng = stationInfo$lng, 
                             lat = stationInfo$lat, 
                             popup = paste("USGS Discharge Station", HUCName),
                             icon = iconDischargeStation)
    
    map <- addAwesomeMarkers(map,
                             lng = outputValue$longitude, 
                             lat = outputValue$latitude,                             
                             popup = paste("NOAA Precipitation Station", 
                                           outputValue$name),
                             icon = iconPrecipitationStation)    
    print(map)
  }
  
  
  return(outputValue)
  
}
