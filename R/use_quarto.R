#' Add sasr quarto template to current directory
#' 
#' @description
#' Adds sasr quarto template and syntax highlighting XML to current directory.
#' 
#' @return No return value.
#' 
#' @export
use_sasr_quarto <- function() {
  template <- system.file("sasr.qmd", package = "sasr")
  file.copy(template, ".")

  sas_xml <- system.file("sas.xml", package = "sasr")
  file.copy(sas_xml, ".")

  invisible()
}