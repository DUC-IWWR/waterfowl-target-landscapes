run_zonation <- function(feature_list = NULL,
                         scenario_name = NULL,
                         zonation_mode = NULL)
{
  # First create featurelist
  featurelist_filename <- paste0("data/generated/", scenario_name, "_featurelist.txt")
  
  featurelist_file <- file(featurelist_filename)
  featurelist_string <- "\"filename\"\n"
  for (f in feature_list)
  {
    featurelist_string <- paste0(featurelist_string, "../../", f, "\n")
  }
  writeLines(featurelist_string, con = featurelist_file)
  
  close(featurelist_file)
  
  # Next create the z5 file
  z5_filename <- paste0("data/generated/", scenario_name, "_", zonation_mode, ".z5")
  z5_file <- file(z5_filename)
  writeLines(paste0("feature list file = ", scenario_name, "_featurelist.txt"), con = z5_file)
  close(z5_file)
  
  # Now generate the zonation cmd file
  cmd_filename <- paste0("data/generated/", scenario_name, "_", zonation_mode, ".cmd")
  cmd_file <- file(cmd_filename)
  cmd_string <- "@setlocal\n"
  cmd_string <- paste0(cmd_string, "@PATH=C:\\Program Files (x86)\\Zonation5;%PATH%\n")
  cmd_string <- paste0(cmd_string, "z5_16bit --mode=CAZMAX ")
  cmd_string <- paste0(cmd_string, "data/generated/", scenario_name, "_", zonation_mode, ".z5 ")
  cmd_string <- paste0(cmd_string, "output/zonation/", scenario_name, "_", zonation_mode, "\n@pause")
  writeLines(cmd_string, cmd_file)
  close(cmd_file)
  
  # Run the resulting zonation file
  system(command = cmd_filename)
  
  return("hi")
}


