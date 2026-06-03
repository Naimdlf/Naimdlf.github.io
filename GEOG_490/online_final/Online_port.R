#-------------------------------Header------------------------------------------
#title: "Online Final"
#author: Naim Ferris
#date: "June 3rd, 2026"

# Libraries:
install.packages("tidyverse")
install.packages("tidycensus")
library(tidycensus)
census_api_key("fbb3f7914f7097828de7fd0ce50ab55c51222d60", install = TRUE, overwrite=TRUE)
library(tidyverse)
library(sf)
library(scales)
install.packages("mapboxapi")
install.packages("tmap")
install.packages("mapview")
library(mapboxapi)

library(tmap)
library(mapview)
install.packages("spdep")
library(spdep)
options(tigris_use_cache = TRUE)

#--------------------------------Data download----------------------------------
housing_vars <- c(
  median_home_value = "B25077_001",
  rent_burden        = "B25070_001",
  median_income      = "B19013_001"
)

# Bounds Data
lane_housing_sf <- get_acs(
  geography = "tract",
  variables = housing_vars,
  state     = "OR",
  county    = "Lane County",
  year      = 2024, 
  geometry  = TRUE,
  output    = "wide"
)

lane_GEOID = 41039

#--------------------------------Charts-----------------------------------------
#--------------------------------MEDIAN GROSS RENT------------------------------
lane_top20 <- lane_housing_sf %>% slice_max(order_by = rent_burdenE, n = 20, with_ties = FALSE)

error_map_lane <- ggplot(lane_top20, aes(x = rent_burdenE, y = reorder(str_remove(NAME, ";.*"), rent_burdenE))) +
  geom_errorbarh(aes(xmin = rent_burdenE - rent_burdenM, xmax = rent_burdenE + rent_burdenM)) +
  geom_point(size = 3, color = "darkorange") +
  theme_minimal(base_size = 11) +
  labs(
    title = "Median Rent Burden with Margins of Error",
    subtitle = "Top 20 Census Tracts in the Lane County (2024 ACS)",
    x = "2018-2024 ACS Estimate (with MOE)",
    y = ""
  ) +
  scale_x_continuous(labels = label_dollar())

print(error_map_lane)


#-------------------------------Lane County HOME VALUE MOE-------------------------
#FIGURE 4.12 A time series chart of median home values in Deschutes County, OR
#get Lane County data
years <- c(2005:2019, 2021:2024)
names(years) <- years
Lane_County_value <- map_dfr(years, ~{
  get_acs(
    geography = "County",
    state = "OR",
    variables = "B25077_001",
    year = .x,
    survey = "acs1"
  ) %>%
    filter(GEOID == lane_GEOID)
}, .id = "year")

LaneCounty_homevalueMOE<-ggplot(Lane_County_value, aes(x = year, y = estimate, group = 1)) +
  geom_ribbon(aes(ymax = estimate + moe, ymin = estimate - moe),
              fill = "navy",
              alpha = 0.4) +
  geom_line(color = "navy") +
  geom_point(color = "navy", size = 2) +
  theme_minimal(base_size = 12) +
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k")) +
  labs(title = "Median home value in Lane County MSA, OR",
       x = "Year",
       y = "ACS estimate",
       caption = "Shaded area represents margin of error around the ACS estimate")
LaneCounty_homevalueMOE

#next figure

lane_val <- get_acs(
  geography = "county",
  state     = "OR",
  variables = "B25077_001",
  year      = 2024,
  survey    = "acs1"
) %>% 
  filter(GEOID == "41039") %>% 
  mutate(NAME = "Lane County")

or_val <- get_acs(
  geography = "state",
  state     = "OR",
  variables = "B25077_001",
  year      = 2024,
  survey    = "acs1"
) %>% 
  mutate(NAME = "Oregon")

us_val <- get_acs(
  geography = "us",
  variables = "B25077_001",
  year      = 2024,
  survey    = "acs1"
) %>% 
  mutate(NAME = "United States")

housing_comparison <- bind_rows(lane_val, or_val, us_val) %>%
  mutate(NAME = factor(NAME, levels = c("Lane County", "Oregon", "United States")))

plot_comparison <- ggplot(housing_comparison, aes(x = estimate, y = NAME, fill = NAME)) +
  geom_col(alpha = 0.85, width = 0.6, show.legend = FALSE) +
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe), 
                 height = 0.2, color = "black", linewidth = 0.7) +
  scale_fill_manual(values = c("Lane County" = "darkorange", 
                               "Oregon" = "navy", 
                               "United States" = "grey50")) +
  scale_x_continuous(labels = dollar_format(scale = 0.001, suffix = "k"),
                     expand = expansion(mult = c(0, 0.1))) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(face = "bold")
  ) +
  labs(
    x = "Median Home Value (ACS Estimate)",
    y = "",
    title = "Regional Comparison of Home Values",
    subtitle = "Lane County vs. Oregon vs. United States (2024 ACS)",
    caption = "Black horizontal bars indicate the Margin of Error (MOE)."
  )

print(plot_comparison)

plot_lane_housing_sf_median_income <- lane_housing_sf

plot_lane_housing_sf_median_income
plot(plot_lane_housing_sf_median_income["median_incomeE"])

#ggplot version 
plot_lane_housing_sf_median_income<-plot(lane_housing_sf$geometry)
ggplot(data = lane_housing_sf, aes(fill = median_incomeE)) +
  geom_sf(color = NA) +
  scale_fill_distiller(palette = "Oranges",
                       direction = 1) +
  labs(title = "Per-Capita Income, Lane County, 2024",
       caption = "Data source: 2024 1-year ACS, US Census Bureau",
       fill = "ACS estimate") +
  theme_void()

plot_lane_housing_sf_median_income

#--------------------------------Maps-------------------------------------------
plot_lane_home_value <- ggplot(data = lane_housing_sf, aes(fill = median_home_valueE)) +
  geom_sf(color = NA) +
  scale_fill_distiller(palette = "Blues", direction = 1, labels = label_dollar(scale = 0.001, suffix = "k")) +
  theme_void() +
  labs(
    title = "Median Home Value by Census Tract",
    subtitle = "Lane County, OR (2024 5-Year ACS)",
    fill = "Home Value"
  )

plot_lane_rent_burden <- ggplot(data = lane_housing_sf, aes(fill = rent_burdenE)) +
  geom_sf(color = NA) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1, labels = label_comma()) +
  theme_void() +
  labs(
    title = "Rent Burden Status by Census Tract",
    subtitle = "Lane County, OR (2024 5-Year ACS)",
    fill = "Rent Burden"
  )


plot_lane_income <- ggplot(data = lane_housing_sf, aes(fill = median_incomeE)) +
  geom_sf(color = NA) +
  scale_fill_distiller(palette = "Oranges", direction = 1, labels = label_dollar(scale = 0.001, suffix = "k")) +
  theme_void() +
  labs(
    title = "Median Household Income by Census Tract",
    subtitle = "Lane County, OR (2024 5-Year ACS)",
    fill = "Median Income"
  )

print(plot_lane_home_value)
print(plot_lane_rent_burden)
print(plot_lane_income)
