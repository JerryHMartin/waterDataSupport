# This code tests NOAA Stations Code



test_that("Test NOAA Stations", {

  expect_no_error(Get_NOAA_Stations(localSave = FALSE, refresh = FALSE))

  })
