library(taskscheduleR)

path <- getwd()

# 20200612
# Rules for data retrieval 

# Since all need to be run after 13.00 GMT, just run everything everyday at 13.00

taskscheduler_create(
  taskname = "sweden_daily"
  , rscript = paste0(path, "/sweden_task.R")
  , schedule = "DAILY"
  , starttime = "15:00"
  , startdate = "30/06/2020"
)

taskscheduler_create(
  taskname = "nyc_daily"
  , rscript = paste0(path, "/nyc_task.R")
  , schedule = "DAILY"
  , starttime = "15:00"
  , startdate = "30/06/2020"
)

taskscheduler_create(
  taskname = "estonia_weekly"
  , rscript = paste0(path, "/estonia_task.R")
  , schedule = "WEEKLY"
  , starttime = "15:00"
  , startdate = "03/07/2020"
)

# Delete tasks ------------

# taskscheduler_delete("sweden_daily")
# taskscheduler_delete("nyc_daily")
# taskscheduler_delete("estonia_weekly")
