.pkgenv <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  reticulate::py_discover_config("saspy", "r-saspy")
  .pkgenv$SASPy <- reticulate::import("saspy", delay_load = TRUE)
  knitr::knit_engines$set(sas = sas_engine)

  knitr::knit_hooks$set(document = function(x, options) {
    resizer_url <- system.file("resize-iframes.js", package = "sasquatch")
    resizer_code <- paste(readLines(resizer_url), collapse = "\n")
    resizer_script <- paste("<script>", resizer_code, "</script>", sep = "\n")

    iframe_start <- "<iframe width = '100%' class='resizable-iframe'"
    sub(iframe_start, paste0(resizer_script, iframe_start), x)
  })
}
