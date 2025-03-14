#Relationship between relative priority values and density of individual waterfowl species
library(terra)

#import relative priority layer
rp <- rast("Output/waterfowl_nulloptions_cazmax/rankmap.tif")

#load waterfowl rasters
waterfowl <- rast(list.files("Data/SnappedDensityRasters", pattern = "snapped", full.names = T))

#extract raster values across all cells
values <- as.data.frame(cbind(values(rp), values(waterfowl)))


#plot values
plot(x = values$rankmap, y  = values$BWTE)
plot(x = values$rankmap, y  = values$MALL)
points(x = values$rankmap, y = values$MALL)
