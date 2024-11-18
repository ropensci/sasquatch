#' Establish SAS session
#' 
#' @description
#' Starts a SAS session. This is required before doing anything!
#' 
#' @param config Configuration to use from the SAS_config_names list in 
#' `sascfg_personal.py`.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect(config = "oda")
#' }
sas_connect <- function(config) {
  if (missing(config)) {
    .pkgenv$session <- .pkgenv$SASPy$SASsession()
  } else {
    .pkgenv$session <- .pkgenv$SASPy$SASsession(config)
  }

  invisible()
}

#' Disconnect SAS session
#' 
#' @description
#' Disconnects from the current SAS session.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_disconnect()
#' }
sas_disconnect <- function() {
  check_connection()
  .pkgenv$session$endsas()
  .pkgenv$session <- NULL

  invisible()
}

#' Get current SAS session
#' 
#' Gets current SAS session so that you can use functions not yet implemented.
#' Can also be useful for testing or using Python.
#' 
#' @return Current SAS session.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_get_session()
#' }
sas_get_session <- function() {
  check_connection()

  .pkgenv$session
}
