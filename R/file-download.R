#' Download a file from SAS
#'
#' Downloads a file to the remote SAS server.
#'
#' @param sas_path string; Path of file on remote SAS server to be download
#' @param local_path string; Path to upload SAS file to on local machine.
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
#' # download file from SAS
#' sas_file_download(sas_path = "~/script.sas", local_path = "script.sas")
#' }
sas_file_download <- function(sas_path, local_path) {
  check_session()
  check_string(sas_path)
  check_string(local_path)

  execute_if_connection_active(
    result <- .sas_file_download(local_path, sas_path)
  )

  if (!result$Success) {
    if (sprintf("File %s is a directory.", sas_path) == result$LOG) {
      cli::cli_warn("`{.val {sas_path}}` is a directory.")
    } else if (sprintf("File %s does not exist.", sas_path) == result$LOG) {
      cli::cli_warn("`{.val {sas_path}}` cannot be found.")
    } else {
      # Looking at the SASPy source code, it doesn't seem like this
      # should ever fire, but this is a good backup in case SASPy
      # changes.
      cli::cli_warn("{result$LOG}")
    }
  }

  invisible(result$Success)
}

.sas_file_download <- function(local_path, sas_path) {
  .pkgenv$session$download(local_path, sas_path)
}
