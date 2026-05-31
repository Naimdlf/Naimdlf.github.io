#title: "Pab Portfolio"
#author: Naim Ferris
#date: "April 27, 2026"

# Libraries:
install.packages("tidyverse")
install.packages("tidycensus")
library(tidycensus)
census_api_key("fbb3f7914f7097828de7fd0ce50ab55c51222d60", install = TRUE, overwrite=TRUE)
library(tigris)
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
install.packages("segregation")
library(segregation)
mb_access_token("pk.eyJ1IjoibmZlcnJpczEiLCJhIjoiY21scTZnenBtMHVqODNlcTZsZGF4a2ZiNyJ9.7UGrFE1U37aXzTuzuyY0wQ", overwrite = TRUE, install = TRUE)

options(tigris_use_cache = TRUE)

#---------------------------------ACS VERIABLES---------------------------------
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
  # Total_pop is added later
  
  # Income & Economics
  MedInc = "B19013_001",       # Median Household Income
  PerCapInc = "B19301_001",    # Per Capita Income
  
  # Age
  MedAge = "B01002_001",       # Median Age
  
  # youth
    m_under5  = "B01001_003", 
    m_5to9   = "B01001_004", 
    m_10to14 = "B01001_005", 
    m_15to17 = "B01001_006",
    f_under5  = "B01001_027", 
    f_5to9   = "B01001_028", 
    f_10to14 = "B01001_029", 
    f_15to17 = "B01001_030",
  
  # Youth Variables
    Total_Under18 = "B09001_001",        # Total kids under 18
    Enrolled_College = "B14001_007",      # College undergrads
  
  # Housing
  MedRent = "B25058_001",      # Median Gross Rent
  MedHomeVal = "B25077_001",   # Median Home Value
  
  # Education 
  Edu_Total = "B15003_001",    # Total population 25 and older
  Edu_Bachelors = "B15003_022", # Bachelor's degree
  withBachelors_25plus = "DP02_0068P" #percent of the population age 25 and up with a bachelor’s degree
)

#------------------------------------DEFINE PORTLAND----------------------------

# Portland-Vancouver-Hillsboro, OR-WA MSA

PDX_NAME  <- "Portland-Vancouver-Hillsboro"
PDX_GEOID <- "38900"   # CBSA code

PDX_CRS <- 2913        # Oregon Statewide Lambert

PDX_MSA_COUNTIES <- c("Multnomah", "Washington", "Clackamas", "Yamhill", "Columbia", "Clark", "Skamania", "Cowlitz")
PDX_MSA <- core_based_statistical_areas(cb = TRUE, year = 2020) %>%
  filter(GEOID == PDX_GEOID) %>%
  st_transform(PDX_CRS)

OR_TRACTS <- tracts(
  state = "OR",
  cb = TRUE,
  year = 2020
) %>%
  st_transform(PDX_CRS)

OR_WA_TRACTS <- map_dfr(c("OR", "WA"), ~{
  tracts(.x, cb = TRUE, year = 2020)
}) %>%
  st_transform(PDX_CRS)

PDX_TRACTS <- OR_WA_TRACTS %>%
  mutate(centroid = st_centroid(geometry)) %>%
  st_filter(PDX_MSA, .predicate = st_within, join = st_within) %>%
  select(-centroid)

PDX_TRACTS <- erase_water(PDX_TRACTS)


#-----------------------------------LAB 5---------------------------------------

PDX_MSA <- core_based_statistical_areas(cb = TRUE, year = 2020) %>%
  filter(str_detect(NAME, "Portland-Vancouver-Hillsboro")) %>%
  st_transform(PDX_CRS)

plot_PDX_CBSA <- ggplot() + 
  geom_sf(data = OR_WA_TRACTS, fill = "white", color = "grey") +
  geom_sf(data = PDX_MSA, fill = NA, color = "orange") +
  theme_void()
plot_PDX_CBSA

ggplot() + 
  geom_sf(data = OR_WA_TRACTS, fill = "white", color = "grey") +
  geom_sf(data = PDX_TRACTS, fill = NA, color = "orange") +
  theme_void()

