####### Function Information ######################
# Brandon P.M. Edwards & Barry Robinson
# Waterfowl Target Landscapes
# snap-density-rasters.R
# Created April 2025
# Last Updated April 2025

reproject_raster <- function(raster_file = NULL,
                             ref = NULL)
{
  raster_to_reproject <- rast(raster_file)
  reference_raster <- rast(ref)
  
  new_raster <- project(raster_to_reproject, reference_raster)
  
  filename = paste0("data/generated/snapped-rasters/", 
                    names(new_raster), 
                    "_snapped.tif")
  
  writeRaster(new_raster, 
              filename = filename, 
              overwrite = TRUE)
  
  return(filename)
}


