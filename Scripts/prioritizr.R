#This script uses prioritizr to identify priority areas for waterfowl and other bird groups within the Prairie Habitat Joint Venture

#Load packages
library(prioritizr)
library(terra)
library(sf)
library(tidyverse)
#load duck density rasters, excluding the combined, multi-species rasters (files names that contain "DuckDensity")

#use this line for all 10 species
###
#ducklist <- grep(list.files("Data/DensityRasters", full.names = T), pattern = "DuckDensity", invert = T, value = T)
###

#use this line for a selection of species
ducklist <- grep(list.files("data/raw/density-rasters", full.names = T), pattern = "MALL|GADW|NOPI|BWTE|NSHO|CANV|REDH", value = T)


#the extents and origins are different, so need to initially load them as a list
ducks <- lapply(ducklist, rast)
lapply(ducks, terra::origin) # 4 of 10 rasters have the same origin (3, 5, 9, 10 in list), so resample to that origin (i.e use 3rd raster as a template)
lapply(ducks, terra::ext)

#use project to match projection, resolution, origin, and extent, then stack
ducks <- lapply(ducks, terra::project, y = ducks[[3]]) #see below why I chose to use the 3rd raster as the template for reprojection
ducks <- rast(ducks[1:4])

#create a planning unit raster that provides the cost of conserving each pixel. In our case, we'll set the cost of all 
#pixels to 1 because in our case, we're only trying to minimize area, so all pixels need to have the same value
pu <- rast(ducks[[1]], vals = 1)

#divide each duck raster by 1000 to ensure population targets are not too large for the optimizer
ducks <- ducks/1000
#try example problem 
p1 <- problem(pu, ducks) %>%
      add_min_set_objective() %>%
      add_relative_targets(0.2) %>%
      add_boundary_penalties(penalty = 200) %>%
      add_gurobi_solver()
s1 <- solve(p1)

