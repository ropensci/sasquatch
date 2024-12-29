# from https://github.com/tidyverse/reprex/blob/33ccedffb699d5cdfc9c274bbe4acbdee3266dcf/R/reprex-addin.R
################################################################################
rstudio_text_tidy <- function(x) {
  if (identical(x, "")) {
    return(character())
  }
  Encoding(x) <- "UTF-8"
  if (length(x) == 1) {
    ## rstudio_selection() returns catenated text
    x <- strsplit(x, "\n")[[1]]
  }

  n <- length(x)
  if (!grepl("\n$", x[[n]])) {
    x[[n]] <- newline(x[[n]])
  }
  x
}

newline <- function(x) paste0(x, "\n")

rstudio_context <- function() {
  rstudioapi::getSourceEditorContext()
}

rstudio_selection <- function(context = rstudio_context()) {
  text <- rstudioapi::primary_selection(context)[["text"]]
  rstudio_text_tidy(text)
}
################################################################################

#' Execute selected SAS code
#' 
#' @description
#' Execute selected SAS code in current session and render html output as SAS
#' widget. See `vignette("sasquatch")` for more information on how to utilize 
#' the addin within RStudio or Positron.
#' 
#' @return `htmlwidget`; HTML5 output.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' 
#' # highlight something in the active editor of RStudio or Positron
#' 
#' sas_run_selected()
#' }
sas_run_selected <- function() {
  sas_run_string(paste(rstudio_selection(), collapse = "\n"))
}
