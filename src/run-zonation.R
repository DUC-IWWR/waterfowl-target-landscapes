run_zonation <- function(zonation_command_path = NULL,
                         output_dir = NULL)
{
  # Run the resulting zonation file
  system(command = zonation_command_path)
  
  rankmap_path <- paste0(output_dir, "/rankmap.tif")
  
  return(rankmap_path)
}


