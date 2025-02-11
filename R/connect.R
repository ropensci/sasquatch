#' Establish SAS session
#' 
#' @description
#' Starts a SAS session. This is required before doing anything!
#' 
#' @param cfgname string; Name of configuration to use from the SAS_config_names
#' list within in `sascfg_personal.py`.
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
