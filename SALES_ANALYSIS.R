library(plyr)
library(dplyr)
library(vroom)
library(lubridate)


columns <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/columns.csv')
main <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/Transaction Tables/mta_details_processed_04.05.2022.csv',col_select = columns$cols)

main$Deal_Year <- year(main$lease_exec_dt)
main$Deal_Month <- month(main$lease_exec_dt)


df <- main %>% filter(property_type == 'Industrial') %>% filter(Deal_Year %in% c('2019','2020','2021')) %>% filter(deal_type == 'SALE') %>% distinct(deal_id,.keep_all = T)

write.csv(df,'/Users/zburns/OneDrive - CBRE, Inc/Documents/Ad Hoc/John Morris/A&T Sales/a&t_sales.csv')

df$tranche <- Create_Tranchs(df$tot_cons)
df$tranche <- as.character(df$tranche)

Create_Tranchs <- function(column_to_be_tranched){
  new_column <- list()
  for (x in column_to_be_tranched){
    if(x < 25000001){
      y <- " < 25M"}
    else if(x > 25000000 && x < 50000001){
      y <- "25M < 50M"}
    else if(x > 50000000 && x < 75000001){
      y <- "50M < 75M"}
    else if(x > 75000000 && x < 100000001){
      y <- "75M < 100M"}
    else if(x > 100000000 && x < 150000001){
      y <- "100M < 150M"}
    else{y <- ">150M"}
    new_column <- append(new_column,y)
  }
  return(new_column)
}


brkrs <- vroom('/Users/zburns/OneDrive - CBRE, Inc/Documents/Ad Hoc/John Morris/A&T Sales/deals_for_checkin.csv',delim = ',')

dff <- main %>% filter(property_type == 'Industrial') %>% filter(Deal_Year %in% c('2019','2020','2021')) %>% filter(deal_type == 'SALE') %>% filter(deal_id %in% brkrs$deal_id)

dff$tranche <- Create_Tranchs(dff$tot_cons)
dff$tranche <- as.character(dff$tranche)

write.csv(dff,'/Users/zburns/OneDrive - CBRE, Inc/Documents/Ad Hoc/John Morris/A&T Sales/a&t_sales_brkr_level.csv')







