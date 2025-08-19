####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# _targets.R
# Created April 2025
# Last Updated August 2025

####### Import Libraries and External Files #######

library(targets)
library(tarchetypes)
library(geotargets)
library(tibble)
library(crew)

tar_source("src/target-factories/generate-scenario-target-factory.R")
tar_source("src/target-factories/generate-dss-target-factory.R")

tar_source("src/snap-density-raster.R")
tar_source("src/run-zonation.R")
tar_source("src/generate-target-landscape.R")
tar_source("src/plot-target-landscape.R")
tar_source("src/calculate-tl-area.R")
tar_source("src/calculate-tl-population.R")
tar_source("src/mask-dss.R")
tar_source("src/calculate-tl-area-province.R")
tar_source("src/calculate-tl-population-province.R")
tar_source("src/wrangle-df.R")
tar_source("src/plotting-functions.R")
tar_source("src/generate-scenarios.R")

####### Targets ###################################

# Set target options:
tar_option_set(
  packages = c("terra", "smoothr", "ggplot2", "tidyr"),
  controller = crew_controller_local(workers = 10)
)

# Create DSS target factory
dss_target_factory <- generate_dss_target_factory()

# Create scenario target factory
scenarios <- generate_scenarios()
scenario_target_factory <- generate_scenario_target_factory(scenarios)

