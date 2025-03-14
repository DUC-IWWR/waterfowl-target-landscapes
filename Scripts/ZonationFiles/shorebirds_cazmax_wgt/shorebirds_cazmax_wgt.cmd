@setlocal
@PATH=C:\Program Files (x86)\Zonation5;%PATH%

z5_16bit -hw --mode=CAZMAX --gui shorebirds_cazmax_wgt.z5 ../../../Output/ZonationRaw/shorebirds_cazmax_wgt
#-w = apply species weighting based on the "weight" column in the featurelist file
#-h = Hierarchic analysis that takes into account existing protected areas
@pause