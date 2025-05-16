####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# _targets.R
# Created April 2025
# Last Updated May 2025

####### Import Libraries and External Files #######

library(targets)
library(tarchetypes)
library(geotargets)
library(tibble)
library(crew)

tar_source("src/reproject-raster.R")
tar_source("src/run-zonation.R")
tar_source("src/stack-rasters.R")
tar_source("src/generate-target-landscape.R")
tar_source("src/plot-target-landscape.R")
tar_source("src/calculate-tl-area.R")
tar_source("src/calculate-tl-population.R")
tar_source("src/mask-raster.R")
tar_source("src/calculate-tl-area-province.R")
tar_source("src/calculate-tl-population-province.R")
tar_source("src/wrangle-df.R")

####### Targets ###################################

# Set target options:
tar_option_set(
  packages = c("terra", "smoothr"),
  controller = crew_controller_local(workers = 10)
)

scenarios <- tibble::tribble(
  ~scenario_name, ~zonation_rankmap, ~min_poly, ~threshold,
  "sep_layers_poly156_thres0.70", quote(separate_layers_rankmap), 156000000, 0.70,
  "sep_layers_poly156_thres0.72", quote(separate_layers_rankmap), 156000000, 0.72,
  "sep_layers_poly156_thres0.74", quote(separate_layers_rankmap), 156000000, 0.74,
  "sep_layers_poly156_thres0.76", quote(separate_layers_rankmap), 156000000, 0.76,
  "sep_layers_poly156_thres0.78", quote(separate_layers_rankmap), 156000000, 0.78,
  "sep_layers_poly156_thres0.80", quote(separate_layers_rankmap), 156000000, 0.80,
  "sep_layers_poly128_thres0.70", quote(separate_layers_rankmap), 128000000, 0.70,
  "sep_layers_poly128_thres0.72", quote(separate_layers_rankmap), 128000000, 0.72,
  "sep_layers_poly128_thres0.74", quote(separate_layers_rankmap), 128000000, 0.74,
  "sep_layers_poly128_thres0.76", quote(separate_layers_rankmap), 128000000, 0.76,
  "sep_layers_poly128_thres0.78", quote(separate_layers_rankmap), 128000000, 0.78,
  "sep_layers_poly128_thres0.80", quote(separate_layers_rankmap), 128000000, 0.80,
  "sep_layers_poly100_thres0.70", quote(separate_layers_rankmap), 100000000, 0.70,
  "sep_layers_poly100_thres0.72", quote(separate_layers_rankmap), 100000000, 0.72,
  "sep_layers_poly100_thres0.74", quote(separate_layers_rankmap), 100000000, 0.74,
  "sep_layers_poly100_thres0.76", quote(separate_layers_rankmap), 100000000, 0.76,
  "sep_layers_poly100_thres0.78", quote(separate_layers_rankmap), 100000000, 0.78,
  "sep_layers_poly100_thres0.80", quote(separate_layers_rankmap), 100000000, 0.80,
  
  "sep_layers_weighted_poly156_thres0.70", quote(separate_layers_weighted_rankmap), 156000000, 0.70,
  "sep_layers_weighted_poly156_thres0.72", quote(separate_layers_weighted_rankmap), 156000000, 0.72,
  "sep_layers_weighted_poly156_thres0.74", quote(separate_layers_weighted_rankmap), 156000000, 0.74,
  "sep_layers_weighted_poly156_thres0.76", quote(separate_layers_weighted_rankmap), 156000000, 0.76,
  "sep_layers_weighted_poly156_thres0.78", quote(separate_layers_weighted_rankmap), 156000000, 0.78,
  "sep_layers_weighted_poly156_thres0.80", quote(separate_layers_weighted_rankmap), 156000000, 0.80,
  "sep_layers_weighted_poly128_thres0.70", quote(separate_layers_weighted_rankmap), 128000000, 0.70,
  "sep_layers_weighted_poly128_thres0.72", quote(separate_layers_weighted_rankmap), 128000000, 0.72,
  "sep_layers_weighted_poly128_thres0.74", quote(separate_layers_weighted_rankmap), 128000000, 0.74,
  "sep_layers_weighted_poly128_thres0.76", quote(separate_layers_weighted_rankmap), 128000000, 0.76,
  "sep_layers_weighted_poly128_thres0.78", quote(separate_layers_weighted_rankmap), 128000000, 0.78,
  "sep_layers_weighted_poly128_thres0.80", quote(separate_layers_weighted_rankmap), 128000000, 0.80,
  "sep_layers_weighted_poly100_thres0.70", quote(separate_layers_weighted_rankmap), 100000000, 0.70,
  "sep_layers_weighted_poly100_thres0.72", quote(separate_layers_weighted_rankmap), 100000000, 0.72,
  "sep_layers_weighted_poly100_thres0.74", quote(separate_layers_weighted_rankmap), 100000000, 0.74,
  "sep_layers_weighted_poly100_thres0.76", quote(separate_layers_weighted_rankmap), 100000000, 0.76,
  "sep_layers_weighted_poly100_thres0.78", quote(separate_layers_weighted_rankmap), 100000000, 0.78,
  "sep_layers_weighted_poly100_thres0.80", quote(separate_layers_weighted_rankmap), 100000000, 0.80,
  
  "stacked_layers_poly156_thres0.70", quote(stacked_layers_rankmap), 156000000, 0.70,
  "stacked_layers_poly156_thres0.72", quote(stacked_layers_rankmap), 156000000, 0.72,
  "stacked_layers_poly156_thres0.74", quote(stacked_layers_rankmap), 156000000, 0.74,
  "stacked_layers_poly156_thres0.76", quote(stacked_layers_rankmap), 156000000, 0.76,
  "stacked_layers_poly156_thres0.78", quote(stacked_layers_rankmap), 156000000, 0.78,
  "stacked_layers_poly156_thres0.80", quote(stacked_layers_rankmap), 156000000, 0.80,
  "stacked_layers_poly128_thres0.70", quote(stacked_layers_rankmap), 128000000, 0.70,
  "stacked_layers_poly128_thres0.72", quote(stacked_layers_rankmap), 128000000, 0.72,
  "stacked_layers_poly128_thres0.74", quote(stacked_layers_rankmap), 128000000, 0.74,
  "stacked_layers_poly128_thres0.76", quote(stacked_layers_rankmap), 128000000, 0.76,
  "stacked_layers_poly128_thres0.78", quote(stacked_layers_rankmap), 128000000, 0.78,
  "stacked_layers_poly128_thres0.80", quote(stacked_layers_rankmap), 128000000, 0.80,
  "stacked_layers_poly100_thres0.70", quote(stacked_layers_rankmap), 100000000, 0.70,
  "stacked_layers_poly100_thres0.72", quote(stacked_layers_rankmap), 100000000, 0.72,
  "stacked_layers_poly100_thres0.74", quote(stacked_layers_rankmap), 100000000, 0.74,
  "stacked_layers_poly100_thres0.76", quote(stacked_layers_rankmap), 100000000, 0.76,
  "stacked_layers_poly100_thres0.78", quote(stacked_layers_rankmap), 100000000, 0.78,
  "stacked_layers_poly100_thres0.80", quote(stacked_layers_rankmap), 100000000, 0.80,
  
  
  "combined_poly156_thres0.70", quote(combined_rankmap), 156000000, 0.70,
  "combined_poly156_thres0.72", quote(combined_rankmap), 156000000, 0.72,
  "combined_poly156_thres0.74", quote(combined_rankmap), 156000000, 0.74,
  "combined_poly156_thres0.76", quote(combined_rankmap), 156000000, 0.76,
  "combined_poly156_thres0.78", quote(combined_rankmap), 156000000, 0.78,
  "combined_poly156_thres0.80", quote(combined_rankmap), 156000000, 0.80,
  "combined_poly128_thres0.70", quote(combined_rankmap), 128000000, 0.70,
  "combined_poly128_thres0.72", quote(combined_rankmap), 128000000, 0.72,
  "combined_poly128_thres0.74", quote(combined_rankmap), 128000000, 0.74,
  "combined_poly128_thres0.76", quote(combined_rankmap), 128000000, 0.76,
  "combined_poly128_thres0.78", quote(combined_rankmap), 128000000, 0.78,
  "combined_poly128_thres0.80", quote(combined_rankmap), 128000000, 0.80,
  "combined_poly100_thres0.70", quote(combined_rankmap), 100000000, 0.70,
  "combined_poly100_thres0.72", quote(combined_rankmap), 100000000, 0.72,
  "combined_poly100_thres0.74", quote(combined_rankmap), 100000000, 0.74,
  "combined_poly100_thres0.76", quote(combined_rankmap), 100000000, 0.76,
  "combined_poly100_thres0.78", quote(combined_rankmap), 100000000, 0.78,
  "combined_poly100_thres0.80", quote(combined_rankmap), 100000000, 0.80,
)

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


