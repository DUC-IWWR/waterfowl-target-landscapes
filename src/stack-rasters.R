stack_rasters <- function(raster_list = NULL,
                          new_raster_name = NULL)
{
  raster_list <- lapply(raster_list, rast)
  raster_collection <- terra::sprc(raster_list)
  
  new_raster <- terra::mosaic(raster_collection, fun = "sum")
  
  filename = paste0("data/generated/stacked-rasters/", 
                    new_raster_name, 
                    "_snapped.tif")
  
  writeRaster(new_raster,
              filename = filename,
              overwrite = TRUE)
  
  return(filename)
}


