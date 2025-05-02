calculate_proportion_area <- function(target_landscape = NULL,
                                      rankmap = NULL)
{
  crs(target_landscape) <- crs(rankmap)
  return(expanse(target_landscape, unit = "km"))
}