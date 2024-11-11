#' Establish SAS session
#' 
#' @description
#' Starts a SAS session. This is required before doing anything!
#' 
#' @return No return value.
#' 
#' @export
sas_connect <- function() {
  saspy <- reticulate::import("saspy")
  .pkgenv[["session"]] <- saspy$SASsession()
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
  .pkgenv[["session"]]$disconnect()
}