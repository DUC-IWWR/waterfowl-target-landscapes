#This script provides summary information about draft updates to the PHJV waterfowl Target Landscapes.
#The summary will include the following info about each draft TL:  (1) total area, (2) proportion of total waterfowl population included, (3) mean waterfowl density within

library(terra)

#Import TL polygons and summed duck density across all 7 species
files <- list.files("Output/ZonationPostprocessing/Polygons", pattern = ".shp", full.names = T)
polys <- lapply(files, FUN = vect)
names <- list.files("Output/ZonationPostprocessing/Polygons", pattern = ".shp")
names <- substr(names, start = 1, stop = nchar(names)-4)
names(polys) <- names

#import current TLs, reproject, and add to the list
currentTL <- vect("Data/masks/PHJV_Target_landscapes_v2.shp")
currentTL <- project(currentTL, crs(polys[[1]]))

#disolve into a single polygon
currentTL <- aggregate(currentTL, dissolve = T)
polys <- append(polys, currentTL)
names(polys)[6] <- "currentTL"

#import summed densities of all 7 species
density <- rast("Data/DensityRasters/DuckDensity_Original7Species.tif")

#calculate area
area <- lapply(polys, FUN = expanse, unit = "km")
area <- unlist(area)

#Calculate proportion of waterfowl population
#first need to transform density predictions into pairs/pixel using pixel resolution
res <- prod(res(density))*0.000001 #calculate pixel area in km^2
density <- density*res
totalPop <- sum(values(density), na.rm =T) #total waterfowl population (pairs)

#calculate population size within each draft TL and divide by total pop to get proportion
propPop <- lapply(polys, FUN = function(x) {return(zonal(x = density, z = x, fun = "sum", na.rm = T))})
propPop <- unlist(propPop)/totalPop
names(propPop) <- gsub(pattern = ".DuckDensity_Original7Species", replace = "", x = names(propPop))

#calculate mean density within each of the draft TLs
meanDen <- lapply(polys, FUN = function(x) {return(zonal(x = density, z = x, fun = "mean", na.rm = T))})
meanDen <- unlist(meanDen)/res #divide by pixel size to transform from pairs/pixel to pairs/km^2
names(meanDen) <- gsub(pattern = ".DuckDensity_Original7Species", replace = "", x = names(meanDen))

#combine results into a single table and export
results <- rbind(area, propPop, meanDen)
results <- cbind(c("Area (km^2)", "Proportion of population", "Mean density (pairs/km^2)"), results)
colnames(results)[1] <- "Metric"

write.csv(results, "Output/DraftTL_SummaryStats.csv", row.names = FALSE)
