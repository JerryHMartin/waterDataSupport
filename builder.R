
install.packages("devtools", dependencies = TRUE)
#install.packages("roxygen2")



library(devtools)




library(roxygen2)


support_Dir = ""

setwd(support_Dir)


devtools::create("waterDataSupport")


<<<<<<< HEAD

=======
>>>>>>> f561acd7fdbe6188b162e793aa3e88643d6dba29
roxygen2::roxygenise()



install("waterDataSupport")

library(waterDataSupport)


# devtools::build_vignettes()

#usethis::use_testthat()
#usethis::use_test()
devtools::test()
devtools::check()

testthat::test_file("tests/testthat/test-SiteFunctionsUSGS.R")

<<<<<<< HEAD
=======
testthat::test_file("tests/testthat/test-Functions_NOAA_Stations.R")

usethis::use_vignette("station_download")

>>>>>>> f561acd7fdbe6188b162e793aa3e88643d6dba29

