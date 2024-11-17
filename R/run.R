#' Execute SAS code
#' 
#' @description
#' Execute SAS code in current session and render html output.
#' 
#' @return No return value.
#' 
#' @export
sas_run_string <- function(input) {
  results <- .pkgenv$session$submit(input)

  sas_widget(
    paste(gsub("'", "\"", results$LST), collapse = "\n"), 
    paste(results$LOG, collapse = "\n")
  )
}
