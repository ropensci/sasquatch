#' Check if file on SAS exists
#'
#' Checks if a file exists on the remote SAS server. Is analogous to
#' `file.exists()`, but for the remote SAS server.
#'
#' @param path string; Path of file on remote SAS server.
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
#' sas_file_exists(sas_path)
#'
#' # cleanup
#' unlink(local_path)
#' sas_file_remove(sas_path)
sas_file_exists <- function(path) {
  check_session()
  check_string(path)

  # cannot simply use `basename()` and `dirname()` because user may be on
  # Windows while SAS is on a unix-like platform, or vice-versa.
  uses_bslash <- grepl("\\\\", path)
  path_split <- unlist(strsplit(path, "/|\\\\"))
  path_basename <- path_split[length(path_split)]
  if (length(path_split) == 1) {
    path_dirname <- "/"
  } else {
    slash <- ifelse(uses_bslash, "\\", "/")
    path_dirname <- paste0(
      paste(path_split[-length(path_split)], collapse = slash),
      slash
    )
  }

  sas_files <- .sas_list(path_dirname)
  any(path_basename == gsub("/|\\\\", "", sas_files))
}
