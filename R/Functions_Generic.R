#' Convert Degree-Minutes-Seconds coordinates to Decimal Coordinates.
#'
#'  This function converts the format of a location.
#' 
#' @param angle the angle to convert
#' @param split_string the characters used to separate
#' @keywords coordinates
#' @examples
#'
#' Convert_DMS_to_Decimal("02131000")
#' 
#' @export

Convert_DMS_to_Decimal <- function(angle, split_string = ' ') {
  
  angle <- as.character(angle)
  
  x <- sapply(strsplit(angle, split=split_string), as.numeric)
  return(x[1] + x[2]/60 + x[3]/3600)
}



#' as.International.Date wrapper function
#'
#'  This function is a wrapper for the as.Date function.
#'  
#'  The necessity of the format string is gone
#' 
#' @param date_text the text to convert into a date
#' @keywords time
#' @examples
#'
#' as.International.Date("1992/1/1")
#' 
#' @export
#' 
#' 
as.International.Date <- function (date_text) {
  return (as.Date(date_text, "%Y/%m/%d"))
}


#' as.Year wrapper function
#'
#'  This function is a wrapper which formats a data as a Year
#'  
#' 
#' @param international_date the date to convert into a year
#' @keywords time
#' @examples
#'
#' as.Year(as.International.Date("1992/1/1"))
#' 
#' @export
#' 
#' 
as.Year <- function(international_date){
  format(international_date, "%Y")
}


#' as.geospatial.coordinate wrapper function
#'
#'  This function is a wrapper which formats a latitude, longitude pair as a 
#'  geospatial coordinate.  This is useful if a coordinate is treated as a single 
#'  parameter
#'  
#'  The parameters can be shorted to lat, lon if space is short.
#' 
#' @param lat the latitude of a geospatial coordinate
#' @param lon longitude of a geospatial coordinate
#' @param elev elevation of a geospatial coordinate
#' @keywords time
#' @examples
#'
#' as.geospatial.coordinate(lat = 10, lon = 5)
#' 
#' @export
#' 
#' 
as.geospatial.coordinate <- function(lat, lon, elev = NA){
  
  return(data.frame(latitude = lat, longitude = lon, elevation = elev))
  
}

#' remove_attributes
#'
#'  This function clears attributes
#'  
#'  The parameters can be shorted to lat, lon if space is short.
#' 
#' @param x the variable which to remove the attributes
#' @keywords attr attributes
#' @examples
#'
#' df <- list(
#'   fun = function(x){sum(x)},
#'   fun1 = function(x){mean(x)},
#'   fun2 = function(x){sd(x)} 
#' )
#'
#' df$fun <- remove_attributes(df$fun)
#'
#' df <- lapply(df, remove_attributes)
#'
#' 
#' @export
#' 
#' 
remove_attributes <- function(x) {attributes(x) <- NULL; return(x)}

