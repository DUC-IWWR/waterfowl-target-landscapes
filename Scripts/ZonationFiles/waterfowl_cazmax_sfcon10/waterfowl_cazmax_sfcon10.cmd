@setlocal
@PATH=C:\Program Files (x86)\Zonation5;%PATH%

z5_16bit -ad --mode=CAZMAX --gui waterfowl_cazmax_sfcon10.z5 ../../../Output/ZonationRaw/waterfowl_cazmax_sfcon10
#-a = analysis area mask, which will exlude any pixels that don't have data for all species
#-d = single feature connectivity

@pause
