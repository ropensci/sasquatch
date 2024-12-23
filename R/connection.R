#' Establish SAS session
#' 
#' @description
#' Starts a SAS session. This is required before doing anything!
#' 
#' @param config Configuration to use from the SAS_config_names list in 
#' `sascfg_personal.py`.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect(config = "oda")
#' }
sas_connect <- function(config) {
  if (!missing(config)) {
    chk::chk_string(config)
  }
  
  if (missing(config)) {
    reticulate::py_capture_output(
      .pkgenv$session <- .pkgenv$SASPy$SASsession()
    )
  } else {
    reticulate::py_capture_output(
      .pkgenv$session <- .pkgenv$SASPy$SASsession(config = config)
    )
  }
  chk::msg("SAS Connection established.")

  invisible()
}

#' Disconnect SAS session
#' 
#' @description
#' Disconnects from the current SAS session.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_disconnect()
#' }
sas_disconnect <- function() {
  chk_connection()
  
  reticulate::py_capture_output(
    .pkgenv$session$endsas()
  )
  .pkgenv$session <- NULL
  chk::msg("SAS Connection terminated.")

  invisible()
}

#' Get current SAS session
#' 
#' Gets current SAS session so that you can use functions not yet implemented.
#' Can also be useful for testing or using Python.
#' 
#' @return Current SAS session.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect()
#' sas_get_session()
#' }
sas_get_session <- function() {
  .pkgenv$session
}

#' Check SAS connection
#' 
#' Checks if a SAS session currently exists. If the SAS session has terminated
#' during the session, `chk_connection()` will not detect it. 
#' 
#' @details 
#' Use `execute_if_connection_active()` for any function that relies on a SAS
#' connection to catch inactive sessions.
chk_connection <- function() {
  if (vld_connection()) {
    return(invisible())
  }
  chk::abort_chk("No active SAS session. Use sas_connect() to start one.")
}
vld_connection <- function() exists("session", envir = .pkgenv) && !is.null(.pkgenv$session)

#' Execute SASPy function if session is active
#' 
#' Executes the code passed to it if the connection is active and provides a 
#' more helpful error message if no connection is active.
#' 
#' @details
#' The SAS connection is asynchronous so it can become inactive without the user
#' knowing. When the connection is inactive and an action is preformed it will 
#' check the connection and raise an error.
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
