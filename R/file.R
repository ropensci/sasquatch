#' Upload a file to SAS
#' 
#' Uploads a file to the remote SAS server.
#' 
#' @param local_path Path of file on local machine to be uploaded.
#' @param sas_path Path to upload local file to on the remote SAS server.
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
#' # create a file to upload
#' cat("PROC MEANS DATA = sashelp.cars;RUN;", file = "script.sas")
#' 
#' # upload file
#' sas_file_upload(local_path = "script.sas", sas_path = "~/script.sas")
#' }
sas_file_upload <- function(local_path, sas_path) {
  chk_connection()
  chk::chk_string(local_path)
  chk::chk_file(local_path)
  chk::chk_string(sas_path)

  execute_if_connection_active(
    result <- .pkgenv$session$upload(local_path, sas_path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}

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
  chk::chk_not_missing(sas_path)
  chk::chk_string(sas_path)
  chk::chk_not_missing(local_path)
  chk::chk_string(local_path)

  execute_if_connection_active(
    result <- .pkgenv$session$download(local_path, sas_path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}

#' Delete a file or directory from SAS
#' 
#' Deletes a file or directory from the remote SAS server. Is analogous to 
#' `file.remove()`, but for the remote SAS server.
#' 
#' @param path Path of file on remote SAS server to be deleted.
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
#' # remove file from SAS
#' sas_file_remove(sas_path = "~/script.sas")
#' }
sas_file_remove <- function(path) {
  chk_connection()
  chk::chk_string(path)

  execute_if_connection_active(
    result <- .pkgenv$session$file_delete(path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}

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
  chk::chk_string(path)

  execute_if_connection_active(
    result <- .pkgenv$session$file_copy(from_path, to_path)
  )

  if (!result$Success) {
    chk::wrn(result$LOG)
  }

  result$Success
}

#' List contents of a SAS directory
#' 
#' Lists the files or directories of a directory within the remote SAS server.
#' 
#' @param path Path of directory on remote SAS server to list the contents of.
#' 
#' @return Vector of file or directory names.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_list(".")
#' }
sas_list <- function(path) {
  chk_connection()
  chk::chk_string(path)

  execute_if_connection_active(
    dirlist <- .pkgenv$session$dirlist(path)
  )
  dirlist
}
