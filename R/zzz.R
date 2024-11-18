.pkgenv <- new.env(parent = emptyenv())

.onAttach <- function(libname, pkgname) {
  .pkgenv$SASPy <- reticulate::import("saspy", delay_load = TRUE)
  knitr::knit_engines$set(sas = sas_engine)
}