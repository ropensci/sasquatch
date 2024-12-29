#' A SAS engine for `knitr`
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
#' ### HTML formats vs all others
#' SAS has native support for HTML output, which means embeding HTML SAS output
#' within HTML quarto formats is quite easy. You can expect that HTML formats
#' will look nearly identically to how you would expect within a SAS 
#' environment.
#' 
#' Within non-HTML formats (pdf, typst, docx), embeding HTML SAS output is not 
#' an option. Thus, the engine first renders output to HTML3 and transforms
#' it with the Python package `markdownify`. 
#' 
#' This process is by no means perfect, but in order to use it ensure that 
#' `markdownify` has been installed (`install_saspy()` will install 
#' `markdownify` for you) AND set a temporary directory to write to within the 
#' SAS client, which can be set by `sas_set_tempdir()`.
#' 
#' Credit for this idea goes to [fsmunoz](https://github.com/fsmunoz) within
#' this `SASPy` [discussion post](https://github.com/sassoftware/saspy/discussions/412).
#' 
#' @return `knitr` engine output.
#' 
#' @export
#' 
#' @examples
#' # The below function is run internally within `sasquatch` on startup
#' knitr::knit_engines$set(sas = sas_engine)
#' 
#' # If rendering to non-HTML formats, set the SAS temporary directory
#' sas_set_tempdir("~/tempdir")
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
    chk_set_tempdir()
    sas_temp_dir <- .pkgenv$tempdir
    sas_temp_html <- basename(tempfile(pattern="temp", fileext=".html"))
    sas_temp_html_path <- paste0(sas_temp_dir, "/", sas_temp_html)
    local_temp_dir <- tempdir()
    local_temp_html_path <- paste0(local_temp_dir, "/", sas_temp_html)

    sas_header <- paste(
      "ods noproctitle;",
      "title;",
      "ods listing close;",
      "ods graphics;",
      "OPTIONS NONUMBER NODATE PAGESIZE = MAX FORMCHAR = '|----|+|---+=|-/<>*' FORMDLIM=' ';",
      paste0(
        "ods html3 file='", sas_temp_html_path,
        "' gpath = '", sas_temp_dir, 
        "' (no_top_matter no_bottom_matter) style=journal;\n"
      ),
      sep = "\n"
    )

    execute_if_connection_active(
      results <- .pkgenv$session$submit(
        paste0(sas_header, code),
        "TEXT"
      )
    )
    log <- gsub("\024", "", results$LOG)

    sas_file_download(sas_temp_html_path, local_temp_html_path)
    lst <- read_file(local_temp_html_path)
    markdownify <- reticulate::import("markdownify")
    lst <- markdownify$markdownify(lst)

    md_image_regex <- "\\[.*?\\]\\((.*?)\\)"
    images <- regmatches(lst, gregexec(md_image_regex, lst))[[1]]
    if (length(images) != 0) {
      sas_image_paths <- images[2, ]
  
      for (sas_image_path in sas_image_paths) {
        local_image_path <- gsub(sas_temp_dir, local_temp_dir, sas_image_path, fixed = TRUE)
        sas_file_download(sas_image_path, local_image_path)
        sas_file_remove(sas_image_path)
        lst <- gsub(sas_image_path, knitr::image_uri(local_image_path), lst, fixed = TRUE)
      }
    }
    lst <- sub("SAS Output", "", lst, fixed = TRUE)
    sas_file_remove(sas_temp_html_path)

    if (identical(options$capture, "lst")) {
      out <- lst
    } else if (identical(options$capture, "log")) {
      out <- paste("```", log, "```", sep = "\n")
    } else {
      log <- paste("```", log, "```", sep = "\n")
      out <- wrap_in_panel_tabset(lst, log)
    }
  }

  if (identical(options$echo, FALSE)) {
    code <- list()
  }
  if (identical(options$output, FALSE)) {
    out <- list()
  }
  
  knitr::engine_output(options, code, out)
}

#' Set SAS temporary directory
#' 
#' In order to create markdown output for non-HTML formats, SAS must render
#' intermediate files to a directory on the SAS. This function allows you
#' to set what directory intermediate files are writen to.
#' 
#' @param path Path for SAS to write intermediate files to for the `knitr` 
#' `sas_engine()`
#' 
#' @return No return value.
#' 
#' @export
sas_set_tempdir <- function(path) {
  chk::chk_string(path)

  .pkgenv$tempdir <- path

  invisible()
}

chk_set_tempdir <- function() {
  if (vld_set_tempdir()) {
    return(invisible())
  }
  chk::abort_chk("No SAS temporary directory has been set. Use `sas_set_tempdir()`")
}
vld_set_tempdir <- function() exists("tempdir", envir = .pkgenv) && !is.null(.pkgenv$tempdir)

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