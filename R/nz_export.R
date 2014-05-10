#' nz_export
#' 
#' Export the result of a query to a .txt file in chunks
#' 
#' @param q query to be exported
#' @param fetchSize
#' @param file
#' @param requires a nzcon Java Connection
#' @export
nz_export = function(query, fetchSize = 100000, verbose = TRUE, 
                     file = "export.txt", col_names = TRUE, ...) {
  if(class(nzcon) == "JDBCConnection") {
    send = nz_sendquery(query)
    top = fetch(send, 1)
    write.table(top, file = file, quote = FALSE, append = FALSE, sep = ";",
                dec = ",", row.names = FALSE, col.names = col_names)
    tryCatch({while (1) {
      moredata = fetch(send, fetchSize)
      data.n = nrow(moredata)
      write.table(moredata, file = file, quote = FALSE, append = TRUE, sep = ";",
                  dec = ",", row.names = FALSE, col.names = FALSE)      
      if (verbose) print(sprintf("%s rows fetched", data.n))
      if (data.n < fetchSize) break
    }}, error = function(e) { e })
    dbClearResult(send)
  }
}