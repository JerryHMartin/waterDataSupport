#' Get Watershed Information 
#' 
#' This function assembles all watershed information in the US
#' 
#' The watershed information is broken into 3 files based on regions, this internal function
#' binds these files together. 
#'
#' @return Large SpatialPolygonsDataFrame
#' @export
#' @keywords internal
#'
#' @examples
#' 
#' WatershedInfo <- getWatershedInfo()
getWatershedInfo <- function() {
  return(rbind(wIgroup1, wIgroup2, wIgroup3))
}



#' spatialPointsLatLng
#'
#' This function is a wrapper for the spatialPoints function in the sp package
#'
#' This turns lattitude and longitude coordinates into a spaital projection 
#'
#' @param latitude latitude coordinates
#' @param longitude longitude coordinates
#' @param proj4stringAttributes (optional) which projection to copy attributes from
#'
#' @return a SpatialPolygonsDataframe
#' @export
#'
#' @examples
#' 
#' spatialPointsLatLng (latitude, longitude)
spatialPointsLatLng <- function(latitude, 
                                longitude, 
                                proj4stringAttributes = NULL){
  
  require(sp, quietly = TRUE)
  
  returnSp <- SpatialPoints(data.frame(cbind(longitude, latitude)))
  
  if (!is.null(proj4stringAttributes)){
    proj4string(returnSp) <- proj4string(proj4stringAttributes)
  } 
  
  return(returnSp)
}



#' Get distance range of watershed
#' 
#' This function gets a distance (in meters) which encompases the full range
#' of the watershed.  This function uses a diagonal
#' across the bounding box of the watershed.  
#' 
#' The Haversine formula is used to calculate the distance in Longitude and
#' Latitude.
#'
#' @param watershedOfInterest a SpatialPolygonsDataFrame showing a single watershed
#' @keywords internal
#' 
#' @return a distance in meters
#' @export
#'
#' @examples 
#' 
#' getWatershedRange(watershedOfInterest)
#' 
getWatershedRange <- function(watershedOfInterest) {
  
  require(geosphere, quietly = TRUE)
  
  boundingBox <- bbox(watershedOfInterest)
  
  return(distHaversine(c(boundingBox[1],boundingBox[2]),
                       c(boundingBox[3],boundingBox[4])) / 1000)
}




#' droplevelsPolygon
#'
#' This function removes unused levels from a polygon.
#' 
#' This is useful when a single watershed has been isolated. Information
#' concerning every other watershed is removed.
#'
#' @param polygon a SpatialPolygonsDataframe
#' @keywords internal
#'
#' @return a SpatialPolygonsDataframe
#' @export
#'
#' @examples
#' 
#' droplevelsPolygon(polygon)
#' 
droplevelsPolygon <- function(polygon) {
  
  #remove uneeded levels from polygon object
  polygonNames <- names(polygon)
  for (i in polygonNames){
    if (is.factor(polygon[[i]])){
      polygon[[i]] <- droplevels(polygon[[i]])
      
    }
  }
  return(polygon)
}

