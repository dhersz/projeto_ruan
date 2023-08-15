rm_curitiba <- sf::st_read("data/IAT_municipios_rmc_2023.shp")
rm_curitiba <- sf::st_transform(rm_curitiba, 4326)

bbox <- sf::st_bbox(rm_curitiba)

lons <- seq(floor(bbox$xmin), ceiling(bbox$xmax - 1), by = 1)
lats <- seq(floor(bbox$ymin), ceiling(bbox$ymax - 1), by = 1)

coords <- expand.grid(lat = lats, lon = lons)
descricao_celula <- paste0("S", coords$lat * (-1), "W0", coords$lon * (-1))

url_celulas <- paste0(
  "https://e4ftl01.cr.usgs.gov/MEASURES/SRTMGL1.003/2000.02.11/",
  descricao_celula,
  ".SRTMGL1.hgt.zip"
)

output <- file.path(tempdir(), paste0(descricao_celula, ".hgt.zip"))

responses <- mapply(
  url = url_celulas,
  out = output,
  function(url, out) {
    httr::GET(
      url,
      httr::authenticate(
        Sys.getenv("EARTHDATA_LOGIN"),
        Sys.getenv("EARTHDATA_PASS")
      ),
      httr::write_disk(out, overwrite = TRUE),
      httr::progress()
    )
  }
)

for (out in output) utils::unzip(out, exdir = tempdir())

rasters <- gsub("\\.zip", "", output)

lista_rasters <- lapply(rasters, terra::rast)
raster_combinado <- do.call(
  terra::mosaic,
  args = c(lista_rasters, fun = "mean")
)
