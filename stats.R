setwd("C:/Users/ftw712/Desktop/gbif-country-density-table/")

library(dplyr)
library(purrr)

# mutate(area_sqkm = round(area_sqkm,100)) %>% 
# CoordinateCleaner::countryref %>% 
# select(iso2,area_sqkm) %>%
# na.omit() %>% 
# group_by(iso2) %>%
# summarise(area_sqkm = dplyr::first(area_sqkm)) %>%
# na.omit() %>% 
# glimpse() %>%
# readr::write_tsv("data/sqkm.tsv")

tt = readr::read_tsv("data/sqkm.tsv") %>%
glimpse() %>% 
select(iso2,area_sqkm) %>% 
merge(rgbif::enumeration_country(),by="iso2",all.y=TRUE) %>% 
mutate(occ_count=map_dbl(iso2,~rgbif::occ_count(country=.x))) %>% 
select(iso2,title,gbifRegion,occ_count,area_sqkm) %>% 
na.omit() %>% 
mutate(occ_per_sqkm = occ_count/area_sqkm) %>%
arrange(-occ_per_sqkm) %>%
mutate(area_sqkm = format(area_sqkm,digits=1,scientific=FALSE)) %>%
mutate(occ_per_sqkm = format(occ_per_sqkm,digits=1,scientific=FALSE)) %>%
glimpse()

tt %>% readr::write_tsv("exports/occ_density_table.tsv")

tt %>% knitr::kable()