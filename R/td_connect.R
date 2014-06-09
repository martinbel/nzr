#' Connect to teradata
#' 
#' 
#' @description
#' Connects to teradata using JDBC and leaves an object (td_con_details)
#' with connection details of the user. 
#' The idea is to use this as input for other functions to avoid tiping user credentials when posible.
#'
#' @param dsn
#' @param uid: user id
#' @param pwd: password
#' @param Default database
#' @param dtype: Connection type, JDBC or ODBC. 
#' JDBC is recommended
#' @param Class paths for JDBC .jar driver files
#'
#' @export
td_connect <- function (dsn, uid = "", pwd = "", database = "", dType = "odbc",
                        class_path1 = "D://Dropbox//TERADATA_JDBC//tdgssconfig.jar",
                        class_path2 = "D://Dropbox//TERADATA_JDBC//terajdbc4.jar"){
  .jinit()
  .jaddClassPath(class_path1)
  .jaddClassPath(class_path2)
  if (dType == "odbc") {
    require(RODBC)
    st <- paste("DSN=", dsn, sep = "")
    if (nchar(uid)) 
      st <- paste(st, ";UID=", uid, sep = "")
    if (nchar(pwd)) 
      st <- paste(st, ";PWD=", pwd, sep = "")
    if (nchar(database)) 
      st <- paste(st, ";Database=", database, sep = "")
    tdConnection <- odbcDriverConnect(st)
    assign("tdcon", tdConnection, envir = .GlobalEnv)
    td_con_details <- list(dsn = dsn, host = host, uid = uid, pwd = pwd, 
                           database = database)
    assign("td_con_details", td_con_details, envir = .GlobalEnv)
  }
  if (dType == "jdbc") {
    require(RJDBC)
    drv <- JDBC("com.teradata.jdbc.TeraDriver")
    st <- paste("jdbc:teradata://", dsn, sep = "")
    if (nchar(database)) 
      st <- paste(st, "/database=", database, sep = "")
    tdConnection <- dbConnect(drv, st, user = uid, password = pwd)
    assign("tdcon", tdConnection, envir = .GlobalEnv)
    td_con_details <- list(dsn = dsn, uid = uid, pwd = pwd, database = database)
    assign("td_con_details", td_con_details, envir = .GlobalEnv)
  }
}