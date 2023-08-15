rm_curitiba <- sf::st_read("data/IAT_municipios_rmc_2023.shp")
rm_curitiba <- sf::st_transform(rm_curitiba, 4326)

grade_h3 <- h3jsr::polygon_to_cells(rm_curitiba, res = 7)
grade_h3 <- h3jsr::cell_to_polygon(grade_h3, simple = FALSE)

saveRDS(grade_h3, "data/grade_hex.R")
