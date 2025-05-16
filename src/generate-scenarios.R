generate_scenarios <- function()
{
  zonation_rankmap <- c(quote(separate_layers_rankmap_cazmax),
                        quote(separate_layers_rankmap_caz1),
                        quote(separate_layers_rankmap_caz2),
                        quote(separate_layers_weighted_rankmap_cazmax),
                        quote(separate_layers_weighted_rankmap_caz1),
                        quote(separate_layers_weighted_rankmap_caz2),
                        quote(stacked_layers_rankmap_cazmax),
                        quote(stacked_layers_rankmap_caz1),
                        quote(stacked_layers_rankmap_caz2),
                        quote(combined_rankmap_cazmax),
                        quote(combined_rankmap_caz1),
                        quote(combined_rankmap_caz2))
  min_poly <- c(156000000, 128000000, 100000000)
  threshold <- seq(0.65,0.85, by = 0.01)
  
  scenarios <- tidyr::crossing(zonation_rankmap, min_poly, threshold)
  scenarios$zonation_mode <- sub('.*\\_', '', as.character(scenarios$zonation_rankmap))
  scenarios$scenario_name <- paste0(as.character(scenarios$zonation_rankmap),
                                    "_poly",
                                    scenarios$min_poly / 1000000,
                                    "_thres",
                                    scenarios$threshold)
  
  return(scenarios)
  
}
