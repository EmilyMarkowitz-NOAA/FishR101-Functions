# Homework 4: Data wrangling and manipulation with tidyverse
# Created by: 
# Contact: 
# Created: 
# Modified: 


# packages ----------------------------------------------------------------
library(tidyverse)
library(here)

# tasks -------------------------------------------------------------------

# NOTE: For this homework, also refer to the PDF version. 
# There are helpful graphics included in the PDF version!

#*** 1. If-else statements----------------


## ******1.1 Performance: was this a good trawl? ----------

# If the weather is `excellent` or `good`, the peformance of the trawl is `0`
# if the weather is `fair`, the peformance of the trawl is `1`
# if the weather is `poor`, the peformance of the trawl is `-1`

# Write the following as an: 

# - if() / if()}else{} / if()}else if(){} statement (whichever you see fit), 
# - in an ifelse() function, 
# - using dplyr::if_else(), and 
# - using dplyr::case_when()

# Test your scripts with for the first two bullets (if-else statement, ifelse())
weather <- "good"

# Test your scripts with for the second - fourth bullet (ifelse(), if_else(), case_when())
dat<-data.frame(weather = c("excellent", "good", "fair", "poor"))

# Then tell us which do you think is the most sensible approach?

#  - if() / if()}else{} / if()}else if(){} statement (whichever you see fit), 


#  - in an ifelse() function,  

     # with one variable


     # with a data.frame



#  - using dplyr::if_else(), and 



#  - using dplyr::case_when()


# Q. Which do you think is the most sensible approach?


# ***2. For loops--------------------

## Improve the following code by putting it into a for loop!

# Let's use a for loop to estimate the average the result of a roll of a die. 
nsides = 6
ntrials = 1000

# A non-loop version of this for the first variable would be: 
trials <- c()
j <- 1
trials <- c(trials, sample(1:nsides,1))
trials
# once you write your loop, you can use the following to calcuale the average 
# the result of a roll of a die.  
mean(trials) # NOTE: because we are taking a random sample (sample()) 
# you will not get the same answer that I get in the solutions. 
# Here it is important to be in the ballpark!

# EXTRA Credit

# Vectorize the below loop into 4 tidyverse lines: 

EBS_haul_table<-read_csv(here::here("data", "ebs_2017-2018.csv"))

EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::group_by(YEAR, STRATUM, COMMON) %>% # Group by YEAR, STRATUM, COMMON for next command
  dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above

unique_yr_strat<-EBS_summary %>% 
  dplyr::select("YEAR", "STRATUM") %>% 
  distinct()

unique_yr_strat

max_5_spp<-NULL

for (i in 1:nrow(unique_yr_strat)){
  
  # basically use the same code you had above, but with iterative, not fixed, 
  # variables for year and stratum 
  # max_5_spp0 <- NULL
  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == unique_yr_strat$YEAR[i], 
                  STRATUM == unique_yr_strat$STRATUM[i]) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  max_5_spp<-bind_rows(max_5_spp, 
                       max_5_spp0)
}

max_5_spp


