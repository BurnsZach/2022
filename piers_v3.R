library(plyr)
library(dplyr, warn.conflicts = F)
library(vroom)
library(stringr)
library(lubridate)
library(tidygeocoder)


colz <- c('Quantity','Quantity Type','TEUs','Arrival Date','Commodity Short Description','Shipper',
          'Consignee','Carrier','Bill of Lading Number','Country of Origin','Port of Arrival')


JAN_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_JAN_2021.csv',col_select = colz)
FEB_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_FEB_2021.csv',col_select = colz)
MAR_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_MAR_2021.csv',col_select = colz)
APR_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_APR_2021.csv',col_select = colz)
MAY_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_MAY_2021.csv',col_select = colz)
JUN_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_JUN_2021.csv',col_select = colz)
JUL_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_JUL_2021.csv',col_select = colz)
AUG_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_AUG_2021.csv',col_select = colz)
SEP_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_SEP_2021.csv',col_select = colz)
OCT_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_OCT_2021.csv',col_select = colz)
NOV_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_NOV_2021.csv',col_select = colz)
DEC_21 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_DEC_2021.csv',col_select = colz)
JAN_22 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_JAN_2022.csv',col_select = colz)
FEB_22 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_FEB_2022.csv',col_select = colz)
MAR_22 <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/Raw/PIERS_IMPORT_MAR_2022.csv',col_select = colz)

q1_21 <- rbind(JAN_21,FEB_21,MAR_21)
q2_21 <- rbind(APR_21,MAY_21,JUN_21)
q3_21 <- rbind(JUL_21,AUG_21,SEP_21)
q4_21 <- rbind(OCT_21,NOV_21,DEC_21)

all_2021 <- rbind(q1_21,q2_21,q3_21,q4_21)

#### 2022

q1_22 <- rbind(JAN_22,FEB_22,MAR_22)

### Full File

working_df <- rbind(q2_21,q3_21,q4_21,q1_22)

geo <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/latz_longz_imp.csv')

final_df <- left_join(working_df,geo,by= "Port of Arrival")
final_df$ones <-c(1)

consignees <- aggregate(cbind(ones,TEUs)~ Consignee,final_df,FUN = sum)

consignees_1 <- consignees %>% filter(ones < 10) %>% filter(TEUs <5)

dudz <- consignees_1$Consignee

final_df <- final_df %>% filter(!Consignee %in% dudz)
  
write.csv(final_df,'/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/final_df_v2.csv')


#attempt to cluster commodities

df <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/PIERS/final_df_v2.csv')
insides <- unique(df$`Commodity Short Description`)

df_inside <- as.data.frame(insides)
library(reticulate)
library(tidyverse)

# use python libs

DIFFLIB <- reticulate::import('difflib')

py_install("polyfuzz")
POLYFUZZ <- reticulate::import('polyfuzz')
