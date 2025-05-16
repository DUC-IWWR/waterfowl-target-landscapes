wrangle_df <- function(df = NULL,
                       type = NULL,
                       metric = NULL,
                       scenarios = scenarios)
{
  if (type == "scalar")
  {
    return(wrangle_df_scalar(df = df,
                             metric = metric,
                             scenarios = scenarios))
  }else if (type == "vector")
  {
    return(wrangle_df_vector(df = df,
                             metric = metric,
                             scenarios = scenarios))
  }else if (type == "matrix")
  {
    return(wrangle_df_matrix(df = df,
                             metric = metric,
                             scenarios = scenarios))
  }
  

}

wrangle_df_scalar <- function(df = NULL,
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

wrangle_df_vector <- function(df = NULL,
                              metric = NULL,
                              scenarios = scenarios)
{
  row_names <- rownames(df)
  df <- as.data.frame(t(df))
  df$scenario_name <- rownames(df)
  df <- reshape2::melt(df, id = "scenario_name")
  names(df) <- c("scenario_name", "grouping", metric)
  
  df$rankmap <- rep(as.character(scenarios$zonation_rankmap), times = length(row_names))
  df$min_poly <- rep(scenarios$min_poly, times = length(row_names))
  df$threshold <- rep(scenarios$threshold, times = length(row_names))
  
  return(df)
}

wrangle_df_matrix <- function(df = NULL,
                              metric = NULL,
                              scenarios = scenarios)
{
  row_names <- rownames(df)
  df <- as.data.frame(t(df))
  df$scenario_name <- rownames(df)
  df <- reshape2::melt(df, id = "scenario_name")
  df$grouping_2 <- sub('.*\\.', '', df$scenario_name)
  names(df) <- c("scenario_name", "grouping_1", "value", "grouping_2")
  
  df$rankmap <- rep(rep(as.character(scenarios$zonation_rankmap), times = length(row_names)),
                    each = length(unique(df$grouping_2)))
  df$min_poly <- rep(rep(scenarios$min_poly, times = length(row_names)),
                     each = length(unique(df$grouping_2)))
  df$threshold <- rep(rep(scenarios$threshold, times = length(row_names)),
                      each = length(unique(df$grouping_2)))
  
  return(df)
}