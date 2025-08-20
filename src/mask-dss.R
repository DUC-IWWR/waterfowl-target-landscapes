#' This function is needed for the various masks that must be applied to the
#' waterfowl rasters. We need to mask to JUST the PHJV area, then mask out
#' rivers and lakes

mask_dss <- function(raster_file = NULL,
                     phjv = NULL,
                     lakes = NULL,
                     rivers = NULL,
                     target_crs = NULL)
{
  raster_to_mask <- rast(raster_file)
  crs(phjv) <- target_crs
  
  crs(lakes) <- target_crs
  
  crs(rivers) <- target_crs
  
  new_raster <- mask(raster_to_mask, phjv) |>
    mask(mask = lakes, inverse = TRUE) |>
    mask(mask = rivers, inverse = TRUE)
  
  filename = paste0("data/generated/masked-rasters/", 
                    varnames(new_raster), 
                    "_masked.tif")
  
  writeRaster(new_raster, 
              filename = filename, 
              overwrite = TRUE)
  
  return(filename)
}


