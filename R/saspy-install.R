# derived from https://github.com/rstudio/tensorflow//blob/main/R/install.R

#' Install SASPy package
#'
#' @description
#' Installs the `SASPy` package and its dependencies within a
#' virtual Python environment.
#'
#' Behavior was derived from `tensorflow::install_tensorflow()`.
#'
#' @param method By default, `“auto”` automatically finds a method that
#' will work in the local environment. Change the default to force a
#' specific installation method.
#' @param conda The path to a conda executable. Use `"auto"` to allow reticulate to automatically find an
#' appropriate conda binary.
#' @param envname The name, or full path, of the environment in which Python packages are to be installed.
#' @param extra_packages Additional packages to install.
#' @param restart_session Restart session?
#' @param conda_python_version Passed to conda (only applicable if `method = "conda"`)
#' @param ... other arguments passed to [`reticulate::conda_install()`] or [`reticulate::virtualenv_install()`],
#' depending on the `method` used.
#' @param pip_ignore_installed Should pip ignore installed python packages and reinstall all already installed
#' python packages?
#' @param new_env If `TRUE`, any existing Python virtual environment and/or conda environment specified by
#' `envname` is deleted first.
#' @param python_version Select the Python that will be used to create the virtualenv. Pass a string with
#' version constraints like `"3.8"`, or `">=3.9,<=3.11"` or a file path to a `python` executable like
#' `"/path/to/bin/python3"`. The supplied value is passed on to `reticulate::virtualenv_starter()`.
#' Note that `SASPy` requires a Python version of at least >3.4.
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
  method = c("auto", "virtualenv", "conda"),
  conda = "auto",
  envname = "r-saspy",
  extra_packages = NULL,
  restart_session = TRUE,
  conda_python_version = NULL,
  ...,
  pip_ignore_installed = FALSE,
  new_env = identical(envname, "r-saspy"),
  python_version = NULL
) {
  method <- rlang::arg_match(method)
  check_string(conda)
  check_string(envname)
  check_character(extra_packages, allow_null = TRUE)
  check_bool(restart_session)
  check_bool(pip_ignore_installed)
  check_string(python_version, allow_null = TRUE)

  packages <- c("wheel", "saspy", "pandas")
  packages <- unique(c(packages, extra_packages))

  if (isTRUE(new_env)) {
    if (
      # fmt: skip
      method %in% c("auto", "virtualenv") &&
        reticulate::virtualenv_exists(envname)
    ) {
      reticulate::virtualenv_remove(envname = envname, confirm = FALSE)
    }

    if (method %in% c("auto", "conda")) {
      if (
        !is.null(tryCatch(
          reticulate::conda_python(envname, conda = conda),
          error = function(e) NULL
        ))
      ) {
        reticulate::conda_remove(envname, conda = conda)
      }
    }
  }

  reticulate::py_install(
    packages = packages,
    envname = envname,
    method = method,
    conda = conda,
    python_version = python_version,
    pip = TRUE,
    pip_ignore_installed = pip_ignore_installed,
    ...
  )

  if (restart_session && rstudioapi::hasFun("restartSession")) {
    rstudioapi::restartSession()
  }

  invisible()
}
