run_zonation <- function(feature_list = NULL,
                         feature_weights = NULL,
                         scenario_name = NULL,
                         zonation_mode = NULL)
{
  if (!is.null(feature_weights))
  {
    if (length(feature_list) != length(feature_weights))
    {
      stop("Length of feature weights do not match lenght of feature list.")
    }
  }

  
  # First create featurelist
  featurelist_filename <- paste0("data/generated/zonation/", scenario_name, "_featurelist.txt")
  
  featurelist_file <- file(featurelist_filename)
  
  if (!is.null(feature_weights))
  {
    featurelist_string <- "\"weight\" \"filename\"\n"
  }else
  {
    featurelist_string <- "\"filename\"\n"
  }
  
  for (i in 1:length(feature_list))
  {
    if (!is.null(feature_weights))
    {
      featurelist_string <- paste0(featurelist_string,
                                   feature_weights[i], 
                                   "     ../../../", 
                                   feature_list[i], "\n")
    }else
    {
      featurelist_string <- paste0(featurelist_string, "../../../", 
                                   feature_list[i], "\n")
    }
  }
  writeLines(featurelist_string, con = featurelist_file)
  
  close(featurelist_file)
  
  # Next create the z5 file
  z5_filename <- paste0("data/generated/zonation/", scenario_name, "_", zonation_mode, ".z5")
  z5_file <- file(z5_filename)
  writeLines(paste0("feature list file = ", scenario_name, "_featurelist.txt"), con = z5_file)
  close(z5_file)
  
  # Now generate the zonation cmd file
  cmd_filename <- paste0("data/generated/zonation/", scenario_name, "_", zonation_mode, ".cmd")
  cmd_file <- file(cmd_filename)
  cmd_string <- "@setlocal\n"
  cmd_string <- paste0(cmd_string, "@PATH=C:\\Program Files (x86)\\Zonation5;%PATH%\n")
  cmd_string <- paste0(cmd_string, "z5_16bit --mode=CAZMAX ")
  cmd_string <- paste0(cmd_string, "data/generated/zonation/", scenario_name, "_", zonation_mode, ".z5 ")
  cmd_string <- paste0(cmd_string, "output/zonation/", scenario_name, "_", zonation_mode, "\n@pause")
  writeLines(cmd_string, cmd_file)
  close(cmd_file)
  
  # Run the resulting zonation file
  system(command = cmd_filename)
  
  rankmap_path <- paste0("output/zonation/", scenario_name, "_", zonation_mode, "/rankmap.tif")
  
  return(rast(rankmap_path))
}