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
#' @examples
#' \dontrun{
#' # connect to SAS
#' sas_connect()
#' 
#' # create a file and upload it to SAS
#' cat("PROC MEANS DATA = sashelp.cars;RUN;", file = "script.sas")
#' sas_file_upload(local_path = "script.sas", sas_path = "~/script.sas")
#' 
#' # check if file exists on SAS
#' sas_file_exists("~/script.sas")
#' }
sas_file_exists <- function(path) {
  chk_connection()
  chk::chk_string(path)

  file <- basename(path)
  dir <- gsub(file, "", path)

  execute_if_connection_active(
    dirlist <- .pkgenv$session$dirlist(dir)
  )

  any(dirlist == file)
}
