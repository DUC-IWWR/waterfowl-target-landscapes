#This script applies a threshold value to create new waterfowl target landscape polygons from the Zonation relative priority surfaces
#Using the waterfowl_RPvsDensity.R script, I determined that a relative priority value of 0.78 is associated with the 30 pairs/sqmile 
#threshold that was used to define the old Target Landscapes, so I will use that threshold here.

library(terra)
library(smoothr)

#load relative priority surfaces (nw for no intail weight, w for pintail weight of 2)
nw <- rast("Output/ZonationRaw/waterfowl_cazmax/rankmap.tif")
names(nw) <- "noPintailwgt"
w <- rast("Output/ZonationRaw/waterfowl_cazmax_wgt/rankmap.tif")
names(w) <- "Pintailwgt"

#Load zonation output when only the sum of the new (DSSV3) 7 species models is input into Zonation
allV3 <- rast("Output/ZonationRaw/waterfowl_allspecies_new/rankmap.tif")
names(allV3) <- "7spDSSV3"

 
#define reclass table and reclassify WITH 0.78 as cutoff. ONly need to run this once. Skip to next section if reclassified rasters have already been saved
# rcl <- matrix(data = c(-0.01,0.78,0.78,1.0,NA,1),
#               nrow=2, ncol=3)
# rcl.rankmaps <- lapply(list(nw,w),
#                        function(x) {
#                          return(classify(x = x, rcl = rcl, filename = paste0("Output/ZonationPostprocessing/ReclassRasters/", "waterfowlTL_", names(x),".tif"), overwrite = T))
#                        })


rcl <- matrix(data = c(-0.01,0.70,0.70,1.0,NA,1),
              nrow=2, ncol=3)
rcl.rankmaps <- lapply(list(nw,w),
                       function(x) {
                         return(classify(x = x, rcl = rcl, filename = paste0("Output/ZonationPostprocessing/ReclassRasters/", "waterfowlTL0.7", names(x),".tif"), overwrite = T))
                       })

calcPoly <- function(raster, thres, minpoly, maxhole, smooth) { #raster = raw raster output from Zonation, thres = relative priority threshold for defining priority areas, minpoly = minimum polygon size in m^2, maxhole = maximum hole size in m^2, smooth = smoothnes parameter
  require(terra)
  require(sf)
  require(smoothr)
  #reclassify raster based on user-defined threshold
  rcl = matrix(data = c(-0.01,thres,thres,1.0,NA,1),
                nrow=2, ncol=3)
  tmp = classify(x = raster, rcl = rcl, filename = paste0("Output/ZonationPostprocessing/ReclassRasters/", "waterfowlTL_", thres, "_", names(raster),".tif"))
        
  #transform to polygon for sf
  tl = as.polygons(tmp, aggregate = T)
  tl = st_as_sf(tl)
  #remove small isolated polygons
  tl_drop = drop_crumbs(tl, threshold = minpoly) #156km^2 = 156000000m^2
  #fill holes in polygons
  tl_fill = fill_holes(tl_drop, threshold = maxhole)
  #smooth polygon borders
  tl_smooth = smooth(tl_fill, method = "ksmooth", smoothness = smooth)
  file = paste0("Output/ZonationPostprocessing/Polygons/", "TL_", thres, "_", names(raster), ".shp")
  st_write(tl_smooth, dsn = file, filetype = "ESRI Shapefile")
}

results <- calcPoly(raster = allV3, thres = 0.78, minpoly = 156000000, maxhole = 70000000, smooth = 8)

TLs <- lapply(rcl.rankmaps, calcPoly, y = 156000000, z = 70000000)
#minimum polygon size in original target landscapes is 156km^2. Transform to area in number of pixels
res(nw) #400 x 400m
minsize <- 156/(0.4*0.4)

