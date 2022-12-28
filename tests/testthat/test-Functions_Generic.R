# This code tests Generic Functions of the waterDataSupport Package

test_that("Tests displaySiteInfo", {
  expect_equal(Convert_DMS_to_Decimal('34 34 34.34'), 34.57621,
               tolerance = 0.0001)
  expect_no_error(as.International.Date("1992/1/1"))
  
})



