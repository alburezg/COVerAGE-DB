rm(list=ls())
# devtools::install_github("hrbrmstr/wayback")
library(tidyverse)
library(wayback)
library(XML)
library(lubridate)
library(readxl)

# Example of extraction of links with the wayback machine (Sweden)
archive_check_url <- "https://www.arcgis.com/sharing/rest/content/items/b5e7488e117749c19881cce45db13f7e/data"

res <- get_mementos(archive_check_url)

get_timemap(archive_check_url)

timestamps <- get_timemap(res$link[2]) %>% 
  filter(!is.na(datetime))

get_date <- function(x){
  x %>% 
    str_split(pattern=" ") %>% 
    unlist() %>% 
    '['(2:4) %>% 
    paste(collapse = " ") %>% 
    dmy() %>% 
    as.character()
}

timestamps$date <- lapply(timestamps$datetime, get_date) %>% unlist()

timestamps <- timestamps %>% 
  group_by(date) %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(date, link)

dates <- unique(timestamps$date)

ref <- dates[1]

for (ref in dates){
  
  date <- paste(sprintf("%02d", day(ref)),
                sprintf("%02d", month(ref)),
                year(ref), sep = ".")
  
  link <- timestamps$link[timestamps$date == ref]

  ### etc...
  
  
    
}
