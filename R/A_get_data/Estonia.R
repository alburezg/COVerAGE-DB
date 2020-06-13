# rm(list=ls())

country <- "estonia"
path_out <- paste0("../../Data/",country,"/")

db <- read_csv("https://opendata.digilugu.ee/opendata_covid19_test_results.csv")

db2 <- db %>% 
  rename(Sex = Gender) %>% 
  separate(AgeGroup, c("Age","age2"), "-") %>% 
  mutate(Test = 1,
         Case = ifelse(ResultValue == "P", 1, 0),
         date = as.Date(ResultTime),
         Sex = case_when(Sex == 'N' ~ 'f',
                         Sex == 'M' ~ 'm',
                         TRUE ~ 'UNK'),
         Age = ifelse(Age == "üle 85", "85", Age),
         Age = replace_na(Age, "UNK")) %>% 
  group_by(date, Age, Sex) %>% 
  summarise(Cases = sum(Case),
            Tests = sum(Test)) %>% 
  ungroup() %>% 
  gather('Cases', 'Tests', key = 'Measure', value = 'Value')

unique(db2$Sex)
unique(db2$date)
unique(db2$Age)

empty_db <- expand_grid(Sex = c("b", "f", "m"), 
                        Measure = c("Cases", "Tests"), 
                        Age = c(unique(db2$Age), "TOT")) %>% 
  filter(Age != "UNK")

db_all <- NULL

min(db2$date)
max(db2$date)

date_start <- dmy("01/03/2020")
date_end <- max(db2$date)

ref <- date_start

while (ref <= date_end){

  print(ref)  
  db3 <- db2 %>% 
    filter(date <= ref) %>% 
    group_by(Age, Sex, Measure) %>% 
    summarise(Value = sum(Value)) 
  
  db4 <- db3 %>% 
    group_by(Measure, Age) %>% 
    summarise(Value = sum(Value)) %>% 
    mutate(Sex = "b")
  
  db5 <- bind_rows(db3, db4) %>% 
    group_by(Measure, Sex) %>% 
    summarise(Value = sum(Value))%>% 
    mutate(Age = "TOT")
  
  db6 <- bind_rows(db3, db4, db5)
  
  db7 <- empty_db %>% 
    left_join(db6) %>%
    mutate(date_f = ref,
           Value = replace_na(Value, 0))
  
  db_all <- bind_rows(db_all, db7)
  
  ref = ref + 1
}  

db_estonia <- db_all %>%
  mutate(Region = "All",
         Date = paste(sprintf("%02d", day(date_f)),
                      sprintf("%02d", month(date_f)),
                      year(date_f), sep = "."),
         Country = "Estonia",
         Code = paste0("EE_", Date),
         AgeInt = case_when(Age == "TOT" | Age == "UNK" ~ NA_character_, 
                            Age == "85" ~ "20",
                            TRUE ~ "5"),
         Metric = "Count") %>% 
  arrange(date_f, Sex, Measure, suppressWarnings(as.integer(Age))) %>% 
  select(Country, Region, Code, Date, Sex, Age, AgeInt, Metric, Measure, Value)

############################################
#### uploading database to Google Drive ####
############################################

# This command replace the whole sheet
write_sheet(db_estonia, 
            ss = "https://docs.google.com/spreadsheets/d/1Jp2ffKZBYzraR5qb0eDcaz9jx-90vRwZqZBHn8tp-ak/edit#gid=1548224005",
            sheet = "database")

########################################################
#### saving metadata in the PC, too large to upload ####
########################################################

date <- Sys.Date()

file_name <- paste0(path_out, "EE", sprintf("%02d", day(date)), ".", sprintf("%02d", month(date)), ".", year(date), "_cases&tests.csv")
write_csv(db, file_name)

print(paste(country, "data saved!", Sys.Date()))
