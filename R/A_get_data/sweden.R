############################
# When using it daily
############################
date_f <- Sys.Date() - 1
date <- paste(sprintf("%02d", day(date_f)),
              sprintf("%02d", month(date_f)),
              year(date_f), sep = ".")

url <- "https://www.arcgis.com/sharing/rest/content/items/b5e7488e117749c19881cce45db13f7e/data"

##################################
# in case of using Wayback Machine
##################################
# date <- "09.06.2020"
# url <- "https://web.archive.org/web/20200609193415/https://www.arcgis.com/sharing/rest/content/items/b5e7488e117749c19881cce45db13f7e/data"

httr::GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))
tf

db_sex <- read_xlsx(tf)

db_sex <- read_xlsx(tf, sheet = "Totalt antal per kön")
db_age <- read_xlsx(tf, sheet = "Totalt antal per åldersgrupp")

db_s2 <- db_sex %>% 
  rename(Sex = starts_with("K"),
  # rename(Sex = Kön,
         Cases = Totalt_antal_fall,
         Deaths = Totalt_antal_avlidna) %>% 
  mutate(Sex = case_when(Sex == "Man" ~ "m",
                         Sex == "Kvinna" ~ "f",
                         Sex == "Uppgift saknas" ~ "UNK"),
         Age = "TOT") %>% 
  select(Sex, Age, Cases, Deaths)

db_a2 <- db_age %>% 
  rename(Cases = Totalt_antal_fall,
         Deaths = Totalt_antal_avlidna
         , Age = ends_with("ldersgrupp")
         ) %>% 
  # mutate(Age = str_sub(Åldersgrupp, 7, 8),
  mutate(Age = str_sub(Age, 7, 8),
         Age = case_when(Age == "0_" ~ "0",
                         Age == "t " ~ "UNK",
                         TRUE ~ Age),
         Sex = "b") %>% 
  select(Sex, Age, Cases, Deaths)
  
db_all <- bind_rows(db_s2, db_a2) %>% 
  gather(Cases, Deaths, key = Measure, value = Value) %>% 
  mutate(Country = "Sweden",
         Region = "All",
         Code = paste0("SE", date),
         Date = date,
         AgeInt = case_when(Age == "TOT" | Age == "UNK" ~ "",
                            TRUE ~ "10"),
         Metric = "Count") %>% 
  select(Country, Region, Code, Date, Sex, Age, AgeInt, Metric, Measure, Value) 

############################################
#### uploading database to Google Drive ####
############################################
# This command append new rows at the end of the sheet
sheet_append(db_all,
             ss = "https://docs.google.com/spreadsheets/d/1w-ynPuKT_5xZf7emTuUFp_n-PdStCyrylY6gZVQj_do/edit#gid=1079196673",
             sheet = "database")

############################################
#### uploading metadata to Google Drive ####
############################################
filename <- paste0("SE", date, "cases&deaths.xlsx")
drive_upload(
  tf,
  path = "https://drive.google.com/drive/folders/1194c1EJL1PEYJr8VBpbcoWJ5Bq7LZ-Va?usp=sharing",
  name = filename,
  overwrite = T)