list(
  
  ####### Raw Rasters and Shapefiles ####################
  tar_target(
    name = species_7_stacked,
    "data/raw/rasters/7species_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = mall_raw_raster,
    "data/raw/rasters/MALL_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = gadw_raw_raster,
    "data/raw/rasters/GADW_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = nopi_raw_raster,
    "data/raw/rasters/NOPI_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = bwte_raw_raster,
    "data/raw/rasters/BWTE_Pairs_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = nsho_raw_raster,
    "data/raw/rasters/NSHO_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = canv_raw_raster,
    "data/raw/rasters/CANV_Pairs_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = redh_raw_raster,
    "data/raw/rasters/REDH_perSQK_CopyRaster.tif",
    format = "file"
  ),
  tar_target(
    name = dss_v2_raster,
    "data/raw/rasters/DSS_v2.tif",
    format = "file"
  ),
  
  # unsure if this one is needed but we'll see
  tar_terra_vect(
    name = tl_old,
    vect("data/raw/target-landscapes-previous/PHJV_WaterfowlTargetLandscapes.shp")
  ),
  tar_terra_vect(
    name = phjv,
    vect("data/raw/PHJV_projected/PHJV_projected.shp")
  ),
  tar_terra_vect(
    name = provinces,
    vect("data/raw/Provinces_projected/Provinces_projected.shp")
  ),

  
  
  ####### Reprojected Rasters and Shapefiles ###################################
  tar_target(
    name = species_7_reprojected,
    command = reproject_raster(raster_file = species_7_stacked,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = mall_reprojected,
    command = reproject_raster(raster_file = mall_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = gadw_reprojected,
    command = reproject_raster(raster_file = gadw_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = nopi_reprojected,
    command = reproject_raster(raster_file = nopi_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = bwte_reprojected,
    command = reproject_raster(raster_file = bwte_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = nsho_reprojected,
    command = reproject_raster(raster_file = nsho_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = canv_reprojected,
    command = reproject_raster(raster_file = canv_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = redh_reprojected,
    command = reproject_raster(raster_file = redh_raw_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_target(
    name = dss_v2_reprojected,
    command = reproject_raster(raster_file = dss_v2_raster,
                               ref = gadw_raw_raster),
    format = "file"
  ),
  tar_terra_vect(
    name = tl_old_projected,
    command = project(tl_old, rast(gadw_raw_raster))
  ),
  
  ####### Mask Rasters ###################################
  
  tar_target(
    name = species_7_masked,
    command = mask_raster(raster_file = species_7_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
    ),
  tar_target(
    name = mall_masked,
    command = mask_raster(raster_file = mall_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = gadw_masked,
    command = mask_raster(raster_file = gadw_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = nsho_masked,
    command = mask_raster(raster_file = nsho_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = bwte_masked,
    command = mask_raster(raster_file = bwte_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = nopi_masked,
    command = mask_raster(raster_file = nopi_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = canv_masked,
    command = mask_raster(raster_file = canv_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = redh_masked,
    command = mask_raster(raster_file = redh_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  tar_target(
    name = dss_v2_masked,
    command = mask_raster(raster_file = dss_v2_reprojected,
                          mask_vect = phjv[which(phjv$CA_REGION == "PPR"),]),
    format = "file"
  ),
  
  ####### Zonation Rankmaps #################################

  tar_terra_rast(
    name = separate_layers_rankmap,
    command = run_zonation(feature_list = c(mall_masked,
                                            gadw_masked,
                                            nopi_masked,
                                            bwte_masked,
                                            nsho_masked,
                                            canv_masked,
                                            redh_masked),
                           scenario_name = "separate_layers",
                           zonation_mode = "CAZMAX")
  ),
  
  tar_terra_rast(
    name = separate_layers_weighted_rankmap,
    command = run_zonation(feature_list = c(mall_masked,
                                            gadw_masked,
                                            nopi_masked,
                                            bwte_masked,
                                            nsho_masked,
                                            canv_masked,
                                            redh_masked),
                           feature_weights = c(1.0,1.0,2.0,1.0,1.0,1.0,1.0),
                           scenario_name = "separate_layers_weighted",
                           zonation_mode = "CAZMAX")
  ),
  
  tar_terra_rast(
    name = stacked_layers_rankmap,
    command = run_zonation(feature_list = species_7_masked,
                           scenario_name = "stacked_layers",
                           zonation_mode = "CAZMAX")
  ),
  
  # and now a Frankenstein version
  tar_terra_rast(
    name = combined_rankmap,
    command = max(stacked_layers_rankmap, separate_layers_weighted_rankmap)
  ),
  
  ####### Summary Statistics for Old TL #################################  
  
  tar_target(
    name = dss_v2_prop_area,
    command = calculate_tl_area(target_landscape = aggregate(tl_old_projected,
                                                             dissolve = TRUE),
                                rankmap = rast(dss_v2_masked))
  ),
  tar_target(
    name = dss_v2_prop_population,
    command = calculate_tl_population(target_landscape = aggregate(tl_old_projected,
                                                                   dissolve = TRUE),
                                      species_list = c(dss_v2_masked))
  ),
  tar_target(
    name = dss_v2_prop_population_province,
    command = calculate_tl_population_province(target_landscape = aggregate(tl_old_projected,
                                                                            dissolve = TRUE),
                                               species_list = c(dss_v2_masked),
                                               provinces = provinces)
  ),
  tar_target(
    name = dss_v2_prop_area_province,
    command = calculate_tl_area_province(target_landscape = aggregate(tl_old_projected,
                                                                      dissolve = TRUE),
                                         provinces = provinces,
                                         rankmap = rast(dss_v2_masked))
  ),
  
  
  ####### Scenario Runs #################################
  
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
    name = province_df,
    scenario_target_factory[[4]],
    command = data.frame(!!!.x) |> wrangle_df(type = "vector",
                                              metric = "population",
                                              scenarios = scenarios)
  )
)
  
  
  
  
  
  


 

