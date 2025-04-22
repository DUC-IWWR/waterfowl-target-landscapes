reproject_vector <- function(vector_file = NULL,
                             ref = NULL)
{
  vector_to_reproject <- vect(vector_file)
  reference_raster <- rast(ref)
  
  new_vector <- project(vector_to_reproject, crs(reference_raster))
  
  filename = paste0("data/generated/snapped-rasters/", 
                    names(new_vector), 
                    "_snapped.shp")
  
  writeVector(new_vector, 
              filename = filename, 
              filetype = "ESRI Shapefile",
              overwrite = TRUE)
  
  return(filename)
}


