calculate_tl_area_province <- function(target_landscape = NULL,
                                       provinces = NULL,
                                       rankmap = NULL)
{
  crs(target_landscape) <- crs(rankmap)
  crs(provinces) <- crs(rankmap)
  total_area <- expanse(target_landscape, unit = "km")
  
  provs <- c("MB", "SK", "AB")
  prop_area <- vector(mode = "numeric", length = length(provs))
  
  for (p in provs)
  {
    
  }
  
  return(prop_area)
}