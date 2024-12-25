#' Establish SAS session
#' 
#' @description
#' Starts a SAS session. This is required before doing anything!
#' 
#' @param cfgname string; Name of configuration to use from the SAS_config_names
#' list in `sascfg_personal.py`.
#' 
#' @details
#' All configurations are specified within the `sascfg_personal.py` file inside
#' the `SASPy` package. For more information about `SASPy` configuration, check
#' out the [configuration documentation](https://sassoftware.github.io/saspy/configuration.html)
#' or `vignette("setting_up")`.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' sas_connect(cfgname = "oda")
#' }
sas_connect <- function(cfgname) {
  if (!missing(cfgname)) {
    chk::chk_string(cfgname)
  }
  
  if (missing(cfgname)) {
    reticulate::py_capture_output(
      .pkgenv$session <- .pkgenv$SASPy$SASsession()
    )
  } else {
    reticulate::py_capture_output(
      .pkgenv$session <- .pkgenv$SASPy$SASsession(cfgname = cfgname)
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
#' Returns the current SAS session, which can be used to extend `sasquatch`
#' functionality or access the current session within Python.
#' 
#' @return Current SAS session.
#' 
#' @details
#' ## Extending `sasquatch` functionality
#' `SASPy` has a wealth of functionality that has not been implemented within 
#' `sasquatch`. `sas_get_session()` offers a gateway to unimplemented
#' functionality within the [SASsession class](https://sassoftware.github.io/saspy/api.html#sas-session-object).
#' 
#' ## Using Python
#' When utilizing Python, R, and SAS, start the session within R using 
#' `sas_connect()` and utilize `reticulate` to pass the current SAS session
#' to Python.
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
#' 
#' @keywords internal
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
