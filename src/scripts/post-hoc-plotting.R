####### Script Information ########################
# Brandon P.M. Edwards
# Waterfowl Target Landscapes
# post-hoc-plotting.R
# Created 22 April 2025
# Last Updated 6 May 2025

####### Import Libraries and External Files #######

library(targets)
library(terra)

tar_source("src/calculate-tl-area.R")
tar_source("src/calculate-tl-population.R")
tar_source("src/calculate-tl-area-province.R")

####### Read Data #################################

tar_load(names = c("separate_layers_weighted_rankmap", "separate_layers_rankmap",
                   "stacked_layers_rankmap", "combined_rankmap", 
                   "tl_combined_poly156_thres0.76", 
                   "tl_combined_poly128_thres0.76",
                   "tl_combined_poly100_thres0.76",
                   "tl_sep_layers_poly156_thres0.76",
                   "tl_sep_layers_weighted_poly156_thres0.76",
                   "tl_stacked_layers_poly156_thres0.76",
                   "tl_old",
                   "mall_masked", "gadw_masked", "nopi_masked", "bwte_masked",
                   "nsho_masked", "canv_masked", "redh_masked",
                   "provinces", "phjv", "species_7_masked"))

####### Projections ###############################

tlo <- vect(tl_old)
tlo <- project(tlo, combined_rankmap)

crs(tl_combined_poly156_thres0.76) <- crs(combined_rankmap)

####### Generate Plots ############################

