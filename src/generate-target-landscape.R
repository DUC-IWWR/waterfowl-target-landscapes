generate_target_landscape <- function(rankmap = NULL,
                                      scenario_name = NULL,
                                      threshold = NULL,
                                      min_poly = NULL,
                                      max_hole = NULL,
                                      smooth = NULL)
{
  #reclassify raster based on user-defined threshold
  rcl <- matrix(data = c(-0.01,threshold,threshold,1.0,NA,1),
               nrow=2, ncol=3)
  
  tl <- terra::classify(x = rankmap, rcl = rcl) |>
    terra::as.polygons(aggregate = T) |>
    smoothr::drop_crumbs(threshold = min_poly) |>
    smoothr::fill_holes(threshold = max_hole) |>
    smoothr::smooth(method = "ksmooth", smoothness = smooth)
  
  terra::crs(tl) <- terra::crs(rankmap)
  
  output_dir <- paste0("output/target-landscapes/", scenario_name)
  if (!dir.exists(file.path(output_dir)))
  {
    dir.create(file.path(output_dir))
  }
  
  file = paste0(output_dir, "/TL_", threshold, ".shp")
  terra::writeVector(x = tl, filename = file, filetype = "ESRI Shapefile", overwrite = TRUE)

  return(tl)
}
