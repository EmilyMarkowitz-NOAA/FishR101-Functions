# Created by Rebecca Haehn
# Start date: 09/11/2019
# latest edit: 09/16/2019

# building block script
## creates haul table for Bering Sea region that includes ONLY hauls that will be used
##    in biomass assessment

# once haul table is built for stock assessment
    ## NEXT STEP 1 OF 2: build windows prompt to select cruise enabling yearly biomass
#________________________________________________________________

## can also set working directory by clicking "Session" and "Set Working Directory"
# setwd("G:/HaehnR/CSV/building_blocks4scripts")

PKG <- c("dplyr", "tidyverse", "knitr", "kableExtra", "reshape")
for (p in PKG) {
  if(!require(p,character.only = TRUE)) {  
    install.packages(p)
    require(p,character.only = TRUE)}
}

# This has a specific link because I DONT want people to have access to this!
source("C:/Users/emily.markowitz/Documents/Projects/ConnectToOracle.R")

######################################################

## generates table with named all_hauls that fall within the defined 
##  parameters: survey definition id, performance, haul type, has a station
##  id and is with in stratums used to determine biomass

## NOTE: paramater definitions are listed in the following Oracle tables
##       survey definition ID -> RACE_DATA.SURVEY_DEFINITIONS
##       performance -> RACEBASE.PERFORMANCE
##       haul type -> RACE_DATA.HAUL_TYPES
##       station ID  and stratum -> RACE_DATA.STRATUM_STATIONS

## NOTE: stratums 82 and 90 are part of the Northwest area. Some stock
##  assessment authors do not want data from these strata. When these strata
##  are included, the output only includes data from 1987 to present

##   NEXT STEP 2 of 2: windows prompt "include NW stratums Y/N?"

EBS_haul_table <- sqlQuery(channel, "
                      SELECT b.survey_definition_id, a.cruise, b.year, a.region, a.vessel,
                             a.haul, a.stationid, a.stratum, a.haul_type,
                             a.performance, a.start_time, a.duration, a.distance_fished, 
                             a.net_width, a.net_height, a.hauljoin 
                
                      FROM RACEBASE.HAUL a
         
                      JOIN RACE_DATA.V_CRUISES b
         
                      ON a.cruisejoin = b.cruisejoin 
         
                      WHERE
                         survey_definition_id = 98 AND
                         performance >= 0  AND 
                         haul_type = 3 AND 
                         stationid IS NOT NULL AND
                         stratum IN (10,20,31,32,41,42,43,50,61,62,82,90);
                      ")
################# EBS_haul_table has same row count as SQL script for haulname (14089)

write.csv(x = EBS_haul_table, file = "EBS_haul_table.csv")

