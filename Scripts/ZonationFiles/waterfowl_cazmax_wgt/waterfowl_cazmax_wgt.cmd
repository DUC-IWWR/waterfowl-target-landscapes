@setlocal
@PATH=C:\Program Files (x86)\Zonation5;%PATH%

z5_16bit -aw --mode=CAZMAX --gui waterfowl_cazmax_wgt.z5 ../../../Output/ZonationRaw/waterfowl_cazmax_wgt
#-a = analysis area mask, which will exlude any pixels that don't have data for all species
#-w = apply species weighting based on the "weight" column in the featurelist file.
@pause