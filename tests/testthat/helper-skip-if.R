skip_if_no_session <- function() {
  if (!valid_session()) {
    skip(message = "No SAS connection.")
  }
}

skip_if_no_saspy_install <- function() {
  skip_if(
    is.null(
      reticulate::py_discover_config("saspy", "r-saspy")$required_module_path
    ),
    "SASPy is not installed."
  )
}

skip_if_no_configuration <- function(config) {
  configs <- sas_cgfnames()
  skip_if(
    is.null(configs) || !(config %in% configs),
    message = paste0("\"", config, "\" configuration cannot be found.")
  )
}
