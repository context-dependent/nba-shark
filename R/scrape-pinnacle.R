library(pinnacle.API)
library(RSelenium)

scrape_pinnacle <- function() {
  
  url <- "https://classic.sportsbookreview.com/betting-odds/nba-basketball/money-line/"
  
  req <- httr::GET(url)
  raw <- httr::content(req)
  
  all_nodes <- raw %>% html_nodes(".dateGroup") %>% map(~.x %>% html_nodes(".eventLine.status-scheduled"))
  dates <- all_nodes %>% map_chr(~ .x[1] %>% html_attr("rel") %>% str_sub(1, 10)) %>% as.Date() 
  nodes <- all_nodes[dates == Sys.Date()][[1]]
  
  dat <- 
    tibble(
      date = nodes[1] %>% html_attr("rel") %>% str_sub(1, 10) %>% as.Date(),
      team = nodes %>% map(~ .x %>% html_nodes(".team-name a") %>% html_text()), 
      odds_moneyline = nodes %>% 
        map(~ .x %>% html_nodes(".eventLine-book")) %>% 
        map(~ .x[2]) %>% 
        map(~ .x %>% html_nodes(".eventLine-book-value") %>% html_text() %>% as.numeric()), 
      
    ) %>% 
    unnest(cols = c(team, odds_moneyline)) %>% 
    mutate(
      odds_dec = case_when(
        odds_moneyline > 0 ~ (odds_moneyline + 100) / 100, 
        TRUE ~ 1 + 100 / abs(odds_moneyline) 
      ), 
      team = case_when(
        team %>% str_detect("Clippers") ~ "LAC", 
        team %>% str_detect("Oklahoma") ~ "OKC",
        team %>% str_detect("Orleans") ~ "NOP", 
        TRUE ~ str_sub(team, 1, 3) %>% str_to_upper()
      )
    ) %>% 
    
    select(
      -odds_moneyline
    )
  
  res <- dat
  
  res
  
}
