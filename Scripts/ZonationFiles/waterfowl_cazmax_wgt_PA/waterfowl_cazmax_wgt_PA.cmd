@setlocal
@PATH=C:\Program Files (x86)\Zonation5;%PATH%

z5_16bit -awh --mode=CAZMAX --gui waterfowl_cazmax_wgt_PA.z5 ../../../Output/ZonationRaw/waterfowl_cazmax_wgt_PA
#-a = analysis area mask, which will exlude any pixels that don't have data for all species
#-w = apply species weighting based on the "weight" column in the featurelist file.
#-h = Hierarchic analysis that takes into account existing protected areas
@pause