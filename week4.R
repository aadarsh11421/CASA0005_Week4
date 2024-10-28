library(tidyverse)
library(dplyr)
library(sf)
library(tmap)
library(tmaptools)
library(geojsonio)
library(countrycode)
library(ggplot2)

worldCountries <- st_read("World_Countries_(Generalized)_9029012925078512962.geojson")
head(worldCountries)
plot(worldCountries)

gii <- read.csv("HDR23-24_Composite_indices_complete_time_series.csv")
#gii <- na.omit(gii)
class(gii)

gii <- gii %>%
  mutate(gii_difference = gii_2019 - gii_2010)
gii$gii_difference

head(gii)

gii$iso3
worldCountries$iso3 <- countrycode(worldCountries$COUNTRY, "country.name","iso3c")

head(worldCountries)

giiWorld <- worldCountries %>%
  left_join(gii, by = "iso3")

ggplot(data = giiWorld) +
  geom_sf(aes(fill = gii_2019)) +
  scale_fill_viridis_c(option = "turbo", limits = c(0, 1)) +
  theme_minimal() +
  labs(title = "Global Inequality Index 2019",
       fill = "GII 2019")

ggplot(data = giiWorld) +
  geom_sf(aes(fill = gii_2010)) +
  scale_fill_viridis_c(option = "turbo", limits = c(0, 1)) +
  theme_minimal() +
  labs(title = "Global Inequality Index 2010",
       fill = "GII 2010")

ggplot(data = giiWorld) +
  geom_sf(aes(fill = gii_difference)) +
  scale_fill_viridis_c(option = "plasma") +
  theme_minimal() +
  labs(title = "Global Inequality Index difference from 2019 to 2010",
       fill = "GII Difference")
