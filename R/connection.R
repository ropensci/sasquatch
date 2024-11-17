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
  .pkgenv$saspy <- reticulate::import("saspy")
  
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
#' 
#' @examples
#' \dontrun{
#' sas_disconnect()
#' }
sas_disconnect <- function() {
  check_connection()
  .pkgenv$session$disconnect()
}