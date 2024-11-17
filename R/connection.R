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
sas_connect <- function(config) {
  if (missing(config)) {
    .pkgenv$session <- .pkgenv$saspy$SASsession()
  } else {
    .pkgenv$session <- .pkgenv$saspy$SASsession(config)
  }
}

#' Disconnect SAS session
#' 
#' @description
#' Disconnects from the current SAS session.
#' 
#' @return No return value.
#' 
#' @export
sas_disconnect <- function() {
  check_connection()
  .pkgenv$session$disconnect()
}