.pkgenv <- new.env(parent = emptyenv())

.onAttach <- function(libname, pkgname) {
  knitr::knit_engines$set(sas = sas_engine)
}