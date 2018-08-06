#' Precipitation coverage statistics
#'
#'  Precipitation data is known to have gaps for any number of reasons
#'  
#'  This function is intended to produce a table of outputs concerning
#'  how well the range of a particular statistic is covered.
#'
#' @param precipitationData a dataframe output by meteo_pull_monitors 
#' from the rnoaa package
#'
#' @return print output of a table with coverage statistics
#' @export
#'
#' @examples
#' 
#' precipitationCoverageStats(precipitationData)
#' 
precipitationCoverageStats <- function(precipitationData,
                                       type = "html") {
  
  precipitationData$id <- as.factor(precipitationData$id)
  precipitationData$date <- as.Date(precipitationData$date)
  
  coverageTable <- data.frame(stations = levels(precipitationData$id))
  
  coverageTable$prcpCoverage <- sapply(coverageTable$stations,  function(x){
    mean(is.na(precipitationData[precipitationData$id == x,]$prcp)) * 100
  })
  
  coverageTable$tmaxCoverage <- sapply(coverageTable$stations,  function(x){
    mean(is.na(precipitationData[precipitationData$id == x,]$tmax)) * 100 
  })
  
  coverageTable$tminCoverage <- sapply(coverageTable$stations,  function(x){
    mean(is.na(precipitationData[precipitationData$id == x,]$tmin)) * 100
  })
  
  coverageTable$tavgCoverage <- sapply(coverageTable$stations,  function(x){
    mean(is.na(precipitationData[precipitationData$id == x,]$tavg)) * 100 
  })
  
  
  coverageTable$stations <- as.character(coverageTable$stations)
  
  require(xtable, quietly = TRUE)
  print(
    xtable(coverageTable,
           cap = paste("percent coverage per station"),
           digits = 2
    ), type = type, include.rownames = FALSE)
}
