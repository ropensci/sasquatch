#' Delete a file or directory from SAS
#'
#' Deletes a file or directory from the remote SAS server. Is analogous to
#' `file.remove()`, but for the remote SAS server.
#'
#' @param path string; Path of file on remote SAS server to be deleted.
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
#' cat("some example test", file = tempfile_path)
#'
#' sas_path <- readline("Please provide the full path to upload an example file to (e.g., ~/example.txt).")
#' sas_file_upload(local_path, sas_path)
#'
#' sas_file_remove(sas_path)
#'
#' # cleanup
#' unlink(local_path)
sas_file_remove <- function(path) {
  check_session()
  check_string(path)

  execute_if_connection_active(
    result <- .sas_file_remove(path)
  )

  if (!result$Success) {
    cli::cli_warn("{result$LOG}")
  }

  invisible(result$Success)
}

.sas_file_remove <- function(path) {
  .pkgenv$session$file_delete(path)
}
