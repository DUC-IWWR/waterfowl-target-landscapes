####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# _targets.R
# Created April 2025
# Last Updated April 2025

####### Import Libraries and External Files #######

library(targets)
library(geotargets)

tar_source("src/reproject-raster.R")
tar_source("src/run-zonation.R")
tar_source("src/stack-rasters.R")
tar_source("src/generate-target-landscape.R")

####### Targets ###################################

# Set target options:
tar_option_set(
  packages = c("terra", "sf", "smoothr")
)

list(
  
  ####### Raw Rasters ###################################
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
  
  
  ####### Reprojected Rasters ###################################
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
  
  ####### Layer Stacking Targets ###################################
  
  # note that "dabblers_stacked" does NOT include pintail
  tar_target(
    name = dabblers_stacked,
    command = stack_rasters(raster_list = c(mall_reprojected,
                                            gadw_reprojected,
                                            bwte_reprojected,
                                            nsho_reprojected),
                            new_raster_name = "dabblers"),
    format = "file"
  ),
  
  tar_target(
    name = divers_stacked,
    command = stack_rasters(raster_list = c(canv_reprojected,
                                            redh_reprojected),
                            new_raster_name = "divers"),
    format = "file"
  ),
  
  ####### Zonation Scenarios ###################################
  
  ######### Single Layer #################
  tar_target(
    name = single_layer_waterfowl,
    command = run_zonation(feature_list = c(species_7_reprojected),
                           scenario_name = "single_layer_all",
                           zonation_mode = "CAZMAX"),
    format = "file"
  ),
 
   tar_target(
    name = single_layer_tl,
    command = generate_target_landscape(rankmap_path = single_layer_waterfowl,
                                        scenario_name = "single_layer_all",
                                        threshold = 0.78,
                                        min_poly = 156000000,
                                        max_hole = 70000000,
                                        smooth = 8),
    format = "file"
  ),
  
  
  ##### Separate Layers ######
  tar_target(
    name = all_waterfowl_separate,
    command = run_zonation(feature_list = c(mall_reprojected,
                                            gadw_reprojected,
                                            nopi_reprojected,
                                            bwte_reprojected,
                                            nsho_reprojected,
                                            canv_reprojected,
                                            redh_reprojected),
                           scenario_name = "separate_layer_all",
                           zonation_mode = "CAZMAX"),
    format = "file"
  ),
  
  tar_target(
    name = separate_layer_tl,
    command = generate_target_landscape(rankmap_path = all_waterfowl_separate,
                                        scenario_name = "separate_layer_all",
                                        threshold = 0.78,
                                        min_poly = 156000000,
                                        max_hole = 70000000,
                                        smooth = 8),
    format = "file"
  ),
  
  ###### Guild Level Scenario #####
  # i.e., a layer for dabblers, a layer for divers, and a layer for NOPI
  tar_target(
    name = guild_level,
    command = run_zonation(feature_list = c(dabblers_stacked,
                                            divers_stacked,
                                            nopi_reprojected),
                           scenario_name = "guild_level",
                           zonation_mode = "CAZMAX"),
    format = "file"
  ),
  
  tar_target(
    name = guild_level_tl,
    command = generate_target_landscape(rankmap_path = guild_level,
                                        scenario_name = "guild_level",
                                        threshold = 0.78,
                                        min_poly = 156000000,
                                        max_hole = 70000000,
                                        smooth = 8),
    format = "file"
  )
  
)
