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
#' @family code execution functions
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_run_string("PROC MEANS DATA = sashelp.cars;RUN;")
#' }
sas_run_string <- function(input) {
  check_session()
  check_string(input)

  execute_if_connection_active(
    results <- .sas_run_string(input)
  )

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"),
    paste(results$LOG, collapse = "\n")
  )
}

.sas_run_string <- function(input) {
  .pkgenv$session$submit(input)
}