list(
  
  #' Rather than referencing the CRS of one of the rasters that we are going
  #' to be working on (i.e., the GADW raster), just hard code the target CRS
  #' as a variable. This way the GADW raster does not rely on itself
  #' already being loaded, and the other DSS rasters do not rely on GADW being 
  #' loaded. This can allow for a DSS target factory.
  tar_target(
    name = target_crs,
    command = "PROJCRS[\"Canada_Albers_Equal_Area_Conic\",\n    
    BASEGEOGCRS[\"NAD83\",\n        
    DATUM[\"North American Datum 1983\",\n            
    ELLIPSOID[\"GRS 1980\",6378137,298.257222101004,\n                
    LENGTHUNIT[\"metre\",1]]],\n        
    PRIMEM[\"Greenwich\",0,\n            
    ANGLEUNIT[\"degree\",0.0174532925199433]],\n        
    ID[\"EPSG\",4269]],\n    
    CONVERSION[\"Albers Equal Area\",\n        
    METHOD[\"Albers Equal Area\",\n            
    ID[\"EPSG\",9822]],\n        
    PARAMETER[\"Latitude of false origin\",40,\n            
    ANGLEUNIT[\"degree\",0.0174532925199433],\n            
    ID[\"EPSG\",8821]],\n        
    PARAMETER[\"Longitude of false origin\",-105,\n            
    ANGLEUNIT[\"degree\",0.0174532925199433],\n            
    ID[\"EPSG\",8822]],\n        
    PARAMETER[\"Latitude of 1st standard parallel\",50,\n            
    ANGLEUNIT[\"degree\",0.0174532925199433],\n            
    ID[\"EPSG\",8823]],\n        
    PARAMETER[\"Latitude of 2nd standard parallel\",70,\n            
    ANGLEUNIT[\"degree\",0.0174532925199433],\n            
    ID[\"EPSG\",8824]],\n        
    PARAMETER[\"Easting at false origin\",0,\n            
    LENGTHUNIT[\"metre\",1],\n            
    ID[\"EPSG\",8826]],\n        
    PARAMETER[\"Northing at false origin\",0,\n            
    LENGTHUNIT[\"metre\",1],\n            
    ID[\"EPSG\",8827]]],\n    
    CS[Cartesian,2],\n        
    AXIS[\"easting\",east,\n            
    ORDER[1],\n            
    LENGTHUNIT[\"metre\",1,\n                
    ID[\"EPSG\",9001]]],\n        
    AXIS[\"northing\",north,\n            
    ORDER[2],\n            
    LENGTHUNIT[\"metre\",1,\n                
    ID[\"EPSG\",9001]]]]"
  ),

  dss_target_factory,

  tar_terra_vect(
    name = tl_old,
    vect("data/raw/target-landscapes-previous/PHJV_WaterfowlTargetLandscapes.shp") |>
      project(y = target_crs)
  ),
  tar_terra_vect(
    name = phjv,
    vect("data/raw/PHJV_projected/PHJV_projected.shp") |>
      project(y = target_crs)
  ),
  tar_terra_vect(
    name = provinces,
    vect("data/raw/Provinces_projected/Provinces_projected.shp") |>
      project(y = target_crs)
  ),
  tar_terra_vect(
    name = lakes,
    vect("data/raw/NA Lakes and Rivers/North America Lakes.shp") |>
      project(y = target_crs)
  ),
  tar_terra_vect(
    name = rivers_500m_buffer,
    vect("data/raw/NA Lakes and Rivers/North America Rivers 500mBuffer.shp") |>
      project(y = target_crs)
  ),
  
  ####### Zonation Rankmaps #################################

  tar_terra_rast(
    name = separate_layers_rankmap_cazmax,
    command = run_zonation(feature_list = c(dss_masked_mall,
                                            dss_masked_gadw,
                                            dss_masked_nopi,
                                            dss_masked_bwte,
                                            dss_masked_nsho,
                                            dss_masked_canv,
                                            dss_masked_redh),
                           scenario_name = "separate_layers_cazmax",
                           zonation_mode = "CAZMAX")
  ),
  tar_terra_rast(
    name = separate_layers_rankmap_caz1,
    command = run_zonation(feature_list = c(dss_masked_mall,
                                            dss_masked_gadw,
                                            dss_masked_nopi,
                                            dss_masked_bwte,
                                            dss_masked_nsho,
                                            dss_masked_canv,
                                            dss_masked_redh),
                           scenario_name = "separate_layers_caz1",
                           zonation_mode = "CAZ1")
  ),
  tar_terra_rast(
    name = separate_layers_rankmap_caz2,
    command = run_zonation(feature_list = c(dss_masked_mall,
                                            dss_masked_gadw,
                                            dss_masked_nopi,
                                            dss_masked_bwte,
                                            dss_masked_nsho,
                                            dss_masked_canv,
                                            dss_masked_redh),
                           scenario_name = "separate_layers_caz2",
                           zonation_mode = "CAZ2")
  ),
  
  
  
  
  tar_terra_rast(
    name = separate_layers_weighted_rankmap_cazmax,
    command = run_zonation(feature_list = c(dss_masked_mall,
                                            dss_masked_gadw,
                                            dss_masked_nopi,
                                            dss_masked_bwte,
                                            dss_masked_nsho,
                                            dss_masked_canv,
                                            dss_masked_redh),
                           feature_weights = c(1.0,1.0,2.0,1.0,1.0,1.0,1.0),
                           scenario_name = "separate_layers_weighted_cazmax",
                           zonation_mode = "CAZMAX")
  ),
  tar_terra_rast(
    name = separate_layers_weighted_rankmap_caz1,
    command = run_zonation(feature_list = c(dss_masked_mall,
                                            dss_masked_gadw,
                                            dss_masked_nopi,
                                            dss_masked_bwte,
                                            dss_masked_nsho,
                                            dss_masked_canv,
                                            dss_masked_redh),
                           feature_weights = c(1.0,1.0,2.0,1.0,1.0,1.0,1.0),
                           scenario_name = "separate_layers_weighted_caz1",
                           zonation_mode = "CAZ1")
  ),
  tar_terra_rast(
    name = separate_layers_weighted_rankmap_caz2,
    command = run_zonation(feature_list = c(dss_masked_mall,
                                            dss_masked_gadw,
                                            dss_masked_nopi,
                                            dss_masked_bwte,
                                            dss_masked_nsho,
                                            dss_masked_canv,
                                            dss_masked_redh),
                           feature_weights = c(1.0,1.0,2.0,1.0,1.0,1.0,1.0),
                           scenario_name = "separate_layers_weighted_caz2",
                           zonation_mode = "CAZ2")
  ),
  
  tar_terra_rast(
    name = stacked_layers_rankmap_cazmax,
    command = run_zonation(feature_list = dss_masked_stacked_v3,
                           scenario_name = "stacked_layers_cazmax",
                           zonation_mode = "CAZMAX")
  ),
  tar_terra_rast(
    name = stacked_layers_rankmap_caz1,
    command = run_zonation(feature_list = dss_masked_stacked_v3,
                           scenario_name = "stacked_layers_caz1",
                           zonation_mode = "CAZ1")
  ),
  tar_terra_rast(
    name = stacked_layers_rankmap_caz2,
    command = run_zonation(feature_list = dss_masked_stacked_v3,
                           scenario_name = "stacked_layers_caz2",
                           zonation_mode = "CAZ2")
  ),
  
  # and now a Frankenstein version
  tar_terra_rast(
    name = combined_rankmap_cazmax,
    command = max(stacked_layers_rankmap_cazmax, 
                  separate_layers_weighted_rankmap_cazmax)
  ),
  tar_terra_rast(
    name = combined_rankmap_caz1,
    command = max(stacked_layers_rankmap_caz1, 
                  separate_layers_weighted_rankmap_caz1)
  ),
  tar_terra_rast(
    name = combined_rankmap_caz2,
    command = max(stacked_layers_rankmap_caz2, 
                  separate_layers_weighted_rankmap_caz2)
  ),
  
  ####### Summary Statistics for Old TL #################################  
  
  tar_target(
    name = dss_v2_prop_area,
    command = calculate_tl_area(target_landscape = aggregate(tl_old,
                                                             dissolve = TRUE),
                                rankmap = rast(dss_masked_stacked_v2))
  ),
  tar_target(
    name = dss_v2_prop_population,
    command = calculate_tl_population(target_landscape = aggregate(tl_old,
                                                                   dissolve = TRUE),
                                      species_list = c(dss_masked_stacked_v2))
  ),
  tar_target(
    name = dss_v2_prop_population_province,
    command = calculate_tl_population_province(target_landscape = aggregate(tl_old,
                                                                            dissolve = TRUE),
                                               species_list = c(dss_masked_stacked_v2),
                                               provinces = provinces)
  ),
  tar_target(
    name = dss_v2_prop_area_province,
    command = calculate_tl_area_province(target_landscape = aggregate(tl_old,
                                                                      dissolve = TRUE),
                                         provinces = provinces,
                                         rankmap = rast(dss_masked_stacked_v2))
  ),
  
  
  ####### Scenario Runs and Result Wrangling ###############

  scenario_target_factory,
  
  tar_combine(
    name = area_df,
    scenario_target_factory[[2]],
    command = data.frame(!!!.x) |> wrangle_df(type = "scalar",
                                              metric = "area",
                                              scenarios = scenarios)
  ),
  tar_combine(
    name = population_df,
    scenario_target_factory[[3]],
    command = data.frame(!!!.x) |> wrangle_df(type = "vector",
                                              metric = "population",
                                              scenarios = scenarios)
  ),
  tar_combine(
    name = province_area_df,
    scenario_target_factory[[4]],
    command = data.frame(!!!.x) |> wrangle_df(type = "vector",
                                              metric = "population",
                                              scenarios = scenarios)
  ),
  tar_combine(
    name = pop_by_prov_df,
    scenario_target_factory[[5]],
    command = data.frame(!!!.x) |> wrangle_df(type = "matrix",
                                              metric = "population",
                                              scenarios = scenarios)
  ),
  
  ####### Post-hoc Plotting ###############
  tar_target(
    name = sp_vs_phjv_prop_plot,
    command = plot_sp_vs_phjv_prop(population_df = population_df,
                                   area_df = area_df,
                                   phjv = phjv,
                                   crs = crs(combined_rankmap_cazmax))
  )
)
  
  
  
  
  
  


 

