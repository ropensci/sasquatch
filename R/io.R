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
  check_connection()

  result <- .pkgenv$session$upload(local_path, sas_path)

  if (!result$Success) {
    warning(result$LOG)
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
  check_connection()

  result <- .pkgenv$session$download(local_path, sas_path)

  if (!result$Success) {
    warning(result$LOG)
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
  check_connection()

  .pkgenv$session$file_delete(path)

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
  check_connection()

  .pkgenv$session$dirlist(path)
}

#' @export
sas_read_csv <- function(file, table_name, libref = "WORK") {
  check_connection()

  .pkgenv$session$read_csv(file, table_name, libref)
}

#' @export
sas_write_csv <- function(table_name, path, libref = "WORK") {
  check_connection()

  .pkgenv$session$write_csv(path, table_name, libref)
}

#' @export
sas_write_parquet <- function(table_name, path, libref = "WORK") {
  check_connection()
  
  .pkgenv$session$sasdata2parquet(path, table_name, libref)
}
