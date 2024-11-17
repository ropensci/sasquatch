#' Convert R table to SAS
#' 
#' @description
#' Converts R table into a table in the current SAS session. Translation errors 
#' may occur.
#' 
#' @param x R table
#' @param table_name Name of table to be created in SAS.
#' @param libref Name of libref to store SAS table within. 
#' 
#' @return No return value.
#' 
#' @export
r_to_sas <- function(x, table_name, libref = "WORK") {
  check_connection()

  x <- reticulate::r_to_py(x)
  .pkgenv$session$dataframe2sasdata(x, table_name, libref)

  invisible()
}

#' Convert SAS table to R
#' 
#' @description
#' Converts table from current SAS session into a R `data.frame`. Translation 
#' errors may occur.
#' 
#' @param table_name Name of table in SAS.
#' @param libref Name of libref SAS table is stored within. 
#' 
#' @return R `data.frame`.
#' 
#' @export
sas_to_r <- function(table_name, libref = "WORK")  {
  check_connection()
  
  x <- .pkgenv$session$sasdata2dataframe(table_name, libref)
  reticulate::py_to_r(x)
}
