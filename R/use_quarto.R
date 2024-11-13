#' Add SAS quarto template to current directory
#' 
#' @description
#' Adds SAS quarto template and syntax highlighting XML to current directory.
#' 
#' @return No return value.
#' 
#' @export
sas_use_quarto <- function() {
  template <- system.file("sasquatch.qmd", package = "sasquatch")
  file.copy(template, ".")

  sas_xml <- system.file("sas.xml", package = "sasquatch")
  file.copy(sas_xml, ".")

  invisible()
}