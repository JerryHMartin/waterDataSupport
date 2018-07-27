#' displaySiteLocationInState
#'
#' This function displays the output of the siteInfo function in
#' a table using the grid.Extra function.
#'
#'
#' @param siteID The USGS site identified for stream flow analysis
#' @keywords USGS
#' @examples
#'
#' displaySiteLocationInState("02131000")
#' 
#' @export


displaySiteLocationInState <- function(siteID){
  
  library(sp)
  library(maps)
  library(mapdata)
  library(maptools)
  
  latlong2state <- function(pointsDF) {
    # This function is adapted from
    # https://stackoverflow.com/questions/8751497/latitude-longitude-coordinates-to-state-code-in-r
    
    
    # Prepare SpatialPolygons object with one SpatialPolygon
    # per state (plus DC, minus HI & AK)
    
    states <- map('state', fill=TRUE, col="transparent", plot=FALSE)
    
    IDs <- sapply(strsplit(states$names, ":"), function(x) x[1])
    
    states_sp <- map2SpatialPolygons(states, IDs=IDs,
                                     proj4string=CRS("+proj=longlat +datum=WGS84"))
    
    # Convert pointsDF to a SpatialPoints object 
    pointsSP <- SpatialPoints(pointsDF, 
                              proj4string=CRS("+proj=longlat +datum=WGS84"))
    
    # Use 'over' to get _indices_ of the Polygons object containing each point 
    indices <- over(pointsSP, states_sp)
    
    # Return the state names of the Polygons object containing each point
    stateNames <- sapply(states_sp@polygons, function(x) x@ID)
    
    stateNames[indices]
  }
  
  siteInfo <- siteInfo(siteID)
  
  par(las = 1, tck = 0.02, mar = c(0, 0, 0, 0))
  map("state", region = c(latlong2state(
    data.frame(x = siteInfo$lng, y = siteInfo$lat)
  )))
  
  points(siteInfo$lng, 
         siteInfo$lat, pch = 19, col = "green")
  text(xy.coords(siteInfo$lng, 
                 siteInfo$lat),
       siteInfo$staid, cex = 0.55, pos = 3)
  box()
  
  
}