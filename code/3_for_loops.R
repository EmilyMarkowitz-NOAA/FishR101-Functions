# Lesson 5: Loops and functions
# 1_setup.R
# Created by: Emily Markowitz
# Contact: Emily.Markowitz@noaa.gov
# Created: 2020-12-18
# Modified: 2021-02-08


# packages ----------------------------------------------------------------

library(tidyverse)
library(here)

# directories --------------------------------------------------------------------
# 
# source(here("functions", "file_folders.R")) (already done in script 1_*.R)
# 
# download data --------------------------------------------------------------------
# EBS_haul_table<-read_csv(here::here("data", "ebs_2017-2018.csv"))
# 
# look at your data -------------------------------------------------------
# 
# str(EBS_haul_table)

# What is a for loop? ---------------------------------

# = “looping”, “cycling”, “iterating” or just replicating instructions. 

# Loops help automate multi-step processes by organizing sequences of actions 
# and by grouping the parts that need to be repeated (blocks of instructions). 

# for loops are best shown with examples:

# Task 1 ---------------------------------

# Create a simple loop that will do this same task in THREE lines or less

print(paste("The year is", 2010))
print(paste("The year is", 2011))
print(paste("The year is", 2012))
print(paste("Te year is", 2013))
print(paste("The year is", 2014))
print(paste("The year is", 2015))

# Simple! We are going to use what we just learned about loops to iterate between years!
# There are two ways of writing this loop:

#A. 
#      Here, we use the iterative value i to cycle through the items in the yrs vector. 
#      Such that i will equal 1, 2, 3,... length(yrs) (=6) and we find the ith 
#      item in the yrs vector by calling yrs[i]. 
yrs<-c(2010,2011,2012,2013,2014,2015) # create a variable

for (i in 1:length(yrs)){ # where i = 1,2,3,... and we call the ith item of the vector yrs
  print(paste("The year is", yrs[i]))
}

i

# B. 
#      Here, we use the variables to be the iterative value, such that 
#      year will be 2010 in the first loop, 2011 the second loop,... 
#      and 2015 for the last loop. 
for (yr in c(2010,2011,2012,2013,2014,2015)){ # Where yr = 2010, 2011, etc. iteratively
  print(paste("The year is", yr))
}

yr

# This was clearly a simple example, but you can see where this approach would 
# become really important for when something has to be done a bunch of times and 
# for more complicated statements

# A note for later, printing i can be a useful tool for troubleshooting code so 
# you can see where a loop breaks. 

# Task 2 ---------------------------------

# Lets say that we want to look at this data by year and by stratum to find out 
# what the top 5 species are in each 

# Initial data wrangling
EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::group_by(YEAR, STRATUM, COMMON) %>% # Group by YEAR, STRATUM, COMMON for next command
  dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above

EBS_summary

# ***Task 2 - the long way ---------------------------------

# Year = 2016, Stratum = 10 
max_5_spp_2016_10 <- EBS_summary %>%
  dplyr::filter(YEAR == 2016, STRATUM == 10) %>% 
  dplyr::arrange(-WTCPUE_sum) %>%
  dplyr::top_n(n = 5)

max_5_spp_2016_10

# Year = 2016, Stratum = 20 
max_5_spp_2016_20 <- EBS_summary %>% # Change name
  dplyr::filter(YEAR == 2016, STRATUM == 20) %>% # we change these variables
  dplyr::arrange(-WTCPUE_sum) %>%
  dplyr::top_n(n = 5)

max_5_spp_2016_20

# ...you get the idea... that this will take FOREVER.
# ...and yes, THERE IS A BETTER WAY!

###### ***Task 2 - with for loops ---------------------------------

# Here are all of the instances we need checked
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

max_5_spp # And that was so easy, so much shorter to write, and faster!!

# While we are here, let's check out the other objects that were created in our 
# loop that we don't care about that came out of this: 

# What is i? By printing it here, it will just print the number of the last iteration
i
# but by looking in our environment under values, we see that i = 36L
#  to learn more about i, we can employ class() and mode()
class(i) # an integer is a value with no decimals
mode(i) # integers are numeric
# i is a numeric integer (no decimal places/only whole numbers)

# and what is max_5_spp0? 
max_5_spp0
# Just the last 5 species that were caught from the last year and stratum assessed
# We don't actually need max_5_spp0 for anything after this point, but it is saved in our environment
# (remember this when we talk about functions in a bit!)
