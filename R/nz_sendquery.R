#' nz_sendquery
#' 
#' Sends a query to the database and but doesn't get the result.
#' Solves the "white space issues" RJDBC has by adding a trim() call to each field.
#' 
#' @param q query to be exported
#' @param fetchSize
#' @param file
#' @param requires a nzcon Java Connection
#' @export
nz_sendquery <- function(query=NULL){
  if(!exists("nzcon")) 
    stop("Use nzconnect function to connect to the database")
  query_names = gsub("limit.*|LIMIT.*", "", query)
  top = dbGetQuery(nzcon, paste(query_names, "limit 1;", sep= " "))
  names = names(top)
  
  field_names = paste0("trim(",names,") as ", names, collapse = ", ")
  rest_query = regmatches(query, regexpr("[FfRrOoMm].*", query))
  rest_query = gsub(";", "", rest_query)
  final_query = paste0("select ",field_names, " ",rest_query,";")
  
  dbSendQuery(nzcon, final_query)
}