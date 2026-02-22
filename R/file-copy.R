#' Copy a file on SAS
#'
#' Copies a file on the remote SAS server. Is analogous to
#' `file.copy()`, but for the remote SAS server.
#'
#' @param from_path string; Path of file on remote SAS server to be copied.
#' @param to_path string; Path of file on remote SAS server to copy to.
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
#' from_path <- sas_path
#' to_path <- readline(
#'   "Please provide the full path to copy the example file to (e.g., ~/example_copy.txt)."
#' )
#' sas_file_copy(from_path, to_path)
#'
#' # cleanup
#' unlink(local_path)
#' sas_file_remove(from_path)
#' sas_file_remove(to_path)
sas_file_copy <- function(from_path, to_path) {
  check_session()
  check_string(from_path)
  check_string(to_path)

  execute_if_connection_active(
    result <- .sas_file_copy(from_path, to_path)
  )

  if (!result$Success) {
    cli::cli_warn("{result$LOG}")
  }

  invisible(result$Success)
}

.sas_file_copy <- function(from_path, to_path) {
  .pkgenv$session$file_copy(from_path, to_path)
}