# Plotting the Portland MSA

PDX_TRACTS_TOUCH <- OR_WA_TRACTS %>%
  st_filter(PDX_MSA, .predicate = st_touches)
# Equivalent syntax:
# kc_metro2 <- kc_tracts[kc_metro, op = st_within]
plot_PDX_CBSA_OUTLINE <- ggplot() + 
  geom_sf(data = PDX_TRACTS_TOUCH, fill = "white", color = "grey") +
  geom_sf(data = PDX_TRACTS, fill = "lightblue", color = "blue", alpha = 0.2) +
  geom_sf(data = PDX_MSA, fill = NA, color = "orange", linewidth = 0.5) +
  theme_void()
plot_PDX_CBSA_OUTLINE

#---------------------------------REPLICATION STUDY SLC-----------------------------
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
  geom_sf(data = SL_metro, fill = NA, color = "orange") +
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

#find column name
print(UT_expanded_data)
names(UT_expanded_data)
"summary_est" %in% names(UT_expanded_data)

#tie everything together
SL_all_data <- SL_tracts_density_catagorized %>%
  st_filter(SL_metro, .predicate = st_within) %>%
  left_join(UT_expanded_data, by = "GEOID") %>%
  mutate( 
    
    pct_white     = 100 * (WhiteE / summary_est.x),
    pct_hispanic  = 100 * (HispanicE / summary_est.x),
    pct_black     = 100 * (BlackE / summary_est.x),
    pct_asian     = 100 * (AsianE / summary_est.x),
    
    pct_bachelors = 100 * (Edu_BachelorsE / Edu_TotalE)
  )
#--------------------------- PULL STATS FOR QUESTION 1 SLC -------------------------

# Drop the spatial geometry to make calculation faster
stats_data <- SL_all_data %>% st_drop_geometry()

# 1. Total Population & Breakdown of Race (Summing up raw estimates)
overall_demographics <- stats_data %>%
  summarise(
    Total_Population = sum(summary_est.x, na.rm = TRUE),
    Total_White      = sum(WhiteE, na.rm = TRUE),
    Total_Hispanic   = sum(HispanicE, na.rm = TRUE),
    Total_Black      = sum(BlackE, na.rm = TRUE),
    Total_Asian      = sum(AsianE, na.rm = TRUE),
    Total_Native     = sum(NativeE, na.rm = TRUE),
    Total_HIPI       = sum(HIPIE, na.rm = TRUE)
  ) %>%
  mutate(
    pct_White    = (Total_White / Total_Population) * 100,
    pct_Hispanic = (Total_Hispanic / Total_Population) * 100,
    pct_Black    = (Total_Black / Total_Population) * 100,
    pct_Asian    = (Total_Asian / Total_Population) * 100,
    pct_Native   = (Total_Native / Total_Population) * 100,
    pct_HIPI     = (Total_HIPI / Total_Population) * 100
  )

# 2. General Economic / Age Metrics (Averages or Medians across tracts)
overall_economics <- stats_data %>%
  summarise(
    Avg_Median_Household_Income = mean(MedIncE, na.rm = TRUE),
    Avg_Per_Capita_Income       = mean(PerCapIncE, na.rm = TRUE),
    Avg_Median_Age              = mean(MedAgeE, na.rm = TRUE),
    Avg_Median_Home_Value       = mean(MedHomeValE, na.rm = TRUE)
  )

# 3. Print results to your console to copy into your report
print("--- DEMOGRAPHIC BREAKDOWN ---")
print(overall_demographics %>% select(Total_Population, starts_with("pct_")))

print("--- ECONOMIC & GENERAL METRICS ---")
print(overall_economics)

#-----------------------------------------MAPS SLC----------------------------------

plot_slc_pop<-ggplot() +
  geom_sf(data = SL_tracts_density, aes(fill = pop_density), color = NA) +
  geom_sf(data = SL_metro, fill = NA, color = "grey") +
  scale_fill_viridis_c(option = "magma") +
  theme_void() +
  labs(title = "Population by Census Tract",
       fill = "Pop per Sq Km")

