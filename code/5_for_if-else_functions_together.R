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

# Task 1: combine the following if-else statement, for loop, and function  ------

var <- 10:20

# *** for loop  --------------------------------------------------------------------

for (i in 1:length(var)){ # For the ith item in var, 
  print(var[i])           # Print to the console that the ith item in var,
}                         # Done
# this will print out each value of i, iteratively


# ***if-else statement --------------------------------------------------------

i <- 1                                            # Let i be 1
if (var[i]<15){                                   # If the ith value of var is less than 15, then:
  print(paste0(var[i],                            # Print to the console that ith value of var... 
               " is less than 15"))               # is less than 15.
} else { # = “} else if (var[i]>=15) {“           # otherwise: 
  print(paste0(var[i],                            # Print to the console that ith value of var... 
               " is greater than or equal to 15"))# is greater than or equal to 15.
}                                                 # Done
# Because var[i] = 10, then this would return: 
# “10 is less than 15”


# ***Combine for loop and if-else statement --------------------------------------------------------

var <- 10:20                                        # Let var be a vector of numbers from 10 to 20.
for (i in 1:length(var)){                           # For the ith item in var, 
  if (var[i]<15){                                   # If the ith value of var is less than 15, then:
    print(paste0(var[i],                            # Print to the console that ith value of var... 
                 " is less than 15"))               # is less than 15.
  } else { # = “} else if (var[i]>=15) {“           # otherwise: 
    print(paste0(var[i],                            # Print to the console that ith value of var... 
                 " is greater than or equal to 15"))# is greater than or equal to 15.
  }                                                 # Done with if-else loop
}                                                   # Done with for loop

# ***Now let's think about how this can become a funciton

# actually, you can just insert it into the function body verbatium. 
# The benefit here is that now you can use it anywhere in your script!

gl15 <- function(var)                                 # Create a funciton named gl15 with arguments var (a vector of numbers)
  {                                                   # Begin function body
  for (i in 1:length(var)){                           # For the ith item in var, 
    if (var[i]<15){                                   # If the ith value of var is less than 15, then:
      print(paste0(var[i],                            # Print to the console that ith value of var... 
                   " is less than 15"))               # is less than 15.
    } else { # = “} else if (var[i]>=15) {“           # otherwise: 
      print(paste0(var[i],                            # Print to the console that ith value of var... 
                   " is greater than or equal to 15"))# is greater than or equal to 15.
    }                                                 # Done with if-else loop
  }                                                   # Done with for loop
}                                                     # Done with function body

gl15(var)

# Task 2------------------------------------------

# Here is a function that we are going to improve on: 

priceCalculator <- function(hours, pph=40){
  net.price <- hours * pph
  round(net.price)
}
# Here’s what this code does:
# Everything between the braces is the body of the function (see Chapter 8).
# Between the parentheses, you specify the arguments hours (without a default value) 
#    and pph (with a default value of $40 per hour).
# You calculate the net price by multiplying hours by pph.
# The outcome of the last statement in the body of your function is the returned value. 
#    In this case, this is the total price rounded to the dollar.

# You could drop the argument pph and just multiply hours by 40. But that would 
# mean that if, for example, your colleague uses a different hourly rate, they 
# would have to change the value in the body of the function in order to be able 
# to use it. It’s good coding practice to use arguments with default values for 
# any value that can change. Doing so makes a function more flexible and usable.

# Now imagine you have some big clients that give you a lot of work. 
# To keep them happy, you decide to give them a reduction of 10 percent on the 
# price per hour for orders that involve more than 100 hours of work. So, if 
# the number of hours worked is larger than 100, you calculate the new price 
# by multiplying the price by 0.9.

# You can write that almost literally in your code like this:
  
  priceCalculator <- function(hours, pph=40){
    net.price <- hours * pph
    if(hours > 100) {
      net.price <- net.price * 0.9
    }
    round(net.price)
  }
  
# You can see that the reduction is given only when the number of hours is larger than 100:
priceCalculator(hours = 55)
priceCalculator(hours = 110)

# Alternatively: 
# This construct is the most general way you can specify an if statement. 
# But if you have only one short line of code in the code block, you don’t 
# have to put braces around it. You can change the complete if statement in the 
# function with the following line:

priceCalculator <- function(hours, pph=40){
  net.price <- hours * pph
  if(hours > 100) net.price <- net.price * 0.9
  round(net.price)
}

priceCalculator(hours = 55)
priceCalculator(hours = 110)
