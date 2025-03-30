#' List contents of a SAS directory
#'
#' Lists the files or directories of a directory within the remote SAS server.
#'
#' @param path string; Path of directory on remote SAS server to list the contents of.
#'
#' @return `character` vector; File or directory names.
#'
#' @export
#'
#' @family file management functions
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_list(".")
#' }
sas_list <- function(path) {
  check_session()
  check_string(path)

  execute_if_connection_active(
    dirlist <- .sas_list(path)
  )

  if (length(dirlist) == 0) {
    dirlist <- character()
  }

  dirlist
}

.sas_list <- function(path) {
  .pkgenv$session$dirlist(path)
}
