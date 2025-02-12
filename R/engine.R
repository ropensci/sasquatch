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
#' - `eval` (Default: `TRUE`): Evaluate the code chunk (if false, just echos the 
#' code into the output)
#' - `echo` (Default: `TRUE`): Include the source code in output
#' - `output` (Default: `TRUE`): Include the results of executing the code in 
#' the output (`TRUE` or `FALSE`).
#' - `include` (Default: `TRUE`): Include any output (code or results).  
#' - `capture` (Default: `"both"`): If `"both"`, tabpanel with output and log 
#' included. 
#' If `"lst"`, only output is included. If `"log"` only log is included.
#' 
#' @return `knitr` engine output.
#' 
#' @export
#' 
#' @examples
#' # The below function is run internally within `sasquatch` on startup
#' knitr::knit_engines$set(sas = sas_engine)
sas_engine <- function (options) {
  chk_connection()
  options$engine <- "txt"
  options$results <- "asis"

  code <- paste(options$code, collapse = "\n")

  # allows html widgets to be returned within the rstudio rmd/quarto interface
  if (!isTRUE(getOption('knitr.in.progress'))) {
    return(sas_run_string(code))
  }

  if (identical(options$include, FALSE)) {
    options$echo <- FALSE
    options$output <- FALSE
  }

  if (identical(options$eval, FALSE)) {
    options$output <- FALSE
  } else if (is_html_output()) {
    execute_if_connection_active(
      results <- .pkgenv$session$submit(code)
    )

    if (identical(options$capture, "lst")) {
      out <- wrap_in_iframe(results$LST)
    } else if (identical(options$capture, "log")) {
      out <- wrap_in_pre(results$LOG)
    } else {
      lst <- wrap_in_iframe(results$LST)
      log <- wrap_in_pre(results$LOG)
      out <- wrap_in_panel_tabset(lst, log)
    }
  } else {
    chk::err("`sas_engine` cannot produce non-html output.")
  }

  if (identical(options$echo, FALSE)) {
    code <- list()
  }
  if (identical(options$output, FALSE)) {
    out <- list()
  }
  
  knitr::engine_output(options, code, out)
}

wrap_in_iframe <- function(html) {
  html <- paste(html, collapse = "\n")
  html <- gsub("'", "\"", html)
  html <- gsub("background-color:\\s*?#fafbfe", "background-color: transparent", html)

  paste(
    "<iframe width = '100%' class='resizable-iframe' srcdoc = '", 
    html,
    "<style>table {margin-left: auto; margin-right: auto;}</style>",
    "'></iframe>",
    sep = "\n"
  )
}

wrap_in_pre <- function(html) {
  html <- paste(html, collapse = "\n")
  paste("<pre>", html, "</pre>")
}

wrap_in_panel_tabset <- function(lst, log) {
  paste(
    '::: panel-tabset',
    '## Output',
    lst,
    '## Log',
    log,
    ':::
    ',
    sep="\n"
  )
}