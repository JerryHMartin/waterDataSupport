
#install.packages("devtools")
#install.packages("roxygen2")

library(devtools)
library(roxygen2)


support_Dir = ""

setwd(support_Dir)


devtools::create("waterDataSupport")




# devtools::use_package("waterData")
# devtools::use_package("gridExtra")
# devtools::use_package("grid")
# devtools::use_package("xtable")
# devtools::use_package("sp")
# devtools::use_package("maps")
# devtools::use_package("mapdata")
# devtools::use_package("maptools")
# devtools::use_package("ggmap")
# devtools::use_package("dataRetrieval")
# devtools::use_package("rgdal")
# devtools::use_package("leaflet")
# devtools::use_package("raster")
# devtools::use_package("rnoaa")
# devtools::use_package("geosphere")
# devtools::use_package("elevatr")




roxygen2::roxygenise()



roxygen2::roxygenise()



install("waterDataSupport")

library(waterDataSupport)


# devtools::build_vignettes()

#usethis::use_testthat()
#usethis::use_test()
devtools::test()
devtools::check()

testthat::test_file("tests/testthat/test-SiteFunctionsUSGS.R")

