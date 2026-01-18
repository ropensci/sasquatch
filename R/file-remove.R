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
#' # create a file and upload it to SAS
#' tempfile_path <- tempfile(fileext = ".sas")
#' tempfile_basename <- basename(tempfile_path)
#' cat("PROC MEANS DATA = sashelp.cars;RUN;", file = tempfile_path)
#' sas_file_upload(local_path = tempfile_path, sas_path = paste0("~/", tempfile_basename))
#'
#' # remove file from SAS
#' sas_file_remove(paste0("~/", tempfile_basename))
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
