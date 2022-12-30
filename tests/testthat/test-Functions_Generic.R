# This code tests Generic Functions of the waterDataSupport Package

test_that("Tests displaySiteInfo", {
  
  expect_equal(Convert_DMS_to_Decimal('34 34 34.34'), 34.57621,
               tolerance = 0.0001)
  
  expect_no_error(as.International.Date("1992/1/1"))
  
  expect_no_error(as.geospatial.coordinate(lat = 10, lon = 5))
  
  expect_equal(as.geospatial.coordinate(lat = 10, lon = 5)$latitude,  10)
  expect_equal(as.geospatial.coordinate(lat = 10, lon = 5)$longitude,  5)
  expect_equal(as.geospatial.coordinate(lat = 10, lon = 5, elev = 0)$elevation,
               0)
  
})