plot_slc_density<-ggplot() +
  geom_sf(data = SL_tracts_density_catagorized, aes(fill = density_class), color = NA) +
  geom_sf(data = SL_metro, fill = NA, color = "grey") +
  scale_fill_viridis_d(option = "magma") +
  theme_void() +
  labs(title = "Population Density by Census Tract",
       fill = "Density Class")

plot_slc_income <- ggplot() +
  geom_sf(data = SL_all_data, aes(fill = MedIncE), color = NA) +
  geom_sf(data = SL_metro, fill = NA, color = "grey") +
  scale_fill_viridis_c(option = "viridis", labels = scalar_labels <- scales::dollar) +
  theme_void() +
  labs(title = "Median Household Income by Census Tract",
       subtitle = "Salt Lake City MSA (2016-2020 ACS)",
       fill = "Median Income")

#---------------------------------------------FIGURES SLC---------------------------

#75
SL_some_data <- SL_all_data %>%
  filter(!is.na(MedIncE)) %>%     
  slice_max(MedIncE, n = 20)      

plot_slc_error<-ggplot(SL_some_data, aes(x = MedIncE, y = reorder(NAMELSAD, MedIncE))) +
  geom_errorbarh(aes(xmin = MedIncE - MedIncM, xmax = MedIncE + MedIncM)) +
  geom_point(size = 3, color = "darkorange") +
  theme_minimal(base_size = 12.5) +
  labs(title = "Median household income",
       subtitle = "MSA in Salt Lake City",
       x = "2016-2020 ACS estimate",
       y = "") +
  scale_x_continuous(labels = scalar_labels <- scales::dollar)

#62
options(scipen = 999)
plot_slc_hist<-ggplot(SL_all_data, aes(x = MedIncE)) +
  geom_histogram()+labs(title = "Distribution of Median Household Income", 
                        subtitle = "Salt Lake City MSA Census Tracts",
                        x = "Median Income", y = "Count of Tracts")

#boxplot
plot_slc_boxplot <- ggplot(SL_all_data, aes(y = MedIncE)) +
  geom_boxplot(fill = "lightgrey", color = "darkorange") +
  theme_minimal() +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Boxplot of Median Household Income",
       subtitle = "Salt Lake City MSA Tracts",
       y = "Median Income")

#----------------------------POP PYRIMID SLC----------------------------------------

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

plot_slc_pyramid<-ggplot(SL_SEX_AGE_filtered, aes(x = value, y = AGEGROUP, fill = SEX)) +
  geom_col()
