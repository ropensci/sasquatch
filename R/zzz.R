.pkgenv <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  Sys.setenv(RETICULATE_USE_MANAGED_VENV = "no")

  reticulate::py_require(
    c("wheel", "saspy", "pandas"),
    ">3.4"
  )
  .pkgenv$SASPy <- reticulate::import(
    "saspy",
    delay_load = list(
      on_error = function(error) {
        get_saspy_path()
      },
      environment = "r-saspy"
    )
  )
  knitr::knit_engines$set(sas = sas_engine)

  # adjusts iframe sizing so that they will adapt to the size of their
  # content dynamically
  knitr::knit_hooks$set(document = function(x, options) {
    if (is_latex_output()) {
      sas_style_dependency <- list(
        name = ".sasquatch/sas_style",
        options = NULL,
        extra_lines = NULL
      )
      class(sas_style_dependency) <- "latex_dependency"
      knitr::knit_meta_add(list(sas_style_dependency))

      x_split <- unlist(strsplit(x, "\n"))
      graphics_rows <- grepl("\\includegraphics{", x_split, fixed = TRUE)
      picture_urls <- regmatches(
        x_split[graphics_rows],
        m = regexpr(
          "(?<=\\\\includegraphics\\{)(.*)(?=\\}$)",
          x_split[graphics_rows],
          perl = TRUE
        )
      )
      x_split[graphics_rows] <- paste0(
        "![](",
        vapply(picture_urls, knitr::image_uri, FUN.VALUE = character()),
        ")"
      )
      lapply(picture_urls, file.remove)

      paste(x_split, collapse = "\n")
    } else {
      x
    }
  })
}
