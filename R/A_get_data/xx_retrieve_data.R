library(tidyverse)
library(lubridate)
library(googlesheets4)
library(googledrive)
library(readxl)
library(httr)
library(taskscheduleR)


print(paste0("Starting data retrieval for Sweden..."))
eval(parse("sweden.R", encoding = 'UTF-8'))

print(paste0("Starting data retrieval for NYC..."))
eval(parse("nyc.R", encoding = 'UTF-8'))

if(weekdays(now(tzone = "GMT")) == "Friday"){
  print(paste0("Starting data retrieval for Estonia..."))
  eval(parse("estonia.R", encoding = 'UTF-8'))
}
