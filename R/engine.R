#' A SAS engine for `knitr`
#'
#' Produces HTML or latex output for rending within quarto or rmarkdown documents.
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
#' - `capture` (Only within HTML; Default: `"both"`): If `"both"`, tabpanel with output and log
#' included. If `"listing"`, only output is included. If `"log"` only log is included.
#' - `out.width` (Only within HTML; Default: `"auto"`): Width of output.
#' - `out.height` (Only within HTML; Default: `"auto"`): Height of output.
#'
#' @return `knitr` engine output.
#'
#' @export
#'
#' @examples
#' # The below function is run internally within `sasquatch` on startup
#' knitr::knit_engines$set(sas = sas_engine)
sas_engine <- function(options) {
  options$engine <- "txt"

  # allows html widgets to be returned within the rstudio rmd/quarto interface
  if (!isTRUE(getOption('knitr.in.progress'))) {
    return(sas_run_string(paste(options$code, collapse = "\n")))
  }

  if (is_html_output()) {
    sas_html_engine(options)
  } else if (is_latex_output()) {
    sas_latex_engine(options)
  } else {
    cli::cli_abort(
      "{.fun sasquatch::sas_engine} can only produce HTML and latex output."
    )
  }
}
