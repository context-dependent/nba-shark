pacman::p_load(
  "httr", 
  "rvest", 
  "tidyverse"
)

source("R/scrape-538.R")
source("R/scrape-pinnacle.R")
source("R/make-bet-table.R")

bets <- make_bet_table()

bets %>% 
  filter(bet > 0)