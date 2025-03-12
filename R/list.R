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
  chk_session()
  chk::chk_not_missing(path, "`path`")
  chk::chk_string(path)

  execute_if_connection_active(
    dirlist <- .pkgenv$session$dirlist(path)
  )
  as.vector(dirlist)
}
