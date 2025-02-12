#' Convert SAS table to R
#' 
#' @description
#' Converts table from current SAS session into a R `data.frame`.
#' 
#' @param table_name string; Name of table in SAS.
#' @param libref string; Name of libref SAS table is stored within. 
#' 
#' @details
#' SAS only has two data types (numeric and character). Data types are converted
#' as follows:
#' 
#' * numeric -> double
#' * character -> character
#' * numeric (datetime) -> POSIXct
#' * numeric (date) -> POSIXct
#' 
#' In the conversion process dates and datetimes are converted to local
#' time. If utilizing another timezone, use `as.POSIXct()` or 
#' `lubridate::with_tz()` to convert back to the desired time zone.
#' 
#' @return `data.frame` of the specified SAS table.
#' 
#' @export
#' 
#' @seealso [sas_from_r()]
#' @examples
#' \dontrun{
#' sas_connect()
#' cars <- sas_to_r("cars", "sashelp")
#' }
sas_to_r <- function(table_name, libref = "WORK")  {
  chk_session()
  chk::chk_not_missing(table_name, "`table_name`")
  chk::chk_string(table_name)
  chk::chk_string(libref)
  
  execute_if_connection_active(
    x <- .pkgenv$session$sasdata2dataframe(table_name, libref)
  )
  x <- reticulate::py_to_r(x)
  x <- as.data.frame(lapply(x, function(col) { 
    col[is.nan(col)] <- NA
    col
  }))

  x
}
