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
  
  # Make sure that it is after 13.00 GMT
  if(hour(now(tzone = "GMT")) >= time_to_start){
    
    print(paste0("Starting data retrieval for Sweden...", d))
    source("sweden.R")
    
    print(paste0("Starting data retrieval for NYC..."))
    source("nyc.R")
    
    if(weekdays(now(tzone = "GMT")) == "Friday"){
      print(paste0("Starting data retrieval for Estonia..."))
      source("estonia.R")
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
