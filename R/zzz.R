.pkgenv <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  Sys.setenv(RETICULATE_USE_MANAGED_VENV = "no")

  reticulate::py_require(
    c("wheel", "saspy", "pandas"),
    ">3.4"
  )
  .pkgenv$SASPy <- reticulate::import(
    "saspy",
    delay_load = list(
      environment = "r-saspy"
    )
  )
  knitr::knit_engines$set(sas = sas_engine)

  # adjusts iframe sizing so that they will adapt to the size of their
  # content dynamically
  knitr::knit_hooks$set(document = function(x, options) {
    resizer_url <- system.file("resize-iframes.js", package = "sasquatch")
    resizer_code <- paste(readLines(resizer_url), collapse = "\n")
    resizer_script <- paste("<script>", resizer_code, "</script>", sep = "\n")

    iframe_start <- "<iframe width = '100%' class='resizable-iframe'"
    sub(iframe_start, paste0(resizer_script, iframe_start), x)
  })
}
