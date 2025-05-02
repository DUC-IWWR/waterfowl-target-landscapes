mask_raster <- function(raster_file = NULL,
                        mask_vect = NULL)
{
  raster_to_mask <- rast(raster_file)
  crs(mask_vect) <- crs(raster_to_mask)
  new_raster <- mask(raster_to_mask, mask_vect)
  
  filename = paste0("data/generated/masked-rasters/", 
                    names(new_raster), 
                    "_masked.tif")
  
  writeRaster(new_raster, 
              filename = filename, 
              overwrite = TRUE)
  
  return(filename)
}


