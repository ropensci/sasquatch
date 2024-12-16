#' Upload a file to SAS
#' 
#' Uploads a file to the remote SAS server.
#' 
#' @param local_path Path of file on local machine to be uploaded.
#' @param sas_path Path to upload local file to on the remote SAS server.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' 
#' quarto_file <- system.file("sasquatch.qmd", package = "sasquatch")
#' sas_upload(quarto_file, "sasquatch.qmd")
#' }
sas_upload <- function(local_path, sas_path) {
  chk_connection()
  chk::chk_string(local_path)
  chk::chk_file(local_path)
  chk::chk_string(sas_path)

  execute_safely(
    result <- .pkgenv$session$upload(local_path, sas_path)
  )

  if (!result$Success) {
    stop(result$LOG)
  }

  invisible()
}

#' Download a file from SAS
#' 
#' Downloads a file to the remote SAS server.
#' 
#' @param sas_path Path of file on remote SAS server to be download
#' @param local_path Path to upload SAS file to on local machine.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' 
#' # upload document to SAS
#' quarto_file <- system.file("sasquatch.qmd", package = "sasquatch")
#' sas_upload(quarto_file, "sasquatch.qmd")
#' 
#' # download document from SAS
#' sas_download("sasquatch.qmd", "sasquatch.qmd")
#' }
sas_download <- function(sas_path, local_path) {
  chk_connection()
  chk::chk_string(sas_path)
  chk::chk_string(local_path)

  execute_safely(
    result <- .pkgenv$session$download(local_path, sas_path)
  )

  if (!result$Success) {
    stop(result$LOG)
  }

  invisible()
}

#' Delete a file or directory from SAS
#' 
#' Deletes a file or directory from the remote SAS server.
#' 
#' @param path Path of file on remote SAS server to be deleted.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' 
#' # upload document to SAS
#' quarto_file <- system.file("sasquatch.qmd", package = "sasquatch")
#' sas_upload(quarto_file, "sasquatch.qmd")
#' 
#' # remove document from SAS
#' sas_remove("sasquatch.qmd")
#' }
sas_remove <- function(path) {
  chk_connection()
  chk::chk_string(path)

  execute_safely(
    result <- .pkgenv$session$file_delete(path)
  )

  if (!result$Success) {
    stop(result$LOG)
  }

  invisible()
}

#' List contents of a SAS directory
#' 
#' Lists the files or directories of a directory within the remote SAS server.
#' 
#' @param path Path of directory on remote SAS server to list the contents of.
#' 
#' @return No return value.
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

  execute_safely(
    .pkgenv$session$dirlist(path)
  )
}
