generate_zonation_settings <- function(zonation_dir = NULL)
{
  z5_filename <- paste0(zonation_dir, "/settings.z5")
  z5_file <- file(z5_filename)
  writeLines(paste0("feature list file = featurelist.txt"), con = z5_file)
  close(z5_file)
  
  return(z5_filename)
}