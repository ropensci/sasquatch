#' Convert R table to SAS
#'
#' @description
#' Converts R table into a table in the current SAS session. R tables must only
#' have logical, integer, double, factor, character, POSIXct, or Date class
#' columns.
#'
#' @param x `data.frame`; R table.
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
#' * POSIXct -> numeric (datetime; timezones are lost)
#' * Date -> numeric (date)
#'
#' @return `data.frame`; `x`.
#'
#' @export
#'
#' @seealso [sas_to_r()]
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_from_r(mtcars, "mtcars")
#' }
sas_from_r <- function(x, table_name, libref = "WORK") {
  check_session()
  check_data_frame(x)
  check_has_sas_valid_datatypes(x)
  check_has_sas_valid_colnames(x)
  check_has_rownames(x)
  check_string(table_name)
  check_string(libref)

  x_data <- from_r_data(x)
  x_datetypes <- from_r_datetypes(date_dict)
  date_dict <- do.call(what = reticulate::dict, x_datetypes)

  execute_if_connection_active(
    reticulate::py_capture_output(
      .sas_from_r(x_data, table_name, libref, date_dict)
    )
  )

  invisible(x)
}

.sas_from_r <- function(x, table_name, libref, date_dict) {
  .pkgenv$session$dataframe2sasdata(
    x,
    table_name,
    libref,
    datetimes = date_dict
  )
}

from_r_data <- function(x) {
  numeric_cols <- sapply(x, is.integer) | sapply(x, is.logical)
  x[numeric_cols] <- lapply(x[numeric_cols], as.double)
  factor_cols <- sapply(x, is.factor)
  x[factor_cols] <- lapply(x[factor_cols], as.character)
  date_cols <- sapply(x, \(col) identical(class(col), "Date"))
  posix_cols <- sapply(x, \(col) inherits(col, "POSIXct"))
  x[date_cols | posix_cols] <- lapply(
    x[date_cols | posix_cols],
    \(col) as.POSIXct(format(col), tz = "UTC")
  )

  x
}

from_r_datetypes <- function(x) {
  date_cols <- sapply(x, \(col) identical(class(col), "Date"))

  date_colnames <- colnames(x)[date_cols]
  date_list <- as.list(rep("date", length(date_colnames)))
  names(date_list) <- date_colnames

  date_list
}

check_has_sas_valid_datatypes <- function(x, call = rlang::caller_env()) {
  valid_classes <- c(
    "logical",
    "integer",
    "numeric",
    "factor",
    "character",
    "POSIXct",
    "Date"
  )

  invalid_cols <- sapply(x, function(col) {
    !(class(col)[1] %in% valid_classes)
  })
  invalid_colnames <- colnames(x)[invalid_cols]
  n_invalid <- length(invalid_colnames)

  cli_multiple_problems(
    n_invalid,
    "{.arg x} must only contain {.or {valid_classes}} columns.",
    "{.field {invalid_colnames[%i]}} is {.type {x[[invalid_colnames[%i]]]}} column.",
    items = list(
      x = x,
      invalid_colnames = invalid_colnames,
      valid_classes = valid_classes
    ),
    call = call
  )
}

check_has_sas_valid_colnames <- function(x, call = rlang::caller_env()) {
  invalid_cols <- sapply(colnames(x), function(colname) {
    !(substring(colname, 1, 1) %in% c(LETTERS, letters))
  })
  invalid_colnames <- colnames(x)[invalid_cols]
  n_invalid <- length(invalid_colnames)

  cli_multiple_problems(
    n_invalid,
    "{.arg x} column names must start with a latin letter.",
    "{.field {invalid_colnames[%i]}} starts with {.val {substring(invalid_colnames[%i], 1, 1)}}.",
    items = list(
      x = x,
      invalid_colnames = invalid_colnames
    ),
    call = call
  )

  invalid_cols <- sapply(colnames(x), function(colname) {
    nchar(colname, type = "bytes") > 32
  })
  invalid_colnames <- colnames(x)[invalid_cols]
  n_invalid <- length(invalid_colnames)

  cli_multiple_problems(
    n_invalid,
    "{.arg x} column names must be less than or equal to 32 bytes.",
    "{.field {invalid_colnames[%i]}} is {nchar(invalid_colnames[%i], 'bytes')} bytes long.",
    items = list(
      x = x,
      invalid_colnames = invalid_colnames
    ),
    call = call
  )

  invalid_cols <- sapply(colnames(x), function(colname) {
    !grepl("^[a-zA-Z0-9_]*$", colname)
  })
  invalid_colnames <- colnames(x)[invalid_cols]
  invalid_chars <- sapply(invalid_colnames, function(colname) {
    substring(gsub("[a-zA-Z0-9_]", "", colname), 1, 1)
  })
  n_invalid <- length(invalid_colnames)

  cli_multiple_problems(
    n_invalid,
    "{.arg x} column names must only contain alphanumeric characters or underscores.",
    "{.field {invalid_colnames[%i]}} contains a special character {.val {invalid_chars[%i]}}.",
    items = list(
      x = x,
      invalid_colnames = invalid_colnames,
      invalid_chars = invalid_chars
    ),
    call = call
  )
}

cli_multiple_problems <- function(
  n_invalid,
  rule,
  alert,
  max_alerts = 3,
  items,
  call = rlang::caller_env()
) {
  if (n_invalid == 0) {
    return(invisible())
  }

  for (var_name in names(items)) {
    assign(var_name, items[[var_name]])
  }

  err_msg <- sapply(1:min(max_alerts, n_invalid), function(col_idx) {
    sprintf(alert, col_idx, col_idx)
  })
  names(err_msg) <- rep("x", length(err_msg))
  err_msg <- c(rule, err_msg)
  if (n_invalid > max_alerts) {
    err_msg <- c(
      err_msg,
      "... and {n_invalid - max_alerts} more problem{?s}."
    )
  }

  cli::cli_abort(err_msg, call = call)
}

check_has_rownames <- function(x, call = rlang::caller_env()) {
  if (.row_names_info(x) > 0L && !is.na(.row_names_info(x, type = 0)[1])) {
    cli::cli_warn(
      "{.arg x} rownames will not be transferred as a column.",
      call = call
    )
  }
}
