create_scenario_output_dir <- function(scenario_name = NULL)
{
  dir_name <- paste0("output/zonation/", scenario_name)
  
  if (dir.exists(dir_name))
  {
    message(paste0(scenario_name), " already exists, so just using this directory.")
    return(dir_name)
  }else
  {
    dir.create(dir_name)
  }
  
  return(dir_name)
}