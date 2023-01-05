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
  
  df <- list(
     fun = function(x){sum(x)},
     fun1 = function(x){mean(x)},
     fun2 = function(x){sd(x)} 
  )
  
  df$fun <- remove_attributes(df$fun)
  expect_null(attributes(df$fun))
  
  df <- lapply(df, remove_attributes)
  
  expect_null(attributes(df$fun1))
  expect_null(attributes(df$fun2))
  
})



