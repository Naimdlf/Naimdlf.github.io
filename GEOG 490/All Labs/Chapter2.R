# tidy census
install.packages("tidycensus")
library(tidycensus)
census_api_key("fbb3f7914f7097828de7fd0ce50ab55c51222d60", install = TRUE)
#_________________________________Chapter 2____________________________________

# total population by state, 2010 Census.
total_population_10 <- get_decennial(
  geography = "state",
  variables = "P001001",
  year = 2010
)

#retrieves information on the American Indian & Alaska Native population by state
#from the 2020 decennial Census.
aian_2020 <- get_decennial(
  geography = "state",
  variables = "P1_005N",
  year = 2020,
  sumfile = "pl"
)

# ACS the number of number of residents born in Mexico by state.
# moe = margin of error
born_in_mexico <- get_acs(
  geography = "state",
  variables = "B05006_150",
  year = 2020
)

# survey defaults to the 5-year ACS; however,
# this can be changed to the 1-year ACS by using the argument survey = "acs1".
born_in_mexico_1yr <- get_acs(
  geography = "state",
  variables = "B05006_150",
  survey = "acs1",
  year = 2019
)

# page 41 has tables for which census surveys availible by what geographies.
# ZIP Code Tabulation Areas (ZCTAs)
# Core Based Statistical Areas (CBSAs)

# Core Based Statistical Area 5-year ACS
cbsa_population <- get_acs(
  geography = "cbsa",
  variables = "B01003_001",
  year = 2020
)

# Median household income by county in Wisconsin
wi_income <- get_acs(
  geography = "county",
  variables = "B19013_001",
  state = "WI",
  year = 2020
)

# collin county ACS Median household income by census tract
collin_income <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = "TX",
  county = "Collin County",
  year = 2020
)

#variables from the 2020 Decennial Census Redistricting data
load_variables(year = 2020, dataset = "pl")

