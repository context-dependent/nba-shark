pacman::p_load(
  "httr", 
  "rvest", 
  "tidyverse", 
  "googlesheets4"
)

source("R/scrape-538.R")
source("R/scrape-pinnacle.R")
source("R/make-bet-table.R")
source("R/upload-to-sheet.R")

bets <- make_bet_table()
upload_to_sheet(bets)
