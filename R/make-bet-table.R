make_bet_table <- function() {
  dat_538 <- scrape_538()
  dat_pinnacle <- scrape_pinnacle()
  dat <- dat_pinnacle %>% 
    inner_join(dat_538) %>% 
    mutate(
      kelly = ((odds_dec - 1) * win_chance - (1 - win_chance)) / (odds_dec - 1), 
      edge = odds_dec / (1 / win_chance) - 1, 
      bet = case_when(
        kelly * 40 < 1.40 ~ 0,
        kelly > 0 & edge > 0 ~ kelly * 40, 
        TRUE ~ 0
      )
    )
  
  res <- dat
  
  res
}

