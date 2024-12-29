#' Execute SAS code string
#' 
#' @description
#' Execute SAS code in current session and render html output.
#' 
#' @param input string; SAS code to run.
#' 
#' @return `htmlwidget`; HTML5 output.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_run_string("PROC MEANS DATA = sashelp.cars;RUN;")
#' }
sas_run_string <- function(input) {
  chk_connection()
  chk::chk_not_missing(input, "`input`")
  chk::chk_string(input)

  execute_if_connection_active(
    results <- .pkgenv$session$submit(input)
  )

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"), 
    paste(results$LOG, collapse = "\n")
  )
}
