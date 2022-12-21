#install.packages("devtools")
#install.packages("roxygen2")

library(devtools)
library(roxygen2)

setwd("P:/Staff/Martin, Jerry/Software/waterDataSupport")
devtools::create("waterDataSupport")



setwd("P:/Staff/Martin, Jerry/Software/waterDataSupport/waterDataSupport")
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


setwd("P:/Staff/Martin, Jerry/Software/waterDataSupport/waterDataSupport")
roxygen2::roxygenise()


setwd("P:/Staff/Martin, Jerry/Software/waterDataSupport")
install("waterDataSupport")

library(waterDataSupport)


# devtools::build_vignettes()

#usethis::use_testthat()
#usethis::use_test()
devtools::test()
devtools::check()

testthat::test_file("tests/testthat/test-SiteFunctionsUSGS.R")

