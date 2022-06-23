library(rvest)
library(stringr)


link = 'https://performancefoodservice.com/Our-Locations'
link2 = ''

page1 <- read_html(link) 
address<- page1 %>% html_nodes("address") %>% html_text()
out <- data.frame(address)
View(out)

write.csv(out,'wherefoodlives.csv')
out$address <- trimws(out$address,which = c("both"))

