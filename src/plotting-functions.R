plot_sp_vs_phjv_prop <- function(population_df = NULL,
                                 area_df = NULL,
                                 phjv = NULL,
                                 crs = NULL)
{
  combined_df <- merge(population_df, area_df[, c("scenario_name", "area")], by = "scenario_name")
  terra::crs(phjv) <- crs
  ppr_area <- terra::expanse(phjv[which(phjv$CA_REGION == "PPR"), ], unit = "km")
  combined_df$ppr_prop <- combined_df$area / ppr_area
  
  #species <- unique(combined_df$grouping)
  rankmap <- unique(combined_df$rankmap)
  poly_size <- unique(combined_df$min_poly)
  
  plot_tibble <- tidyr::crossing(rankmap, poly_size)
  
  plot_list <- vector(mode = "list", length = nrow(plot_tibble))
  
  n <- 1
  for (i in rankmap)
  {
    for (j in poly_size)
    {
      to_plot <- combined_df[which(combined_df$rankmap == i &
                                     combined_df$min_poly == j), ]
      p <- ggplot(data = to_plot, aes(x = ppr_prop, 
                                       y = population, 
                                       group = grouping,
                                       color = grouping)) +
        geom_line() +
        NULL
      
      plot_list[[n]] <- p
      n <- n+1
    }
  }
  
  plot_tibble$plot_list <- plot_list
  
  return(plot_tibble)
}