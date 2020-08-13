library(rvest)
library(tidyverse)

scrape_538 <- function() {
  
  url <- "https://projects.fivethirtyeight.com/2020-nba-predictions/games/"
  
  req <- httr::GET(url)
  
  raw <- httr::content(req)
  
  time_stamp <- raw %>% 
    html_node(".timestamp") %>% 
    html_text() %>% 
    lubridate::mdy_hm()
  
  games_sections <- raw %>% html_nodes(".day")
  
  dat <- 
    
    tibble(
      time_stamp_538 = time_stamp,
      date_raw = games_sections %>% map(html_node, ".h3") %>% map_chr(html_text), 
      date = date_raw %>% str_remove("^.+, ") %>% str_c(" 2020") %>% lubridate::mdy(),
      team = games_sections %>% map(html_nodes, ".tr.team") %>% map(html_attr, "data-team"), 
      win_chance = games_sections %>% map(html_nodes, ".td.number.chance") %>% map(html_text) %>% map(parse_number) %>% map(~ .x / 100)
    ) %>%
    select(
      -date_raw
    ) %>%
    unnest(cols = c(team, win_chance)) 
  
  res <- dat
  
  res
  
  
  
}

