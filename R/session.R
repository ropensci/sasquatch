#' Get current SAS session
#' 
#' Gets current SAS session so that you can use functions not yet implemented.
#' Can also be useful for testing.
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