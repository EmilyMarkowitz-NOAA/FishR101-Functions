# Lesson 5: Loops and functions
# 1_setup.R
# Created by: Emily Markowitz
# Contact: Emily.Markowitz@noaa.gov
# Created: 2020-12-18
# Modified: 2021-02-08


# packages ----------------------------------------------------------------

library(tidyverse)
# install.packages("roxygen2") # RUN THIS!
library(roxygen2) # we'll get to why we need this in a minute
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

# Explore functions --------------------------

#### Functions are made of 4 parts
# Function Name
    # This is the actual name of the function. It is stored in R environment as an object with this name.
# Arguments
    # An argument is a placeholder. When a function is invoked, you pass a value 
    # to the argument. Arguments are optional; that is, a function may contain no 
    #arguments. Also arguments can have default values.
# Function Body
    # The function body contains a collection of statements that defines what the function does.
# Return Value
    # The return value of a function is the last expression in the function body to be evaluated.

# let's see this in a simple example

function_name <-      # Name of function
  function(argument)  # Define what input arguments are needed
    {                 # Begining of function body
  out<-argument       # Statement
  return(out)         # return outputs from the function body
}                     # DONE, end of funciton body

# NOTE the line breaks here mostly don't matter
# This is yields the same as above: 

# probably how you will most often see them written out
function_name <-function(argument) {
    out<-argument
    return(out)
}

# As does this, but harder to read, but works
function_name <-function(argument) { out<-argument; return(out)} 
# note that I used a line break ; to seperate the different parts of this statement


# This will work the same as writing the below because it will assume that the 
# last unassigned variable is meant to be returned, but this is a BAD practice. 
# be specific about what you want to come out of these functions!
function_name<- function(argument){
  # function body
  argument # statement
}

# And then we can use this funciton as we would any other funciton
function_name(1)
  
# function_name() is a simple function. If we needed to take a peek at the 
# inner gears of function_name(), we can do that simply by calling the name 
# of the function without adding the parentheses after it
function_name
# You'll see all of our code for function_name printed!

# you'll also notice that when you ask what class our funciton is, 
# it will return that it is type "funciton"
class(function_name)
# Which is why you see it under "Functions" in the environment tab in the 
# upper right of the screen

# If you click on "function_name" in the enviorment, you'll see it will open 
# a script of your function in a new script tab

# Look at functions already in R --------------------------------------------

# ***sum()  --------------------------------------------
# sum is a primiative function in R and we can see how it is built by just calling 
# the name of the function (sum) without adding the parentheses after it
sum
# function (..., na.rm = FALSE)  .Primitive("sum")

# remember that we can explore the sum() documentation by using the question mark
# and it notes that it is a function from the {base} package
?sum

# And like above, you'll also notice that when you ask what class our funciton is, 
# it will return that it is type "funciton"
class(sum)

# ***stringr::regex()  --------------------------------------------
# Let's check out a funciton that isn't primative (writen in C++)
stringr::regex # see the inner gears of regex
formals(stringr::regex) # lists arguments
body(stringr::regex) # Shows body of the funciton
environment(stringr::regex) # shows what package regex is coming from (text after "namespace:...")

# Create your own functions --------------------------

# What if we took that for loop from 2_for_loops.R and made that into a function?
# Here is that loop again: 

# *** Improving on Task 2 from 2_for_loops.R -> function! ---------------------------------

# Lets say that we want to look at this data by year and by stratum to find out 
# what the top 5 species are in each 

# ****** loop from Example 2 in 2_for_loops.R ----------------------------

# data manipulation

EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::group_by(YEAR, STRATUM, COMMON) %>% # Group by YEAR, STRATUM, COMMON for next command
  dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above

# loop from example 2 2_for_loops.R 

unique_yr_strat<-unique(EBS_summary[,c("YEAR", "STRATUM")])
max_5_spp<-data.frame()

for (i in 1:nrow(unique_yr_strat)){

  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == unique_yr_strat$YEAR[i], 
                  STRATUM == unique_yr_strat$STRATUM[i]) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  max_5_spp<-rbind.data.frame(max_5_spp, 
                              max_5_spp0[1:5,])
}

max_5_spp 

# ****** function of loop from Example 2 2_for_loops.R ----------------------------

# We could simply create a funciton from this code that will allow us to input 
# the data, year, and station we are interested in seeing the top 5 species from

max5spp <- function (EBS_summary, yr, strat){ 
  # named this max5spp to be different from the data.frame object we have saved

  # basically use the same code you had above, 
  # but now with variables from the function where 
  # unique_yr_strat$YEAR[i] and unique_yr_strat$STRATUM[i] where 
  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == yr, 
                  STRATUM == strat) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  return(max_5_spp0[1:5,])
  # 1. same thing as writing:
  # max_5_spp<-max_5_spp0[1:5,])
  # return(max_5_spp)
  
}

max5spp(EBS_summary = EBS_summary, 
          yr = 2016, 
          strat = 10) 
# Wooooo! Short, sweet, and clean!

max_5_spp # same result!


# Benefits of this approach: 
# the mid-step variable max_5_spp0 that we don't actually care about 
# would be saved to your environment. While here that is not a big deal, it 
# can be a big deal when working with bigger data and more complicated objects. 

# ***Return multiple objects---------------

# Let's say I didn't just want to output the result, but also the parameters 
# that went into the function. Easy!

# Here we have to create a list of outputs in the return()

max5spp <- function (EBS_summary, yr, strat){ 
  # named this max5spp to be different from the data.frame object we have saved
  
  # basically use the same code you had above, 
  # but now with variables from the function where 
  # unique_yr_strat$YEAR[i] and unique_yr_strat$STRATUM[i] where 
  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == yr, 
                  STRATUM == strat) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  return(list("max_5_spp" = max_5_spp0[1:5,], 
              "EBS_summary" = EBS_summary, 
              "yr" = yr, 
              "strat" = strat))
}

max5spp(EBS_summary = EBS_summary, 
        yr = 2016, 
        strat = 10) 

# Best Practices: using the roxygen skeleton ------------------

# Now, let's talk about how to document our functions!
# How would you document this? 

max5spp <- function (EBS_summary, yr, strat){ 
  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == yr, 
                  STRATUM == strat) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  return(max_5_spp0[1:5,])
}

# I would document it like this: 

#' Collect top 5 species in each year and stratum
#'
#' @param EBS_summary data.frame with columns "YEAR", "STRATUM", "COMMON" and "WTCPUE_sum". There should be one value of WTCPUE_sum for each yr, strat, and species common name. 
#' @param yr Numeric with 4 digits. The year to be assessed. 
#' @param strat Numeric. The number identifying the stratum. 
#'
#' @return A data.frame including columns "YEAR", "STRATUM", "COMMON" and "WTCPUE_sum" with the top 5 WTCPUE_sum species in that yr and strat
#' @export
#'
#' @examples
#' max5spp(EBS_summary = EBS_summary, 
#'         yr = 2016,
#'         strat = 10) 
max5spp <- function (EBS_summary, yr, strat){ 
  max_5_spp0 <- EBS_summary %>%
    dplyr::filter(YEAR == yr, 
                  STRATUM == strat) %>% 
    dplyr::arrange(-WTCPUE_sum) %>%
    dplyr::top_n(n = 5)
  
  return(max_5_spp0[1:5,])
}

# Besides being incredibly helpful to future you as you try to figure out what you did, 
# this can be helpful when you reach the next stage of R enlightenment and begin 
# creating your own packages and sharing code with colleagues and for public consumption


# You'll have lots of chances in the homework to practice documenting code!


