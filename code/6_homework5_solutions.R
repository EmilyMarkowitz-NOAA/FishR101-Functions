# Homework 4: Data wrangling and manipulation with tidyverse
# Created by: 
# Contact: 
# Created: 
# Modified: 


# packages ----------------------------------------------------------------
library(tidyverse)
library(here)

# tasks -------------------------------------------------------------------

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

# Which do you think is the most sensible approach?

# ANSWERS

####  - if() / if()}else{} / if()}else if(){} statement (whichever you see fit), 
if (weather %in% c("excellent", "good")) {
  performance <- 0
} else if (weather == "fair") {
  performance <- 1
} else if (weather == "poor") {
  performance <- -1
}
performance

# alternatively: 
if (weather == "excellent" | weather == "good") {
  performance <- 0
} else if (weather == "fair") {
  performance <- 1
} else {
  performance <- -1
}
performance

#  - in an ifelse() function,  

# with one variable
performance<-ifelse(weather %in% c("excellent", "good"), 0, 
                    ifelse(weather %in% "fair", 1, 
                           ifelse(weather %in% "poor", -1, NA)))
performance

# alternitively
performance<-ifelse(weather %in% c("excellent", "good"), 0, 
                    ifelse(weather %in% "fair", 1, -1))
performance

# with a data.frame
performance<-ifelse(dat$weather %in% c("excellent", "good"), 0, 
                    ifelse(dat$weather %in% "fair", 1, 
                           ifelse(dat$weather %in% "poor", -1, NA)))
performance


#  - using dplyr::if_else(), and 
dat1 <- dat %>% 
  dplyr::mutate(performance =
                  dplyr::if_else(weather %in% c("excellent", "good"), 0, 
                                 dplyr::if_else(weather %in% "fair", 1, -1)))
dat1


dat1<-dat %>%
  dplyr::mutate(performance =
                  dplyr::if_else(weather %in% c("excellent", "good"), 0,
                                 dplyr::if_else(weather %in% "fair", 1, 
                                                -1)))
dat1


#  - using dplyr::case_when()
dat1<-dat %>%
  dplyr::mutate(performance =
                  dplyr::case_when(weather %in% c("excellent", "good") ~ 0,
                                   weather %in% "fair" ~ 1, 
                                   weather %in% "poor" ~ -1))
dat1

# Which do you think is the most sensible approach?

# ANSWER
# I would argue that the dplyr::case_when() is the cleanest solution, 
# but as you can see, they all work!
# Whichever one suits your fancy. 

# ***2. For loops--------------------

## ******2.1 Improve the following code by putting it into a for loop!--------

# Let's use a for loop to estimate the average the result of a roll of a die. Where...

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

# ANSWER
for (j in 1:ntrials) {
  trials <- c(trials, 
              sample(1:nsides,1))  # We get one sample at a time
}
head(trials)
mean(trials) # NOTE: because we are taking a random sample (sample()) you will not get the same answer that I get in the solutions. Here it is important to be in the ballpark!)


# ***3. EXTRA Credit -------------------------

# Recall this example from the coursework:

EBS_haul_table<-read_csv(here::here("data", "ebs_2017-2018.csv"))

EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::group_by(YEAR, STRATUM, COMMON) %>% # Group by YEAR, STRATUM, COMMON for next command
  dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above

unique_yr_strat<-EBS_summary %>% 
  dplyr::select("YEAR", "STRATUM") %>% 
  distinct()

unique_yr_strat

max_5_spp<-NULL

# Change the the below for loop from the lecture into 4 tidyverse lines with no loop: 

for (i in 1:nrow(unique_yr_strat)){
  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == unique_yr_strat$YEAR[i], 
                  STRATUM == unique_yr_strat$STRATUM[i]) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  max_5_spp<-bind_rows(max_5_spp, 
                       max_5_spp0)
}

# ANSWER
EBS_summary %>% 
  arrange(YEAR, STRATUM, -WTCPUE_sum) %>% 
  group_by(YEAR, STRATUM) %>%
  top_n(n = 5)
