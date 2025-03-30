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
  if (!valid_session()) {
    return(invisible())
  }

  reticulate::py_capture_output(
    .pkgenv$session$endsas()
  )
  cli::cli_alert_success("SAS connection terminated.")

  invisible()
}
