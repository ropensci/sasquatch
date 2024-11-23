#' Install SASPy package
#' 
#' @description
#' Installs the SASPy package within a virtual environment.
#' 
#' @param envname Name of virtual environment to install SASPy within. 
#' @param extra_packages Additional packages to install.
#' @param restart_session Restart session? 
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' install_saspy()
#' }
install_saspy <- function(
  envname = "r-saspy",
  extra_packages = NULL,
  restart_session = TRUE
) {
  packages <- unique(c("wheel", "saspy", "pandas"), extra_packages)
  
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

  invisible(NULL)
}

#' Configure SASPy package
#' 
#' @description
#' Adds `sascfg_personal.py` and `authinfo` files and prefills relevant info
#' according to a specified template.
#' 
#' @param template Default template to base configuration files off of.
#' 
#' @return No return value.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' config_saspy()
#' }
configure_saspy <- function(
  template = c("none", "oda")
) {
  python <- reticulate::py_discover_config("saspy", "r-saspy")
  saspy_path <- python$required_module_path
  sascfg_personal_path <- paste0(saspy_path, "/sascfg_personal.py")

  config_name <- "config_name"
  config <- list()

  if (template[1] == "oda") {
    config_name <- "oda"
    oda_username <- readline("Enter your ODA username: ")
    oda_password <- readline("Enter your ODA password: ")
    authinfo <- paste("oda user", oda_username, "password", oda_password)

    if(.Platform$OS.type == "windows") {
      authinfo_path <- paste0(get_home_dir(), "/_authinfo")
    } else {
      authinfo_path <- paste0(get_home_dir(), "/.authinfo")
    }

    if (file.exists(authinfo_path)) {
      overwrite_auth = menu(
        c("Yes", "No"), 
        title = "The authinfo file already exists and you're about to overwrite it.\nDo you want to proceed anyway?"
      )
      if (overwrite_auth == 0) {
        stop("The authinfo file already exists.")
      }
    }
    if (!exists("overwrite_auth") || overwrite_auth == 1) {
      cat("Writing to", authinfo_path, "\n")
      cat(authinfo, file = authinfo_path)
    }

    servers <- list(
      "['odaws01-usw2.oda.sas.com','odaws02-usw2.oda.sas.com','odaws03-usw2.oda.sas.com','odaws04-usw2.oda.sas.com']",
      "['odaws01-usw2-2.oda.sas.com','odaws02-usw2-2.oda.sas.com']",
      "['odaws01-euw1.oda.sas.com','odaws02-euw1.oda.sas.com']",
      "['odaws01-apse1.oda.sas.com','odaws02-apse1.oda.sas.com']",
      "['odaws01-apse1-2.oda.sas.com','odaws02-apse1-2.oda.sas.com']"
    )
    server_num <- menu(
      c("1: United States 1", "2: United States 2", "3: Europe 2", "4: Asia Pacific 1", "Asia Pacific 2"),
      "Which server is your account on?"
    )
    if (overwrite_auth == 0) {
      stop("No server selected.")
    }
    iom_host = servers[server_num]
   
    java_path <- Sys.which("java")
    if (identical(unname(java_path), "")) {
      cat(
        "No java installation path found. Enter the java path manually within:",
        "\n", sascfg_personal_path, "\n"
      )
      java_path <- "java_path"
    }

    config <- list(
      java = java_path,
      iom_host = iom_host,
      iomport = 8591,
      encoding = "utf-8",
      authkey = "oda"
    )
  }
  config_list <- sub("''", paste0("'", config_name, "'"), "SAS_config_names = ['']")
  config_dict <- list_to_config_dict(config, config_name)
  sascfg_personal <- paste0(config_list, "\n\n", config_dict)
    
  if (file.exists(sascfg_personal_path)) {
    overwrite_sascfg = menu(
      c("Yes", "No"), 
      title = "The sascfg_personal.py file already exists and you're about to overwrite it.\nDo you want to proceed anyway?"
    )
    if (overwrite_sascfg == 0) {
      stop("The sascfg_personal.py file already exists.")
    }
  }
  if (!exists("overwrite_sascfg") || overwrite_sascfg == 1) {
    cat("Writing to", sascfg_personal_path, "\n")
    cat(sascfg_personal, file = sascfg_personal_path)
  }

  if (rstudioapi::hasFun("navigateToFile")) {
    cat("Opening sascfg_personal.py.\n")
    rstudioapi::navigateToFile(sascfg_personal_path)
  }

  invisible()
}

list_to_config_dict <- function(list, config_name) {
  config_key_pairs <- sapply(
    names(list), 
    function(name) {
      key <- paste0("'", name, "' : ")
      value <- list[[name]]
      if (is.character(value)) {
        value <- paste0("'", value, "'")
      }
      paste0(key, value)
    }
  )
  config_key_pairs <- paste0(paste0("\t", config_key_pairs), collapse = ",\n")

  paste0(config_name, " = {\n", config_key_pairs, "\n}")
}

get_home_dir <- function() {
  home_dir <- Sys.getenv("HOME")
  if(.Platform$OS.type == "windows") {
    home_dir <- regmatches(home_dir, regexpr("(.*?[/|\\\\]){3}", home_dir))
  }
  sub("[/|\\\\]$", "", home_dir)
}