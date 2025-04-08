@setlocal
@PATH=C:\Program Files (x86)\Zonation5;%PATH%

z5_16bit --mode=CAZMAX --gui waterfowl_cazmax.z5 ../../output/zonation/waterfowl_cazmax
#-a = analysis area mask, which will exlude any pixels that don't have data for all species

@pause