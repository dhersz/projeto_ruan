rm_curitiba <- sf::st_read("data/IAT_municipios_rmc_2023.shp")
rm_curitiba <- sf::st_transform(rm_curitiba, 4326)

bbox <- sf::st_bbox(rm_curitiba)

query <- paste(bbox$xmin, bbox$ymin, bbox$xmax, bbox$ymax, sep = ",")
