sashtml_engine <- function (options) {
  code <- paste(options$code, collapse = "\n")
  results <- .pkgenv[["session"]]$submit(code)

  out <- paste(results$LST, collapse = "\n")
  out <- gsub("'", "\"", out)

  out <- paste(
    "<iframe width = '100%' srcdoc = '", 
    out,
    "<style>table {margin-left: auto; margin-right: auto;}</style>",
    "<script src=\"https://cdn.jsdelivr.net/npm/@iframe-resizer/child@5.3.2\"></script>", 
    "'></iframe>", 
    sep = "\n"
  )

  out <- paste(
    out,
    "<script>iframeResize({license: 'GPLv3', scrolling: 'yes', waitForLoad: true,}, 'iframe' );</script>",
    sep = "\n"
  )

  options$results <- "asis"
  
  knitr::engine_output(options, code, out)
}
