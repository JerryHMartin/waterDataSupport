#' displaySiteInfo
#'
#' This function displays the output of the siteInfo function in
#' a table using the grid.Extra function.
#'
#' HTML - this is set to TRUE if output is to HTML
#'
#' @param siteID The USGS site identified for stream flow analysis
#' @param HTML HTML = TRUE if output is to HTML 
#' @keywords USGS
#' @examples
#'
#' displaySiteInfo("02131000")
#' 
#' 
#'
#' @export
#'

displaySiteInfo <- function(siteID, HTML = FALSE){
  
  require(waterData, quietly = TRUE)
  
  stationInfo <- siteInfo(siteID)
  
  OutputInfo <- data.frame(
    'Station ID' = stationInfo$staid,
    'Station Name' = stationInfo$staname,
    Latitude = as.character(stationInfo$lat),
    Longitude = as.character(stationInfo$lng),
    stringsAsFactors = FALSE
  ) 
  
  if(HTML){
    require(xtable, quietly = TRUE)
    print(
      xtable(OutputInfo,
             cap = paste("Information for USGS streamgage site",
                         siteID),
             digits = 5
      ), type = "html", include.rownames = FALSE)
  }else{
    require(grid, quietly = TRUE)
    require(gridExtra, quietly = TRUE)
    grid.table(OutputInfo, rows = NULL)
  }
  
  
}



