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
#' @param limitToWatershed only pull datapoints on the watershed
#' @param getElevations retrieve elevations of datapoints
#' @param leafletmap pass a leaflet map arguements, note the output changes to a 
#' list if this parameter is invoked
#' @keywords USGS NOAA precipitation mapping
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
                          getElevations = TRUE,
                          leafletmap = NULL){
  
  require(waterData, quietly = TRUE)
  require(sp, quietly = TRUE)
  require(rgdal, quietly = TRUE)
  require(elevatr, quietly = TRUE)
  require(rnoaa, quietly = TRUE)

  watershed <- getWatershedOfStation(siteID)
  
  NOAAdataframe <-  
    data.frame(id = watershed$name, 
               latitude = watershed$stationLatitude, 
               longitude = watershed$stationLongitude)

    
  # locate nearest NOAA stations
  nearby_NOAA_stations <-  meteo_nearby_stations(
    lat_lon_df = NOAAdataframe, 
    station_data = NOAAstations,
    radius = getWatershedRange(watershed$polygon), 
    var = c("PRCP", "TMAX", "TMIN", "TAVG"),
    year_min = 1800, year_max = 2018)

  
  #Prepare Standard Output Value
  outputValue <- data.frame(
    longitude = nearby_NOAA_stations[[watershed$name]]$longitude,
    latitude = nearby_NOAA_stations[[watershed$name]]$latitude,
    id = nearby_NOAA_stations[[watershed$name]]$id,
    name = nearby_NOAA_stations[[watershed$name]]$name,
    distance = nearby_NOAA_stations[[watershed$name]]$distance
  )
 
   
  pointsNOAAStations <- spatialPointsLatLng(
    nearby_NOAA_stations[[watershed$name]]$latitude, 
    nearby_NOAA_stations[[watershed$name]]$longitude, 
    proj4stringAttributes = watershed$polygon)
  
  
  # see if NOAA points are on watershed
  pointsWithinUSGSWatershed <- over(pointsNOAAStations, watershed$polygon)
  ispointWithinUSGSWatershed <- !sapply(pointsWithinUSGSWatershed$HUC_CODE, is.na)
  
  NOAA_stations_within_watershed <- 
    as.data.frame(nearby_NOAA_stations[[watershed$name]])[ispointWithinUSGSWatershed,]
  
  pointsNOAAStationsWatershed <- spatialPointsLatLng(
    NOAA_stations_within_watershed$latitude, 
    NOAA_stations_within_watershed$longitude, 
    proj4stringAttributes = watershed$polygon)
  
  # test if limiting to only the stations on the watershed
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

  if(plotmap == TRUE){
    
    watershedMap <- 
      mapWatershed (watershed$polygon, 
                    USGSstationLatitude = watershed$stationLatitude,
                    USGSstationLongitude = watershed$stationLongitude,
                    NOAAstationsLatitude = outputValue$latitude,
                    NOAAstationsLongitude = outputValue$longitude,
                    USGSStationName = watershed$name,
                    NOAAStationsNames = outputValue$name,
                    watershedMap = leafletmap,
                    zoomFactor = zoomFactor,
                    printMap = is.null(leafletmap)) 
    
  }
  
  if (is.null(leafletmap)  & !plotmap){
    return(outputValue)
  } else {
    return(list(output = outputValue, leafletmap = watershedMap))
  }
}
