#' ExportDailyValuesToCSV
#'
#' This function exports daily values output by the importDVs
#' function to a CSV file.
#'
#' This function outputs to the working directory.  The directory can be set with 
#' the setwd command.
#'
#' This function only supports discharge data.
#'
#' @param dailyValues daily values output by the importDVs in the waterData package
#' @param fileName file name to save CSV file to
#' @param  metric convert value to metric
#' @keywords USGS
#' @examples
#'
#' site = list(
#'    staid = "02131000",                     # site number
#'    code = "00060",                         # code for discharge 
#'    stat = "00003",                         # code for mean   
#' )
#' 
#' DailyValues <- do.call(importDVs, site)
#' 
#' ExportDailyValuesToCSV(DailyValues, 
#'                        paste0("Daily_Values_for_Site_", site$staid))
#'
#' @export

ExportDailyValuesToCSV <- function(dailyValues, 
                                   fileName,
                                   metric = TRUE){

  
  #sort through the codes for data types and make metric conversions
  if(attr(dailyValues, "code") == "00060"){ # discharge
    dataType = "Discharge"
    if(metric){
      dailyValues$val <- dailyValues$val * 0.0283168 # cubic feet to cubic meter conversion
    }
  }  
  
  # drop irrelevant columns
  within(dailyValues, rm(staid))
  
  # reorder columns
  dailyValues <- dailyValues[c("dates", "val", "qualcode")]
  

  
  # rename columns
  colnames(dailyValues)[colnames(dailyValues)=="val"] <- dataType
  
  write.csv(dailyValues, file = paste0(fileName, ".csv"))
  
  
}