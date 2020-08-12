upload_to_sheet <- function(dat) {
  ss <- gs4_get("1Myb7ee3nCVDxpIbJsRS3_8P2zRv2I9yrv_SRJT-oZpg")
  
  write_sheet(dat, ss, as.character(Sys.time()))
}
