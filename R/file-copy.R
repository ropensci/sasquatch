#' Copy a file on SAS
#' 
#' Copies a file on the remote SAS server. Is analogous to 
#' `file.copy()`, but for the remote SAS server.
#' 
#' @param from_path Path of file on remote SAS server to be copied.
#' @param to_path Path of file on remote SAS server to copy to.
#' 
#' @return Logical value indicating if the operation succeeded.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # connect to SAS
#' sas_connect()
#' 
#' # create a file and upload it to SAS
#' cat("PROC MEANS DATA = sashelp.cars;RUN;", file = "script.sas")
#' sas_file_upload(local_path = "script.sas", sas_path = "~/script.sas")
#' 
#' # copy file on SAS
#' sas_file_copy("~/script.sas", "~/script_copy.sas")
#' }
sas_file_copy <- function(from_path, to_path) {
  chk_connection()
  chk::chk_string(from_path)
  chk::chk_string(to_path)

  execute_if_connection_active(
    result <- .pkgenv$session$file_copy(from_path, to_path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}

#' Check if file on SAS exists
#' 
#' Checks if a file exists on the remote SAS server. Is analogous to 
#' `file.exists()`, but for the remote SAS server.
#' 
#' @param path Path of file on remote SAS server.
#' 
#' @return Logical value indicating if file exists on remote SAS server.
#' 
#' @export
#' 
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
