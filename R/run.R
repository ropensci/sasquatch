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
sas_run_string <- function(input) {
  check_connection()

  results <- .pkgenv$session$submit(input)

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"), 
    paste(results$LOG, collapse = "\n")
  )
}
