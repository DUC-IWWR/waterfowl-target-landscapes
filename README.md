# Waterfowl Target Landscapes
This repository serves as the main set of analysis scripts and functions to generate the target landscapes as used by Ducks Unlimited Canada (DUC) and the Prairie Habitat Joint Venture (PHJV).
To read more about priority area mapping, please visit [this page](https://phjv.ca/science-and-planning/priority-area-mapping/) on the PHJV website.
More details about the process behind this iteration of target landscapes generation can be viewed in the accompanying guidelines.

## Preface
This repository is meant to serve as an internal analysis, for which the results will be made public through various channels.
As such, much of the input data for this analysis (e.g., DSS/species distribution modelling rasters) cannot be made public on GitHub due to data sensitivity.
We view the public facing side of this repository as a way to document this iteration of target landscape formation, and as a way to be transparent about how the target landscapes are being generated.

## Use
This repo makes use of the R packages [targets](https://github.com/ropensci/targets) and[geotargets](https://github.com/ropensci/geotargets) for workflow purposes...shockingly the pun was discovered well after the use of these packages.
This repo also makes use of the program [Zonation 5](https://zonationteam.github.io/Zonation5/), which is a prioritization tool that is used to identify area to prioritize for conservation.
As such, if you have access to all rasters, it is a matter of running ```tar_make()``` which will run the pipeline.

The pipeline in this repo serves to generate many different scenarios of target landscapes to explore consequences of different priority thresholds, different minimum polygon sizes, different raster stacking, etc. 
For this particular release, we were interested in comparing target landscapes produced using 1) a stacked layer of duck distribution, 2) separate layers of duck distributions (i.e., one layer for each of the seven species of interest), 3) seperate layers of duck distributions with Northern Pintail weighted 2x, and 4) a combined approach that takes into account each duck distribution raster, as well as the stacked raster which effectively counts for areas of high duck density.
We then generated several scenarios of priority thresholds to try to target approximately 50% of the total duck population being captured by the target landscapes.

### Data Requirements
#### Not Provided
* DSS version 3 layers (data/raw/rasters) [not provided due to data sensitivity]
* Target landscapes version 2 shapefile (data/raw/target-landscapes-previous/PHJV_WaterfowlTargetLandscapes.shp) [not provided due to data sensitivity]
* North American lakes shapefile (data/raw/NA Lakes and Rivers/North American Lakes.shp) [not provided due to data size]
* North American rivers shapefile (data/raw/NA Lakes and Rivers/North American Rivers 500mBuffer.shp) [not provided due to data size]

#### Provided
* PHJV area shapefile (data/raw/PHJV_projected/PHJV_projected.shp)
* Provinces shapefile (data/raw/Provinces_projected/Provinces_projected.shp)
* Target CRS raster (data/raw/target_crs_raster.tif)

### Notes
#### Zonation 5
This script assumes that Zonation 5 is installed on a Windows computer at C:\\Program Files (x86)\\Zonation5.
This is hard coded for now, but if this script ends up getting used by other people, I will consider making a user-set variable to set the location of your own Zonation installation
