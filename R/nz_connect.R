#' nz_connect
#' 
#' Connects to netezza using RODBC or RJDBC.
#' 
#' @param dsn
#' @param uid
#' @param pwd
#' @param database
#' @param JDBC driver path (nzjdbc.jar path)
#' @param dtype type of Driver (JDBC is recommended)
#' @export
nz_connect <- function(dsn = "100.0.0.1:666", uid = "", pwd = "", database = "", 
                      classPath = "C://JDBC//DIRECTORY", dType = "jdbc"){
    if(dType == "odbc"){
      require(RODBC)
      st <- paste("DSN=", dsn, sep = "")
      if (nchar(uid))
        st <- paste(st, ";UID=", uid, sep = "")
      if (nchar(pwd))
        st <- paste(st, ";PWD=", pwd, sep = "")
      if (nchar(database))
        st <- paste(st, ";Database=", database, sep = "")
      nzcon <- odbcDriverConnect(st)
      assign("nzcon", nzcon, envir=.GlobalEnv)
    }
    
    if(dType == "jdbc"){
      require(RJDBC)
      drv <- JDBC(driverClass="org.netezza.Driver", classPath = classPath, "'") 
      st <- paste("jdbc:netezza://", dsn, "//",sep = "")
      if (nchar(database))
        st <- paste(st, database, "//", sep = "")
      nzcon <- dbConnect(drv, st, user=uid, password=pwd)
      assign("nzcon", nzcon, envir=.GlobalEnv)
    }
    host <- gsub(":.*", "", dsn)
    con_details <- list(dsn = dsn, host = host, uid = uid, pwd = pwd, database = database)
    assign("con_details", con_details, envir = .GlobalEnv)
}