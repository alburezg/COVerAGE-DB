
# 20200612
# Rules for data retrieval 


# Sweden --------------
# Retrieve every day at 13.00 GMT

# Estonia -------------



if(sweden){
  print(paste0("Starting data retrieval for Sweden..."))
  source("sweden.R")  
}

if(estonia){
  print(paste0("Starting data retrieval for Estonia..."))
  source("estonia.R")  
}

if(nyc){
  print(paste0("Starting data retrieval for NYC..."))
  source("nyc.R")
}


print(paste0(""))