wrangle_df <- function(df = NULL,
                       metric = NULL,
                       scenarios = scenarios)
{
  df <- as.data.frame(t(df))
  df$scenario_name <- rownames(df)
  names(df) <- c(metric, "scenario_name")
  df$rankmap <- as.character(scenarios$zonation_rankmap)
  df$min_poly <- scenarios$min_poly
  df$threshold <- scenarios$threshold
  
  
  return(df)
}