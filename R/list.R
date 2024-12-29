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
  as.vector(dirlist)
}
