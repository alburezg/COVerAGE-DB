library(tidyverse)
library(lubridate)
library(googlesheets4)
library(googledrive)
library(readxl)
library(httr)


# 20200612
# Rules for data retrieval 

# Since all need to be run after 13.00 GMT, just run everything everyday at 13.00

time_to_start <- 13

while(T){
  
  sink("output.txt", append = T)
  
  print("~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~")
  print(paste("New data retrieval started for Sweden, Estonia, NYC", now(tzone = "GMT")))
  print("Rules are as follows:")
  print("Sweden: Retrieve every day at 13.00 GMT")
  print("NYC: Run evey day 11.00 GMT")
  print("Estonia: Run every Friday at 13.00 GMT")    
  
  d <- now(tzone = "GMT")
  
  # Make sure that it is after 13.00 GMT
  if(hour(d) >= time_to_start){
    
    print(paste0("Starting data retrieval for Sweden..."))
    # source("sweden.R")
    eval(parse("sweden.R", encoding = 'UTF-8'))
    
    print(paste0("Starting data retrieval for NYC..."))
    # source("nyc.R")
    eval(parse("nyc.R", encoding = 'UTF-8'))
    
    if(weekdays(now(tzone = "GMT")) == "Friday"){
      print(paste0("Starting data retrieval for Estonia..."))
      # source("estonia.R")
      eval(parse("estonia.R", encoding = 'UTF-8'))
    }
    
    print(paste0("SUCESS! All estimates saved for day", d, "!!"))
  } else {
    print(paste("Not yet time to get these, I'll just go back to sleep...", d))
  }
  
  print("Sleeping for 12 h...")
  Sys.sleep(60*60*12)
  
  sink()
  
}

closeAllConnections()
