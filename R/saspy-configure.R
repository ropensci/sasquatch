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
  if (template[1] == "none") {
    configs <- list(config_name = list())
  } else if (template == "oda") {
    oda_username <- readline("Enter your ODA username: ")
    oda_password <- readline("Enter your ODA password: ")
    write_authinfo("oda", oda_username, oda_password, overwrite)

    java_path <- Sys.which("java")
    if (identical(unname(java_path), "")) {
      chk::msg(
        "No java installation found. Enter the java path manually within sascfg_personal.py."
      )
    }

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
      "Europe 2" = list('odaws01-euw1.oda.sas.com', 'odaws02-euw1.oda.sas.com'),
      "Asia Pacific 1" = list(
        'odaws01-apse1.oda.sas.com',
        'odaws02-apse1.oda.sas.com'
      ),
      "Asia Pacific 2" = list(
        'odaws01-apse1-2.oda.sas.com',
        'odaws02-apse1-2.oda.sas.com'
      )
    )
    server_num = menu(names(oda_servers), "Which server is your account on?")
    iom_host = oda_servers[[server_num]]

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

  sascfg_personal_path <- write_sascfg_personal(configs, overwrite)

  if (rstudioapi::hasFun("navigateToFile")) {
    chk::msg("Opening sascfg_personal.py.")
    rstudioapi::navigateToFile(sascfg_personal_path)
  }

  invisible()
}

get_home_dir <- function() {
  home_dir <- Sys.getenv("HOME")
  if (.Platform$OS.type == "windows") {
    home_dir <- regmatches(home_dir, regexpr("(.*?[/|\\\\]){3}", home_dir))
  }
  sub("[/|\\\\]$", "", home_dir)
}

write_authinfo <- function(config_name, username, password, overwrite) {
  if (.Platform$OS.type == "windows") {
    authinfo_path <- paste0(get_home_dir(), "/_authinfo")
  } else {
    authinfo_path <- paste0(get_home_dir(), "/.authinfo")
  }
  if (!overwrite) chk_no_file(authinfo_path, x_name = "authinfo")

  authinfo <- paste(config_name, "user", username, "password", password, "\n")

  write_file(authinfo, file = authinfo_path)

  authinfo_path
}

write_sascfg_personal <- function(configs, overwrite) {
  python <- reticulate::py_discover_config("saspy", "r-saspy")
  saspy_path <- python$required_module_path
  sascfg_personal_path <- paste0(saspy_path, "/sascfg_personal.py")
  if (!overwrite)
    chk_no_file(sascfg_personal_path, x_name = "sascfg_personal.py")

  config_list <- paste(
    "SAS_config_names",
    "=",
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

# created to facilitate mocking within testing
write_file <- function(..., file) {
  cat(..., file = file)
}

menu <- function(choices, title) {
  choice_list <- sapply(seq_along(choices), function(choice_num) {
    paste0(choice_num, ": ", choices[choice_num])
  })
  chk::msg(
    title,
    "\n\n",
    paste(choice_list, collapse = "\n"),
    "\n",
    tidy = FALSE
  )
  repeat {
    selection <- readline("Selection: ")
    if (selection %in% as.character(seq_along(choice_list))) {
      return(as.integer(selection))
    }
    chk::msg("Enter an item from the menu.")
  }
}