plot_slc_pyramid <- ggplot(SL_SEX_AGE_filtered,
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
  scale_fill_manual(values = c("darkorange", "navy")) +
  labs(x = ""
       ,
       y = "2019 Census Bureau population estimate",
       title = "Population structure in Salt Lake City",
       fill = ""
       ,)

plot_slc_pyramid

#--------------------------------LAB PORT---------------------------------------
#-------------------------------DATA MERGE--------------------------------------
#get Port data
PDX_TRACTS_DATA <- map_dfr(c("OR", "WA"), ~{ 
  get_acs(
  geography = "tract",
  variables = expanded_vars,
  state = .x,
  year = 2020,
  output = "wide",
  geometry = TRUE,)
}) %>%
  st_transform(PDX_CRS) %>%
  mutate(centroid = st_centroid(geometry)) %>%
  st_filter(PDX_MSA, .predicate = st_within, join = st_within) %>%
  select(-centroid) %>% erase_water(area_threshold = 0.9)

PDX_TRACTS_DATA <- PDX_TRACTS_DATA %>%
  mutate(Total_Pop = WhiteE + BlackE + NativeE + AsianE + HIPIE + HispanicE)
print("Total_Pop" %in% names(PDX_TRACTS_DATA))

PDX_TRACTS_DATA <- PDX_TRACTS_DATA %>%
  mutate(urban_name = "Portland-Vancouver-Hillsboro")

#Make NA = 0
PDX_TRACTS_DATA[is.na(PDX_TRACTS_DATA)] <- 0

print(expanded_vars)
print(PDX_TRACTS_DATA)

#make long
PDX_TRACTS_DATA_LONG <- PDX_TRACTS_DATA %>%
  pivot_longer(
    cols = c(WhiteE, BlackE, NativeE, AsianE, HIPIE, HispanicE), 
    names_to = "variable", 
    values_to = "estimate"
  ) %>%
  # Clean up the variable
  mutate(variable = str_remove(variable, "E"))


# This creates PDX_TRACTS_DATA_RENT
PDX_TRACTS_DATA_RENT <- PDX_TRACTS_DATA %>%
  filter(!is.na(MedRentE)) %>%
  slice_max(MedRentE, n = 20) %>% 
  mutate(NAME = str_remove(NAME, "County, Oregon")) %>% # Removes state/county
  mutate(NAME = str_remove(NAME, "County, Oregon"))

#GET OR DATA

# 3. Pull Oregon County Educational Attainment Data
OR_ATTAINMENT_COMPARE <- get_acs(
  geography = "county",
  variables = expanded_vars["withBachelors_25plus"],
  state = "OR",
  year = 2020,
  output = "wide",
  geometry = TRUE
)
OR_ATTAINMENT_COMPARE <- OR_ATTAINMENT_COMPARE %>%
  mutate(NAME = str_remove(NAME, " County, Oregon"))

#---------------------------------LAB 2------------------------------------------
#summary for question lab 5
pdx_msa_summary <- PDX_TRACTS_DATA %>%
  st_drop_geometry() %>%
  separate(
    NAME,
    into = c("tract", "county", "state"),
    sep = ", "
  ) %>%
  summarise(
    Total_Tracts     = n_distinct(GEOID),
    Total_Counties   = n_distinct(county),
    Total_Population = sum(Total_Pop, na.rm = TRUE)
  )

print("--- PORTLAND MSA SUMMARY STATS ---")
print(pdx_msa_summary)

Median_Attainment<-OR_ATTAINMENT_COMPARE %>%
  summarise(
    Minimum_Pct = min(withBachelors_25plusE, na.rm = TRUE),
    Median_Pct  = median(withBachelors_25plusE, na.rm = TRUE),
    Maximum_Pct = max(withBachelors_25plusE, na.rm = TRUE)
  )
print(Median_Attainment)


#plot that
  # Clean up the label

  
  plot_or_education <- ggplot(OR_ATTAINMENT_COMPARE, aes(y = reorder(NAME, withBachelors_25plusE), x = withBachelors_25plusE)) +
  geom_col(color = "navy", fill = "navy", alpha = 0.5, width = 0.85) +
  theme_minimal(base_size = 11) +
  scale_x_continuous(labels = label_percent(scale = 1)) +
  labs(
    title = "Educational Attainment in Oregon Counties",
    subtitle = "Percent of population 25+ with a Bachelor's Degree (2014 5-year ACS)",
    y = "",
    x = "Percent of Population",
    caption = "Source: US Census Bureau (DP02_0068P) via tidycensus"
  )
  
  plot_or_education

#--------------------------------MEDIAN GROSS RENT------------------------------


error_map_pdx <- ggplot(PDX_TRACTS_DATA_RENT, aes(x = MedRentE, y = reorder(NAME, MedRentE))) +
  # Translate: estimate -> MedRentE | moe -> MedRentM
  geom_errorbarh(aes(xmin = MedRentE - MedRentM, xmax = MedRentE + MedRentM)) +
  geom_point(size = 3, color = "darkorange") +
  theme_minimal(base_size = 11) +
  labs(
    title = "Median Gross Rent with Margins of Error",
    subtitle = "Top 20 Census Tracts in the Portland MSA (2020 ACS)",
    x = "2016-2020 ACS Estimate (with MOE)",
    y = ""
  ) +
  scale_x_continuous(labels = label_dollar())

print(error_map_pdx)

#-----------------------------------------PYRAMID-------------------------------
SEX <- get_estimates(
  geography = "metropolitan statistical area/micropolitan statistical area",
  state = "OR",
  product = "characteristics",
  breakdown = c("SEX", "AGEGROUP"),
  breakdown_labels = TRUE,
  year = 2020
)

OR_SEX_AGE_filtered<- SEX %>%
  filter(GEOID == PDX_GEOID) %>%
  filter(str_detect(AGEGROUP, "^Age")) %>% 
  filter(SEX != "Both sexes") %>%
  mutate(value = if_else(SEX == "Male", -value, value))

print(nrow(OR_SEX_AGE_filtered))
#80

Portland_pyramid<-ggplot(OR_SEX_AGE_filtered, aes(x = value, y = AGEGROUP, fill = SEX)) +
  geom_col()
Portland_pyramid <- ggplot(OR_SEX_AGE_filtered,
                       aes(x = value,
                           y = AGEGROUP,
                           fill = SEX)) +
  geom_col(width = 0.95, alpha = 0.75) +
  theme_minimal(base_family = "Verdana",
                base_size = 12) +
  scale_x_continuous(
    labels = ~ number_format(scale = .001, suffix = "k")(abs(.x)),
    limits = 150000 * c(-1,1)
  ) +
  scale_y_discrete(labels = ~ str_remove_all(.x, "Age\\s|\\syears")) +
  scale_fill_manual(values = c("darkorange", "navy")) +
  labs(x = ""
       ,
       y = "2020 Census Bureau population estimate",
       title = "Population structure in Portland OR, MSA",
       fill = ""
       ,)

Portland_pyramid

#-------------------------------PORTLAND HOME VALUE MOE-------------------------
#FIGURE 4.12 A time series chart of median home values in Deschutes County, OR
#get portland data

years <- c(2005:2019, 2021:2024)
names(years) <- years
Portland_value <- map_dfr(years, ~{
  get_acs(
    geography = "cbsa",
    variables = "B25077_001",
    year = .x,
    survey = "acs1"
  ) %>%
    filter(GEOID == PDX_GEOID)
}, .id = "year")

Portland_homevalueMOE<-ggplot(Portland_value, aes(x = year, y = estimate, group = 1)) +
  geom_ribbon(aes(ymax = estimate + moe, ymin = estimate - moe),
              fill = "navy",
              alpha = 0.4) +
  geom_line(color = "navy") +
  geom_point(color = "navy", size = 2) +
  theme_minimal(base_size = 12) +
  scale_y_continuous(labels = label_dollar(scale = .001, suffix = "k")) +
  labs(title = "Median home value in Portland MSA, OR",
       x = "Year",
       y = "ACS estimate",
       caption = "Shaded area represents margin of error around the ACS estimate")
Portland_homevalueMOE

housing_val2 <- PDX_TRACTS_DATA %>%
  separate(
    NAME,
    into = c("tract", "county", "state"),
    sep = ", "
  ) %>%
  mutate(county = str_remove(county, " County"))

housing_val2 %>%
  group_by(county) %>%
  summarize(min = min(MedHomeValE, na.rm = TRUE),
            mean = mean(MedHomeValE, na.rm = TRUE),
            median = median(MedHomeValE, na.rm = TRUE),
            max = max(MedHomeValE, na.rm = TRUE))
ggplot(housing_val2, aes(x = MedHomeValE)) +
  geom_density()

ggplot(housing_val2, aes(x = MedHomeValE, fill = county)) +
  geom_density(alpha = 0.3)
ggplot(housing_val2, aes(x = MedHomeValE)) +
  geom_density(fill = "darkorange", color = "darkorange", alpha = 0.5) +
  facet_wrap(~county) +
  scale_x_continuous(labels = dollar_format(scale = 0.000001,
                                            suffix = "m")) +
  theme_minimal(base_size = 14) +
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(angle = 45)) +
  labs(x = "ACS estimate",
       y = ""
       ,
       title = "Median home values by Census tract, 2015-2024 ACS")

