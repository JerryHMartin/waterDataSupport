# This code tests USGS Site Fuctions Code



test_that("Tests displaySiteInfo", {
  expect_no_error(displaySiteInfo("02131000"))
})
