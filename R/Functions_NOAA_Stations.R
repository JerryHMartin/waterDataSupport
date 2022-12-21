#' Get NOAA Stations.
#'
#'  This function retrieves the NOAA stations.
#'  
#' 
#' @param localSave saves / retrieves information locally
#' @param refresh forces a refresh of cached station information
#' @param localFileName local name of file used to cache station information
#' @keywords coordinates
#' @examples
#'
#' # If NOAA stations have not been downloaded in a while
#'  
#' stations <- Get_NOAA_Stations(refresh = TRUE)
#' 
#'  # If local saves are not desired
#'  
#'  stations <- Get_NOAA_Stations(localSave = FALSE)
#'  
#' 
#' @export

Get_NOAA_Stations <- function(localSave = TRUE,
                              refresh = FALSE,
                              localFileName = "stations.Rdata"){
  
  require(rnoaa, quietly = TRUE)
  
  # Use save file for data if possible
  if (!refresh & localSave){
    if (file.exists(localFileName)){
        load(file = localFileName)
        return(stations)
    }
  } 
  
  stations <- ghcnd_stations(refresh = refresh)             
  if(localSave){save(stations, file = localFileName)}
  return (stations)

}

#' Select NOAA Stations.
#'
#'  This function retrieves the NOAA stations, like Get_NOAA_Stations,
#'  then selects a group of stations based on certain properties.
#'  
#' 
#' @param localSave saves / retrieves information locally
#' @param refresh forces a refresh of cached station information
#' @param localFileName local name of file used to cache station information
#' @param selectElements list of elements to limit select
#' @param beginYear the earliest year of data collection
#' @param endYear the last year of data collection
#' @keywords coordinates
#' @examples
#'
#' # If NOAA stations have not been downloaded in a while
#'  
#' stations <- Select_NOAA_Stations(refresh = TRUE)
#' 
#'  # If local saves are not desired
#'  
#'  stations <- Select_NOAA_Stations(localSave = FALSE)
#'  
#'  
#'  
#' 
#' @export

Select_NOAA_Stations <- function(localSave = TRUE,
                                 refresh = FALSE,
                                 localFileName = "stations.Rdata",
                                 selectElements = NULL,
                                 beginYear = NULL,
                                 endYear = NULL
                                 ){
  
  stations <- Get_NOAA_Stations(localSave = localSave,
                                refresh = refresh,
                                localFileName = localFileName)
  
  # limit to specific NOAA variables
  if (!is.null(selectElements)){
    stations <- stations[stations$element %in% selectElements,]
  }

  if (!is.null(beginYear)){
    stations <- stations[stations$last_year >= beginYear,]
  }
  
  if (!is.null(endYear)){
    stations <- stations[stations$first_year <= endYear,]
  }
  
}


