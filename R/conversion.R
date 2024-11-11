#' Convert R table to SAS
#' 
#' @description
#' Converts R table into a table in the current SAS session. Translation errors 
#' may occur.
#' 
#' @return No return value.
#' 
#' @export
r_to_sas <- function(x, table_name, libref = "WORK") {
  x <- reticulate::r_to_py(x)
  .pkgenv[["session"]]$dataframe2sasdata(x, table_name, libref)

  invisible()
}

#' Convert SAS table to R
#' 
#' @description
#' Converts table from current SAS session into a R `data.frame`. Translation 
#' errors may occur.
#' 
#' @return R `data.frame`.
#' 
#' @export
sas_to_r <- function(table_name, libref = "WORK")  {
  x <- .pkgenv[["session"]]$sasdata2dataframe(table_name, libref)
  reticulate::py_to_r(x)
}
