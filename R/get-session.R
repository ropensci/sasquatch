#' Get current SAS session
#' 
#' Returns the current SAS session, which can be used to extend `sasquatch`
#' functionality or access the current session within Python.
#' 
#' @return Current SAS session.
#' 
#' @details
#' ## Extending `sasquatch` functionality
#' `SASPy` has a wealth of functionality that has not been implemented within 
#' `sasquatch`. `sas_get_session()` offers a gateway to unimplemented
#' functionality within the [SASsession class](https://sassoftware.github.io/saspy/api.html#sas-session-object).
#' 
#' ## Using Python
#' When utilizing Python, R, and SAS, start the session within R using 
#' `sas_connect()` and utilize `reticulate` to pass the current SAS session
#' to Python.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_get_session()
#' }
sas_get_session <- function() {
  .pkgenv$session
}
