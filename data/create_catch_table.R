# Created by Rebecca Haehn
# Start date: 09/12/2019
# latest edit: 09/16/2019

# building block script
## creates table with species (weight and number) required by stock assessment authors


# once catch table is built
## next step build windows prompt to select for individual species
      # once window is built, would it be useful to have a list of species names 
      # alongside species code in the window?
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

## creates table with species codes, weight and number of fish collected by
##  haul within each year, INCLUDES ALL HAULS REGARDLESS OF HAUL CRITERIA

#catch_table is a dataframe: species_code, number_fish and hauljoin are INTEGERS, weight is a NUMBER
catch_table <- sqlQuery(channel, "
                        SELECT species_code, weight, number_fish, hauljoin
                        
                        FROM RACEBASE.CATCH
                        
                        WHERE 
                              
                              species_code IN (
                                232,310,320,420,435,440,455,471,472,480,490,495,
                                10110,10112,10115,10120,10130,10140,10180,10200,10210,
                                10211,10212,10220,10260,10261,10262,10270,10285,21110,
                                21420,21371,21370,21368,21347,21314,21315,21316,21329,
                                21333,21340,21341,21346,21348,21352,21353,21354,21355,
                                21356,21388,21390,21397,21405,21406,21438,21441,21720,
                                21725,21735,21740,30050,30051,30052,30060,30150,30152,
                                30420,30535,78010,78012,78020,78403,78454,78455,79020,
                                79210,81742);
                          ")


## join with EBS haul table to filter out hauls that do not meet stock assessement criteria.
##    Haul criteria is listed in create_haul_table.R file

## NOTE: 'right_join' joins matching rows from catch_table to EBS_haul_table thus retaining
##       all the information in EBS_haul_table and filtering info from catch_table

haul_catch <- dplyr::right_join(catch_table, EBS_haul_table)      
############ hual_catch has same row count as SQL script for biocatch (157985)

write.csv(x = catch_table, file = "catch_table.csv")

write.csv(x = haul_catch, file = "haul_catch.csv")
