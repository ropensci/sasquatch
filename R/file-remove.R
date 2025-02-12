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
#' @examples
#' \dontrun{
#' # connect to SAS
#' sas_connect()
#' 
#' # create a file and upload it to SAS
#' cat("PROC MEANS DATA = sashelp.cars;RUN;", file = "script.sas")
#' sas_file_upload(local_path = "script.sas", sas_path = "~/script.sas")
#' 
#' # remove file from SAS
#' sas_file_remove(sas_path = "~/script.sas")
#' }
sas_file_remove <- function(path) {
  chk_session()
  chk::chk_not_missing(path, "`path`")
  chk::chk_string(path)

  execute_if_connection_active(
    result <- .pkgenv$session$file_delete(path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}
