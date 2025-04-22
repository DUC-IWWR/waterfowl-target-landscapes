plot_target_landscape <- function(tl_path = NULL,
                                  old_tl_path = NULL,
                                  width = NULL,
                                  height = NULL,
                                  res = NULL,
                                  units = NULL,
                                  scenario_name = NULL)
{
  tl <- terra::vect(tl_path)
  if(!is.null(old_tl_path))
  {
    old_tl <- terra::vect(old_tl_path)
  }
  
  filename <- paste0("output/plots/", scenario_name, ".png")
  
  png(filename = filename,
      width = width,
      height = height,
      res = res,
      units = units)
  terra::plot(tl)
  terra::lines(project(old_tl, tl), add = TRUE, col = "red")
  dev.off()
  
  return(filename)
}
