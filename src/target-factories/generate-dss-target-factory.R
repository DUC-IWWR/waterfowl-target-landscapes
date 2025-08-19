generate_dss_target_factory <- function()
{
  dss_target_factory <- tar_map(
    values = tibble::tibble(dss_name = c("stacked_v3",
                                         "mall",
                                         "bwte",
                                         "gadw",
                                         "nopi",
                                         "nsho",
                                         "canv",
                                         "redh",
                                         "stacked_v2"),
                            raw_raster_path = c("data/raw/rasters/7species_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/MALL_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/BWTE_Pairs_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/GADW_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/NOPI_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/NSHO_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/CANV_Pairs_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/REDH_perSQK_CopyRaster.tif",
                                                "data/raw/rasters/DSS_v2.tif")),
    names = dss_name,
    unlist = FALSE,
    
    tar_target(
      name = dss_raw,
      command = raw_raster_path,
      format = "file"
    ),
    
    tar_target(
      name = dss_snapped,
      command = snap_density_raster(raster_file = dss_raw,
                                    ref = target_crs),
      format = "file"
    ),
    
    tar_target(
      name = dss_masked,
      command = mask_dss(raster_file = dss_snapped,
                         phjv = phjv[which(phjv$CA_REGION == "PPR"),],
                         lakes = lakes,
                         rivers = rivers_500m_buffer)
    )
  )
  
  return(dss_target_factory)
}