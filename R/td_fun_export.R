#' Applies a function while exporting table from Teradata
#' 
#' Requires a tdConnection object in the Gloval Environment   
#'    
#' @param q query to be exported
#' @param fetchSize Size of chunks to be received in memory
#' @param file .txt file to be exported locally
#' @export
td_fun_export = function(q, fetchSize = 100000, verbose = T, FUN = NULL, 
                     file = "export.txt", col_names = TRUE, ...) {
  require("teradataR")
  if(class(tdConnection) == "JDBCConnection") {
    send = dbSendQuery(tdConnection, q, ...)
    data = list()
    top = fetch(send, 1)
    write.table(top, file = file, quote = FALSE, append = FALSE, sep = ";",
                dec = ",", row.names = FALSE, col.names = col_names)
    tryCatch({while (1) {
      moredata = fetch(send, fetchSize)
      moredata = FUN(moredata)
      data.n = nrow(moredata)
      write.table(moredata, file = file, quote = FALSE, append = TRUE, sep = ";",
                  dec = ",", row.names = FALSE, col.names = FALSE)      
      if (verbose) print(sprintf("%s rows fetched", data.n))
      if (data.n < fetchSize) break
    }}, error = function(e) { e })
    dbClearResult(send)
    return (data)
  }
}