#' Uploads a file to an existing table in netezza
#' 
#' @param file_path
#' Complete file path including the files name
#' @param table_name
#' Destination table name
#' @param
#' Directory where nzload.exe is
#' @export
nz_load_file <- function(file_path, table_name, nzload_wd = "C:\\Program Files\\IBM Netezza Tools\\Bin",
                         append = FALSE, col_names = TRUE, maxerrors = 0, exists = TRUE){
  wd_original <- getwd()
  file_path <- gsub("\\\\", "\\\\", file_path)
  
  if (!exists("nzcon")) 
    stop("Use nzr::nz_connect function to connect to the database")
  
  if(exists == FALSE){
    names <- names(read.table(file_path, nrows = 5, sep = ";"))
    
    create_tbl = paste0(names, " VARCHAR (255) ", collapse = ", ")
    create_tbl = sprintf("CREATE TABLE %s ( %s ) DISTRIBUTE ON RANDOM;", table_name, create_tbl)
    try(dbSendQuery(nzcon, create_tbl), silent = TRUE)
  }
  
  nzload_wd = "C:\\Program Files\\IBM Netezza Tools\\Bin"
  setwd(nzload_wd)
  cmd_command = sprintf("nzload.exe -host %s -u %s -pw %s -db %s -t %s -delim ; -skiprows 1 -df %s -maxerrors %s", 
                        con_details[["host"]], con_details[["uid"]], con_details[["pwd"]], 
                        con_details[["database"]], table_name, file_path, maxerrors)
  shell(shQuote(cmd_command, type = "cmd"))
  setwd(wd_original)
}