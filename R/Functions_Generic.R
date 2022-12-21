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



