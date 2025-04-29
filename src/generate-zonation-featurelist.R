generate_zonation_featurelist <- function(zonation_dir = NULL,
                                          feature_list = NULL,
                                          feature_weights = NULL)
{
  if(!is.null(feature_weights))
  {
    if (length(feature_list) != length(feature_weights))
    {
      stop("Length of feature weights do not match lenght of feature list.")
    }
  }

  
  # First create featurelist
  featurelist_filename <- paste0(zonation_dir, "/featurelist.txt")
  
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
                                   "     ../../../../", 
                                   feature_list[i], "\n")
    }else
    {
      featurelist_string <- paste0(featurelist_string, "../../../../", 
                                   feature_list[i], "\n")
    }
  }
  writeLines(featurelist_string, con = featurelist_file)
  
  close(featurelist_file)

  
  return(featurelist_filename)
}


