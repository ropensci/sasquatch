sas_widget <- function(lst, log, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    lst = lst,
    log = log
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sas_widget',
    x,
    width = width,
    height = height,
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      browser.fill = TRUE,
      knitr.figure = FALSE
    ),
    package = 'sasquatch',
    elementId = elementId
  )
}