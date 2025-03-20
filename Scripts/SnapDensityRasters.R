#This script loads species density rasters of interest and snaps them together so they have the same origin, resolution, extent, and projection
#Load packages
library(terra)
library(sf)

#load duck density rasters, excluding the combined, multi-species rasters (files names that contain "DuckDensity")
#use this line for all 10 species
#ducklist <- grep(list.files("Data/DensityRasters", full.names = T), pattern = "DuckDensity", invert = T, value = T)
#use this line for a selection of species
ducklist <- grep(list.files("data/raw/density-rasters", full.names = T), pattern = "MALL|GADW|NOPI|BWTE|NSHO|CANV|REDH", value = T)


#the extents and origins are different, so need to initially load them as a list
ducks <- lapply(ducklist, rast)
lapply(ducks, terra::origin) # 4 of 10 rasters have the same origin (3, 5, 9, 10 in list), so resample to that origin (i.e use 3rd raster as a template)
lapply(ducks, terra::ext)

#use project to match projection, resolution, origin, and extent, then stack
ducks <- lapply(ducks, terra::project, y = ducks[[3]]) #see below why I chose to use the 3rd raster as the template for reprojection

#export snapped rasters
lapply(ducks, function(x) {writeRaster(x, filename = paste0("data/generated/snapped-rasters/", names(x), "_snapped.tif"))})