#-----------------------------------LAB 3---------------------------------------
#-----------------------------------INCOME MAP----------------------------------

plot_PDX_TRACTS_DATA_MedInc <- PDX_TRACTS_DATA

plot_PDX_TRACTS_DATA_MedInc
plot(plot_PDX_TRACTS_DATA_MedInc["MedIncE"])

#ggplot version 
plot_PDX_TRACTS_DATA_PerCapInc<-plot(PDX_TRACTS_DATA$geometry)
ggplot(data = PDX_TRACTS_DATA, aes(fill = PerCapIncE)) +
  geom_sf(color = NA) +
  scale_fill_distiller(palette = "Oranges",
                       direction = 1) +
  labs(title = "Per-Capita Income, Portland, 2020",
       caption = "Data source: 2020 1-year ACS, US Census Bureau",
       fill = "ACS estimate") +
  theme_void()

plot_PDX_TRACTS_DATA_PerCapInc

#------------------------------------RACE DOT DENSITY---------------------------
class(PDX_TRACTS_DATA)
PDX_DOTS_DATA_RACE <- PDX_TRACTS_DATA_LONG %>%
  as_dot_density(
    value = "estimate",
    values_per_dot = 100,
    group = "variable",
  )

PDX_DOTS_DATA_RACE %>% filter(variable == "White")
plot_pdx_dot_density <- tm_shape(PDX_TRACTS_DATA) +
  tm_polygons(col = "white",
              border.col = "grey") +
  tm_shape(PDX_DOTS_DATA_RACE) +
  tm_dots(col = "variable",
          palette = "Set1",
          size = 0.05,
          title = "1 dot = 100 people") +
  tm_layout(legend.outside = TRUE, frame = FALSE,
            title = "Race/ethnicity,\n2020 Portland ACS")
