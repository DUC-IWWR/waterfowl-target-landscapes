calculate_tl_population <- function(target_landscape = NULL,
                                    species_list = NULL)
{
  species <- lapply(species_list, rast)
  population <- vector(mode = "numeric", length = length(species))
  
  for (i in 1:length(species))
  {
    if (i == 1)
    {
      crs(target_landscape) <- crs(species[[i]])
    }
    
    pop_df <- extract(species[[i]], target_landscape)
    population[i] <- sum(pop_df[,2], na.rm = TRUE) / sum(rowSums(species[[i]], na.rm = TRUE))
  }
  
  return(population)
}