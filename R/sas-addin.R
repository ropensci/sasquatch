# from https://github.com/tidyverse/reprex/blob/33ccedffb699d5cdfc9c274bbe4acbdee3266dcf/R/reprex-addin.R
###############################################################################
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
#' Execute selected SAS code in current session and render html output.
#' 
#' You can add the following to your Positron keybindings.json and run SAS
#' code by selecting it and pressing ctrl+shift+enter.
#' 
#' ```
#' {
#'     "key": "ctrl+shift+enter",
#'     "command": "workbench.action.executeCode.console",
#'     "when": "editorTextFocus",
#'     "args": {
#'         "langId": "r",
#'         "code": "sasr::sas_run_selected()",
#'         "focus": true
#'     }
#' }
#' ```
#' 
#' @return No return value.
#' 
#' @export
sas_run_selected <- function() {
  repl_sas(paste(rstudio_selection(), collapse = "\n"))
}
