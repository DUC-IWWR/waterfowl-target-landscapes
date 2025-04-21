####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# _targets.R
# Created April 2025
# Last Updated April 2025

####### Import Libraries and External Files #######

# Load packages required to define the pipeline:
library(targets)
library(geotargets)
# library(tarchetypes) # Load other packages as needed.

####### Targets #################################$$

# Set target options:
tar_option_set(
  packages = c("terra", "sf") # Packages that your targets need for their tasks.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("src/reproject-raster.R")

# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  
  #First 8 are all raw rasters that have NOT been snapped
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
  
  
  # We then need to reproject all rasters to match the extent of the GADW raster
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
  )
)








