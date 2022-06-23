library(rvest)
library(dplyr)
library(stringr)
library(tidyr)
link = 'https://www.simsmm.com/locations/'
page = read_html(link)

location_links <- page %>% html_nodes('.location a')%>% html_attr("href")

get_info = function(location_link){
  location_page <- read_html(location_link)
  location_address <- location_page %>% html_nodes('.address+ span , .address') %>% html_text() %>% paste(collapse = "  ")
  #description <- location_page %>% html_nodes('#content-additional p') %>% html_text()
  return(location_address)
   }
get_descriptions = function(location_link){
  location_page <- read_html(location_link)
  description <- location_page %>% html_nodes('#content-additional p') %>% paste(collapse =" " )
  return(description)
}

final <- data.frame(sapply(location_links,FUN=get_info,USE.NAMES = F))

final_2 <- sapply(location_links,FUN=get_descriptions,USE.NAMES = F)
final_3 <- data.frame(new_col) 
new_col = c()
for (i in final_2) {
  new_col <- append(new_col,i)
}
final_5 <- data.frame(final,final_3)

colnames(final_5) <- c('Address','Description')

final_5$Address <- trimws(final_5$Address,which = 'both',whitespace = '[\n]')

write.csv(final_5,'/Users/zburns/OneDrive - CBRE, Inc/Documents/Sims Metal/final_output.csv')
