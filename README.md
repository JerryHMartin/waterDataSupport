# waterDataSupport
R package with wrappers for downloading USGS and NOAA data

This package wraps multiple packages in R to perform basic functions with streamflow data from servers.  

This package is primarily to supplement processing stream discharge data. It may be expanded to do more later.

This package borrows heavily from other sources including:

* vignettes associated with the waterData package.
* USGS information on the the dataRetrieval package
* leaflet for making plots

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

This function draws a map of a site in the state which it is loacted. 

#### ExportDailyValuesToCSV(dailyValues, fileName, metric = TRUE)

This function exports daily values imported by the waterData package to csv format.

#### ExportMonthlyValuesToCSV(monthlyValues, fileName, metric = TRUE)

This function exports the monthly values from the readNWISstat function in the dataRetrieval package to csv.

#### getUSGSHUC(siteID, plotmap = TRUE, zoomFactor = 10)

This function can get the hydraullic unit code of the watershed a stream guage is sitting on given the siteID of the stream guage. This function can produce a map with the informaiton
