#This script is written to determine the relationship between duck density predictions from a model developed for all species combined
#and relative priority values when that model is put through zonation as a single layer. The goal is to determine what relative priority
#value is associated with the 30 pairs/sqmile threshold that was used to define the current waterfowl target landscapes.

#load the rasters
library(terra)
#original duck model for all 7 species combined
density_old <- rast("Data/SnappedDensityRasters/AllDucksDSSV2")
plot(density_old)
#sum of new duck models across all 7 species
density_new <- rast("Data/DensityRasters/DuckDensity_Original7Species.tif")
plot(density_new)
rp_old <- rast("Output/ZonationRaw/waterfowl_allspecies_old/rankmap.tif")
plot(rp_old)
rp_new <- rast("Output/ZonationRaw/waterfowl_allspecies_new/rankmap.tif")
plot(rp_new)

#reproject new duck density and rp layer to match the old
density_new <- project(x = density_new, y = density_old)
rp_new <- project(x = rp_new, y = rp_old)
#transform new densities from pairs/km^2 to pairs/mile^2
density_new <- density_new/0.386102
plot(density_new)

#plot a random sample of values
library(ggplot2)
sample <- spatSample(x = density_new, size = 10000, as.df = F, values = F, cells = T, na.rm = T)
values <- data.frame("density_old" = values(density_old)[sample], "density_new" = values(density_new)[sample], "rp_old" = values(rp_old)[sample], "rp_new" = values(rp_new)[sample])

#estimate linear model to estimate the new density values associated with 30 pairs/sqmile
lm <- lm(density_new ~ density_old, data = values)
summary(lm)
y <- 1.084004*30+2.404204 #density_new = 35

#now plot the relationship between old and new density models
ggplot(values, aes(x = density_old, y = density_new)) +
  geom_point() +
  geom_smooth(method = "lm", se = T, fullrange = T, level = 0.95) +
  geom_hline(yintercept = 34.92432, linetype = "dashed", color = "red") +
  geom_vline(xintercept = 30, linetype = "dashed", color = "red") +
  theme(axis.line = element_line(color = "black"), axis.text = element_text(size = 14), axis.title = element_text(size = 18)) +
  labs(x = "Density DSS V2", y = "Density (sum of new models)")

#30 pairs/sqmile from the old model equates to roughly 35 pairs in the new model, so 
#identify rp_new threshold around 35 pairs/sqmi 
thres <- mean(values[values$density_new>34.5&values$density_new<35.5, ]$rp_new)
ggplot(values, aes(x = density_new, y = rp_new)) +
  geom_point() +
  geom_hline(yintercept = 0.78, linetype = "dashed", color = "black") +
  geom_vline(xintercept = 35, linetype = "dashed", color = "black") +
  theme(axis.line = element_line(color = "black"), axis.text = element_text(size = 14), axis.title = element_text(size = 18)) +
  labs(x = "Density (pairs/square mile)", y = "Relative priority")


#Determine minimum polygon size within existing target landscapes
#load target landscapes
tl <- vect("Data/masks/PHJV_Target_Landscapes_v2.shp")
area <- expanse(tl, unit = "km")
min(area) #min area is 156 km^2


