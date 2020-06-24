Script to automate data collecation for COVerAGE-DB

# To do

- Get totals by sex retrospectively for Sweden
- Fix age intervals
- Duplicated entry: June 11

Run script R\A_get_data\00_retrieve_data.R from Hydra ad infinitum. 
It tries to update the files every 12 hours and it the conditions are not right, it goes to sleep and reactivates in anoter 12 hours.

# Instructions

NY toca correrlo diario, es un GitHub que actualizan cada dia a la 1pm de NYC (7 de acá).  
Estonia, como es la base total, con una vez que lo corras a la semana es suficiente. 

## Sweden
https://www.folkhalsomyndigheten.se/smittskydd-beredskap/utbrott/aktuella-utbrott/covid-19/bekraftade-fall-i-sverige

You just have to run it and it will download the file, transform it to the template formate, update the database in Drive, and even better, upload the metadata with the proper name to the metadata folder in drive. 
So it is literally only to run the code once per day. 
There is even an option for Wayback Machine that is not automated so far, but you can copy/paste the link of the file from there, add manually that date, and run it. I already did it for the dates since May 30. I imagine you downloaded the files, but it was faster this way, I think.

https://docs.google.com/spreadsheets/d/1w-ynPuKT_5xZf7emTuUFp_n-PdStCyrylY6gZVQj_do/edit?ts=5e8c5051#gid=1079196673

## Estonia

Estonia has the advantage that it does not need daily runs of the script because they have a full database with a single test by line, so it has information about tests and cases by age and sex, but no deaths. 
The database has to be uploaded to the metadata manually because it is a bit heavy for R to handle, much easier just to drag it to the Drive folder.

https://opendata.digilugu.ee/opendata_covid19_test_results.csv
https://docs.google.com/spreadsheets/d/1Jp2ffKZBYzraR5qb0eDcaz9jx-90vRwZqZBHn8tp-ak/edit?usp=sharing

## NYC

- New York works as Sweden, just a run by day.

https://github.com/nychealth/coronavirus-data/raw/master/by-age.csv
https://github.com/nychealth/coronavirus-data/raw/master/by-sex.csv
https://github.com/nychealth/coronavirus-data/raw/master/summary.csv
https://github.com/nychealth/coronavirus-data/raw/master/tests.csv
https://github.com/nychealth/coronavirus-data/raw/master/tests-by-zcta.csv

https://docs.google.com/spreadsheets/d/1p1BH48_J3sjyT1zvss9H9YqBQZq3q-7c3FEXbA2qeIk/edit?usp=sharing

# Metadata

We'd like to remind you to start completing the metadata tab to the best of your ability if you haven't already. 
This aspect of the database is crucial, and it's the main bottleneck right now for 1) launching the database, and 2) completing the database manuscript. Here's the template   which includes two worked examples:

https://docs.google.com/spreadsheets/d/15HktFkvdmxZ36nHzAfFqAa63rPWnbyP2BFjVsMNBVZs/edit?usp=sharing

Instructions are here https://docs.google.com/document/d/1YmMMcyv1Y9n9CfRDdbhnwyOw2zIuabf1K0wsv6G1ESQ/edit?usp=sharing and you should please bring to our attention if something could be clearer, or if the template needs extra fields or similar. 
Also, remember to upload source files.
