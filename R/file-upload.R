#' Upload a file to SAS
#'
#' Uploads a file to the remote SAS server.
#'
#' @param local_path string; Path of file on local machine to be uploaded.
#' @param sas_path string; Path to upload local file to on the remote SAS server.
#'
#' @return `logical`; value indicating if the operation succeeded.
#'
#' @export
#'
#' @family file management functions
#' @examplesIf interactive()
#' # connect to SAS
#' sas_connect()
#'
#' # create an example file
#' local_path <- tempfile(fileext = ".txt")
#' cat("some example text", file = tempfile_path)
#'
#' sas_path <- readline(
#'   "Please provide the full path to upload an example file to (e.g., ~/example.txt)."
#' )
#' sas_file_upload(local_path, sas_path)
#'
#' # cleanup
#' unlink(local_path)
#' sas_file_remove(sas_path)
sas_file_upload <- function(local_path, sas_path) {
  check_session()
  check_file(local_path, x_name = "local_path")
  check_string(sas_path)

  execute_if_connection_active(
    result <- .sas_file_upload(local_path, sas_path)
  )

  if (!result$Success) {
    cli::cli_warn("{result$LOG}")
  }

  invisible(result$Success)
}

.sas_file_upload <- function(local_path, sas_path) {
  .pkgenv$session$upload(local_path, sas_path)
}
