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
#' # create a file and upload it to SAS
#' tempfile_path <- tempfile(fileext = ".sas")
#' tempfile_basename <- basename(tempfile_path)
#' tempfile_basename_copy <- sub("\\.sas$", "_copy.sas", tempfile_basename)
#' cat("PROC MEANS DATA = sashelp.cars;RUN;", file = tempfile_path)
#' sas_file_upload(local_path = tempfile_path, sas_path = paste0("~/", tempfile_basename))
#'
#' # copy file on SAS
#' sas_file_copy(paste0("~/", tempfile_basename), paste0("~/", tempfile_basename_copy))
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
