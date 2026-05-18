# tidy census
install.packages("tidyverse")
install.packages("tidycensus")
library(tidycensus)
census_api_key("fbb3f7914f7097828de7fd0ce50ab55c51222d60", install = TRUE, overwrite=TRUE)
library(tigris)
library(tidyverse)
library(sf)
library(scales)

options(tigris_use_cache = TRUE)
#_________________________________ACS VERIABLES_______________________________________
#walker 44

# list of variables
expanded_vars <- c(
  # Race 
  White = "B03002_003",
  Black = "B03002_004",
  Native = "B03002_005",
  Asian = "B03002_006",
  HIPI = "B03002_007",
  Hispanic = "B03002_012",
  
  # Income & Economics
  MedInc = "B19013_001",       # Median Household Income
  PerCapInc = "B19301_001",    # Per Capita Income
  
  # Age
  MedAge = "B01002_001",       # Median Age
  
  # Housing
  MedRent = "B25058_001",      # Median Gross Rent
  MedHomeVal = "B25077_001",   # Median Home Value
  
  # Education 
  Edu_Total = "B15003_001",    # Total population 25 and older
  Edu_Bachelors = "B15003_022" # Bachelor's degree
)
#_________________________________Replication Study____________________________________
# population by state for the 2020
pop_2020 <- get_decennial(
  geography = "tract", 
  variables = "P1_001N", 
  year = 2020,
  state = "UT",
)

# CRS used: NAD83(2011) Kansas Regional Coordinate System
# Zone 11 (for Kansas City) (page 169)
SL_UT_tracts <- tracts(state = "UT", cb = TRUE, year = 2020) %>%
  st_transform(6527)
SL_metro <- core_based_statistical_areas(cb = TRUE, year = 2020) %>%
  filter(str_detect(NAME, "Salt Lake City")) %>%
  st_transform(6527)
  
  #filter tracts to inside the MSA (170)
  SL_tracts_within <- SL_UT_tracts %>%
  st_filter(SL_metro, .predicate = st_within)
# Equivalent syntax:
# kc_metro2 <- kc_tracts[kc_metro, op = st_within]
ggplot() +
  geom_sf(data = SL_tracts_within, fill = "white", color = "grey") +
  geom_sf(data = SL_metro, fill = NA, color = "red") +
  theme_void()

# join the data: 
SL_tracts_pop <- SL_tracts_within %>%
left_join(pop_2020, by = "GEOID")

# preform population density calc
SL_tracts_density <- SL_tracts_pop %>%
  mutate( tract_area_sq_meters = st_area(geometry),
          
# devide to sq kilometers
tract_area_sq_km = as.numeric(tract_area_sq_meters) / 1000000,
pop_density = value / tract_area_sq_km

)

#catagorisation (48)
SL_tracts_density_catagorized <- SL_tracts_density %>%
  mutate(density_class = case_when(
    pop_density <= 1 ~ "Rural",
    pop_density <= 100 ~ "Exurban",
    pop_density <= 200 ~ "Suburban",
    pop_density <= 400 ~ "Urban",
    TRUE ~ "uncatagorized"
  ))

UT_expanded_data <- get_acs(
  geography = "tract",
  state = "UT",
  variables = expanded_vars,
  summary_var = "B03002_001",
  year = 2020,
  output = "wide" 
)

#tie everything together
SL_all_data <- SL_tracts_density_catagorized %>%
  st_filter(SL_metro, .predicate = st_within) %>%
  left_join(UT_expanded_data, by = "GEOID") %>%
  mutate( 

    pct_white     = 100 * (WhiteE / summary_est),
    pct_hispanic  = 100 * (HispanicE / summary_est),
    pct_black     = 100 * (BlackE / summary_est),
    pct_asian     = 100 * (AsianE / summary_est),
    
    pct_bachelors = 100 * (Edu_BachelorsE / Edu_TotalE)
  )

#_________________________________________MAPS_________________________________________

pop<-ggplot() +
  geom_sf(data = SL_tracts_density, aes(fill = pop_density), color = NA) +
  geom_sf(data = SL_metro, fill = NA, color = "grey") +
  scale_fill_viridis_c(option = "magma") +
  theme_void() +
  labs(title = "Population by Census Tract",
       fill = "Pop per Sq Km")

