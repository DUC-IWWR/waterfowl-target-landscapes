####### Script Information ########################
# Brandon P.M. Edwards & Barry Robinson
# Waterfowl Target Landscapes
# 00-snap-density-rasters.R
# Created April 2025
# Last Updated April 2025

####### Import Libraries and External Files #######

library(terra)
library(sf)

####### Read Data #################################

ducklist <- list.files("data/raw/rasters", full.names = T)

####### Main Script  ##############################

# the extents and origins are different, so need to initially load them as a list
ducks <- lapply(ducklist, rast)

#' 4 of 10 rasters have the same origin (3, 5, 9, 10 in list), so resample to 
#' that origin (i.e use 3rd raster as a template)
lapply(ducks, terra::origin) 
lapply(ducks, terra::ext)

#' use project to match projection, resolution, origin, and extent, then stack
#' see below why I chose to use the 3rd raster as the template for reprojection
ducks <- lapply(ducks, terra::project, y = ducks[[4]]) 

####### Output ####################################

lapply(ducks, function(x) {writeRaster(x, filename = paste0("data/generated/snapped-rasters/", names(x), "_snapped.tif"), overwrite = TRUE)})
