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
sas_engine <- function(options) {
  check_session()
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
      results <- .sas_run_string(code)
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
  } else if (is_latex_output()) {
    execute_if_connection_active(
      out <- .sas_run_latex(code)
    )
  } else {
    cli::cli_abort(
      "{.fun sasquatch::sas_engine} cannot produce non-html output."
    )
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
  html <- gsub(
    "background-color:\\s*?#fafbfe",
    "background-color: transparent",
    html
  )

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
  paste("<pre>", html, "</pre>", sep = "\n")
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
    sep = "\n"
  )
}

.sas_run_latex <- function(code) {
  sas_path <- .pkgenv$session$`_io`$`_sb`$workpath
  output_tex <- basename(tempfile(pattern = "", tmpdir = ".", fileext = ".tex"))

  wrapped_code <- paste(
    "ods noproctitle;",
    "ods listing close;",
    paste0(
      "ods tagsets.simplelatex path = '",
      sas_path,
      "' gpath = '",
      sas_path,
      "' file='",
      output_tex,
      "' (no_top_matter no_bottom_matter) stylesheet='sas_style.sty'(url='sas');"
    ),
    "ods graphics / imagename='glabel' outputfmt=png;",
    "OPTIONS NONUMBER NODATE PAGESIZE = MAX FORMCHAR = '|----|+|---+=|-/<>*' FORMDLIM=' ';title;",
    code,
    "ods tagsets.simplelatex close;",
    sep = "\n"
  )

  .sas_run_string(wrapped_code)

  workspace_files <- .sas_list(sas_path)
  output_files <- grep("(tex|png|sty)$", workspace_files, value = TRUE)

  lapply(
    output_files,
    \(file)
      .sas_file_download(
        file.path(".sasquatch", file),
        paste0(sas_path, "/", file)
      )
  )
  lapply(
    output_files,
    \(file) .sas_file_remove(paste0(sas_path, "/", file))
  )

  # replace problematic styles
  sty <- readLines(".sasquatch/sas_style.sty")
  sty2 <- sub("\\newcommand{\\color}[2][]{}", "", sty, fixed = TRUE)
  sty3 <- sub(
    "\\newcommand{\\sascaption}[2][l]{\\marginpar[#1]{\\fbox{\\parbox{0.7in}{\\sasScaption{#2}}}}}",
    "\\newcommand{\\sascaption}[2][l]{\\reversemarginpar{\\fbox{\\parbox{0.9in}{\\sasScaption{#2}}}}}",
    sty2,
    fixed = TRUE
  )
  writeLines(sty3, ".sasquatch/sas_style.sty")

  tex_file <- grep("tex$", output_files, value = TRUE)
  output_tex <- readLines(file.path(".sasquatch", tex_file))
  graphics_lines <- grepl("\\includegraphics{", output_tex, fixed = TRUE)
  output_tex[graphics_lines] <- gsub(
    sas_path,
    ".sasquatch/",
    output_tex[graphics_lines],
    fixed = TRUE
  )

  gsub("\\pagebreak", " ", output_tex)
}
