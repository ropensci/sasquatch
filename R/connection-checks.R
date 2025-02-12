#' Check SAS session
#' 
#' Checks if a SAS session currently exists. If the SAS session has terminated
#' during the session, `chk_session()` will not detect it. 
#' 
#' @details 
#' Use `execute_if_connection_active()` for any function that relies on a SAS
#' connection to catch inactive sessions.
#' 
#' @keywords internal
chk_session <- function() {
  if (vld_session()) {
    return(invisible())
  }
  chk::abort_chk("No active SAS session. Use sas_connect() to start one.")
}
vld_session <- function() exists("session", envir = .pkgenv) && !is.null(.pkgenv$session) && !is.null(.pkgenv$session$SASpid)

#' Execute SASPy function if session is active
#' 
#' Executes the code passed to it if the connection is active and provides a 
#' more helpful error message if no connection is active.
#' 
#' @details
#' The SAS connection is asynchronous so it can become inactive without the user
#' knowing. When the connection is inactive and an action is preformed it will 
#' check the connection and raise an error.
#' 
#' @keywords internal
execute_if_connection_active <- function(code) {
  calling_env <- parent.frame()
  tryCatch({
    code
  }, error = function(e) {
    if (is.null(.pkgenv$session$SASpid)) {
      chk::err("SAS process has terminated unexpectedly. Use sas_connect() to start new one.")
    } else {
      e
    }
  })
}
