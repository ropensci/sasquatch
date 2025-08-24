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
#' @param factors_as_strings logical; If `TRUE`, factors will become SAS strings.
#' Else, factors will become formatted numerics.
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
sas_from_r <- function(
  x,
  table_name,
  libref = "WORK",
  factors_as_strings = TRUE
) {
  check_session()
  check_data_frame(x)
  check_has_sas_valid_datatypes(x)
  check_has_sas_valid_colnames(x)
  check_has_rownames(x)
  check_string(table_name)
  check_string(libref)
  check_logical(factors_as_strings)

  x_data <- from_r_data(x, factors_as_strings)
  date_dict <- from_r_datedict(x)
  factor_dict <- reticulate::dict()
  if (!factors_as_strings) {
    factor_dict <- from_r_factordict(x, libref)
  }

  execute_if_connection_active(
    reticulate::py_capture_output(
      .sas_from_r(x_data, table_name, libref, date_dict, factor_dict)
    )
  )

  invisible(x)
}

.sas_from_r <- function(x, table_name, libref, date_dict, factor_dict) {
  .pkgenv$session$dataframe2sasdata(
    x,
    table_name,
    libref,
    datetimes = date_dict,
    outfmts = factor_dict
  )
}

from_r_data <- function(x, factors_as_strings) {
  numeric_cols <- vapply(x, is.integer, FUN.VALUE = logical(1)) |
    vapply(x, is.logical, FUN.VALUE = logical(1))
  x[numeric_cols] <- lapply(x[numeric_cols], as.double)
  factor_cols <- vapply(x, is.factor, FUN.VALUE = logical(1))
  if (factors_as_strings) {
    x[factor_cols] <- lapply(x[factor_cols], as.character)
  } else {
    x[factor_cols] <- lapply(x[factor_cols], as.numeric)
  }
  date_cols <- vapply(
    x,
    \(col) identical(class(col), "Date"),
    FUN.VALUE = logical(1)
  )
  posix_cols <- vapply(
    x,
    \(col) inherits(col, "POSIXct"),
    FUN.VALUE = logical(1)
  )
  x[date_cols | posix_cols] <- lapply(
    x[date_cols | posix_cols],
    \(col) as.POSIXct(format(col), tz = "UTC")
  )

  x
}

from_r_datedict <- function(x) {
  date_cols <- vapply(
    x,
    \(col) identical(class(col), "Date"),
    FUN.VALUE = logical(1)
  )

  date_colnames <- colnames(x)[date_cols]
  date_list <- as.list(rep("date", length(date_colnames)))
  names(date_list) <- date_colnames

  do.call(reticulate::dict, date_list)
}

from_r_factordict <- function(x, libref) {
  is_factor_col <- vapply(x, is.factor, logical(1))
  factor_col_names <- names(x)[is_factor_col]

  format_dataframe <- lapply(
    factor_col_names,
    function(col_name) {
      generate_format_string(x, col_name, libref)
    }
  ) |>
    do.call(what = rbind.data.frame)

  format_statements <- paste0(format_dataframe$statement, collapse = "\n\n")

  execute_if_connection_active(
    reticulate::py_capture_output(
      .sas_run_string(format_statements)
    )
  )

  reticulate::py_dict(
    factor_col_names,
    paste0(format_dataframe$name, ".")
  )
}

generate_format_string <- function(x, colname, libref) {
  col <- x[[colname]]

  proc_statement <- paste0("proc format library = ", libref, ";")

  rand_string <- intToUtf8(sample(c(65:90, 97:122), 6))
  format_name <- paste0(colname, "_", rand_string)
  values_start <- paste0("value ", format_name)

  col_levels <- levels(col)
  format_values <- vapply(
    seq_along(col_levels),
    function(i) {
      paste(i, "=", shQuote(col_levels[i], "cmd"))
    },
    character(1)
  )

  list(
    name = format_name,
    statement = paste(
      proc_statement,
      values_start,
      paste(format_values, collapse = "\n"),
      ";",
      "run;",
      sep = "\n"
    )
  )
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

  invalid_cols <- vapply(
    x,
    function(col) {
      !(class(col)[1] %in% valid_classes)
    },
    FUN.VALUE = logical(1)
  )
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
  invalid_cols <- vapply(
    colnames(x),
    function(colname) {
      !(substring(colname, 1, 1) %in% c(LETTERS, letters))
    },
    FUN.VALUE = logical(1)
  )
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

  invalid_cols <- vapply(
    colnames(x),
    function(colname) {
      nchar(colname, type = "bytes") > 32
    },
    FUN.VALUE = logical(1)
  )
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

  invalid_cols <- vapply(
    colnames(x),
    function(colname) {
      !grepl("^[a-zA-Z0-9_]*$", colname)
    },
    FUN.VALUE = logical(1)
  )
  invalid_colnames <- colnames(x)[invalid_cols]
  invalid_chars <- vapply(
    invalid_colnames,
    function(colname) {
      substring(gsub("[a-zA-Z0-9_]", "", colname), 1, 1)
    },
    FUN.VALUE = character(1)
  )
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

  err_msg <- vapply(
    1:min(max_alerts, n_invalid),
    function(col_idx) {
      sprintf(alert, col_idx, col_idx)
    },
    FUN.VALUE = character(1)
  )
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
