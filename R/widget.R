sas_widget <- function(
  lst,
  log,
  width = NULL,
  height = NULL,
  elementId = NULL
) {
  # forward options using x
  x = list(
    lst = lst,
    log = log
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sas_widget',
    x,
    width = "auto",
    height = "auto",
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      viewer.fill = TRUE,
      browser.fill = TRUE
    ),
    package = 'sasquatch',
    elementId = elementId
  )
}
