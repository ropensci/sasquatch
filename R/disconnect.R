#' Disconnect SAS session
#' 
#' @description
#' Disconnects from the current SAS session.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @family session management functions
#' @examples
#' \dontrun{
#' sas_disconnect()
#' }
sas_disconnect <- function() {
  chk_connection()
  
  reticulate::py_capture_output(
    .pkgenv$session$endsas()
  )
  .pkgenv$session <- NULL
  chk::msg("SAS Connection terminated.")

  invisible()
}