plot_pdx_dot_density

#-----------------------------------GRADUATED SYMBOL YOUNG MAP------------------
#figure 6.20
print(PDX_TRACTS_DATA_LONG)
plot_PDX_TRACTS_DATA_Total_Under18 <- tm_shape(PDX_TRACTS_DATA_LONG) +
  tm_polygons(fill = "Total_Under18E",
              style = "jenks",
              n = 5,
              palette = "Oranges",
              title = "2020 US Census",
              alpha = 0.7) +
  tm_layout(title = "Total Under 18 by Census tract",
            legend.outside = TRUE, frame = FALSE,
            fontfamily = "Verdana") +
  tm_scalebar(position = c("left", "bottom")) +
  tm_compass(position = c("right", "top")) +
  tm_credits("(c) Mapbox, OSM ",
             bg.color = "white",
             position = c("RIGHT", "BOTTOM"))

plot_PDX_TRACTS_DATA_Total_Under18

plot_PDX_TRACTS_DATA_Enrolled_College <- tm_shape(PDX_TRACTS_DATA) +
  # Draw the base census tract boundaries
  tm_polygons(
    fill = "white", 
    col = "grey80", 
    fill_alpha = 0.5
  ) +
  # Layer the graduated bubbles on top
  tm_bubbles(
    size = "Enrolled_CollegeE", 
    size.scale = tm_scale_intervals(
      style = "jenks",
      n = 5
    ),
    size.legend = tm_legend(title = "College Undergraduate Population"),
    col = "navy",
    scale = 1
  ) +
  tm_title("College Population\nPortland MSA by Census Tract") + 
  tm_layout(
    legend.outside = TRUE, 
    frame = FALSE,
    legend.outside.position = "bottom", 
    text.fontfamily = "Verdana"         
  ) +
  tm_scalebar(position = c("left", "bottom")) +
  tm_compass(position = c("right", "top")) +
  tm_credits(
    text = "(c) Mapbox, OSM ",
    bg.color = "white",
    position = c("right", "bottom")
  )
plot_PDX_TRACTS_DATA_Enrolled_College

#------------------------------------LAB 5 GERIS-ORD----------------------------------
# For Gi*, re-compute the weights with`include.self()`

