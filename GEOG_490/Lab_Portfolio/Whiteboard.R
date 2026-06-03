#--------------------------------------------DECENNIAL CENSUS PORTLAND----------
# 2000 Decennial Census
pdx_2000 <- get_decennial(
  geography = "cbsa",
  variables = "",
  year = 2000
) %>%
fudge <- get_acs(
    geography = "tract",
    state = "OR",
    county = PDX_MSA_COUNTIES,
    year = 2024,
    output = "wide",
    geometry = TRUE
  )
    # Filter to keep only the tracts that fall inside the Portland MSA boundary
    st_transform(PDX_CRS) %>%    
    st_filter(PDX_MSA, .predicate = st_within)

# 2010 Decennial Census
pdx_2010 <- get_decennial(
  geography = "cbsa",
  variables = "",
  year = 2010
) %>%
  filter(GEOID == PDX_GEOID) %>%
  mutate(year = 2010, moe = NA)

# 2020 Decennial Census
pdx_2020 <- get_decennial(
  geography = "state",
  state = "OR"
  variables = "",
  year = 2020
) %>%
  filter(GEOID == PDX_GEOID) %>%
  mutate(year = 2020, moe = NA)

# Combine all 
decennial_data <- bind_rows(pdx_2020, pdx_2010, pdx_2000) %>%
  select(year, GEOID, NAME, estimate = value, moe)

library(tidycensus)

# Load 2020 Decennial Census variables
dhc_vars<-decennial_vars_2020 <- load_variables(year = 2020, dataset = "pl", cache = TRUE)
dhc_vars<-decennial_vars_2020 <- load_variables(year = 2020, dataset = "dhc", cache = TRUE)
View(dhc_vars)

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
  geom_point(size = 3, color = "darkgreen") +
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
  geom_boxplot(fill = "lightgrey", color = "darkblue") +
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
  scale_fill_manual(values = c("darkred", "navy")) +
  labs(x = ""
       ,
       y = "2019 Census Bureau population estimate",
       title = "Population structure in Salt Lake City",
       fill = ""
       ,)

plot_slc_pyramid
