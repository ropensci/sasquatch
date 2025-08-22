sas_latex_engine <- function(options) {
  check_session()

  options$results <- "asis"

  code <- paste(options$code, collapse = "\n")

  if (isFALSE(options$include)) {
    options$echo <- FALSE
    options$output <- FALSE
  }

  if (isFALSE(options$eval)) {
    options$output <- FALSE
  } else if (is_latex_output()) {
    execute_if_connection_active(
      out <- .sas_run_latex(code)
    )
  }

  if (isFALSE(options$echo)) {
    code <- list()
  }
  if (isFALSE(options$output)) {
    out <- list()
  }

  knitr::engine_output(options, code, out)
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

  suppressWarnings(dir.create(".sasquatch"))

  workspace_files <- .sas_list(sas_path)
  output_files <- grep("(tex|png|sty)$", workspace_files, value = TRUE)

  lapply(
    output_files,
    \(file) {
      .sas_file_download(
        file.path(".sasquatch", file),
        paste0(sas_path, "/", file)
      )
    }
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
  file.remove(file.path(".sasquatch", tex_file))

  gsub("\\pagebreak", " ", output_tex)
}