neighbors <- poly2nb(PDX_TRACTS_DATA, queen = TRUE)
summary(neighbors)

sum(is.na(PDX_TRACTS_DATA$withBachelors_25plusE))

sum(is.na(PDX_TRACTS_DATA$withBachelors_25plusE))

localg_weights <- nb2listw(include.self(neighbors))
PDX_TRACTS_DATA$localG <- as.numeric(localG(as.numeric(PDX_TRACTS_DATA$withBachelors_25plusE), localg_weights))
ggplot(PDX_TRACTS_DATA) +
  geom_sf(aes(fill = localG), color = NA) +
  scale_fill_distiller(palette = "Oranges") +
  theme_void() +
  labs(
    title = "Educational Attainment Hotspot Analysis (Gi*)",
    subtitle = "Spatial clusters of Bachelor's Degrees in the Portland MSA",
    fill = "Z-score (Gi*)",
    caption = "Source: 2020 ACS Data via tidycensus"
  )
localg_weights

PDX_TRACTS_DATA <- PDX_TRACTS_DATA %>%
  mutate(hotspot = case_when(
    localG >= 2.56 ~ "High cluster",
    localG <= -2.56 ~ "Low cluster",
    TRUE ~ "Not significant"
  ))

plot_PDX_TRACTS_NEIGHBORS <- ggplot(PDX_TRACTS_DATA) +
  geom_sf(aes(fill = hotspot), color = "grey90", size = 0.1) +
  scale_fill_manual(values = c("orange", "blue", "grey")) +
  theme_void() + labs(
    title = "Educational Attainment Hotspot Clusters",
    subtitle = "Significant spatial clustering of population 25+ with a Bachelor's Degree (99% CI)",
    fill = "Cluster Type",
    caption = "Source: 2020 ACS Data | Threshold: |Z| >= 2.56"
  )
plot_PDX_TRACTS_NEIGHBORS

#-----------------------------------LAB 7---------------------------------------
Sys.getenv("MAPBOX_API_TOKEN")

mutual_within(
  data = PDX_TRACTS_DATA,
  group = "HispanicE",
  unit = "GEOID",
  weight = "Total_Pop",
  within = "urban_name",
  wide = TRUE
)

PDX_local_seg <- PDX_TRACTS_DATA %>%
  filter(urban_name == "Portland-Vancouver-Hillsboro") %>%
  mutual_local(
    group = "HispanicE",
    unit = "GEOID",
    weight = "Total_Pop",
    wide = TRUE
  )

PDX_tracts_seg <- PDX_TRACTS_DATA %>%
  inner_join(PDX_local_seg, by = "GEOID")
PDX_tracts_seg %>%
  ggplot(aes(fill = ls)) +
  geom_sf(color = NA) +
  coord_sf(crs = 26946) +
  scale_fill_viridis_c(option = "Oranges") +
  theme_void() + labs(
    title = "Local Segregation Index (Hispanic Population)",
    subtitle = "Spatial distribution of localized multi-group entropy within the Portland MSA",
    fill = "Local Segregation\nIndex (ls)",
    caption = "Source: 2020 ACS Data | Mutual Local Index Calculation"
  )
PDX_tracts_seg

PDX_entropy <- PDX_TRACTS_DATA %>%
  filter(urban_name == "Portland-Vancouver-Hillsboro") %>%
  group_by(GEOID) %>%
  mutate(
    p_hispanic = HispanicE / Total_Pop,
    p_other    = (Total_Pop - HispanicE) / Total_Pop,
    p_hisp_safe = ifelse(p_hispanic == 0 | is.na(p_hispanic), 1, p_hispanic),
    p_othe_safe = ifelse(p_other == 0 | is.na(p_other), 1, p_other),
    entropy = -( (p_hispanic * log(p_hisp_safe, base = 2)) + (p_other * log(p_othe_safe, base = 2)) )
  ) %>%
  ungroup()%>% st_drop_geometry()

PDX_entropy_geo <- PDX_TRACTS_DATA %>%
  inner_join(PDX_entropy, by = "GEOID")

