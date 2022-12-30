# waterDataSupport
R package for downloading USGS and NOAA stream flow and precipitation data, which sacrifices robustness of the packages normally used for downloading for simplicity. 

## Purpose
This package, which contains mostly wrapper functions, borrows heavily from other sources including:

* vignettes associated with the waterData package.
* USGS information on the the dataRetrieval package
* leaflet for making plots
* rnoaa for precipitaiton data

### Installing waterDataSupport

Instructions for installing devtools can be found at https://www.r-project.org/nosvn/pandoc/devtools.html.
To install this library 

```r
    library(devtools)
    install_github("agriculturist/waterDataSupport")
```

### Loading Library

After the library is installed it is to be loaded.

```r
    library(waterDataSupport)
```

### Available Functions





#### displaySiteInfo(siteID)

This function displays information about a particular USGS site.

#### displaySiteLocation(siteID)

This function locates a site on Google Maps.  

#### displaySiteLocationInState(siteID)

This function draws a map of a site in the state which it is located. 

#### ExportDailyValuesToCSV(dailyValues, fileName, metric = TRUE)

This function exports daily values imported by the waterData package to csv format.

#### ExportMonthlyValuesToCSV(monthlyValues, fileName, metric = TRUE)

This function exports the monthly values from the readNWISstat function in the dataRetrieval package to csv.

#### getUSGSHUC(siteID, plotmap = TRUE, zoomFactor = 10)

This function can get the hydraullic unit code of the watershed a stream guage is sitting on given the siteID of the stream guage. This function can produce a map with the informaiton
