generate_scenario_target_factory <- function(scenarios = scenarios)
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
                                  target_crs = target_crs)
    ),
    tar_target(
      name = tl_prop_population,
      command = calculate_tl_population(target_landscape = tl,
                                        species_list = c(dss_masked_mall,
                                                         dss_masked_gadw,
                                                         dss_masked_nopi,
                                                         dss_masked_bwte,
                                                         dss_masked_nsho,
                                                         dss_masked_canv,
                                                         dss_masked_redh,
                                                         dss_masked_stacked_v3),
                                        species_names = c("MALL", "GADW", "NOPI",
                                                          "BWTE", "NSHO", "CANV",
                                                          "REDH", "ALL"),
                                        target_crs = target_crs)
    ),
    tar_target(
      name = tl_prop_area_province,
      command = calculate_tl_area_province(target_landscape = tl,
                                           provinces = provinces,
                                           target_crs = target_crs)
    ),
    tar_target(
      name = tl_prop_population_province,
      command = calculate_tl_population_province(target_landscape = tl,
                                                 species_list = c(dss_masked_mall,
                                                                  dss_masked_gadw,
                                                                  dss_masked_nopi,
                                                                  dss_masked_bwte,
                                                                  dss_masked_nsho,
                                                                  dss_masked_canv,
                                                                  dss_masked_redh,
                                                                  dss_masked_stacked_v3),
                                                 provinces = provinces,
                                                 species_names = c("MALL", "GADW", "NOPI",
                                                                   "BWTE", "NSHO", "CANV",
                                                                   "REDH", "ALL"),
                                                 target_crs = target_crs)
    )
  )
  
  return(scenario_target_factory)
}

