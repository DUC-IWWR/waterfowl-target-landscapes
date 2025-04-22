generate_target_landscape <- function(rankmap_path = NULL,
                                      scenario_name = NULL,
                                      threshold = NULL,
                                      min_poly = NULL,
                                      max_hole = NULL,
                                      smooth = NULL)
{
  rankmap <- rast(rankmap_path)
  #reclassify raster based on user-defined threshold
  rcl = matrix(data = c(-0.01,threshold,threshold,1.0,NA,1),
               nrow=2, ncol=3)
  
  tmp = classify(x = rankmap, rcl = rcl)#, filename = paste0("Output/ZonationPostprocessing/ReclassRasters/", "waterfowlTL_", threshold, "_", names(raster),".tif"))
  
  #transform to polygon for sf
  tl = as.polygons(tmp, aggregate = T)
  tl = st_as_sf(tl)
  
  #remove small isolated polygons
  tl_drop = drop_crumbs(tl, threshold = min_poly) #156km^2 = 156000000m^2
  
  #fill holes in polygons
  tl_fill = fill_holes(tl_drop, threshold = max_hole)
  
  #smooth polygon borders
  tl_smooth = smooth(tl_fill, method = "ksmooth", smoothness = smooth)
  
  output_dir <- paste0("output/target-landscapes/", scenario_name)
  if (!dir.exists(file.path(output_dir)))
  {
    dir.create(file.path(output_dir))
  }
  
  file = paste0(output_dir, "/TL_", threshold, ".shp")
  st_write(tl_smooth, dsn = file, filetype = "ESRI Shapefile", append = FALSE)

  return(file)
}