density<-ggplot() +
  geom_sf(data = SL_tracts_density_catagorized, aes(fill = density_class), color = NA) +
  geom_sf(data = SL_metro, fill = NA, color = "grey") +
  scale_fill_viridis_d(option = "magma") +
  theme_void() +
  labs(title = "Population Density by Census Tract",
       fill = "Density Class")

income_map <- ggplot() +
  geom_sf(data = SL_all_data, aes(fill = MedIncE), color = NA) +
  geom_sf(data = SL_metro, fill = NA, color = "grey") +
  scale_fill_viridis_c(option = "viridis", labels = scalar_labels <- scales::dollar) +
  theme_void() +
  labs(title = "Median Household Income by Census Tract",
       subtitle = "Salt Lake City MSA (2016-2020 ACS)",
    fill = "Median Income")

#_____________________________________________Figures___________________________________

#75
SL_some_data <- SL_all_data %>%
  filter(!is.na(MedIncE)) %>%     
  slice_max(MedIncE, n = 20)      
error<-ggplot(SL_some_data, aes(x = MedIncE, y = reorder(NAMELSAD, MedIncE))) +
  geom_errorbarh(aes(xmin = MedIncE - MedIncM, xmax = MedIncE + MedIncM)) +
  geom_point(size = 3, color = "darkgreen") +
  theme_minimal(base_size = 12.5) +
  labs(title = "Median household income",
       subtitle = "MSA in Salt Lake City",
       x = "2016-2020 ACS estimate",
       y = "") +
  scale_x_continuous(labels = scalar_labels <- scales::dollar)

#62
options(scipen = 999)
histogram<-ggplot(SL_all_data, aes(x = MedIncE)) +
  geom_histogram()+labs(title = "Distribution of Median Household Income", 
                       subtitle = "Salt Lake City MSA Census Tracts",
                       x = "Median Income", y = "Count of Tracts")

#boxplot
boxplot <- ggplot(SL_all_data, aes(y = MedIncE)) +
  geom_boxplot(fill = "lightgrey", color = "darkblue") +
  theme_minimal() +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Boxplot of Median Household Income",
       subtitle = "Salt Lake City MSA Tracts",
       y = "Median Income")

#____________________________POP Pyrimid_________________________-

SEX <- get_estimates(
  geography = "metropolitan statistical area/micropolitan statistical area",
  state = "UT",
  product = "characteristics",
  breakdown = c("SEX", "AGEGROUP"),
  breakdown_labels = TRUE,
  year = 2020
)

SL_SEX_AGE_filtered<- SEX %>%
  filter(GEOID == "41620") %>%
  filter(str_detect(AGEGROUP, "^Age")) %>% 
  filter(SEX != "Both sexes") %>%
  mutate(value = if_else(SEX == "Male", -value, value))

print(nrow(SL_SEX_AGE_filtered))
#80

utah_pyramid<-ggplot(SL_SEX_AGE_filtered, aes(x = value, y = AGEGROUP, fill = SEX)) +
  geom_col()
utah_pyramid <- ggplot(SL_SEX_AGE_filtered,
                       aes(x = value,
                           y = AGEGROUP,
                           fill = SEX)) +
  geom_col(width = 0.95, alpha = 0.75) +
  theme_minimal(base_family = "Verdana",
                base_size = 12) +
  scale_x_continuous(
    labels = ~ number_format(scale = .001, suffix = "k")(abs(.x)),
    limits = 100000 * c(-1,1)
  ) +
  scale_y_discrete(labels = ~ str_remove_all(.x, "Age\\s|\\syears")) +
  scale_fill_manual(values = c("darkred", "navy")) +
  labs(x = ""
       ,
       y = "2019 Census Bureau population estimate",
       title = "Population structure in Salt Lake City",
       fill = ""
       ,)

utah_pyramid




#______________________________________________________________________GGSAVE_____

ggsave("slc_pop_density.png", plot = pop, width = 8, height = 6, dpi = 150)
ggsave("utah_pyramid.png", plot = pop, width = 8, height = 6, dpi = 150)
ggsave("slc_density_class.png", plot = density, width = 8, height = 6, dpi = 150)
ggsave("slc_income_map.png", plot = income_map, width = 8, height = 6, dpi = 150)
ggsave("slc_income_errorbars.png", plot = error, width = 10, height = 7, dpi = 150)
ggsave("slc_income_histogram.png", plot = histogram, width = 7, height = 5, dpi = 150)
ggsave("slc_income_boxplot.png", plot = boxplot, width = 5, height = 5, dpi = 150)
