# Lesson 5: Loops and functions
# 2_if_else.R
# Created by: Emily Markowitz
# Contact: Emily.Markowitz@noaa.gov
# Created: 2020-12-18
# Modified: 2021-02-08


# packages ----------------------------------------------------------------

library(tidyverse)
library(here)
library(data.table)


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


# What is a if-else statement? -------------------------------------------------------

# Test variables
x <- 7
y <- 5
z <- 5
v <- 1:6

# ***if(){}else if(){}  statements -------------------------------------------------------

# ******if()  statement -------------------------------------------------------

if(x > y) {
  print("x is greater")
}
# This is a true statement, so it returns something!

if(x < y) {
  print("x is less than")
}
# This is a false statement, so it returns nothing! Nothing in the body was run.


# ******if() else statement -------------------------------------------------------

# now we can combine the two previous statements into the same statement by:
if(x > y) {
  print("x is greater")
} else {
  print("y is greater")
}

# *********One Line If…Else---------------
# If Statement Without Curly Braces: 
# If you have only one statement to execute, one for if, and one for else, 
# you can put it all on the same line and skip curly braces. 
x <- 7
y <- 5

if (x > y) print("x is greater")

if (x > y) print("x is greater") else print("y is greater")
# This returns the same as above

if (x > y) x else y
# This returns the value that this is true for

# ******if(), else if() statement -------------------------------------------------------

if(y > z) {
  print("y is greater")
} else if(y < z) {
  print("z is greater")
} else {
  print("y and z are equal")
}



# ******Nested if() Statement -------------------------------------------------------

# You can write one if statement inside another if statement to test more than one condition and return different results.

x <- 7
y <- 5
z <- 2
if(x > y) {
  print("x is greater than y")
  if(x > z) print("x is greater than y and z")
}

# ******Multiple conditions -------------------------------------------------------

x <- 7
y <- 5
z <- 2
if(x > y && x > z) {
  print("x is greater")
}

# *********NOTE - funny things about if()---------------

# In R, any non-zero value is considered TRUE, whereas a zero is considered FALSE. 
# That’s why all the below if statements are valid.

# Here it's if(value) then TRUE or FALSE  rather than 
# if something is distinct from this other thing in a T/F way. 

# mathematical expression
x <- 7
y <- 5
if(x + y) {
  print("True") # Note that this is a character, not a boolean TRUE (or FALSE)
}


# any non-zero value
if(-3) {
  print("True")
}


# ***ifelse() statement function -------------------------------------------------------

# In R, conditional statements are not vector operations. 
# They deal only with a single value.
# If you pass in, for example, a vector, the if statement will only check the 
# very first element and issue a warning.

v # recall that v is a vector of numbers

if(v %% 2) { # %% is modulo = Give the remainder of the first vector with the second
  print("odd")
} else {
  print("even")
} # Whoops, error!

# The solution to this is the ifelse() function. The ifelse() function checks 
# the condition for every element of a vector and selects elements from the 
# specified vector depending upon the result.

# Here’s the syntax for the ifelse() function.
v1 <- 1:6
ifelse(v1 %% 2 == 0, "even", "odd")

# You can even use this function to choose values from two vectors.
v2 <- c("a","b","c","d","e","f")
ifelse(c(TRUE,FALSE,TRUE,FALSE,TRUE,FALSE), v1, v2)


# suggestions for things we could do with these two data sets?

# ***dplyr::if_else-------------------------------

# create example data
dt <- data.table(
  grp = factor(sample(1L:3L, 1e6, replace = TRUE)),
  x = rnorm(1e6),
  y = rnorm(1e6),
  z = sample(c(1:10, NA), 1e6, replace = TRUE)
)
dt
str(dt)

# single if_else
dt %>% 
  mutate(x_cat = if_else(x > median(x), "high", "low"))

# nested if_else()
dt %>% 
  dplyr::mutate(x_cat = 
                  dplyr::if_else(x < -.5, "low",
                                 dplyr::if_else(x < .5 , "moderate", "high"))) %>% 
  as_tibble()

# Asssign multiple changes based on case_when()
dt %>% 
  mutate(x_cat = case_when(x < -.5 ~ "low",
                           x <  .5 ~ "moderate",
                           x >= .5 ~ "high"))

# ***Compare-contrast - How to best write these -------------------------------------------------------

# ******Example 1------------------
x <- -5

if(x > 0){
  print("Non-negative number")
} else {
  print("Negative number")
}

# Alternatively...
if(x > 0){
  print("Non-negative number")
} else if (x <= 0) {
  print("Negative number")
}

# Alternatively...
ifelse(x > 0, print("Non-negative number"), print("Negative number") )

# ******Example 2------------------

client <- 'private'
net.price <- 100
if(client=='private'){
  tot.price <- net.price * 1.12      # 12% VAT
} else {
  if(client=='public'){
    tot.price <- net.price * 1.06    # 6% VAT
  } else {
    tot.price <- net.price * 1    # 0% VAT
  }
}
tot.price

# Luckily, R allows you to write all that code a bit more clearly. 
# You can chain the if…else statements as follows:
  
if(client=='private'){
  tot.price <- net.price * 1.12
} else if(client=='public'){
  tot.price <- net.price * 1.06
} else {
  tot.price <- net.price
}
tot.price

# In this example, the chaining makes a difference of only two braces, 
# but when you have more possibilities, it makes code readable. Note, that you 
# don’t have to test whether the argument client is equal to ‘abroad’ 
# (although it wouldn’t be wrong to do that). You just assume that if client 
# doesn’t have any of the two other values, it has to be ‘abroad’.

VAT <- ifelse(client=='private', 1.12,
              ifelse(client == 'public', 1.06, 1)
)
VAT

tot.price <- net.price * VAT
tot.price



