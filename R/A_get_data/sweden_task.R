library(tidyverse)
library(lubridate)
library(googlesheets4)
library(googledrive)
library(readxl)
library(httr)

# path <- getwd()
path <- "U:/Projects/COVerAGE-DB/R/A_get_data"

# sink("estonia_output.txt", append = T)
eval(parse(paste0(path, "/sweden.R"), encoding = 'UTF-8'))
# sink()