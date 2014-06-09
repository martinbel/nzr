#' Uploads a file to an existing table in netezza
#' 
#' @param file_path
#' Complete file path including the files name
#' @param table_name
#' Destination table name
#' @param
#' Directory where nzload.exe is
#' @export
nz_load_file2 <- function(file_path, table_name, nzload_wd = "C:\\Program Files\\IBM Netezza Tools\\Bin",
                         append = FALSE, col_names = TRUE, maxerrors = 0){
  
  file_path <- gsub("\\\\", "\\\\", file_path)
  
  if (!exists("nzcon")) 
    stop("Use nzr::nz_connect function to connect to the database")
  
  nzload_wd = "C:\\Program Files\\IBM Netezza Tools\\Bin"
  setwd(nzload_wd)
  cmd_command = sprintf('nzload.exe -host %s -u %s -pw %s -db %s -t %s -delim ; -df %s -maxerrors %s', 
                        con_details[["host"]], con_details[["uid"]], con_details[["pwd"]], 
                        con_details[["database"]], table_name, file_path, maxerrors)
  shell(shQuote(cmd_command, type = "cmd"))
}