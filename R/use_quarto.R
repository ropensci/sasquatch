#' Add SAS quarto template to specified directory
#' 
#' @description
#' Adds SAS quarto template and syntax highlighting XML to a specified
#' directory.
#'
#' @param path (Default: Current directory) Path to copy quarto template and
#' syntax highlighting XML into.
#'  
#' @return No return value.
#' 
#' @export
sas_use_quarto <- function(path) {
  if (!hasArg(path)) {
    path <- "."
  } else if (!dir.exists(path)) {
    stop("Specified directory does not exist")
  }

  template <- system.file("sasquatch.qmd", package = "sasquatch")
  file.copy(template, path)

  sas_xml <- system.file("sas.xml", package = "sasquatch")
  file.copy(sas_xml, path)

  invisible()
}
