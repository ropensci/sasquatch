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

skip_if_no_configuration <- function(config, require_jars = FALSE) {
  configs <- sas_cgfnames()

  if (is.null(configs) || !(config %in% configs)) {
    skip(
      message = paste0("\"", config, "\" configuration cannot be found.")
    )
  }

  if (require_jars) {
    saspy_path <- reticulate::py_discover_config(
      "saspy",
      "r-saspy"
    )$required_module_path

    skip_if(
      !all(
        c("sas.rutil.jar", "sas.rutil.nls.jar", "sastpj.rutil.jar") %in%
          list.files(file.path(saspy_path, "java/iomclient"))
      ),
      message = "Encryption jar files not found"
    )
  }
}
