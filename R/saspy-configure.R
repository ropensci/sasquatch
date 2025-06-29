#' Configure SASPy package
#'
#' @description
#' Adds `sascfg_personal.py` and `authinfo` files and prefills relevant info
#' according to a specified template.
#'
#' @param template Default template to base configuration files off of.
#' @param overwrite Can new configuration files overwrite existing config files (if they exist)?
#'
#' @details
#' Configuration for SAS can vary greatly based on your computer's operating
#' system and the SAS platform you wish to connect to (see
#' `vignette("configuration")` for more information).
#'
#' Regardless of your desired configuration, configuration always starts with
#' the creation of a `sascfg_personal.py` file within the `SASPy` package
#' installation. This will look like:
#'
#' ```
#' SAS_config_names = ['config_name']
#'
#' config_name = {
#'
#' }
#' ```
#'
#' `SAS_config_names` should contain a string list of the variable names
#' of all configurations. Configurations are specified as dictionaries,
#' and configuration parameters depend on the access method.
#'
#' Additionally, some access methods will require an additional
#' authentication file (`.authinfo` for Linux and Mac, `_authinfo`
#' for Windows) stored in the user's home directory, which are
#' constructed as follows:
#'
#' ```
#' config_name user {your username} password {your password}
#' ```
#'
#' ### Templates
#'
#' The `"none"` template simply creates a `sascfg_personal.py` file within
#' the `SASPy` package installation.
#'
#' The `"oda"` template will set up a configuration for SAS On Demand for
#' Academics. The `sascfg_personal.py` and `authinfo` files will be
#' automatically configured using the information you provide through prompts.
#'
#' @return No return value.
#'
#' @export
#'
#' @seealso [install_saspy()]
#' @examples
#' \dontrun{
#' config_saspy()
#' }
configure_saspy <- function(
  template = c("none", "oda"),
  overwrite = FALSE
) {
  template <- rlang::arg_match(template, c("none", "oda"))

  saspy_path <- get_saspy_path()

  if (template == "none") {
    configs <- list(config_name = list())
  } else if (template == "oda") {
    java_path <- check_java_installation(saspy_path)
    iom_host <- ask_oda_server()

    configs <- list(
      oda = list(
        java = java_path,
        iomhost = iom_host,
        iomport = 8591L,
        encoding = "utf-8",
        authkey = "oda"
      )
    )
  }

  write_sascfg_personal(configs, saspy_path, overwrite)

  if (template == "oda") {
    write_authinfo_template(overwrite)
    sas_oda_jar_dir <- paste0(saspy_path, "/java/iomclient/")
    cli::cli_inform(c(
      "i" = "Download and extract the SAS ODA zip encryption jars ({.url https://support.sas.com/downloads/package.htm?pid=2494}) into {.file {sas_oda_jar_dir}}."
    ))
  }

  cli::cli_inform(c(
    "i" = "For more information about {.pkg SASPy} configuration see the {.vignette sasquatch::configuration} vignette or the {.href [SASPy documentation](https://sassoftware.github.io/saspy/configuration.html)}."
  ))

  invisible()
}

get_saspy_path <- function() {
  python <- reticulate::py_discover_config("saspy", "r-saspy")
  saspy_path <- python$required_module_path
  if (is.null(saspy_path)) {
    cli::cli_abort(
      "No SASPy installation found. Use {.fun sasquatch::install_saspy} to install SASPy."
    )
  }
  saspy_path
}

check_java_installation <- function(saspy_path) {
  java_path <- Sys.which("java")
  if (identical(unname(java_path), "")) {
    sascfg_personal_path <- paste0(saspy_path, "/sascfg_personal.py")
    cli::cli_warn(
      "No java installation found. Enter the java path manually within {.file {sascfg_personal_path}}."
    )
  }

  java_path
}

ask_oda_server <- function() {
  oda_servers <- list(
    "United States 1" = list(
      'odaws01-usw2.oda.sas.com',
      'odaws02-usw2.oda.sas.com',
      'odaws03-usw2.oda.sas.com',
      'odaws04-usw2.oda.sas.com'
    ),
    "United States 2" = list(
      'odaws01-usw2-2.oda.sas.com',
      'odaws02-usw2-2.oda.sas.com'
    ),
    "Europe 1" = list('odaws01-euw1.oda.sas.com', 'odaws02-euw1.oda.sas.com'),
    "Asia Pacific 1" = list(
      'odaws01-apse1.oda.sas.com',
      'odaws02-apse1.oda.sas.com'
    ),
    "Asia Pacific 2" = list(
      'odaws01-apse1-2.oda.sas.com',
      'odaws02-apse1-2.oda.sas.com'
    )
  )

  cli::cli_inform("Which server is your account on?")
  server_num = utils::menu(
    names(oda_servers)
  )
  if (server_num == 0L) {
    cli::cli_abort("Server location required to create SAS ODA configuration.")
  }

  oda_servers[[server_num]]
}

write_authinfo_template <- function(
  overwrite,
  call = rlang::caller_env()
) {
  if (.Platform$OS.type == "windows") {
    authinfo_path <- paste0(get_home_dir(), "/_authinfo")
  } else {
    authinfo_path <- paste0(get_home_dir(), "/.authinfo")
  }
  if (!overwrite) {
    check_no_file(authinfo_path, call)
  }

  authinfo <- "oda user {username} password {password}\n"
  write_file(authinfo, file = authinfo_path)

  cli::cli_inform(c(
    "i" = "Replace {.str {{username}}} and {.str {{password}}} with your ODA username and password within {.file {authinfo_path}}."
  ))

  if (rstudioapi::hasFun("navigateToFile")) {
    rstudioapi::navigateToFile(authinfo_path)
  }
}

get_home_dir <- function() {
  home_dir <- Sys.getenv("HOME")
  if (.Platform$OS.type == "windows") {
    home_dir <- regmatches(home_dir, regexpr("(.*?[/|\\\\]){3}", home_dir))
  }
  sub("[/|\\\\]$", "", home_dir)
}

write_sascfg_personal <- function(
  configs,
  saspy_path,
  overwrite,
  call = rlang::caller_env()
) {
  sascfg_personal_path <- paste0(saspy_path, "/sascfg_personal.py")

  if (!overwrite) {
    check_no_file(sascfg_personal_path, call)
  }

  config_list <- paste0(
    "SAS_config_names = ",
    reticulate::r_to_py(list(names(configs)))
  )
  config_dicts <- sapply(names(configs), function(config_name) {
    paste(
      config_name,
      "=",
      as.character(reticulate::dict(configs[[config_name]]))
    )
  })
  contents <- paste(
    config_list,
    paste(config_dicts, collapse = "\n\n"),
    "",
    sep = "\n"
  )

  write_file(contents, file = sascfg_personal_path)

  sascfg_personal_path
}

write_file <- function(..., file) {
  cli::cli_alert_success("Writing to {.path {file}}.")
  cat(..., file = file)
}
