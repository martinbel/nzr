#' nz_query for small querys
#' 
#' @param query
#' @param nzcon
#' 
#' @export
nz_query2 <- function(nzcon, query=NULL){
  require(stringr)
  res <- dbGetQuery(nzcon, query)
  res <- apply(res, 2, stringr::str_trim)
  res
}