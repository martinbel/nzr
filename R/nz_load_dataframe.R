#' nz load's a data.frame
#' 
#' @description
#' Grabs a data.frame and creates an empty table in Netezza and runs an nzload to insert the data.
#' 
#' @param data a data.frame to be insereted
#' @param append TRUE if the data.frame will be appended to an existing file an then inserted to the same table (not tested)
#' @param maxerrores numeric amount of errors allowed by nz_load
#' @export
nz_load_dataframe <- function(data = NULL, nzload_wd = "C:\\Program Files\\IBM Netezza Tools\\Bin",
                              append = FALSE, col_names = TRUE, maxerrors = 0) {
  if (!exists("nzcon")) 
    stop("Use nzr::nz_connect function to connect to the database")
  if (is.null(data.frame))
    stop("Your data.frame is null")
  
  new_nz_table = as.character(toupper(deparse(substitute(data))))
  print(new_nz_table)
  data <- as.data.frame(data)
  names = names(data)
  
  col_lenght <- as.numeric(apply(data, 2, function(x) max(nchar(x))))
  col_lenght <- ifelse(col_lenght < 255, 255, col_lenght)
  create_tbl = paste0(names, sprintf(" VARCHAR (%s) ", col_lenght), collapse = ", ")
  create_tbl = sprintf("CREATE TABLE %s ( %s ) DISTRIBUTE ON RANDOM;", 
                       new_nz_table, create_tbl)
  
  try(dbSendQuery(nzcon, create_tbl), silent = TRUE)
  print(sprintf("Se creo la tabla %s", new_nz_table))
  
  file_export = paste0(new_nz_table, ".txt", collapse = "")
  write.table(data, file = file_export, quote = FALSE, append = FALSE, 
              sep = ";", dec = ",", row.names = FALSE, col.names = col_names)
  
  file_wd = getwd()
  file_path = paste0(getwd(), "/", file_export)
  file_path = gsub("\\/", '\\\\', file_path)
  
  nzload_wd = "C:\\Program Files\\IBM Netezza Tools\\Bin"
  setwd(nzload_wd)
  cmd_command = sprintf("Nzload.exe -host %s -u %s -pw %s -db %s -t %s -delim ; -skiprows 1 -df %s -maxerrors %s",
                        con_details[["host"]], con_details[["uid"]], con_details[["pwd"]], 
                        con_details[["database"]], new_nz_table, file_path, maxerrors)
  
  shell(shQuote(cmd_command, type = "cmd"))
  setwd(file_wd)
}