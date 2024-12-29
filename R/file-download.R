#' Download a file from SAS
#' 
#' Downloads a file to the remote SAS server.
#' 
#' @param sas_path Path of file on remote SAS server to be download
#' @param local_path Path to upload SAS file to on local machine.
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
#' # download file from SAS
#' sas_file_download(sas_path = "~/script.sas", local_path = "script.sas")
#' }
sas_file_download <- function(sas_path, local_path) {
  chk_connection()
  chk::chk_string(sas_path)
  chk::chk_string(local_path)

  execute_if_connection_active(
    result <- .pkgenv$session$download(local_path, sas_path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}
