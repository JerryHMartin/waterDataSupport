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

