#' Execute SAS file
#' 
#' @description
#' Execute a SAS file and render html output or save output as html and log.
#' 
#' @param input_path string; Path of SAS file to run.
#' @param output_path optional string; Path to save html output to (log file will be
#' named the same). 
#' @param overwrite logical; Can output overwrite prior output?
#' 
#' @return If `output_path` specified, `htmlwidget`. Else, no return value.
#' 
#' @export
#' 
#' @family code execution functions
#' @examples
#' \dontrun{
#' cat("PROC MEANS DATA = sashelp.cars;\n RUN;", file = "test.sas")
#' 
#' sas_connect()
#' sas_run_file("test.sas", "test.html")
#' }
sas_run_file <- function(input_path, output_path, overwrite = FALSE) {
  chk_connection()
  chk::chk_not_missing(input_path)
  chk::chk_string(input_path)
  chk::chk_file(input_path)

  input <- read_file(input_path)
  if (missing(output_path)) {
    return(sas_run_string(input))
  } else {
    chk::chk_string(output_path)
    chk::chk_ext(output_path, "html")
    chk::chk_logical(overwrite)
  }

  output_dir <- dirname(output_path)
  output_file <- basename(output_path)
  output_file_name <- substr(output_file, 0, nchar(output_file) - 5)
  output_log_path <- file.path(output_dir, paste0(output_file_name, ".log"))

  if (!overwrite) {
    chk_no_file(output_path)
    chk_no_file(output_log_path)
  }

  results <- .pkgenv$session$submit(input)

  cat(paste(results$LST, collapse = "\n"), file = output_path)
  cat(paste(results$LOG, collapse = "\n"), file = output_log_path)

  invisible()
}

chk_no_file <- function(x, x_name = NULL) {
  if (vld_no_file(x)) {
    return(invisible(x))
  }
  if (is.null(x_name)) x_name <- chk::deparse_backtick_chk(substitute(x))
  chk::abort_chk(x_name, " already exists. If you would like to overwrite the file, use overwrite = TRUE.")
}
vld_no_file <- function(x) !file.exists(x)

read_file <- function(path) {
  readChar(path, file.info(path)$size)
}
