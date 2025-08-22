#' Execute SAS code string
#'
#' @description
#' Execute SAS code in current session and render html output.
#'
#' @param input string; SAS code to run.
#' @param capture If `"both"`, tabpanel with output and log included. If
#' `"listing"`, only output is included. If `"log"` only log is included.
#' @param height string; The height of the SAS output.
#' @param width string; The width of the SAS output.
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
sas_run_string <- function(
  input,
  capture = "both",
  height = "auto",
  width = "auto"
) {
  check_session()
  check_string(input)
  check_string(capture)
  rlang::arg_match(capture, c("both", "listing", "log"))
  check_string(height)
  check_string(width)

  execute_if_connection_active(
    results <- .sas_run_string(input)
  )

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"),
    paste(results$LOG, collapse = "\n"),
    capture = capture,
    height,
    width
  )
}

.sas_run_string <- function(input) {
  .pkgenv$session$submit(input)
}
