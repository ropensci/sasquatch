#' A SAS HTML5 engine for `knitr`
#' 
#' @param options Options from `knitr`.
#' 
#' @details
#' Will be activated by running `library(sasquatch)`
#' 
#' ### Supported `knitr` chunk options
#' `sasquatch`'s engine implements may of the same options as the R engine in
#' `knitr`, but not all.
#' 
#' - `eval` (Default: `TRUE`): Evaluate the code chunk (if false, just echos the code into the output)
#' - `echo` (Default: `TRUE`): Include the source code in output
#' - `output` (Default: `TRUE`): Include the results of executing the code in 
#' the output (`TRUE` or `FALSE`).
#' - `include` (Default: `TRUE`): Include any output (code or results).  
#' - `capture` (Default: `"both"`): If `"both"`, tabpanel with output and log included. 
#' If `"lst"`, only output is included. If `"log"` only log is included.
#' 
#' @return `knitr` engine output.
#' 
#' @export
sas_engine <- function (options) {
  code <- paste(options$code, collapse = "\n")

  if (!isTRUE(getOption('knitr.in.progress'))) {
    return(sas_run_string(code))
  }

  if (identical(options$include, FALSE)) {
    options$echo <- FALSE
    options$output <- FALSE
  }

  if (identical(options$eval, FALSE)) {
    out <- list()
  } else {
    results <- .pkgenv$session$submit(code)

    if (identical(options$output, FALSE)) {
      out <- list()
    } else {
      if (identical(options$capture, "lst")) {
        out <- wrap_in_iframe(results$LST)
      } else if (identical(options$capture, "log")) {
        out <- wrap_in_pre(results$LOG)
      } else {
        lst <- wrap_in_iframe(results$LST)
        log <- wrap_in_pre(results$LOG)
        out <- wrap_in_panel_tabset(lst, log)
      }
      options$results <- "asis"
    }
  }

  if (identical(options$echo, FALSE)) {
    code <- list()
  }
  
  knitr::engine_output(options, code, out)
}
