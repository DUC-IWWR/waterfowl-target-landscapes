#This script calculates the Volumne of Intersection Index to make comparisons of the amount of overlap between
#relative priority surface of different species groups in a pairwise manner.
#Author:Barry Robinson
#Nov, 2024

library(terra)

#input relative priority rasters
lb <- rast("Output/ZonationRaw/landbirds_cazmax_wgt/rankmap.tif")
mb <- rast("Output/ZonationRaw/marshbirds_cazmax_wgt/rankmap.tif")
sb <- rast("Output/ZonationRaw/shorebirds_cazmax_wgt/rankmap.tif")
wf <- rast("Output/ZonationRaw/waterfowl_cazmax_wgt_PA/rankmap.tif")

#The waterfowl models span a different area than the other species groups, so need to mask
wf <- mask(x = wf, mask = lb)

#Set all pixels that fall within existing protected areas to NA
pa <- rast("Data/masks/PA_All_int.tif")
lb[pa==1] <- NA
mb[pa==1] <- NA
sb[pa==1] <- NA
wf[pa==1] <- NA

#for each raster, divide by the sum of all pixels so that pixels sum to 1
lb.sum <- global(lb, 'sum', na.rm = T)[1,1]
lb.1 <- lb/lb.sum

mb.sum <- global(mb, 'sum', na.rm = T)[1,1]
mb.1 <- mb/mb.sum

sb.sum <- global(sb, 'sum', na.rm = T)[1,1]
sb.1 <- sb/sb.sum

wf.sum <- global(wf, 'sum', na.rm = T)[1,1]
wf.1 <- wf/wf.sum

#double check that all pixels sum to 1
global(lb.1, 'sum', na.rm = T)[1,1]
global(mb.1, 'sum', na.rm = T)[1,1]
global(sb.1, 'sum', na.rm = T)[1,1]
global(wf.1, 'sum', na.rm = T)[1,1]

#put results in list
vi <- list(lb.1, mb.1, sb.1, wf.1)
groups <- c("lb", "mb", "sb", "wf")
names(vi) <- groups

#calculate VI for each pair of rasters (create new raster based on min of raster pair, then sum all pixels)
#create an empty matrix to populate
mat <- matrix(data = NA, nrow = 4, ncol = 4)
row.names(mat) <- groups
colnames(mat) <- groups

#run loop to calculate VI for each pair-wise comparison.
for(i in groups) {
  for (j in groups) {
    mat[i,j] <- global(min(vi[[i]], vi[[j]]), 'sum', na.rm = T)[1,1]
  }
} 

#export
write.csv(mat, "Output/VI.csv")

