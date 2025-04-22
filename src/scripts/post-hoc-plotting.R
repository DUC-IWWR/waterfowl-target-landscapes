####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# post-hoc-plotting.R
# Created 22 April 2025
# Last Updated 22 April 2025

####### Import Libraries and External Files #######

library(targets)
library(terra)

####### Read Data #################################

tar_load(names = c("single_layer_rankmap", "separate_layer_rankmap",
                   "guild_level_rankmap", "single_layer_tl", "separate_layer_tl", 
                   "guild_level_tl", "tl_old", "divers_stacked"))

####### Generate Plots ############################

# Building up the 7 species layer
# First just the rank map
png("output/plots/single-layer-rankmap.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(single_layer_rankmap))
dev.off()

# Now the rankmap with target landscapes
png("output/plots/single-layer-rankmap+tl.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(single_layer_rankmap), alpha = 0.5)
lines(vect(single_layer_tl))
dev.off()

# Now the rankmap with target landscapes + old target landscapes
png("output/plots/single-layer-rankmap+tl+old_tl.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(single_layer_rankmap), alpha = 0.5)
lines(vect(single_layer_tl), alpha = 0.75)
lines(project(vect(tl_old), vect(single_layer_tl)), col = "red", lwd = 2)
dev.off()





# Building up the indivudual species plots
# First just the rank map
png("output/plots/separate-layer-rankmap.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(separate_layer_rankmap))
dev.off()

# Now the rankmap with target landscapes
png("output/plots/separate-layer-rankmap+tl.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(separate_layer_rankmap), alpha = 0.5)
lines(vect(separate_layer_tl))
dev.off()

# Now the rankmap with target landscapes + old target landscapes
png("output/plots/separate-layer-rankmap+tl+old_tl.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(separate_layer_rankmap), alpha = 0.5)
lines(vect(separate_layer_tl), alpha = 0.75)
lines(project(vect(tl_old), vect(separate_layer_tl)), col = "red", lwd = 2)
dev.off()




# Building up the guild level plots
# First just the rank map
png("output/plots/guild-level-rankmap.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(guild_level_rankmap))
dev.off()

# Now the rankmap with target landscapes
png("output/plots/guild-level-rankmap+tl.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(guild_level_rankmap), alpha = 0.5)
lines(vect(guild_level_tl))
dev.off()

# Now the rankmap with target landscapes + old target landscapes
png("output/plots/guild-level-rankmap+tl+old_tl.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(rast(guild_level_rankmap), alpha = 0.5)
lines(vect(guild_level_tl), alpha = 0.75)
lines(project(vect(tl_old), vect(guild_level_tl)), col = "red", lwd = 2)
dev.off()

plot(rast(divers_stacked), alpha = 0.5)
lines(vect(separate_layer_tl), col = "white")


