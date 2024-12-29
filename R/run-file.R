#' Execute SAS file
#' 
#' @description
#' Execute a SAS file and render html output or save output as html and log.
#' 
#' @param input_path Path of SAS file to run.
#' @param output_path Optional path to save html output to (log file will be
#' named the same). 
#' @param overwrite Can output overwrite prior output?
#' 
#' @return If `output_path` specified, `htmlwidget`. Else, no return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' cat("PROC MEANS DATA = sashelp.cars;\n RUN;", file = "test.sas")
#' 
#' sas_connect()
#' sas_run_file("test.sas", "test.html")
#' }
sas_run_file <- function(input_path, output_path, overwrite = FALSE) {
  chk_connection()
  chk::chk_string(input_path)
  chk::chk_file(input_path)
  
  input <- read_file(input_path)
  if (missing(output_path)) {
    return(sas_run_string(input))
  } else {
    chk::chk_string(output_path)
    chk::chk_logical(overwrite)
  }

  output_dir <- dirname(output_path)
  output_file <- basename(output_path)
  output_file_name <- substr(output_file, 0, nchar(output_file) - 5)
  output_file_ext <- substr(output_file, nchar(output_file) - 4, nchar(output_file))

  if (output_file_ext != ".html") {
    chk::err("Output file extension must end in .html")
  }
  results <- .pkgenv$session$submit(input)

  write_file(
    output = paste(results$LST, collapse = "\n"), 
    path = output_path,
    overwrite
  )
  write_file(
    output = paste(results$LOG, collapse = "\n"), 
    path = file.path(output_dir, paste0(output_file_name, ".log")),
    overwrite
  )

  invisible()
}

read_file <- function(path) {
  readChar(path, file.info(path)$size)
}

write_file <- function(output, path, overwrite) {
  if (file.exists(path) && !overwrite) {
    chk::err("Output file already exists. If you would like to overwrite the file, use overwrite = TRUE.")
  }

  cat(output, file = path)
}