Sys.getenv("MAPBOX_API_TOKEN")

PDX_city_hall <- mb_geocode("City Hall, Portland, OR")
minutes_to_downtown <- mb_matrix(PDX_entropy_geo, PDX_city_hall)

PDX_entropy_geo$minutes <- as.numeric(minutes_to_downtown)
PDX_entropy_travel_time<-ggplot(PDX_entropy_geo, aes(x = minutes, y = entropy)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_minimal() +
  scale_x_continuous(limits = c(0, 80)) +
  labs(
         title = "Local Segregation Index (Hispanic Population)",
         subtitle = "Portland-Vancouver-Hillsboro MSA",
         fill = "Local\nsegregation index",
         caption = "Source: 2020 ACS Data"
       )
PDX_entropy_travel_time

#---------------------------------------------------DOWNLOAD--------------------
# File Export SLC
ggsave("slc_pop_density.png",       plot = plot_slc_pop,       width = 8,  height = 6, dpi = 150)
ggsave("utah_pyramid.png",          plot = plot_slc_pyramid,   width = 8,  height = 6, dpi = 150)
ggsave("slc_density_class.png",     plot = plot_slc_density,   width = 8,  height = 6, dpi = 150)
ggsave("slc_income_map.png",        plot = plot_slc_income,    width = 8,  height = 6, dpi = 150)
ggsave("slc_income_errorbars.png",  plot = plot_slc_error,     width = 10, height = 7, dpi = 150)
ggsave("slc_income_histogram.png",  plot = plot_slc_hist,      width = 7,  height = 5, dpi = 150)
ggsave("slc_income_boxplot.png",    plot = plot_slc_boxplot,   width = 5,  height = 5, dpi = 150)


# Oregon exports
ggsave("OR_attainment_compare.png", plot = plot_or_education,  width = 8,  height = 6, dpi = 150)
ggsave("Portland_pyramid.png",      plot = Portland_pyramid,   width = 8,  height = 6, dpi = 150)
st_write(PDX_TRACTS_DATA_RENT, "pdx_top_rent_tracts.geojson", delete_dsn = TRUE)
st_write(plot_PDX_TRACTS_DATA_MedInc, "Portland_Median_Income.geojson", delete_dsn = TRUE)
ggsave("Portland_homevalue_MOE.png",    plot = Portland_homevalueMOE,   width = 10,  height = 5, dpi = 150)
ggsave("Portland_Income_PerCap.png",    plot = plot_PDX_TRACTS_DATA_PerCapInc,   width = 5,  height = 5, dpi = 150)
ggsave("plot_PDX_CBSA_OUTLINE.png",    plot = plot_PDX_CBSA_OUTLINE,   width = 5,  height = 5, dpi = 150)
tmap_save(plot_pdx_dot_density, "pdx_dot_density_map.png", width = 8, height = 6)
tmap_save(plot_PDX_TRACTS_DATA_Total_Under18, "Portland_Total_Under_18.png", width = 5, height = 5, dpi = 150)
tmap_save(plot_PDX_TRACTS_DATA_Enrolled_College, "Portland_Total_Enrolled.png", width = 5, height = 5, dpi = 150)
ggsave("Portland_Entropy_Distance_Scatter.png", width = 5, height = 5, dpi = 150)
ggsave("Portland_Tract_Neighbors.png", plot = plot_PDX_TRACTS_NEIGHBORS, width = 5, height = 5, dpi = 150)
tmap_save(plot_pdx_dot_density, "pdx_dot_density_map.png", width = 8, height = 6)
ggsave("pdx_entropy_travel_time.png", plot = PDX_entropy_travel_time, width = 8, height = 6, dpi = 300)


# Data Table Exports
write.csv(pdx_msa_summary, "pdx_msa_summary_stats.csv", row.names = FALSE)
write.csv(Median_Attainment, "or_attainment_summary.csv", row.names = FALSE)
write_csv(overall_demographics, "slc_overall_demographics.csv")
write_csv(overall_economics,    "slc_overall_economics.csv")