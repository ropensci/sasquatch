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
  chk_connection()
  chk::chk_string(input)

  execute_if_connection_active(
    results <- .pkgenv$session$submit(input)
  )

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"), 
    paste(results$LOG, collapse = "\n")
  )
}
