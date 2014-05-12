#' Utilities for nzr package
#' 
#' Loads packages
load_pkgs <- function() {
  options(scipen=666) 
  require("RJDBC")
  require("RODBC")
  require("teradataR")
  require("data.table")
  require("ggplot2")
}

invisible(load_pkgs())
