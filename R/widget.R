sas_widget <- function(
  lst,
  log,
  capture,
  height = "auto",
  width = "auto",
  elementId = NULL
) {
  # forward options using x
  x <- list(
    lst = lst,
    log = log,
    capture = capture
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sas_widget',
    x,
    height = height,
    width = width,
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      viewer.fill = TRUE,
      browser.fill = TRUE
    ),
    package = 'sasquatch',
    elementId = elementId
  )
}
