# All packages used in this script:
library(tidyverse)
library(here)
library(withr)

url <- "https://github.com/jonthegeek/apis/raw/main/data/data_ufo_reports_with_day_part.rds"
ufo_path <- withr::local_tempfile(fileext = ".rds")
download.file(url, ufo_path)

ufo_data_original <- readRDS(ufo_path)

# We need to make the csv small enough that github won't choke. We'll pull out
# some of the joined data back into separate tables.

ufo_sightings <- ufo_data_original |> 
  dplyr::select(
    reported_date_time:city,
    state, 
    country_code,
    shape:has_images,
    day_part
  ) |> 
  # This got normalized after the data was saved, re-normalize.
  dplyr::mutate(
    shape = tolower(shape)
  )

places <- ufo_data_original |>
  dplyr::select(
    city:country_code, 
    latitude:elevation_m
  ) |> 
  dplyr::distinct()

# We'll also provide the map of "day parts" in case anybody wants to do
# something with that.
url2 <- "https://github.com/jonthegeek/apis/raw/main/data/data_day_parts_map.rds"
day_parts_path <- withr::local_tempfile(fileext = ".rds")
download.file(url2, day_parts_path)

day_parts_map <- readRDS(day_parts_path)

readr::write_csv(
  ufo_sightings,
  here::here(
    "data",
    "2023",
    "2023-06-20",
    "ufo_sightings.csv"
  )
)

readr::write_csv(
  places,
  here::here(
    "data",
    "2023",
    "2023-06-20",
    "places.csv"
  )
)

readr::write_csv(
  day_parts_map,
  here::here(
    "data",
    "2023",
    "2023-06-20",
    "day_parts_map.csv"
  )
)