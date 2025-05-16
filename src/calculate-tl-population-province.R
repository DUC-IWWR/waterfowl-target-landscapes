calculate_tl_population_province <- function(target_landscape = NULL,
                                             species_list = NULL,
                                             provinces = NULL,
                                             species_names = NULL)
{
  species <- lapply(species_list, rast)
  
  crs(target_landscape) <- crs(species[[1]])
  crs(provinces) <- crs(species[[1]])
  
  provs <- c("MB", "SK", "AB")
  species_pops_prov <- matrix(data = 0, 
                         nrow = length(species),
                         ncol = length(provs))
  
  species <- lapply(species, function (x) x * 0.16)
  species_total_pops <- unlist(lapply(species, function (x) sum(rowSums(x, na.rm = TRUE))))
  
  for (i in 1:length(provs))
  {
    tl_reduced <- intersect(target_landscape,
                            provinces[which(provinces$PROV == provs[i]), ])
    for (j in 1:length(species))
    {
      pop_df <- extract(species[[j]], tl_reduced)
      
      species_pops_prov[j,i] <- sum(pop_df[,2], na.rm = TRUE) / species_total_pops[j]
    }
  }
  rownames(species_pops_prov) <- species_names
  colnames(species_pops_prov) <- provs
  return(species_pops_prov)
}