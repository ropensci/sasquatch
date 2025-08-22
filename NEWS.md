# sasquatch 0.1.0

## Features

- Added `out.height` and `out.width` arguments to HTML engine. HTML engine now returns an htmlwidget (#13)
- Added `capture`, `height`, `width` to `sas_run_string()`. (#13)

## rOpenSci Review Changes

- `configure_saspy()` no longer asks that users type in their SAS ODA username and password within the terminal. See `vignette("secrets", "httr")`.  
- Dataset used to show `sas_to_r()` in `README.md` changed to `warpbreaks` and the variable name of the version of `"sashelp.cars"` was renamed to `sas_cars`.
- Fixed typo in `configure_saspy()`. Changed Europe 2 to Europe 1.  
- Specified `rlang` imports.  
- Added a Code of Conduct.  
- A more informative error is now shown when a `reticulate::use_*` function is used for an environment without `SASPy` installed. (#11)
- `install_saspy()` now supports conda environments. (#11)
