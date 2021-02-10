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

source(here("functions", "file_folders.R"))

# download data --------------------------------------------------------------------

EBS_haul_table<-read_csv(here::here("data", "ebs_2017-2018.csv"))

# look at your data -------------------------------------------------------

str(EBS_haul_table)
