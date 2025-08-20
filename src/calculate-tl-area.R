calculate_tl_area <- function(target_landscape = NULL,
                              target_crs = NULL)
{
  crs(target_landscape) <- target_crs
  return(sum(expanse(target_landscape, unit = "km")))
}
