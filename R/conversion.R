#' Convert R table to SAS
#' 
#' @description
#' Converts R table into a table in the current SAS session. R tables must only
#' have logical, integer, double, factor, character, POSIXct, or Date class 
#' columns.
#' 
#' @param x data.frame, tibble, data.table; R table.
#' @param table_name string; Name of table to be created in SAS.
#' @param libref string; Name of libref to store SAS table within.
#' 
#' @details
#' SAS only has two data types (numeric and character). Data types are converted
#' as follows:
#' 
#' * logical -> numeric
#' * integer -> numeric
#' * double -> numeric
#' * factor -> character
#' * character -> character
#' * POSIXct -> numeric (datetime)
#' * Date -> numeric (date)
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
  chk_has_sas_vld_datatypes(x)
  chk_has_rownames(x)
  chk::chk_string(table_name)
  chk::chk_string(libref)
  
  x_copy <- x

  numeric_cols <- sapply(x, is.integer) | sapply(x, is.logical)
  x[numeric_cols] <- lapply(x[numeric_cols], as.double)
  date_cols <- sapply(df_all, \(col) identical(class(col), "Date"))
  x[date_cols] <- lapply(x[date_cols], \(col) as.POSIXct(col))

  # Specify Date columns as date
  date_colnames <- colnames(x)[date_cols]
  date_list <- as.list(rep("date", length(date_colnames)))
  names(date_list) <- date_colnames
  date_dict <- do.call(what = reticulate::dict, date_list)

  x <- reticulate::r_to_py(x)
  execute_if_connection_active(
    reticulate::py_capture_output(
      .pkgenv$session$dataframe2sasdata(x, table_name, libref, datetimes = date_dict)
    )
  )

  invisible(x_copy)
}

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
  x <- reticulate::py_to_r(x)
  x <- as.data.frame(lapply(x, function(col) { 
    col[is.nan(col)] <- NA
    col
  }))

  x
}
