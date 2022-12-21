waterData_URL <- list(
  National_Hydrography_Dataset =
    "https://basemap.nationalmap.gov/arcgis/services/USGSTopo/MapServer/WmsServer"
)
setwd("P:/Staff/Martin, Jerry/Software/waterDataSupport/waterDataSupport/data")
save(waterData_URL, file="waterData_URL.rda")