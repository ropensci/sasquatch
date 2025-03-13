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
  check_session()

  reticulate::py_capture_output(
    .pkgenv$session$endsas()
  )
  .pkgenv$session <- NULL
  cli::cli_inform("SAS connection terminated.")

  invisible()
}
