
land_masker <- function(grid, map) {
  tst <- over(as(spTransform(rasterToPoints(setValues(grid, 0), sp = TRUE),  projection(map)), 
                 "SpatialPoints"), 
              geometry(map))
  r <- setValues(grid, 0)
  r[!is.na(tst)] <- NA
  r
}
#notland <- land_masker(master, countriesLow)
#writeRaster(notland, "notland.grd")

