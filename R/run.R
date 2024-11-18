#' Execute SAS code
#' 
#' @description
#' Execute SAS code in current session and render html output.
#' 
#' @param input String of SAS code input to run.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_run_string("PROC MEANS DATA = sashelp.cars;\n RUN;")
#' }
sas_run_string <- function(input) {
  check_connection()

  results <- .pkgenv$session$submit(input)

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"), 
    paste(results$LOG, collapse = "\n")
  )
}

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
#' @return No return value.
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
  check_connection()

  input <- read_file(input_path)

  if (missing(output_path)) {
    return(sas_run_string(input))
  }

  output_path <- strsplit(output_path, "\\.(?=[^\\.]+$)", perl = TRUE)[[1]]

  if (length(output_path) != 2 || tolower(output_path[2]) != "html") {
    print(output_path)
    stop("Output file extension must end in .html")
  }
  results <- .pkgenv$session$submit(input)

  write_file(
    output = paste(results$LST, collapse = "\n"), 
    path = paste0(output_path[1], ".html"),
    overwrite
  )
  write_file(
    output = paste(results$LOG, collapse = "\n"), 
    path = paste0(output_path[1], ".log"),
    overwrite
  )
}