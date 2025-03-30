valid_session <- function() {
  exists("session", envir = .pkgenv) &&
    !is.null(.pkgenv$session) &&
    !is.null(.pkgenv$session$SASpid)
}

#' Check SAS session
#'
#' Checks if a SAS session currently exists. If the SAS session has terminated
#' during the session, `check_session()` will not detect it.
#'
#' @details
#' Use `execute_if_connection_active()` for any function that relies on a SAS
#' connection to catch inactive sessions.
#'
#' @keywords internal
check_session <- function(call = rlang::caller_env()) {
  if (!valid_session()) {
    cli::cli_abort(
      c(
        "x" = "No active SAS connection.",
        "i" = "Use {.fun sasquatch::sas_connect} to start a new SAS session."
      ),
      call = call
    )
  }
}

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
execute_if_connection_active <- function(code, call = rlang::caller_env()) {
  tryCatch(
    {
      code
    },
    error = function(e) {
      if (is.null(.pkgenv$session$SASpid)) {
        cli::cli_abort(
          c(
            "x" = "SAS connection has terminated unexpectedly.",
            "i" = "Use {.fun sasquatch::sas_connect} to start new SAS session."
          ),
          call = call
        )
      } else {
        e
      }
    }
  )
}
