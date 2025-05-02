####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# _targets.R
# Created April 2025
# Last Updated April 2025

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
tar_source("src/calculate-tl-population")
tar_source("src/mask-raster.R")

####### Targets ###################################

# Set target options:
tar_option_set(
  packages = c("terra", "smoothr"),
  controller = crew_controller_local(workers = 10)
)

scenarios <- tibble::tribble(
  ~scenario_name, ~zonation_rankmap, ~min_poly, ~threshold, ~max_hole,
  "sep_layers_poly156_thres0.70_hole70", quote(separate_layers_rankmap), 156000000, 0.70,70000000,
  "sep_layers_poly156_thres0.72_hole70", quote(separate_layers_rankmap), 156000000, 0.72,70000000,
  "sep_layers_poly156_thres0.74_hole70", quote(separate_layers_rankmap), 156000000, 0.74,70000000,
  "sep_layers_poly156_thres0.76_hole70", quote(separate_layers_rankmap), 156000000, 0.76,70000000,
  "sep_layers_poly156_thres0.78_hole70", quote(separate_layers_rankmap), 156000000, 0.78,70000000,
  "sep_layers_poly156_thres0.80_hole70", quote(separate_layers_rankmap), 156000000, 0.80,70000000,
  "sep_layers_poly128_thres0.70_hole70", quote(separate_layers_rankmap), 128000000, 0.70,70000000,
  "sep_layers_poly128_thres0.72_hole70", quote(separate_layers_rankmap), 128000000, 0.72,70000000,
  "sep_layers_poly128_thres0.74_hole70", quote(separate_layers_rankmap), 128000000, 0.74,70000000,
  "sep_layers_poly128_thres0.76_hole70", quote(separate_layers_rankmap), 128000000, 0.76,70000000,
  "sep_layers_poly128_thres0.78_hole70", quote(separate_layers_rankmap), 128000000, 0.78,70000000,
  "sep_layers_poly128_thres0.80_hole70", quote(separate_layers_rankmap), 128000000, 0.80,70000000,
  "sep_layers_poly100_thres0.70_hole70", quote(separate_layers_rankmap), 100000000, 0.70,70000000,
  "sep_layers_poly100_thres0.72_hole70", quote(separate_layers_rankmap), 100000000, 0.72,70000000,
  "sep_layers_poly100_thres0.74_hole70", quote(separate_layers_rankmap), 100000000, 0.74,70000000,
  "sep_layers_poly100_thres0.76_hole70", quote(separate_layers_rankmap), 100000000, 0.76,70000000,
  "sep_layers_poly100_thres0.78_hole70", quote(separate_layers_rankmap), 100000000, 0.78,70000000,
  "sep_layers_poly100_thres0.80_hole70", quote(separate_layers_rankmap), 100000000, 0.80,70000000,
  
  "sep_layers_weighted_poly156_thres0.70_hole70", quote(separate_layers_weighted_rankmap), 156000000, 0.70,70000000,
  "sep_layers_weighted_poly156_thres0.72_hole70", quote(separate_layers_weighted_rankmap), 156000000, 0.72,70000000,
  "sep_layers_weighted_poly156_thres0.74_hole70", quote(separate_layers_weighted_rankmap), 156000000, 0.74,70000000,
  "sep_layers_weighted_poly156_thres0.76_hole70", quote(separate_layers_weighted_rankmap), 156000000, 0.76,70000000,
  "sep_layers_weighted_poly156_thres0.78_hole70", quote(separate_layers_weighted_rankmap), 156000000, 0.78,70000000,
  "sep_layers_weighted_poly156_thres0.80_hole70", quote(separate_layers_weighted_rankmap), 156000000, 0.80,70000000,
  "sep_layers_weighted_poly128_thres0.70_hole70", quote(separate_layers_weighted_rankmap), 128000000, 0.70,70000000,
  "sep_layers_weighted_poly128_thres0.72_hole70", quote(separate_layers_weighted_rankmap), 128000000, 0.72,70000000,
  "sep_layers_weighted_poly128_thres0.74_hole70", quote(separate_layers_weighted_rankmap), 128000000, 0.74,70000000,
  "sep_layers_weighted_poly128_thres0.76_hole70", quote(separate_layers_weighted_rankmap), 128000000, 0.76,70000000,
  "sep_layers_weighted_poly128_thres0.78_hole70", quote(separate_layers_weighted_rankmap), 128000000, 0.78,70000000,
  "sep_layers_weighted_poly128_thres0.80_hole70", quote(separate_layers_weighted_rankmap), 128000000, 0.80,70000000,
  "sep_layers_weighted_poly100_thres0.70_hole70", quote(separate_layers_weighted_rankmap), 100000000, 0.70,70000000,
  "sep_layers_weighted_poly100_thres0.72_hole70", quote(separate_layers_weighted_rankmap), 100000000, 0.72,70000000,
  "sep_layers_weighted_poly100_thres0.74_hole70", quote(separate_layers_weighted_rankmap), 100000000, 0.74,70000000,
  "sep_layers_weighted_poly100_thres0.76_hole70", quote(separate_layers_weighted_rankmap), 100000000, 0.76,70000000,
  "sep_layers_weighted_poly100_thres0.78_hole70", quote(separate_layers_weighted_rankmap), 100000000, 0.78,70000000,
  "sep_layers_weighted_poly100_thres0.80_hole70", quote(separate_layers_weighted_rankmap), 100000000, 0.80,70000000,
  
  "stacked_layers_poly156_thres0.70_hole70", quote(stacked_layers_rankmap), 156000000, 0.70,70000000,
  "stacked_layers_poly156_thres0.72_hole70", quote(stacked_layers_rankmap), 156000000, 0.72,70000000,
  "stacked_layers_poly156_thres0.74_hole70", quote(stacked_layers_rankmap), 156000000, 0.74,70000000,
  "stacked_layers_poly156_thres0.76_hole70", quote(stacked_layers_rankmap), 156000000, 0.76,70000000,
  "stacked_layers_poly156_thres0.78_hole70", quote(stacked_layers_rankmap), 156000000, 0.78,70000000,
  "stacked_layers_poly156_thres0.80_hole70", quote(stacked_layers_rankmap), 156000000, 0.80,70000000,
  "stacked_layers_poly128_thres0.70_hole70", quote(stacked_layers_rankmap), 128000000, 0.70,70000000,
  "stacked_layers_poly128_thres0.72_hole70", quote(stacked_layers_rankmap), 128000000, 0.72,70000000,
  "stacked_layers_poly128_thres0.74_hole70", quote(stacked_layers_rankmap), 128000000, 0.74,70000000,
  "stacked_layers_poly128_thres0.76_hole70", quote(stacked_layers_rankmap), 128000000, 0.76,70000000,
  "stacked_layers_poly128_thres0.78_hole70", quote(stacked_layers_rankmap), 128000000, 0.78,70000000,
  "stacked_layers_poly128_thres0.80_hole70", quote(stacked_layers_rankmap), 128000000, 0.80,70000000,
  "stacked_layers_poly100_thres0.70_hole70", quote(stacked_layers_rankmap), 100000000, 0.70,70000000,
  "stacked_layers_poly100_thres0.72_hole70", quote(stacked_layers_rankmap), 100000000, 0.72,70000000,
  "stacked_layers_poly100_thres0.74_hole70", quote(stacked_layers_rankmap), 100000000, 0.74,70000000,
  "stacked_layers_poly100_thres0.76_hole70", quote(stacked_layers_rankmap), 100000000, 0.76,70000000,
  "stacked_layers_poly100_thres0.78_hole70", quote(stacked_layers_rankmap), 100000000, 0.78,70000000,
  "stacked_layers_poly100_thres0.80_hole70", quote(stacked_layers_rankmap), 100000000, 0.80,70000000,
  
  
  
  
  
  "sep_layers_poly156_thres0.70_hole50", quote(separate_layers_rankmap), 156000000, 0.70,50000000,
  "sep_layers_poly156_thres0.72_hole50", quote(separate_layers_rankmap), 156000000, 0.72,50000000,
  "sep_layers_poly156_thres0.74_hole50", quote(separate_layers_rankmap), 156000000, 0.74,50000000,
  "sep_layers_poly156_thres0.76_hole50", quote(separate_layers_rankmap), 156000000, 0.76,50000000,
  "sep_layers_poly156_thres0.78_hole50", quote(separate_layers_rankmap), 156000000, 0.78,50000000,
  "sep_layers_poly156_thres0.80_hole50", quote(separate_layers_rankmap), 156000000, 0.80,50000000,
  "sep_layers_poly128_thres0.70_hole50", quote(separate_layers_rankmap), 128000000, 0.70,50000000,
  "sep_layers_poly128_thres0.72_hole50", quote(separate_layers_rankmap), 128000000, 0.72,50000000,
  "sep_layers_poly128_thres0.74_hole50", quote(separate_layers_rankmap), 128000000, 0.74,50000000,
  "sep_layers_poly128_thres0.76_hole50", quote(separate_layers_rankmap), 128000000, 0.76,50000000,
  "sep_layers_poly128_thres0.78_hole50", quote(separate_layers_rankmap), 128000000, 0.78,50000000,
  "sep_layers_poly128_thres0.80_hole50", quote(separate_layers_rankmap), 128000000, 0.80,50000000,
  "sep_layers_poly100_thres0.70_hole50", quote(separate_layers_rankmap), 100000000, 0.70,50000000,
  "sep_layers_poly100_thres0.72_hole50", quote(separate_layers_rankmap), 100000000, 0.72,50000000,
  "sep_layers_poly100_thres0.74_hole50", quote(separate_layers_rankmap), 100000000, 0.74,50000000,
  "sep_layers_poly100_thres0.76_hole50", quote(separate_layers_rankmap), 100000000, 0.76,50000000,
  "sep_layers_poly100_thres0.78_hole50", quote(separate_layers_rankmap), 100000000, 0.78,50000000,
  "sep_layers_poly100_thres0.80_hole50", quote(separate_layers_rankmap), 100000000, 0.80,50000000,
  
  "sep_layers_weighted_poly156_thres0.70_hole50", quote(separate_layers_weighted_rankmap), 156000000, 0.70,50000000,
  "sep_layers_weighted_poly156_thres0.72_hole50", quote(separate_layers_weighted_rankmap), 156000000, 0.72,50000000,
  "sep_layers_weighted_poly156_thres0.74_hole50", quote(separate_layers_weighted_rankmap), 156000000, 0.74,50000000,
  "sep_layers_weighted_poly156_thres0.76_hole50", quote(separate_layers_weighted_rankmap), 156000000, 0.76,50000000,
  "sep_layers_weighted_poly156_thres0.78_hole50", quote(separate_layers_weighted_rankmap), 156000000, 0.78,50000000,
  "sep_layers_weighted_poly156_thres0.80_hole50", quote(separate_layers_weighted_rankmap), 156000000, 0.80,50000000,
  "sep_layers_weighted_poly128_thres0.70_hole50", quote(separate_layers_weighted_rankmap), 128000000, 0.70,50000000,
  "sep_layers_weighted_poly128_thres0.72_hole50", quote(separate_layers_weighted_rankmap), 128000000, 0.72,50000000,
  "sep_layers_weighted_poly128_thres0.74_hole50", quote(separate_layers_weighted_rankmap), 128000000, 0.74,50000000,
  "sep_layers_weighted_poly128_thres0.76_hole50", quote(separate_layers_weighted_rankmap), 128000000, 0.76,50000000,
  "sep_layers_weighted_poly128_thres0.78_hole50", quote(separate_layers_weighted_rankmap), 128000000, 0.78,50000000,
  "sep_layers_weighted_poly128_thres0.80_hole50", quote(separate_layers_weighted_rankmap), 128000000, 0.80,50000000,
  "sep_layers_weighted_poly100_thres0.70_hole50", quote(separate_layers_weighted_rankmap), 100000000, 0.70,50000000,
  "sep_layers_weighted_poly100_thres0.72_hole50", quote(separate_layers_weighted_rankmap), 100000000, 0.72,50000000,
  "sep_layers_weighted_poly100_thres0.74_hole50", quote(separate_layers_weighted_rankmap), 100000000, 0.74,50000000,
  "sep_layers_weighted_poly100_thres0.76_hole50", quote(separate_layers_weighted_rankmap), 100000000, 0.76,50000000,
  "sep_layers_weighted_poly100_thres0.78_hole50", quote(separate_layers_weighted_rankmap), 100000000, 0.78,50000000,
  "sep_layers_weighted_poly100_thres0.80_hole50", quote(separate_layers_weighted_rankmap), 100000000, 0.80,50000000,
  
  "stacked_layers_poly156_thres0.70_hole50", quote(stacked_layers_rankmap), 156000000, 0.70,50000000,
  "stacked_layers_poly156_thres0.72_hole50", quote(stacked_layers_rankmap), 156000000, 0.72,50000000,
  "stacked_layers_poly156_thres0.74_hole50", quote(stacked_layers_rankmap), 156000000, 0.74,50000000,
  "stacked_layers_poly156_thres0.76_hole50", quote(stacked_layers_rankmap), 156000000, 0.76,50000000,
  "stacked_layers_poly156_thres0.78_hole50", quote(stacked_layers_rankmap), 156000000, 0.78,50000000,
  "stacked_layers_poly156_thres0.80_hole50", quote(stacked_layers_rankmap), 156000000, 0.80,50000000,
  "stacked_layers_poly128_thres0.70_hole50", quote(stacked_layers_rankmap), 128000000, 0.70,50000000,
  "stacked_layers_poly128_thres0.72_hole50", quote(stacked_layers_rankmap), 128000000, 0.72,50000000,
  "stacked_layers_poly128_thres0.74_hole50", quote(stacked_layers_rankmap), 128000000, 0.74,50000000,
  "stacked_layers_poly128_thres0.76_hole50", quote(stacked_layers_rankmap), 128000000, 0.76,50000000,
  "stacked_layers_poly128_thres0.78_hole50", quote(stacked_layers_rankmap), 128000000, 0.78,50000000,
  "stacked_layers_poly128_thres0.80_hole50", quote(stacked_layers_rankmap), 128000000, 0.80,50000000,
  "stacked_layers_poly100_thres0.70_hole50", quote(stacked_layers_rankmap), 100000000, 0.70,50000000,
  "stacked_layers_poly100_thres0.72_hole50", quote(stacked_layers_rankmap), 100000000, 0.72,50000000,
  "stacked_layers_poly100_thres0.74_hole50", quote(stacked_layers_rankmap), 100000000, 0.74,50000000,
  "stacked_layers_poly100_thres0.76_hole50", quote(stacked_layers_rankmap), 100000000, 0.76,50000000,
  "stacked_layers_poly100_thres0.78_hole50", quote(stacked_layers_rankmap), 100000000, 0.78,50000000,
  "stacked_layers_poly100_thres0.80_hole50", quote(stacked_layers_rankmap), 100000000, 0.80,50000000,
  
  
  
  
  
  "sep_layers_poly156_thres0.70_hole25", quote(separate_layers_rankmap), 156000000, 0.70,25000000,
  "sep_layers_poly156_thres0.72_hole25", quote(separate_layers_rankmap), 156000000, 0.72,25000000,
  "sep_layers_poly156_thres0.74_hole25", quote(separate_layers_rankmap), 156000000, 0.74,25000000,
  "sep_layers_poly156_thres0.76_hole25", quote(separate_layers_rankmap), 156000000, 0.76,25000000,
  "sep_layers_poly156_thres0.78_hole25", quote(separate_layers_rankmap), 156000000, 0.78,25000000,
  "sep_layers_poly156_thres0.80_hole25", quote(separate_layers_rankmap), 156000000, 0.80,25000000,
  "sep_layers_poly128_thres0.70_hole25", quote(separate_layers_rankmap), 128000000, 0.70,25000000,
  "sep_layers_poly128_thres0.72_hole25", quote(separate_layers_rankmap), 128000000, 0.72,25000000,
  "sep_layers_poly128_thres0.74_hole25", quote(separate_layers_rankmap), 128000000, 0.74,25000000,
  "sep_layers_poly128_thres0.76_hole25", quote(separate_layers_rankmap), 128000000, 0.76,25000000,
  "sep_layers_poly128_thres0.78_hole25", quote(separate_layers_rankmap), 128000000, 0.78,25000000,
  "sep_layers_poly128_thres0.80_hole25", quote(separate_layers_rankmap), 128000000, 0.80,25000000,
  "sep_layers_poly100_thres0.70_hole25", quote(separate_layers_rankmap), 100000000, 0.70,25000000,
  "sep_layers_poly100_thres0.72_hole25", quote(separate_layers_rankmap), 100000000, 0.72,25000000,
  "sep_layers_poly100_thres0.74_hole25", quote(separate_layers_rankmap), 100000000, 0.74,25000000,
  "sep_layers_poly100_thres0.76_hole25", quote(separate_layers_rankmap), 100000000, 0.76,25000000,
  "sep_layers_poly100_thres0.78_hole25", quote(separate_layers_rankmap), 100000000, 0.78,25000000,
  "sep_layers_poly100_thres0.80_hole25", quote(separate_layers_rankmap), 100000000, 0.80,25000000,
  
  "sep_layers_weighted_poly156_thres0.70_hole25", quote(separate_layers_weighted_rankmap), 156000000, 0.70,25000000,
  "sep_layers_weighted_poly156_thres0.72_hole25", quote(separate_layers_weighted_rankmap), 156000000, 0.72,25000000,
  "sep_layers_weighted_poly156_thres0.74_hole25", quote(separate_layers_weighted_rankmap), 156000000, 0.74,25000000,
  "sep_layers_weighted_poly156_thres0.76_hole25", quote(separate_layers_weighted_rankmap), 156000000, 0.76,25000000,
  "sep_layers_weighted_poly156_thres0.78_hole25", quote(separate_layers_weighted_rankmap), 156000000, 0.78,25000000,
  "sep_layers_weighted_poly156_thres0.80_hole25", quote(separate_layers_weighted_rankmap), 156000000, 0.80,25000000,
  "sep_layers_weighted_poly128_thres0.70_hole25", quote(separate_layers_weighted_rankmap), 128000000, 0.70,25000000,
  "sep_layers_weighted_poly128_thres0.72_hole25", quote(separate_layers_weighted_rankmap), 128000000, 0.72,25000000,
  "sep_layers_weighted_poly128_thres0.74_hole25", quote(separate_layers_weighted_rankmap), 128000000, 0.74,25000000,
  "sep_layers_weighted_poly128_thres0.76_hole25", quote(separate_layers_weighted_rankmap), 128000000, 0.76,25000000,
  "sep_layers_weighted_poly128_thres0.78_hole25", quote(separate_layers_weighted_rankmap), 128000000, 0.78,25000000,
  "sep_layers_weighted_poly128_thres0.80_hole25", quote(separate_layers_weighted_rankmap), 128000000, 0.80,25000000,
  "sep_layers_weighted_poly100_thres0.70_hole25", quote(separate_layers_weighted_rankmap), 100000000, 0.70,25000000,
  "sep_layers_weighted_poly100_thres0.72_hole25", quote(separate_layers_weighted_rankmap), 100000000, 0.72,25000000,
  "sep_layers_weighted_poly100_thres0.74_hole25", quote(separate_layers_weighted_rankmap), 100000000, 0.74,25000000,
  "sep_layers_weighted_poly100_thres0.76_hole25", quote(separate_layers_weighted_rankmap), 100000000, 0.76,25000000,
  "sep_layers_weighted_poly100_thres0.78_hole25", quote(separate_layers_weighted_rankmap), 100000000, 0.78,25000000,
  "sep_layers_weighted_poly100_thres0.80_hole25", quote(separate_layers_weighted_rankmap), 100000000, 0.80,25000000,
  
  "stacked_layers_poly156_thres0.70_hole25", quote(stacked_layers_rankmap), 156000000, 0.70,25000000,
  "stacked_layers_poly156_thres0.72_hole25", quote(stacked_layers_rankmap), 156000000, 0.72,25000000,
  "stacked_layers_poly156_thres0.74_hole25", quote(stacked_layers_rankmap), 156000000, 0.74,25000000,
  "stacked_layers_poly156_thres0.76_hole25", quote(stacked_layers_rankmap), 156000000, 0.76,25000000,
  "stacked_layers_poly156_thres0.78_hole25", quote(stacked_layers_rankmap), 156000000, 0.78,25000000,
  "stacked_layers_poly156_thres0.80_hole25", quote(stacked_layers_rankmap), 156000000, 0.80,25000000,
  "stacked_layers_poly128_thres0.70_hole25", quote(stacked_layers_rankmap), 128000000, 0.70,25000000,
  "stacked_layers_poly128_thres0.72_hole25", quote(stacked_layers_rankmap), 128000000, 0.72,25000000,
  "stacked_layers_poly128_thres0.74_hole25", quote(stacked_layers_rankmap), 128000000, 0.74,25000000,
  "stacked_layers_poly128_thres0.76_hole25", quote(stacked_layers_rankmap), 128000000, 0.76,25000000,
  "stacked_layers_poly128_thres0.78_hole25", quote(stacked_layers_rankmap), 128000000, 0.78,25000000,
  "stacked_layers_poly128_thres0.80_hole25", quote(stacked_layers_rankmap), 128000000, 0.80,25000000,
  "stacked_layers_poly100_thres0.70_hole25", quote(stacked_layers_rankmap), 100000000, 0.70,25000000,
  "stacked_layers_poly100_thres0.72_hole25", quote(stacked_layers_rankmap), 100000000, 0.72,25000000,
  "stacked_layers_poly100_thres0.74_hole25", quote(stacked_layers_rankmap), 100000000, 0.74,25000000,
  "stacked_layers_poly100_thres0.76_hole25", quote(stacked_layers_rankmap), 100000000, 0.76,25000000,
  "stacked_layers_poly100_thres0.78_hole25", quote(stacked_layers_rankmap), 100000000, 0.78,25000000,
  "stacked_layers_poly100_thres0.80_hole25", quote(stacked_layers_rankmap), 100000000, 0.80,25000000,
  
  
  
  
  
  
  
  
  "combined_poly156_thres0.70_hole70", quote(combined_rankmap), 156000000, 0.70,70000000,
  "combined_poly156_thres0.72_hole70", quote(combined_rankmap), 156000000, 0.72,70000000,
  "combined_poly156_thres0.74_hole70", quote(combined_rankmap), 156000000, 0.74,70000000,
  "combined_poly156_thres0.76_hole70", quote(combined_rankmap), 156000000, 0.76,70000000,
  "combined_poly156_thres0.78_hole70", quote(combined_rankmap), 156000000, 0.78,70000000,
  "combined_poly156_thres0.80_hole70", quote(combined_rankmap), 156000000, 0.80,70000000,
  "combined_poly128_thres0.70_hole70", quote(combined_rankmap), 128000000, 0.70,70000000,
  "combined_poly128_thres0.72_hole70", quote(combined_rankmap), 128000000, 0.72,70000000,
  "combined_poly128_thres0.74_hole70", quote(combined_rankmap), 128000000, 0.74,70000000,
  "combined_poly128_thres0.76_hole70", quote(combined_rankmap), 128000000, 0.76,70000000,
  "combined_poly128_thres0.78_hole70", quote(combined_rankmap), 128000000, 0.78,70000000,
  "combined_poly128_thres0.80_hole70", quote(combined_rankmap), 128000000, 0.80,70000000,
  "combined_poly100_thres0.70_hole70", quote(combined_rankmap), 100000000, 0.70,70000000,
  "combined_poly100_thres0.72_hole70", quote(combined_rankmap), 100000000, 0.72,70000000,
  "combined_poly100_thres0.74_hole70", quote(combined_rankmap), 100000000, 0.74,70000000,
  "combined_poly100_thres0.76_hole70", quote(combined_rankmap), 100000000, 0.76,70000000,
  "combined_poly100_thres0.78_hole70", quote(combined_rankmap), 100000000, 0.78,70000000,
  "combined_poly100_thres0.80_hole70", quote(combined_rankmap), 100000000, 0.80,70000000,
  "combined_poly156_thres0.70_hole50", quote(combined_rankmap), 156000000, 0.70,50000000,
  "combined_poly156_thres0.72_hole50", quote(combined_rankmap), 156000000, 0.72,50000000,
  "combined_poly156_thres0.74_hole50", quote(combined_rankmap), 156000000, 0.74,50000000,
  "combined_poly156_thres0.76_hole50", quote(combined_rankmap), 156000000, 0.76,50000000,
  "combined_poly156_thres0.78_hole50", quote(combined_rankmap), 156000000, 0.78,50000000,
  "combined_poly156_thres0.80_hole50", quote(combined_rankmap), 156000000, 0.80,50000000,
  "combined_poly128_thres0.70_hole50", quote(combined_rankmap), 128000000, 0.70,50000000,
  "combined_poly128_thres0.72_hole50", quote(combined_rankmap), 128000000, 0.72,50000000,
  "combined_poly128_thres0.74_hole50", quote(combined_rankmap), 128000000, 0.74,50000000,
  "combined_poly128_thres0.76_hole50", quote(combined_rankmap), 128000000, 0.76,50000000,
  "combined_poly128_thres0.78_hole50", quote(combined_rankmap), 128000000, 0.78,50000000,
  "combined_poly128_thres0.80_hole50", quote(combined_rankmap), 128000000, 0.80,50000000,
  "combined_poly100_thres0.70_hole50", quote(combined_rankmap), 100000000, 0.70,50000000,
  "combined_poly100_thres0.72_hole50", quote(combined_rankmap), 100000000, 0.72,50000000,
  "combined_poly100_thres0.74_hole50", quote(combined_rankmap), 100000000, 0.74,50000000,
  "combined_poly100_thres0.76_hole50", quote(combined_rankmap), 100000000, 0.76,50000000,
  "combined_poly100_thres0.78_hole50", quote(combined_rankmap), 100000000, 0.78,50000000,
  "combined_poly100_thres0.80_hole50", quote(combined_rankmap), 100000000, 0.80,50000000,
  "combined_poly156_thres0.70_hole25", quote(combined_rankmap), 156000000, 0.70,25000000,
  "combined_poly156_thres0.72_hole25", quote(combined_rankmap), 156000000, 0.72,25000000,
  "combined_poly156_thres0.74_hole25", quote(combined_rankmap), 156000000, 0.74,25000000,
  "combined_poly156_thres0.76_hole25", quote(combined_rankmap), 156000000, 0.76,25000000,
  "combined_poly156_thres0.78_hole25", quote(combined_rankmap), 156000000, 0.78,25000000,
  "combined_poly156_thres0.80_hole25", quote(combined_rankmap), 156000000, 0.80,25000000,
  "combined_poly128_thres0.70_hole25", quote(combined_rankmap), 128000000, 0.70,25000000,
  "combined_poly128_thres0.72_hole25", quote(combined_rankmap), 128000000, 0.72,25000000,
  "combined_poly128_thres0.74_hole25", quote(combined_rankmap), 128000000, 0.74,25000000,
  "combined_poly128_thres0.76_hole25", quote(combined_rankmap), 128000000, 0.76,25000000,
  "combined_poly128_thres0.78_hole25", quote(combined_rankmap), 128000000, 0.78,25000000,
  "combined_poly128_thres0.80_hole25", quote(combined_rankmap), 128000000, 0.80,25000000,
  "combined_poly100_thres0.70_hole25", quote(combined_rankmap), 100000000, 0.70,25000000,
  "combined_poly100_thres0.72_hole25", quote(combined_rankmap), 100000000, 0.72,25000000,
  "combined_poly100_thres0.74_hole25", quote(combined_rankmap), 100000000, 0.74,25000000,
  "combined_poly100_thres0.76_hole25", quote(combined_rankmap), 100000000, 0.76,25000000,
  "combined_poly100_thres0.78_hole25", quote(combined_rankmap), 100000000, 0.78,25000000,
  "combined_poly100_thres0.80_hole25", quote(combined_rankmap), 100000000, 0.80,25000000,
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
  
  # unsure if this one is needed but we'll see
  tar_target(
    name = tl_old,
    "data/raw/target-landscapes-previous/PHJV_WaterfowlTargetLandscapes.shp",
    format = "file"
  ),
  tar_target(
    name = ppr_raw,
    "data/raw/prairie_ecozone/prairie_ecozone.shp",
    format = "file"
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
  tar_terra_vect(
    name = ppr,
    command = terra::project(vect(ppr_raw), rast(gadw_raw_raster))
  ),
  
  ####### Mask Rasters ###################################
  
  tar_target(
    name = species_7_masked,
    command = mask_raster(raster_file = species_7_reprojected,
                          mask_vect = ppr),
    format = "file"
    ),
  tar_target(
    name = mall_masked,
    command = mask_raster(raster_file = mall_reprojected,
                          mask_vect = ppr),
    format = "file"
  ),
  tar_target(
    name = gadw_masked,
    command = mask_raster(raster_file = gadw_reprojected,
                          mask_vect = ppr),
    format = "file"
  ),
  tar_target(
    name = nsho_masked,
    command = mask_raster(raster_file = nsho_reprojected,
                          mask_vect = ppr),
    format = "file"
  ),
  tar_target(
    name = bwte_masked,
    command = mask_raster(raster_file = bwte_reprojected,
                          mask_vect = ppr),
    format = "file"
  ),
  tar_target(
    name = nopi_masked,
    command = mask_raster(raster_file = nopi_reprojected,
                          mask_vect = ppr),
    format = "file"
  ),
  tar_target(
    name = canv_masked,
    command = mask_raster(raster_file = canv_reprojected,
                          mask_vect = ppr),
    format = "file"
  ),
  tar_target(
    name = redh_masked,
    command = mask_raster(raster_file = redh_reprojected,
                          mask_vect = ppr),
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
    command = terra::max(stacked_layers_rankmap,
                         separate_layers_weighted_rankmap)
  ),
  
  ####### Scenario Runs #################################

  tar_map(
    values = scenarios,
    names = scenario_name,
    tar_terra_vect(
      name = tl,
      command = generate_target_landscape(rankmap = zonation_rankmap,
                                          scenario_name = scenario_name,
                                          threshold = threshold,
                                          min_poly = min_poly,
                                          max_hole = max_hole,
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
                                        species = c(mall_masked,
                                                   gadw_masked,
                                                   nopi_masked,
                                                   bwte_masked,
                                                   nsho_masked,
                                                   canv_masked,
                                                   redh_masked))
    )
  )
  
)