png("output/plots/tl-stacked.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(stacked_layers_rankmap, alpha = 0.5)
lines(tl_stacked_layers_poly156_thres0.76)
lines(provinces)
dev.off()
stacked_total_area <- calculate_tl_area(target_landscape = tl_stacked_layers_poly156_thres0.76,
                                       rankmap = stacked_layers_rankmap)
stacked_prop_area <- stacked_total_area / expanse(stacked_layers_rankmap, unit = "km")
stacked_prov_prop_area <- calculate_tl_area_province(target_landscape = tl_stacked_layers_poly156_thres0.76,
                                                     provinces = provinces,
                                                     rankmap = stacked_layers_rankmap)
stacked_prop_pop <- calculate_tl_population(target_landscape = tl_stacked_layers_poly156_thres0.76,
                                            species = c(species_7_masked))
stacked_prop_species_pop <- calculate_tl_population(target_landscape = tl_stacked_layers_poly156_thres0.76,
                                                    species = c(mall_masked,
                                                                gadw_masked,
                                                                nopi_masked,
                                                                bwte_masked,
                                                                nsho_masked,
                                                                canv_masked,
                                                                redh_masked))



png("output/plots/tl-separate.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(separate_layers_rankmap, alpha = 0.5)
lines(tl_sep_layers_poly156_thres0.76)
lines(provinces)
dev.off()
separate_total_area <- calculate_tl_area(target_landscape = tl_sep_layers_poly156_thres0.76,
                                        rankmap = separate_layers_rankmap)
separate_prop_area <- separate_total_area / expanse(separate_layers_rankmap, unit = "km")
separate_prov_prop_area <- calculate_tl_area_province(target_landscape = tl_sep_layers_poly156_thres0.76,
                                                     provinces = provinces,
                                                     rankmap = separate_layers_rankmap)
separate_prop_pop <- calculate_tl_population(target_landscape = tl_sep_layers_poly156_thres0.76,
                                            species = c(species_7_masked))
separate_prop_species_pop <- calculate_tl_population(target_landscape = tl_sep_layers_poly156_thres0.76,
                                                    species = c(mall_masked,
                                                                gadw_masked,
                                                                nopi_masked,
                                                                bwte_masked,
                                                                nsho_masked,
                                                                canv_masked,
                                                                redh_masked))




png("output/plots/tl-separate-weighted.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(separate_layers_rankmap, alpha = 0.5)
lines(tl_sep_layers_weighted_poly156_thres0.76)
lines(provinces)
dev.off()

separate_weighted_total_area <- calculate_tl_area(target_landscape = tl_sep_layers_weighted_poly156_thres0.76,
                                         rankmap = separate_layers_weighted_rankmap)
separate_weighted_prop_area <- separate_weighted_total_area / expanse(separate_layers_weighted_rankmap, unit = "km")
separate_weighted_prov_prop_area <- calculate_tl_area_province(target_landscape = tl_sep_layers_weighted_poly156_thres0.76,
                                                      provinces = provinces,
                                                      rankmap = separate_layers_weighted_rankmap)
separate_weighted_prop_pop <- calculate_tl_population(target_landscape = tl_sep_layers_weighted_poly156_thres0.76,
                                             species = c(species_7_masked))
separate_weighted_prop_species_pop <- calculate_tl_population(target_landscape = tl_sep_layers_weighted_poly156_thres0.76,
                                                     species = c(mall_masked,
                                                                 gadw_masked,
                                                                 nopi_masked,
                                                                 bwte_masked,
                                                                 nsho_masked,
                                                                 canv_masked,
                                                                 redh_masked))

png("output/plots/tl-combined.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(combined_rankmap, alpha = 0.5)
lines(tl_combined_poly156_thres0.76)
lines(provinces)
dev.off()

png("output/plots/tl-combined+old.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(combined_rankmap, alpha = 0.5)
lines(tl_combined_poly156_thres0.76)
lines(tlo, col = "red")
lines(provinces)
dev.off()

png("output/plots/tl-combined+old+overlap.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(combined_rankmap, alpha = 0.5)
lines(tl_combined_poly156_thres0.76, alpha = 0.5)
lines(tlo, col = "red", alpha = 0.5)
lines(terra::intersect(tl_combined_poly156_thres0.76, tlo), col = "red", lwd = 1.5)
lines(provinces)
dev.off()

combined_total_area <- calculate_tl_area(target_landscape = tl_combined_poly156_thres0.76,
                                                  rankmap = separate_layers_weighted_rankmap)
combined_prop_area <- combined_total_area / expanse(separate_layers_weighted_rankmap, unit = "km")
combined_prov_prop_area <- calculate_tl_area_province(target_landscape = tl_combined_poly156_thres0.76,
                                                               provinces = provinces,
                                                               rankmap = separate_layers_weighted_rankmap)
combined_prop_pop <- calculate_tl_population(target_landscape = tl_combined_poly156_thres0.76,
                                                      species = c(species_7_masked))
combined_prop_species_pop <- calculate_tl_population(target_landscape = tl_combined_poly156_thres0.76,
                                                              species = c(mall_masked,
                                                                          gadw_masked,
                                                                          nopi_masked,
                                                                          bwte_masked,
                                                                          nsho_masked,
                                                                          canv_masked,
                                                                          redh_masked))

old_tl_area <- sum(expanse(tlo, unit = "km"))
new_tl_area <- expanse(tl_combined_poly156_thres0.76, unit = "km")

overlapped_tl <- terra::intersect(tl_combined_poly156_thres0.76, tlo)
overlapped_area <- sum(expanse(overlapped_tl, unit = "km"))





png("output/plots/tl-combined-128.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(combined_rankmap, alpha = 0.5)
lines(tl_combined_poly128_thres0.76)
lines(provinces)
dev.off()

combined_128_total_area <- calculate_tl_area(target_landscape = tl_combined_poly128_thres0.76,
                                             rankmap = separate_layers_weighted_rankmap)
combined_128_prop_area <- combined_128_total_area / expanse(separate_layers_weighted_rankmap, unit = "km")
combined_128_prov_prop_area <- calculate_tl_area_province(target_landscape = tl_combined_poly128_thres0.76,
                                                          provinces = provinces,
                                                          rankmap = separate_layers_weighted_rankmap)
combined_128_prop_pop <- calculate_tl_population(target_landscape = tl_combined_poly128_thres0.76,
                                                 species = c(species_7_masked))
combined_128_prop_species_pop <- calculate_tl_population(target_landscape = tl_combined_poly128_thres0.76,
                                                         species = c(mall_masked,
                                                                     gadw_masked,
                                                                     nopi_masked,
                                                                     bwte_masked,
                                                                     nsho_masked,
                                                                     canv_masked,
                                                                     redh_masked))




png("output/plots/tl-combined-100.png", width = 8, height = 6, 
    units = "in", res = 300)
plot(combined_rankmap, alpha = 0.5)
lines(tl_combined_poly100_thres0.76)
lines(provinces)
dev.off()

combined_100_total_area <- calculate_tl_area(target_landscape = tl_combined_poly100_thres0.76,
                                             rankmap = separate_layers_weighted_rankmap)
combined_100_prop_area <- combined_100_total_area / expanse(separate_layers_weighted_rankmap, unit = "km")
combined_100_prov_prop_area <- calculate_tl_area_province(target_landscape = tl_combined_poly100_thres0.76,
                                                          provinces = provinces,
                                                          rankmap = separate_layers_weighted_rankmap)
combined_100_prop_pop <- calculate_tl_population(target_landscape = tl_combined_poly100_thres0.76,
                                                 species = c(species_7_masked))
combined_100_prop_species_pop <- calculate_tl_population(target_landscape = tl_combined_poly100_thres0.76,
                                                         species = c(mall_masked,
                                                                     gadw_masked,
                                                                     nopi_masked,
                                                                     bwte_masked,
                                                                     nsho_masked,
                                                                     canv_masked,
                                                                     redh_masked))
