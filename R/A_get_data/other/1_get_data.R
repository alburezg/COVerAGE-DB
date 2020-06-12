
library(tabulizer)

# Age-specific data ----

# Get tables from pdfs 
# https://cran.r-project.org/web/packages/tabulizer/vignettes/tabulizer.html

pdfs <- list.files("../../Data/pdf", full.names = T)

tabs <- extract_tables(pdfs)
