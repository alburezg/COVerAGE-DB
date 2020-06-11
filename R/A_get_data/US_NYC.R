rm(list=ls())
library(tidyverse)
library(lubridate)
library(googlesheets4)
library(googledrive)

country <- "nyc"
path_out <- paste0("../../Data/",country,"/")

db_age <- read_csv("https://github.com/nychealth/coronavirus-data/raw/master/by-age.csv")
db_sex <- read_csv("https://github.com/nychealth/coronavirus-data/raw/master/by-sex.csv")
db_sum <- read_csv("https://github.com/nychealth/coronavirus-data/raw/master/summary.csv", col_names = F)
db_tests <- read_csv("https://github.com/nychealth/coronavirus-data/raw/master/tests.csv")
db_tested <- read_csv("https://github.com/nychealth/coronavirus-data/raw/master/tests-by-zcta.csv")

tests <- db_tests %>% 
  group_by() %>% 
  summarise(sum(TOTAL_TESTS))

tested <- db_tested %>% 
  group_by() %>% 
  summarise(sum(Total))

date_f <- Sys.Date() - 1
date <- paste(sprintf("%02d", day(date_f)),
              sprintf("%02d", month(date_f)),
              year(date_f), sep = ".")

db_other <- tibble(Sex = "b",
                      Age = "TOT",
                      Measure = c("Probable deaths", "Tests", "Tested"),
                      Value = c(as.numeric(db_sum[4,2]), 
                                as.numeric(tests[1,1]),
                                as.numeric(tested[1,1])))

db_a2 <- db_age %>% 
  mutate(Age = str_sub(AGE_GROUP, 1, 2),
         Age = case_when(Age == "0-" ~ "0",
                         Age == "Ci" ~ "TOT",
                         TRUE ~ Age),
         Sex = "b") %>% 
  rename(Cases = CASE_COUNT,
         Deaths = DEATH_COUNT) %>% 
  select(Sex, Age, Cases, Deaths)
  
db_s2 <- db_sex %>% 
  rename(Sex = SEX_GROUP,
         Cases = CASE_COUNT,
         Deaths = DEATH_COUNT) %>% 
  mutate(Sex = case_when(Sex == "Female" ~ "f",
                         Sex == "Male" ~ "m",
                         TRUE ~ "b"),
         Age = "TOT") %>% 
  select(Sex, Age, Cases, Deaths) %>% 
  filter(Sex != "b")
  
db_all <- bind_rows(db_a2, db_s2) %>% 
  gather(Cases, Deaths, key = Measure, value = Value) %>% 
  bind_rows(db_other) %>%
  mutate(Country = "USA",
         Region = "NYC",
         Code = paste0("US_NYC", date),
         Date = date,
         AgeInt = case_when(Age == "0" ~ "18",
                            Age == "18" ~ "27",
                            Age == "45" ~ "20",
                            Age == "65" ~ "10",
                            Age == "75" ~ "30",
                            TRUE ~ ""),
         Metric = "Count") %>% 
  select(Country, Region, Code, Date, Sex, Age, AgeInt, Metric, Measure, Value) 

############################################
#### uploading database to Google Drive ####
############################################

# This command append new rows at the end of the sheet
sheet_append(db_all,
             ss = "https://docs.google.com/spreadsheets/d/1p1BH48_J3sjyT1zvss9H9YqBQZq3q-7c3FEXbA2qeIk/edit?usp=sharing",
             sheet = "database")

############################################
#### uploading metadata to Google Drive ####
############################################
# setwd("C:/Users/kikep/Dropbox/covid_age/automated_COVerAge-DB/NYC_data")

to_drive <- function(x = db_age, file_type = "_cases&deaths_age.csv"){
 filename <- paste0("USA_NYC", date, file_type)
  write_csv(x, paste0(path_out, "temp_nyc.csv"))
  drive_upload(
    "temp_nyc.csv",
    path = "https://drive.google.com/drive/folders/10BtgHUcPLXOeUrxBfzyEYEIL9TeZ4qzY?usp=sharing",
    name = filename,
    overwrite = T)
}

to_drive(db_age, "_cases&deaths_age.csv")
to_drive(db_sex, "_cases&deaths_sex.csv")
to_drive(db_sum, "_cases&deaths_summary.csv")
to_drive(db_tests, "_tests.csv")
to_drive(db_tested, "_tested.csv")

file.remove("temp_nyc.csv")

print(paste(country, "data saved!", Sys.Date()))