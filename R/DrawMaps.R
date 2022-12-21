

#' displaySiteLocation
#'
#' This function displays the output of the stationInfo function in
#' a table using the ggmap function.
#' 
#' This function imports the location of the site from the 
#' USGS database then pins it on a map from Google
#' 
#' credit for this function goes to this link
#' https://ryanpeek.github.io/2016-09-28-static_maps_in_R/ 
#' accessed July 2018
#'
#' @param siteID the USGS site identified for stream flow analysis
#' @param maptype the Google Maptype to use
#' @param zoom the zoom level on the map
#' @keywords USGS
#' @examples
#'
#' displaySiteLocation("02131000")
#' 
#' @export

displaySiteLocation <- function(siteID,
                                maptype = "satellite",
                                zoom = 14
){
  
  require(waterData, quietly = TRUE)
  require(ggmap, quietly = TRUE)
  
  stationInfo <- siteInfo(siteID)
  
  location <- c(stationInfo$lng, stationInfo$lat)
  
  par(las = 1, tck = 0.02, mar = c(0, 0, 0, 0))
  
  locationData <- data.frame(
    lat = stationInfo$lat, 
    lon = stationInfo$lng,
    siteID = siteID)
  
  ggmap(get_map(location = location,
                crop = F,
                maptype = maptype,
                source = "google",
                zoom = zoom)) + 
    geom_point(data = locationData, 
               aes(x=lon, y=lat), 
               pch=21, size=4, fill="#FDE725FF") + 
    geom_text(data = locationData,
              aes(label = siteID),
              hjust=-0.1, vjust=0, color = "yellow" 
    )
  
}

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
  
  require(waterData, quietly = TRUE)
  require(sp, quietly = TRUE)
  require(maps, quietly = TRUE)
  require(mapdata, quietly = TRUE)
  require(maptools, quietly = TRUE)
  
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

