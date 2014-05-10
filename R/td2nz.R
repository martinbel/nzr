#' Exports a table from teradata into Netezza
#' 
#' @param td_query Teradata Query
#' @param new_nz_table DATABASE.USER.TABLENAME
#' @param data_type All collums datatype, defaults to VARCHAR(255)
#' @param requires a netezza and teradata JDBC connection
#' @export
td2nz <- function(td_query = NULL, new_nz_table = "td2nz"){
  require("teradataR")
  
  if(!exists("tdConnection")) 
    stop("Use teradataR::tdConnect function to connect to the database")
  
  if(!exists("nzcon")) 
    stop("Use nzr::nz_connect function to connect to the database")
  
  # Create empty table in netezza
  top <- tdBigQuery(q=paste(td_query, " sample 1 "))
  names = names(top)
  create_tbl = paste0(names, " VARCHAR (255) ", collapse = ", ")
  create_tbl = sprintf("CREATE TABLE %s ( %s ) DISTRIBUTE ON RANDOM;", new_nz_table, create_tbl)

  try(dbSendQuery(nzcon, create_tbl), silent = TRUE)
  sprintf("Se creo la tabla %s", new_nz_table)
    
  # Export file to working directory for nzload
  file_export = paste0(new_nz_table, ".txt", collapse = "")
  td_export(td_query, file = file_export, col_names = TRUE)
  
  file_path = paste0(getwd(), file_export)
}