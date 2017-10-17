#'
#'

colourGroupInput <- function(inputId) {
  ns <- NS(inputId)
  tagList(
    strong(textOutput(ns("heading"))),
    uiOutput(ns("colorChoosers"))
  )
}

#'
#'

colourGroup <- function(input, output, session, heading = "", options="",
                        labels = "", value = "", ...){
  ns <- session$ns
  ids <- reactive(sapply(options, function(option) paste(option, "inputId", sep = "_")))

  cols <- reactive({
    if (length(options) != 0){
      sapply(1:length(options), function(i) {
        if (!is.null(input[[as.character(ids()[i])]])){
          setNames(input[[as.character(ids()[i])]], options[i])
        }
      })
    }
  })

  if (length(cols) == 0){
    cols2 <- NULL
  } else {
    cols2 <- debounce(cols, 2000)
  }

  output$heading <- renderText({
    heading
  })

  output$colorChoosers <- renderUI({
    if (length(options) != 0){
      L <- vector("list", length(options))
      for (i in 1:length(L)){
        if (is.null(input[[as.character(ids()[i])]])) {
          color <- palette()[(i %% length(palette())) + 1]
        } else {
          color <- input[[as.character(ids()[i])]]
        }
        L[[i]] <- list(do.call(colourpicker::colourInput,
                               list(ns(ids()[i]), label = options[i],
                                    value = color, ...)))
      }
      return(L)
    }
  })
  return(cols2)
}