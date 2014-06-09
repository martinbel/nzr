#' Export files as .txt 
#'
#'
#' @description 
#' Utility function to export files as would be nz_loaded. Simple wraper function to write.table.
#' 
#' @param data
#' A data.frame, matrix or whatever writable to a txt file
#' @param file_name
#' 
#' @export
write_file <- function(data, file_name = "data.txt", col_names = TRUE){
  write.table(data, file = file_name, quote = FALSE, append = FALSE, 
              sep = ";", dec = ",", row.names = FALSE, col.names = col_names)
}