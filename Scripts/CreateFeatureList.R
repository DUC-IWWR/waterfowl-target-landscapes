#This script creates the feature list text files for the Zonation runs for each species. It pulls conservation concern
#scores from the ACAD database and applies them as weights for each species
library(dplyr)
#Import species codes table, ACAD regional concern scores, SARA status, and species list for this project
codes <- read.csv("Data/IBPSpeciesCodes.csv") %>% select(SPEC, COMMONNAME) %>%
         rename(Common.Name = COMMONNAME, species = SPEC)
rcs <- read.csv("Data/ACADRegional2024.06.03.csv") %>% select(Common.Name, RCS.b)
sp <- read.csv("Data/SpeciesList.csv")
sar <- read.csv("Data/SAR.csv") %>% 
  select(Common.Name, SARA..Status.Current, SARA.Status.Comment) %>% 
  rename(current = SARA..Status.Current, comment = SARA.Status.Comment)

#join tables together
sp <- sp %>% left_join(codes, by = 'species') %>%
             left_join(sar, by = 'Common.Name') %>%
             left_join(rcs, by = 'Common.Name')

#create weight column
sp$weight <- ifelse(is.na(sp$current), sp$RCS.b, 
                    ifelse(sp$current == "EN"|sp$current == "TH", 40, 30)) 
sp <- sp %>% select(weight, species, BirdGroup)

#separate table into bird groups
lb <- sp %>% filter(BirdGroup == "Landbird")
mb <- sp %>% filter(BirdGroup == "Marshbird")
sb <- sp %>% filter(BirdGroup == "Shorebird")
wf <- sp %>% filter(BirdGroup == "Waterfowl")

#add filename column and remove all others (needed for featurelist file), then export
#NOTE, QUOTATIONS NEED TO BE MANUALLY ADDED AROUND COLUMN NAMES IN THE TXT FILE AFTER EXPORT WITH WRITE.TABLE
#Landbirds
lb$filename <- paste0("../../../Data/SnappedDensityRasters/Landbirds/", lb$species, "_2018_50.tif")
lb <- lb %>% select(weight, filename)
write.table(lb, file = "Scripts/ZonationFiles/landbirds_cazmax_wgt/landbirds_cazmax_wgt_featurelist.txt", 
            quote = F, sep = " ", row.names = F)

#Marshbirds
mb$filename <- paste0("../../../Data/SnappedDensityRasters/Marshbirds/", mb$species, "_occu.tif")
#update files names for species with density models and different file naming comvention
mb$filename[c(3,9,10,12,13)] <- paste0("../../../Data/SnappedDensityRasters/Marshbirds/", 
                                       mb$species[c(3,9,10,12,13)], "_2018_50.tif")
mb <- mb %>% select(weight, filename)

write.table(mb, file = "Scripts/ZonationFiles/marshbirds_cazmax_wgt/marshbirds_cazmax_wgt_featurelist.txt", 
            quote = F, sep = " ", row.names = F)

#Marshbirds
sb$filename <- paste0("../../../Data/SnappedDensityRasters/Shorebirds/", sb$species, "_2018_50.tif")
sb <- sb %>% select(weight, filename)
write.table(sb, file = "Scripts/ZonationFiles/shorebirds_cazmax_wgt/shorebirds_cazmax_wgt_featurelist.txt", 
            quote = F, sep = " ", row.names = F)

#Waterfowl
wf$filename <- paste0("../../../Data/SnappedDensityRasters/Waterfowl_ZonationMSonly/", wf$species, ".tif")
wf <- wf %>% select(weight, filename)
write.table(wf, file = "Scripts/ZonationFiles/waterfowl_cazmax_wgt_PA/waterfowl_cazmax_wgt_PA_featurelist.txt", 
            quote = F, sep = " ", row.names = F)
