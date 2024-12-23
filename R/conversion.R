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
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' r_to_sas(mtcars, "mtcars")
#' }
r_to_sas <- function(x, table_name, libref = "WORK") {
  chk::chk_data(x)
  chk_has_rownames(x)
  chk::chk_string(table_name)
  chk::chk_string(libref)
  
  x <- reticulate::r_to_py(x)
  execute_if_connection_active(
    reticulate::py_capture_output(
      .pkgenv$session$dataframe2sasdata(x, table_name, libref)
    )
  )

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
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' cars <- sas_to_r("cars", "sashelp")
#' }
sas_to_r <- function(table_name, libref = "WORK")  {
  chk_connection()
  chk::chk_string(table_name)
  chk::chk_string(libref)
  

  execute_if_connection_active(
    x <- .pkgenv$session$sasdata2dataframe(table_name, libref)
  )
  reticulate::py_to_r(x)
}
