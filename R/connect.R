#' Establish SAS session
#'
#' @description
#' Starts a SAS session. This is required before doing anything!
#'
#' @param cfgname string; Name of configuration to use from the SAS_config_names
#' list within in `sascfg_personal.py`.
#' @param reconnect logical; Establish a new connection if a connection already
#' exists?
#'
#' @details
#' All configurations are specified within the `sascfg_personal.py` file inside
#' the `SASPy` package. For more information about `SASPy` configuration, check
#' out the [configuration documentation](https://sassoftware.github.io/saspy/configuration.html)
#' or `vignette("configuration")`.
#'
#' @return No return value.
#'
#' @export
#'
#' @family session management functions
#' @examples
#' \dontrun{
#' sas_connect(cfgname = "oda")
#' }
sas_connect <- function(cfgname, reconnect = FALSE) {
  if (!missing(cfgname)) {
    check_string(cfgname)
  }
  check_logical(reconnect)

  if (valid_session()) {
    if (reconnect) {
      sas_disconnect()
    } else {
      cli::cli_warn(
        "SAS connection already established. Specify {.code reconnect = TRUE} to establish a new connection."
      )
      return(invisible())
    }
  }

  if (missing(cfgname)) {
    reticulate::py_capture_output(
      .pkgenv$session <- .pkgenv$SASPy$SASsession()
    )
  } else {
    check_cfgname(cfgname)

    reticulate::py_capture_output(
      .pkgenv$session <- .pkgenv$SASPy$SASsession(cfgname = cfgname)
    )
  }
  cli::cli_alert_success("SAS connection established.")

  invisible()
}

check_cfgname <- function(cfgname, call = rlang::caller_env()) {
  configs <- sas_cgfnames()
  if (is.null(configs)) {
    cli::cli_abort(
      c(
        "x" = "No configurations found.",
        "i" = "Use {.fun sasquatch::config_saspy} to set up a connection and check out the {.vignette sasquatch::configuration} vignette."
      ),
      call = call
    )
  }
  if (!(cfgname %in% configs)) {
    cli::cli_abort(
      c(
        "{.arg cfgname} must specify an existing configuration.",
        "x" = "`{.val {cfgname}} cannot be found.",
        "i" = "Available configurations include: {.val {configs}}"
      ),
      call = call
    )
  }
}

sas_cgfnames <- function() {
  reticulate::py_capture_output(
    configs <- reticulate::py_to_r(reticulate::py_get_attr(
      .pkgenv$SASPy$SASconfig()$`_find_config`(),
      "SAS_config_names",
      silent = TRUE
    ))
  )
  configs
}
