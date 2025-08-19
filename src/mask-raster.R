#' This function is needed for the various masks that must be applied to the
#' waterfowl rasters. We need to mask to JUST the PHJV area, then mask out
#' rivers and lakes

mask_raster <- function(raster_file = NULL,
                        phjv = NULL,
                        lakes = NULL,
                        rivers = NULL)
{
  raster_to_mask <- rast(raster_file)
  crs(phjv) <- crs(raster_to_mask)
  crs(lakes) <- crs(raster_to_mask)
  crs(rivers) <- crs(raster_to_mask)
  new_raster <- mask(raster_to_mask, phjv) |>
    mask(lakes) |>
    mask(rivers)
  
  filename = paste0("data/generated/masked-rasters/", 
                    names(new_raster), 
                    "_masked.tif")
  
  writeRaster(new_raster, 
              filename = filename, 
              overwrite = TRUE)
  
  return(filename)
}


