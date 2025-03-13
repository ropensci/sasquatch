#' Install SASPy package
#'
#' @description
#' Installs the `SASPy` package and its dependencies within a
#' virtual Python environment.
#'
#' @param envname Name of virtual environment to install SASPy within.
#' @param extra_packages Additional packages to install.
#' @param restart_session Restart session?
#'
#' @return No return value.
#'
#' @export
#'
#' @seealso [configure_saspy()]
#' @examples
#' \dontrun{
#' install_saspy()
#' }
install_saspy <- function(
  envname = "r-saspy",
  extra_packages,
  restart_session = TRUE
) {
  check_string(envname)
  packages <- c("wheel", "saspy", "pandas")
  if (!missing(extra_packages)) {
    check_character(extra_packages)
    packages <- c(packages, extra_packages)
  }
  check_bool(restart_session)

  if (reticulate::virtualenv_exists(envname)) {
    reticulate::virtualenv_remove(envname = envname, confirm = FALSE)
  }
  reticulate::py_install(
    packages = packages,
    envname = envname
  )

  if (restart_session && rstudioapi::hasFun("restartSession")) {
    rstudioapi::restartSession()
  }

  invisible()
}
