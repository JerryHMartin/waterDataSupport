
#install.packages("devtools", dependencies = TRUE)
#install.packages("roxygen2")

library(devtools)
library(roxygen2)


support_Dir = ""

setwd(support_Dir)


devtools::create("waterDataSupport")






roxygen2::roxygenise()



install("waterDataSupport")

library(waterDataSupport)


# devtools::build_vignettes()

#usethis::use_testthat()
#usethis::use_test()
devtools::test()
devtools::check()

testthat::test_file("tests/testthat/test-SiteFunctionsUSGS.R")

