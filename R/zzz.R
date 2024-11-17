.pkgenv <- new.env(parent = emptyenv())

.onAttach <- function(libname, pkgname) {
  .pkgenv$saspy <- reticulate::import("saspy")
  knitr::knit_engines$set(sas = sas_engine)
}