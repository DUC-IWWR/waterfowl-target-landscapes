#This script will snap the updated (circa 2024) waterfowl models to the other species density models so results can be compared directly.
#These snapped models should only be used for the Zonation manuscript and not for updating the PHJV Waterfowl Target Landscapes

library(terra)
#load waterfowl rasters
wf <- rast(list.files("Data/SnappedDensityRasters", pattern = ".tif", full.name = T))
#rename the a_mask file (has pixels with a value of 1 to represent areas that have data across all waterfowl species)
names(wf[[1]]) <- "a_mask"

#load protected areas mask as the template to snap to
pa <- rast("Data/masks/PA_All_int.tif")

wf <- project(x = wf, y = pa)

#change no data values in a_mask to NA
wf[[1]][wf[[1]] > 1] <- NA
plot(wf[[1]])

#save snapped raster files
wf <- as.list(wf)
#separate mask raster so it can be changed to integer type
mask <- wf[[1]]
wf <- wf[-1]
lapply(as.list(wf), FUN = function(x) {writeRaster(x, filename = paste0("Data/SnappedDensityRasters/Waterfowl_ZonationMSonly/" ,names(x), ".tif"))} )
writeRaster(mask, filename = "Data/SnappedDensityRasters/Waterfowl_ZonationMSonly/a_mask.tif", datatype = "INT1U")
