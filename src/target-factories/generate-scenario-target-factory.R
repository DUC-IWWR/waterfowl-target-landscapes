generate_scenario_target_factory <- function(scenarios = NULL)
{
  scenario_target_factory <- tar_map(
    values = scenarios,
    names = scenario_name,
    unlist = FALSE,
    tar_terra_vect(
      name = tl,
      command = generate_target_landscape(rankmap = zonation_rankmap,
                                          scenario_name = scenario_name,
                                          threshold = threshold,
                                          min_poly = min_poly,
                                          max_hole = 70000000,
                                          smooth = 8)
    ),
    tar_target(
      name = tl_prop_area,
      command = calculate_tl_area(target_landscape = tl,
                                  rankmap = zonation_rankmap)
    ),
    tar_target(
      name = tl_prop_population,
      command = calculate_tl_population(target_landscape = tl,
                                        species_list = c(mall_masked,
                                                         gadw_masked,
                                                         nopi_masked,
                                                         bwte_masked,
                                                         nsho_masked,
                                                         canv_masked,
                                                         redh_masked,
                                                         species_7_masked),
                                        species_names = c("MALL", "GADW", "NOPI",
                                                          "BWTE", "NSHO", "CANV",
                                                          "REDH", "ALL"))
    ),
    tar_target(
      name = tl_prop_area_province,
      command = calculate_tl_area_province(target_landscape = tl,
                                           provinces = provinces,
                                           rankmap = zonation_rankmap)
    ),
    tar_target(
      name = tl_prop_population_province,
      command = calculate_tl_population_province(target_landscape = tl,
                                                 species_list = c(mall_masked,
                                                                  gadw_masked,
                                                                  nopi_masked,
                                                                  bwte_masked,
                                                                  nsho_masked,
                                                                  canv_masked,
                                                                  redh_masked,
                                                                  species_7_masked),
                                                 provinces = provinces,
                                                 species_names = c("MALL", "GADW", "NOPI",
                                                                   "BWTE", "NSHO", "CANV",
                                                                   "REDH", "ALL"))
    )
  )
  
  return(scenario_target_factory)
}

