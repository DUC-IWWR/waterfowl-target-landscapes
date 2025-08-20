calculate_tl_area_province <- function(target_landscape = NULL,
                                       provinces = NULL,
                                       target_crs = NULL)
{
  crs(target_landscape) <- target_crs
  crs(provinces) <- target_crs
  total_area <- sum(expanse(target_landscape, unit = "km"))
  
  provs <- c("MB", "SK", "AB")
  prop_area <- vector(mode = "numeric", length = length(provs))
  
  for (i in 1:length(provs))
  {
    tl_reduced <- intersect(target_landscape,
                            provinces[which(provinces$PROV == provs[i]), ])
    crs(tl_reduced) <- target_crs
    prop_area[i] <- sum(expanse(tl_reduced, unit = "km")) / total_area
  }
  names(prop_area) <- provs
  return(prop_area)
}