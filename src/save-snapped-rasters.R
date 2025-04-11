save_snapped_rasters <- function(rasters = NULL)
{
  lapply(rasters, function(x) {writeRaster(x, filename = paste0("data/generated/snapped-rasters/", names(x), "_snapped.tif"), overwrite = TRUE)})
}