#' Execute SAS code
#' 
#' @description
#' Execute SAS code in current session and render html output.
#' 
#' @return No return value.
#' 
#' @export
sas_run_string <- function(input) {
  results <- .pkgenv[["session"]]$submit(input)

  results_html <- htmltools::HTML(results$LST)
  htmltools::html_print(results_html)
}
