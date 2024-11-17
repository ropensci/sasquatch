#' Add SAS quarto template to specified directory
#' 
#' @description
#' Adds SAS quarto template and syntax highlighting XML to a specified
#' directory.
#'
#' @param path (Default: Current directory) Path to copy quarto template and
#' syntax highlighting XML into.
#' @param xml Include syntax highlighting XML?
#'  
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_use_quarto()
#' }
sas_use_quarto <- function(path, xml = TRUE) {
  if (missing(path)) {
    path <- "."
  } else if (!dir.exists(path)) {
    stop("Specified directory does not exist")
  }

  template <- system.file("sasquatch.qmd", package = "sasquatch")
  file.copy(template, path)

  if (xml) {
    sas_xml <- system.file("sas.xml", package = "sasquatch")
    file.copy(sas_xml, path)
  }

  invisible()
}
