
    // elements

      // object directory linking state abbriveations to names https://stackoverflow.com/questions/33514915/what-s-the-difference-between-and-while-declaring-a-javascript-array
    // creates a global veriable so we can save our city when we co back from our agency details
    let currentCity = null;

    const stateFullNames = {
      OR: 'Oregon',
      AK: 'Alaska',
      AL: 'Alabama',
      AR: 'Arkansas',
      AZ: 'Arizona',
      CA: 'California',
      CO: 'Colorado',
      CT: 'Connecticut',
      DE: 'Delaware',
      FL: 'Florida',
      GA: 'Georgia',
      HI: 'Hawaii',
      ID: 'Idaho',
      IL: 'Illinois',
      IN: 'Indiana',
      IA: 'Iowa',
      KS: 'Kansas',
      KY: 'Kentucky',
      LA: 'Louisiana',
      ME: 'Maine',
      MD: 'Maryland',
      MA: 'Massachusetts',
      MI: 'Michigan',
      MN: 'Minnesota',
      MS: 'Mississippi',
      MO: 'Missouri',
      MT: 'Montana',
      NE: 'Nebraska',
      NV: 'Nevada',
      NH: 'New Hampshire',
      NJ: 'New Jersey',
      NM: 'New Mexico',
      NY: 'New York',
      NC: 'North Carolina',
      ND: 'North Dakota',
      OH: 'Ohio',
      OK: 'Oklahoma',
      PA: 'Pennsylvania',
      RI: 'Rhode Island',
      SC: 'South Carolina',
      SD: 'South Dakota',
      TN: 'Tennessee',
      TX: 'Texas',
      UT: 'Utah',
      VT: 'Vermont',
      VA: 'Virginia',
      WA: 'Washington',
      WV: 'West Virginia',
      WI: 'Wisconsin',
      WY: 'Wyoming',
      PR: 'Puerto Rico',

    };
      // object directory with each of the cities in a given state
  const stateToUZA = {
    AK: [
      "Anchorage, AK",
      "Fairbanks, AK",
      "Wasilla--Knik-Fairview--North Lakes, AK"
    ],
    AL: [
      "Anniston--Oxford, AL",
      "Auburn, AL",
      "Birmingham, AL",
      "Decatur, AL",
      "Dothan, AL",
      "Florence, AL",
      "Gadsden, AL",
      "Huntsville, AL",
      "Mobile, AL",
      "Montgomery, AL",
      "Tuscaloosa, AL",
      "Fairhope--Daphne, AL"
    ],
    AR: [
      "Conway, AR",
      "Fayetteville--Springdale--Rogers, AR--MO",
      "Fort Smith, AR--OK",
      "Hot Springs, AR",
      "Jonesboro, AR",
      "Little Rock, AR",
      "Texarkana, TX--AR"
    ],
    AZ: [
      "Bullhead City, AZ--NV",
      "Flagstaff, AZ",
      "Lake Havasu City, AZ",
      "Maricopa, AZ",
      "Phoenix--Mesa--Scottsdale, AZ",
      "Phoenix West--Goodyear--Avondale, AZ",
      "Prescott--Prescott Valley, AZ",
      "Tucson, AZ",
      "Yuma, AZ--CA"
    ],
    CA: [
      "Antioch, CA",
      "Arroyo Grande--Grover Beach--Pismo Beach, CA",
      "Bakersfield, CA",
      "Camarillo, CA",
      "Chico, CA",
      "Concord--Walnut Creek, CA",
      "Davis, CA",
      "El Centro, CA",
      "El Paso de Robles (Paso Robles)--Atascadero, CA",
      "Fairfield, CA",
      "Fresno, CA",
      "Gilroy--Morgan Hill, CA",
      "Hanford, CA",
      "Indio--Palm Desert--Palm Springs, CA",
      "Livermore--Pleasanton--Dublin, CA",
      "Lodi, CA",
      "Lompoc, CA",
      "Los Angeles--Long Beach--Anaheim, CA",
      "Madera, CA",
      "Manteca, CA",
      "Merced, CA",
      "Mission Viejo--Lake Forest--Laguna Niguel, CA",
      "Napa, CA",
      "Oxnard--San Buenaventura (Ventura), CA",
      "Palmdale--Lancaster, CA",
      "Porterville, CA",
      "Redding, CA",
      "Riverside--San Bernardino, CA",
      "Sacramento, CA",
      "Salinas, CA",
      "San Diego, CA",
      "San Francisco--Oakland, CA",
      "San Jose, CA",
      "San Luis Obispo, CA",
      "Santa Barbara, CA",
      "Santa Clarita, CA",
      "Santa Cruz, CA",
      "Santa Maria, CA",
      "Santa Rosa, CA",
      "Seaside--Monterey--Pacific Grove, CA",
      "Simi Valley, CA",
      "Stockton, CA",
      "Temecula--Murrieta--Menifee, CA",
      "Thousand Oaks, CA",
      "Tracy--Mountain House, CA",
      "Vacaville, CA",
      "Vallejo, CA",
      "Visalia, CA",
      "Watsonville, CA",
      "Woodland, CA",
      "Yuba City, CA"
    ],
    CO: [
      "Boulder, CO",
      "Castle Rock, CO",
      "Colorado Springs, CO",
      "Denver--Aurora, CO",
      "Fort Collins, CO",
      "Grand Junction, CO",
      "Greeley, CO",
      "Lafayette--Erie--Louisville, CO",
      "Longmont, CO",
      "Pueblo, CO"
    ],
    CT: [
      "Bridgeport--Stamford, CT--NY",
      "Danbury, CT--NY",
      "Hartford, CT",
      "New Haven, CT",
      "Norwich--New London, CT",
      "Waterbury, CT",
      "Springfield, MA--CT",
      "Worcester, MA--CT"
    ],
    DC: [
      "Washington--Arlington, DC--VA--MD"
    ],
    DE: [
      "Dover, DE",
      "Salisbury, MD--DE",
      "Philadelphia, PA--NJ--DE--MD"
    ],
    FL: [
      "Beverly Hills--Homosassa Springs--Pine Ridge, FL",
      "Bonita Springs--Estero, FL",
      "Bradenton--Sarasota--Venice, FL",
      "Cape Coral, FL",
      "Daytona Beach--Palm Coast--Port Orange, FL",
      "Deltona, FL",
      "Fernandina Beach--Yulee, FL",
      "Four Corners, FL",
      "Gainesville, FL",
      "Jacksonville, FL",
      "Kissimmee--St. Cloud, FL",
      "Lakeland, FL",
      "Leesburg--Eustis--Tavares, FL",
      "Ocala, FL",
      "Orlando, FL",
      "Palm Bay--Melbourne, FL",
      "Panama City--Panama City Beach, FL",
      "Port Charlotte--North Port, FL",
      "Port St. Lucie, FL",
      "St. Augustine, FL",
      "St. Petersburg--Tampa, FL",
      "Spring Hill, FL",
      "Tallahassee, FL",
      "The Villages--Lady Lake, FL",
      "Vero Beach--Sebastian, FL",
      "Winter Haven, FL",
      "Zephyrhills, FL",
      "Miami--Fort Lauderdale, FL",
      "Navarre--Miramar Beach--Destin, FL"
    ],
    GA: [
      "Albany, GA",
      "Athens-Clarke County, GA",
      "Atlanta, GA",
      "Augusta-Richmond County, GA--SC",
      "Columbus, GA--AL",
      "Dalton, GA",
      "Gainesville, GA",
      "Macon-Bibb County, GA",
      "Rome, GA",
      "Savannah, GA",
      "Valdosta, GA",
      "Hinesville, GA"
    ],
    HI: [
      "Honolulu, HI",
      "Kahului--Wailuku, HI",
      "Kailua (Honolulu County)--Kaneohe, HI"
    ],
    IA: [
      "Ames, IA",
      "Cedar Rapids, IA",
      "Davenport, IA--IL",
      "Des Moines, IA",
      "Dubuque, IA--IL",
      "Iowa City, IA",
      "Sioux City, IA--NE--SD",
      "Waterloo, IA"
    ],
    ID: [
      "Boise City, ID",
      "Coeur d'Alene, ID",
      "Lewiston, ID--WA",
      "Nampa, ID",
      "Pocatello, ID",
      "Twin Falls, ID"
    ],
    IL: [
      "Alton, IL",
      "Bloomington--Normal, IL",
      "Champaign, IL",
      "Chicago, IL--IN",
      "Decatur, IL",
      "DeKalb, IL",
      "Kankakee, IL",
      "Peoria, IL",
      "Rockford, IL",
      "Round Lake Beach--McHenry--Grayslake, IL--WI",
      "Springfield, IL",
      "Paducah, KY--IL",
      "Beloit, WI--IL",
      "Cape Girardeau, MO--IL",
      "St. Louis, MO--IL"
    ],
    IN: [
      "Anderson, IN",
      "Bloomington, IN",
      "Columbus, IN",
      "Elkhart, IN--MI",
      "Evansville, IN",
      "Fort Wayne, IN",
      "Indianapolis, IN",
      "Kokomo, IN",
      "Lafayette, IN",
      "Muncie, IN",
      "Valparaiso--Shorewood Forest, IN",
      "Michigan City--La Porte, IN--MI",
      "Chicago, IL--IN",
    ],
    KS: [
      "Lawrence, KS",
      "Manhattan, KS",
      "Topeka, KS",
      "Wichita, KS",
      "St. Joseph, MO--KS",
      "Kansas City, MO--KS"
    ],
    KY: [
      "Bowling Green, KY",
      "Elizabethtown--Radcliff, KY",
      "Lexington-Fayette, KY",
      "Louisville/Jefferson County, KY--IN",
      "Owensboro, KY",
      "Paducah, KY--IL"
    ],
    LA: [
      "Alexandria, LA",
      "Baton Rouge, LA",
      "Hammond, LA",
      "Houma, LA",
      "Lafayette, LA",
      "Lake Charles, LA",
      "Mandeville--Covington, LA",
      "Monroe, LA",
      "New Orleans, LA",
      "Shreveport, LA",
      "Slidell, LA"
    ],
    MA: [
      "Amherst Town--Northampton--Easthampton Town, MA",
      "Barnstable Town, MA",
      "Boston, MA--NH",
      "Leominster--Fitchburg, MA",
      "New Bedford, MA",
      "Nashua, NH--MA",
      "Pittsfield, MA",
      "Springfield, MA--CT",
      "Worcester, MA--CT"
    ],
    MD: [
      "Baltimore, MD",
      "Bel Air--Aberdeen, MD",
      "Frederick, MD",
      "Lexington Park--California--Chesapeake Ranch Estates, MD",
      "Salisbury, MD--DE",
      "Waldorf, MD",
      "Philadelphia, PA--NJ--DE--MD",
      "Hagerstown, MD--WV--PA--VA"
    ],
    ME: [
      "Bangor, ME",
      "Lewiston, ME",
      "Portland, ME",
      "Dover--Rochester, NH--ME",
      "Portsmouth, NH--ME"
    ],
    MI: [
      "Ann Arbor, MI",
      "Battle Creek, MI",
      "Bay City, MI",
      "Benton Harbor--Lincoln--St. Joseph, MI",
      "Detroit, MI",
      "Flint, MI",
      "Holland, MI",
      "Jackson, MI",
      "Kalamazoo, MI",
      "Lansing, MI",
      "Midland, MI",
      "Monroe, MI",
      "Muskegon--Norton Shores, MI",
      "Port Huron, MI",
      "Saginaw, MI",
      "South Lyon--Hamburg--Genoa, MI",
      "Toledo, OH--MI",
      "Elkhart, IN--MI",
      "Michigan City--La Porte, IN--MI"
    ],
    MN: [
      "Duluth, MN--WI",
      "Minneapolis--St. Paul, MN",
      "Mankato, MN",
      "Rochester, MN",
      "St. Cloud, MN",
      "Fargo, ND--MN",
      "La Crosse, WI--MN"
    ],
    MO: [
      "Cape Girardeau, MO--IL",
      "Columbia, MO",
      "Fayetteville--Springdale--Rogers, AR--MO",
      "Joplin, MO",
      "Jefferson City, MO",
      "Kansas City, MO--KS",
      "Lee's Summit, MO",
      "St. Joseph, MO--KS",
      "St. Louis, MO--IL",
    ],
    MS: [
      "Gulfport--Biloxi, MS",
      "Hattiesburg, MS",
      "Jackson, MS",
      "Pascagoula--Gautier, MS",
      "Memphis, TN--MS--AR"
    ],
    MT: [
      "Billings, MT",
      "Bozeman, MT",
      "Great Falls, MT",
      "Helena, MT",
      "Missoula, MT"
    ],
    NC: [
      "Asheville, NC",
      "Burlington, NC",
      "Charlotte, NC--SC",
      "Clayton, NC",
      "Concord, NC",
      "Durham, NC",
      "Fayetteville, NC",
      "Gastonia, NC",
      "Goldsboro, NC",
      "Greensboro, NC",
      "Greenville, NC",
      "Hickory, NC",
      "High Point, NC",
      "Jacksonville, NC",
      "Pinehurst--Southern Pines, NC",
      "Raleigh, NC",
      "Rocky Mount, NC",
      "Wilmington, NC",
      "Winston-Salem, NC",
      "Myrtle Beach--North Myrtle Beach, SC--NC"
    ],
    ND: [
      "Bismarck, ND",
      "Fargo, ND--MN",
      "Grand Forks, ND--MN",
      "Minot, ND"
    ],
    NE: [
      "Grand Island, NE",
      "Lincoln, NE",
      "Omaha, NE--IA",
    ],
    NH: [
      "Concord, NH",
      "Manchester, NH",
      "Nashua, NH--MA",
      "Dover--Rochester, NH--ME",
      "Portsmouth, NH--ME",
    ],
    NJ: [
      "Allentown--Bethlehem, PA--NJ",
      "Atlantic City--Ocean City--Villas, NJ",
      "New York--Jersey City--Newark, NY--NJ",
      "Trenton, NJ",
      "Vineland, NJ",
    ],
    NM: [
      "Albuquerque, NM",
      "Farmington, NM",
      "Las Cruces, NM",
      "Santa Fe, NM",
      "El Paso, TX--NM",
    ],
    NV: [
      "Carson City, NV",
      "Las Vegas--Henderson--Paradise, NV",
      "Reno, NV--CA",
    ],
    NY: [
      "Albany--Schenectady, NY",
      "Binghamton, NY",
      "Elmira, NY",
      "Ithaca, NY",
      "Kingston, NY",
      "Kiryas Joel, NY",
      "Middletown, NY",
      "New York--Jersey City--Newark, NY--NJ",
      "Poughkeepsie--Newburgh, NY",
      "Riverhead--Southold, NY",
      "Rochester, NY",
      "Saratoga Springs, NY",
      "Syracuse, NY",
    ],
    OH: [
      "Akron, OH",
      "Canton, OH",
      "Cincinnati, OH--KY",
      "Cleveland, OH",
      "Dayton, OH",
      "Columbus, OH",
      "Lima, OH",
      "Lorain--Elyria, OH",
      "Mansfield, OH",
      "Newark, OH",
      "Sandusky--Port Clinton, OH",
      "Steubenville--Weirton, OH--WV--PA",
      "Toledo, OH--MI",
      "Youngstown, OH",
      "Huntington, WV--KY--OH",
      "Parkersburg, WV--OH",
    ],
    OK: [
      "Enid, OK",
      "Lawton, OK",
      "Norman, OK",
      "Oklahoma City, OK",
      "Tulsa, OK",
      "Fort Smith, AR--OK",
    ],
    OR: [
      "Albany, OR",
      "Bend, OR",
      "Corvallis, OR",
      "Eugene, OR",
      "Grants Pass, OR",
      "Medford, OR",
      "Portland, OR--WA",
      "Longview, WA--OR",
      "Walla Walla, WA--OR",
    ],
    PA: [
      "Allentown--Bethlehem, PA--NJ",
      "Altoona, PA",
      "Chambersburg, PA",
      "Erie, PA",
      "Harrisburg, PA",
      "Hazleton, PA",
      "Johnstown, PA",
      "Lancaster--Manheim, PA",
      "Philadelphia, PA--NJ--DE--MD",
      "Pittsburgh, PA",
      "Reading, PA",
      "Scranton, PA",
      "State College, PA",
      "Steubenville--Weirton, OH--WV--PA",
    ],
    PR: [
      "Aguadilla--Isabela--San Sebastián, PR",
      "Arecibo, PR",
      "Barceloneta--Florida--Bajadero, PR",
      "Fajardo, PR",
      "Guayama, PR",
      "Juana Díaz, PR",
      "Mayagüez, PR",
      "Ponce, PR",
      "San Germán--Cabo Rojo--Sabana Grande, PR",
      "San Juan, PR",
      "Yauco, PR",
    ],
    RI: [
      "Providence, RI--MA",
    ],
    SC: [
      "Anderson--Clemson, SC",
      "Augusta-Richmond County, GA--SC",
      "Bluffton East--Hilton Head Island, SC",
      "Charleston, SC",
      "Columbia, SC",
      "Greenville, SC",
      "Mauldin--Simpsonville, SC",
      "Rock Hill, SC",
      "Spartanburg, SC",
      "Sumter, SC",
      "Myrtle Beach--North Myrtle Beach, SC--NC",
      "Charlotte, NC--SC",
    ],
    SD: [
      "Rapid City, SD",
      "Sioux Falls, SD",
      "Sioux City, IA--NE--SD",
    ],
    TN: [
      "Bristol, TN--VA",
      "Chattanooga, TN--GA",
      "Clarksville, TN--KY",
      "Cleveland, TN",
      "Jackson, TN",
      "Johnson City, TN",
      "Kingsport, TN--VA",
      "Knoxville, TN",
    ]
  }
  

  // avoid null by making sure dom is loaded
  document.addEventListener('DOMContentLoaded', () => {

      const statesList = document.getElementById('statesList');
    const citiesList = document.getElementById('citiesList');
    const stateDiv = document.getElementById('state-hide');
    const cityDiv = document.getElementById('city-hide');
    const backButton = document.getElementById('backButton');

    // button
    document.getElementById('backToNav').addEventListener('click', () => {
      document.getElementById('sidebarData').style.display = 'none';
      document.getElementById('sidebarNav').style.display = 'block';

      // Go back to city list (not all the way to states)
      if (currentCity) {
        document.getElementById('city-hide').style.display = 'block';
        document.getElementById('state-hide').style.display = 'none';
      } else {
        document.getElementById('city-hide').style.display = 'none';
        document.getElementById('state-hide').style.display = 'block';
      }
    });
       
    // populate states
    for (const abbr in stateFullNames) {
      const li = document.createElement('li');
      li.textContent = stateFullNames[abbr];
      li.dataset.abbr = abbr;
      statesList.appendChild(li);
    }

    // when a state is clicked
    statesList.addEventListener('click', (event) => {
      const abbr = event.target.dataset.abbr;
      if (!abbr) return;

      // hide states, show cities
      stateDiv.style.display = 'none';
      cityDiv.style.display = 'block';

      // populate cities
      citiesList.innerHTML = '';
      const cities = stateToUZA[abbr] || [];
      cities.forEach(city => {
        const li = document.createElement('li');
        li.textContent = city;
        li.dataset.city = city;
          li.addEventListener('click', () => {
        sidebarClickToMap(city);
      });
        citiesList.appendChild(li);
      });
    });

    // back button: show states again
    backButton.addEventListener('click', () => {
      citiesList.innerHTML = ''; // optional: clear city list
        // If we came from a city, go back to city list; otherwise go to states
        currentCity = null;
        cityDiv.style.display = 'none';
        stateDiv.style.display = 'block';
      });
        
    function sidebarClickToMap(cityName) {
    if (!map) return;

    // Save current city globally
    currentCity = cityName;

    // Look up feature data for the city (you may need a city-to-feature mapping)
    const feature = cityFeatures[cityName]; // links to nity name directory

      function tryOpen(attemptsLeft) {
        const feature = cityFeatures[cityName];
        if (feature) {
          const coords = feature.geometry.coordinates;
          map.flyTo({ center: coords, zoom: 9 });
          window.openSidebarWithFeature(feature);
        } else if (attemptsLeft > 0) {
          // wait 300ms and try again
          setTimeout(() => tryOpen(attemptsLeft - 1), 300);
        } else {
          alert("Could not find data for " + cityName + ". Try zooming into that area on the map first.");
        }
      }

      tryOpen(10); // try up to 10 times = 3 seconds total
    }
    })
