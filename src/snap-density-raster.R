####### Function Information ######################
# Brandon P.M. Edwards & Barry Robinson
# Waterfowl Target Landscapes
# snap-density-raster.R
# Created April 2025
# Last Updated August 2025

snap_density_raster <- function(raster_file = NULL,
                                ref = NULL)
{
  raster_to_reproject <- rast(raster_file)
  
  new_raster <- project(x = raster_to_reproject,
                        y = ref)
  
  filename = paste0("data/generated/snapped-rasters/", 
                    names(new_raster), 
                    "_snapped.tif")
  
  writeRaster(new_raster, 
              filename = filename, 
              overwrite = TRUE)
  
  return(filename)
}


