#--> Libraries 
library(tidyverse)

#--> Load data
load("NSDUH_2016.RData")
DATA <- PUF2016_022818
rm(PUF2016_022818)

#--> Rename variables and pick out the ones we're interested in
DATA2 <- DATA %>%
  transmute(alcohol_days = iralcfy, marijuana_days = irmjfy, 
            cocaine_days = ircocfy, hallucinogen_days = irhallucyfq,
            income_level = IRPINC3, geography =  COUTYP4, suicidal = mhsuithk) 

#--> Knock out the NAs
DATA3 <- filter(DATA2, rowSums(is.na(DATA2)) < 1)

#--> Convert values to something that can be used in ML model
DATA4 <- DATA3 %>%
  mutate(alcohol_days = ifelse(alcohol_days > 365, 0, alcohol_days),
         marijuana_days = ifelse(marijuana_days > 365, 0, marijuana_days),
         cocaine_days = ifelse(cocaine_days > 365, 0, cocaine_days),
         hallucinogen_days = ifelse(hallucinogen_days > 365, 0, hallucinogen_days))

save(DATA4, file = "NSDUH_2016_v2.RData")