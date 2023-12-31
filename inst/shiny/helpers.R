# All the code in this file needs to be copied to your Shiny app, and you need
# to call `withBusyIndicatorUI()` and `withBusyIndicatorServer()` in your app.
# You can also include the `appCSS` in your UI, as the example app shows.

# =============================================

# Set up a button to have an animated loading indicator and a checkmark
# for better user experience
# Need to use with the corresponding `withBusyIndicator` server function
withBusyIndicatorUI <- function(button) {
  id <- button[["attribs"]][["id"]]
  div(
    `data-for-btn` = id,
    button,
    span(
      class = "btn-loading-container",
      hidden(
        img(src = "ajax-loader-bar.gif", class = "btn-loading-indicator"),
        icon("check", class = "btn-done-indicator")
      )
    ),
    hidden(
      div(class = "btn-err",
          div(icon("exclamation-circle"),
              tags$b("Error: "),
              span(class = "btn-err-msg")
          )
      )
    )
  )
}

# does the same thing as above, but put the animation inside the button label
actionButtonBusy <- function(buttonId, buttonTitle) {
  tags$div(
    `data-for-btn` = buttonId,
    actionButton(
      buttonId,
      tags$div(
        buttonTitle,
        tags$span( class = "btn-loading-container", style = "float:right",
                   hidden(
                     img(src = "ajax-loader-bar.gif", class = "btn-loading-indicator"),
                     icon("check", class = "btn-done-indicator")
                   )
        )
      )
    ),
    hidden(
      div(class = "btn-err",
          div(icon("exclamation-circle"),
              tags$b("Error: "),
              span(class = "btn-err-msg")
          )
      )
    )
  )
}

# Call this function from the server with the button id that is clicked and the
# expression to run when the button is clicked
withBusyIndicatorServer <- function(buttonId, expr) {
  # UX stuff: show the "busy" message, hide the other messages, disable the button
  loadingEl <- sprintf("[data-for-btn=%s] .btn-loading-indicator", buttonId)
  doneEl <- sprintf("[data-for-btn=%s] .btn-done-indicator", buttonId)
  errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
  shinyjs::disable(buttonId)
  shinyjs::show(selector = loadingEl)
  shinyjs::hide(selector = doneEl)
  shinyjs::hide(selector = errEl)
  on.exit({
    shinyjs::enable(buttonId)
    shinyjs::hide(selector = loadingEl)
  })

  # Try to run the code when the button is clicked and show an error message if
  # an error occurs or a success message if it completes
  tryCatch({
    value <- expr
    shinyjs::show(selector = doneEl)
    shinyjs::delay(2000, shinyjs::hide(selector = doneEl, anim = TRUE, animType = "fade",
                                       time = 0.5))
    value
  }, error = function(err){
    errorFunc(err, buttonId)
  })
}

# When an error happens after a button click, show the error
errorFunc <- function(err, buttonId) {
  message(paste0(date(), " !!! ", err))
  shinyalert("Error", text = err$message, type = "error")
  errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
  errElMsg <- sprintf("[data-for-btn=%s] .btn-err-msg", buttonId)
  errMessage <- gsub("^ddpcr: (.*)", "\\1", err$message)
  shinyjs::html(html = errMessage, selector = errElMsg)
  shinyjs::show(selector = errEl, anim = TRUE, animType = "fade")
}

appCSS <- "
.btn-loading-container {
  margin-left: 10px;
  font-size: 1.2em;
}
.btn-done-indicator {
  color: green;
}
.btn-err {
  margin-top: 10px;
  color: red;
}
"

# Accordion - formatting for collapsible section in an accordion
# Use example:
#     HTML('<div class="accordion" id="myAccordion">
#       <div class="panel">'),

#         HTML(accordionSection("1","2","myAccordion")),
#           # panel content code,
#         HTML('</div>'),

#       HTML('</div>
#     </div>')
accordionSection <- function(collapseId, panelTitle, accordionId) {
  return(
    paste(
      '<button type="button" class="btn btn-default btn-block" ',
      'data-toggle="collapse" data-target="#', collapseId, '" data-parent="#', accordionId, '">',
      panelTitle,
      '</button>
      <div id="', collapseId, '" class="collapse">',
      sep = ""
    )
  )
}

# show or hide all collapses in a list
allSections <- function(action, collapseList) {
  if (action == "hide"){
    for (i in collapseList){
      shinyjs::hide(i, anim = TRUE)
    }
  }
  else if (action == "show"){
    for (i in collapseList){
      shinyjs::show(i, anim = TRUE)
    }
  }
}

withConsoleRedirect <- function(expr) {
  options(warn = 1)
  tmpSinkfileName <- tempfile()
  tmpFD <- file(tmpSinkfileName, open = "wt")
  sink(tmpFD, type="output", split = TRUE)
  sink(tmpFD, type = "message")

  result <- expr

  sink(type = "message")
  sink()
  console.out <- readChar(tmpSinkfileName, file.info(tmpSinkfileName)$size)
  unlink(tmpSinkfileName)
  if (length(console.out) > 0) {
    insertUI(paste0("#", "console"), where = "beforeEnd",
             ui = tags$p(paste0(console.out, "\n", collapse = ""))
    )
  }
  result
}

withConsoleMsgRedirect <- function(expr, msg="Please wait. See console log for progress.") {
  withCallingHandlers(
    expr = {
      .loadOpen(msg)
      tryCatch(
        {
          result <- expr
        },
        error = function(e) {
          message(paste0(date(), " !!! ", e))
          shinyalert("Error", text = e$message, type = "error",
                     callbackR = .loadClose())
        }
      )
      .loadClose()
    },
    message = function(m) {
      shinyjs::html(id = "consoleText", html = m$message, add = TRUE)
    }
  )
}


#-----------#
# Gene Sets #
#-----------#
formatGeneSetList <- function(setListStr) {
  setListArr <- strsplit(setListStr, "\n")[[1]]
  setListList <- list()
  for (set in setListArr) {
    setListList[[set]] <- set
  }
  return(setListList)
}

formatGeneSetDBChoices <- function(dbIDs, dbCats) {
  splitIds = strsplit(dbIDs, " ")
  choices <- list()

  for (i in seq_along(splitIds)) {
    entry <- splitIds[i][[1]]
    choices[[sprintf("%s - %s", entry, dbCats[i])]] <- entry
  }

  return(choices)
}


#--------------#
# QC/Filtering #
#--------------#
combineQCMPlots <- function(input, output, combineP, sampleList, plots, plotIds, statuses) {
  if (length(sampleList) == 1) {
    # Plot output code from https://gist.github.com/wch/5436415/
    output[[plotIds$QCMetrics]] <- renderUI({
      plot_output_list <- lapply(names(plots), function(subScore) {
        subPlotID <- paste0("QCMetrics", subScore)
        plotOutput(subPlotID)
      })

      # Convert the list to a tagList - this is necessary for the list of items
      # to display properly.
      do.call(tagList, plot_output_list)
    })

    for (subScore in names(plots)) {
      # Need local so that each item gets its own number. Without it, the value
      # of i in the renderPlot() will be the same across all instances, because
      # of when the expression is evaluated.
      local({
        my_subScore <- subScore
        subPlotID <- paste0("QCMetrics", subScore)
        output[[subPlotID]] <- renderPlot(plots[[my_subScore]])
      })
    }
  } else {
    output[[plotIds$QCMetrics]] <- renderUI({
      plot_output_list <- lapply(names(plots$Violin), function(subScore) {
        subPlotID <- paste0("QCMetrics", subScore)
        if (is.null(input$subScore)){
          plotOutput(subPlotID)
        }
      })

      # Convert the list to a tagList - this is necessary for the list of items
      # to display properly.
      do.call(tagList, plot_output_list)
    })

    for (subScore in names(plots$Violin)) {
      # Need local so that each item gets its own number. Without it, the value
      # of i in the renderPlot() will be the same across all instances, because
      # of when the expression is evaluated.
      local({
        my_subScore <- subScore
        subPlotID <- paste0("QCMetrics", my_subScore)

        output[[subPlotID]] <- renderPlot(plots$Violin[[my_subScore]])
      })
    }
  }
}

combineQCSubPlots <- function(output, combineP, algo, sampleList, plots, plotIds, statuses) {
  if (length(sampleList) == 1) {
    # Plot output code from https://gist.github.com/wch/5436415/
    output[[plotIds[[algo]]]] <- renderUI({
      plot_output_list <- lapply(names(plots), function(subScore) {
        subPlotID <- paste(c(algo, subScore), collapse="")
        plotOutput(subPlotID)
      })

      # Convert the list to a tagList - this is necessary for the list of items
      # to display properly.
      do.call(tagList, plot_output_list)
    })

    for (subScore in names(plots)) {
      # Need local so that each item gets its own number. Without it, the value
      # of i in the renderPlot() will be the same across all instances, because
      # of when the expression is evaluated.
      local({
        my_subScore <- subScore
        subPlotID <- paste(c(algo, my_subScore), collapse="")
        output[[subPlotID]] <- renderPlot(plots[[my_subScore]])
      })
    }
  } else {
    tabsetID <- paste0(algo, "Tabs") # for the tabsetPanel within a tab
    mainPlotID <- paste0(plotIds[[algo]], "Main")
    if (!is.null(plots$Violin)) {
      output[[plotIds[[algo]]]] <- renderUI(plotOutput(mainPlotID))
      output[[mainPlotID]] <- renderPlot(plots$Violin)
    }


    for (i in seq_along(sampleList)) {
      local({
        s <- sampleList[[i]]
        sID <- paste(c(algo, s, "Tab"), collapse = "")
        if (is.null(statuses[[algo]][[s]])) {
          if (i == 1) {
            appendTab(tabsetID, tabPanel(s, uiOutput(sID)), select = TRUE)
          } else {
            appendTab(tabsetID, tabPanel(s, uiOutput(sID)), select = FALSE)
          }

        }
        # Plot output code from https://gist.github.com/wch/5436415/
        output[[sID]] <- renderUI({
          plot_output_list <- lapply(names(plots$Sample[[s]]), function(subScore) {
            subPlotID <- paste(c(algo, s, subScore), collapse="")
            plotOutput(subPlotID)
          })

          # Convert the list to a tagList - this is necessary for the list of items
          # to display properly.
          do.call(tagList, plot_output_list)
        })

        for (subScore in names(plots$Sample[[s]])) {
          # Need local so that each item gets its own number. Without it, the value
          # of i in the renderPlot() will be the same across all instances, because
          # of when the expression is evaluated.
          local({
            my_subScore <- subScore
            subPlotID <- paste(c(algo, s, my_subScore), collapse="")

            output[[subPlotID]] <- renderPlot(plots$Sample[[s]][[my_subScore]])
          })
        }
      })
    }
  }
}


arrangeQCPlots <- function(inSCE, input, output, algoList, sampleList, plotIDs, statuses, redDimName) {
  uniqueSampleNames <- unique(sampleList)
  combineP <- "none"
  for (a in algoList) {
    if (a == "scDblFinder") {
      dcPlots <- plotScDblFinderResults(inSCE, combinePlot = combineP, sample = sampleList,
                                         reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, dcPlots, plotIDs, statuses)
    } else if (a == "cxds") {
      cxPlots <- plotCxdsResults(inSCE, combinePlot = combineP, sample = sampleList,
                                 reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, cxPlots, plotIDs, statuses)
    } else if (a == "bcds") {
      bcPlots <- plotBcdsResults(inSCE, combinePlot = combineP, sample = sampleList,
                                 reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, bcPlots, plotIDs, statuses)
    } else if (a == "cxds_bcds_hybrid") {
      cxbcPlots <- plotScdsHybridResults(inSCE, combinePlot = combineP, sample = sampleList,
                                         reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, cxbcPlots, plotIDs, statuses)
    } else if (a == "decontX") {
      dxPlots <- plotDecontXResults(inSCE, combinePlot = combineP, sample = sampleList,
                                    reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, dxPlots, plotIDs, statuses)
    } else if (a == "soupX") {
      soupXPlots <- plotSoupXResults(inSCE, combinePlot = combineP, 
                                     sample = sampleList)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, soupXPlots, plotIDs, statuses)
    } else if (a == "QCMetrics") {
      qcmPlots <- plotRunPerCellQCResults(inSCE, sample = sampleList, combinePlot = combineP)
      combineQCMPlots(input, output, combineP, uniqueSampleNames, qcmPlots, plotIDs, statuses)

    } else if (a == "scrublet") {
      sPlots <- plotScrubletResults(inSCE, combinePlot = combineP, sample = sampleList,
                                    reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, sPlots, plotIDs, statuses)
      return(sPlots)

    } else if (a == "doubletFinder") {
      dfPlots <- plotDoubletFinderResults(inSCE, combinePlot = combineP, sample = sampleList,
                                          reducedDimName = redDimName)
      combineQCSubPlots(output, combineP, a, uniqueSampleNames, dfPlots, plotIDs, statuses)
    }
  }
}


findOverlapping <- function(arr1, arr2) {
  filter <- vector()
  for (x in arr1) {
    if (x %in% arr2) {
      filter <- c(filter, TRUE)
    } else {
      filter <- c(filter, FALSE)
    }
  }
  return(arr1[filter])
}

addToColFilterParams <- function(name, categorial, criteria, criteriaGT, criteriaLT, id, paramsReactive) {
  threshStr <- ""
  if (categorial) {
    threshArr <- list()
    for (c in criteria) {
      threshArr <- c(threshArr, sprintf("%s == '%s'", name, c))
    }
    threshStr <- paste(threshArr, collapse = " | ")
  } else {
    if (is.null(criteriaGT)) {
      threshStr <- sprintf("%s < %.5f", name, criteriaLT)
    } else if (is.null(criteriaLT)) {
      threshStr <- sprintf("%s > %.5f", name, criteriaGT)
    } else {
      threshStr <- sprintf("%s > %.5f & %s < %.5f", name, criteriaGT, name, criteriaLT)
    }
  }

  entry <- list(col=name, param=threshStr, id=id)
  paramsReactive$params <- c(paramsReactive$params, list(entry))
  paramsReactive$id_count <- paramsReactive$id_count + 1
}

addToRowFilterParams <- function(name, X, Y, id, paramsReactive) {
  entry <- reactiveValues(row=name, X=X, Y=Y, id=id)
  paramsReactive$params <- c(paramsReactive$params, list(entry))
  paramsReactive$id_count <- paramsReactive$id_count + 1
}


formatFilteringCriteria <- function(paramsReactive) {
  criteria = list()
  for (entry in paramsReactive) {
    criteria <- c(criteria, entry$param)
  }
  return(criteria)
}


addRowFiltersToSCE <- function(inSCE, paramsReactive) {
  for (entry in paramsReactive$params) {
    rowName <- paste0(entry$row, "_filter")
    a <- assay(inSCE, entry$row)
    vec <- rowSums(a > entry$X) > entry$Y
    rowData(inSCE)[[rowName]] <- vec
    entry$param <- sprintf("%s == T", rowName)
  }
  return(inSCE)
}

#helper function to add notification bar while code is executing
spinnerShape <- "orbit"
spinnerColor <- "gainsboro"

.loadOpen <- function(message) {
  shinybusy::show_modal_spinner(
    spin = spinnerShape,
    color = spinnerColor,
    text = message
  ) # show the notification spinner

  shinyjs::runjs("var intervalVarAutoScrollConsole =  setInterval(startAutoScroll, 1000); Shiny.onInputChange('logDataAutoScrollStatus', intervalVarAutoScrollConsole);")

  shinyjs::show(id = "consolePanel") # open console

}

.loadClose <- function(){
  shinyjs::hide(id = "consolePanel") # close console
  shinybusy::remove_modal_spinner() #closes the notification spinner
}

#' Usually numericInput returns NA when not entering anything in UI, but
#' directly using NA causes error. Similarly, character inputs (selectionInput)
#' returns empty string "", which should usually be changed to NULL.
#' @return if not identified as empty inputs, returns as is; otherwise,
#' changeTo to `changeTo`
handleEmptyInput <- function(x,
                             type = c("auto", "numeric", "character"),
                             changeTo = NULL) {
  type = match.arg(type)
  if (type == "auto") {
    if (is.numeric(x) || is.na(x)) {
      type <- "numeric"
    } else if (is.character(x)) {
      type <- "character"
    }
  }
  if (type == "numeric" & is.na(x)) {
    x <- changeTo
  } else if (type == "character" & x == "") {
    x <- changeTo
  }
  return(x)
}

getTypeByMat <- function(inSCE, matName) {
  if (matName %in% assayNames(inSCE)) {
    return("assay")
  } else if (matName %in% altExpNames(inSCE)) {
    return("altExp")
  } else if (matName %in% reducedDimNames(inSCE)) {
    return("reducedDim")
  } else {
    for (i in altExpNames(inSCE)) {
      if (matName %in% reducedDimNames(altExp(inSCE, i))) {
        return(c("reducedDim", i))
      }
    }
    return()
  }
}

#' Generate distinct colors for all categorical col/rowData entries.
#' Character columns will be considered as well as all-integer columns. Any
#' column with all-distinct values will be excluded.
#' @param inSCE \linkS4class{SingleCellExperiment} inherited object.
#' @param axis Choose from \code{"col"} or \code{"row"}.
#' @param colorGen A function that generates color code vector by giving an
#' integer for the number of colors. Alternatively,
#' \code{\link{rainbow}}. Default \code{\link{distinctColors}}.
#' @return A \code{list} object containing distinct colors mapped to all
#' possible categorical entries in \code{rowData(inSCE)} or
#' \code{colData(inSCE)}.
#' @author Yichen Wang
dataAnnotationColor <- function(inSCE, axis = NULL,
                                colorGen = distinctColors){
    if(!is.null(axis) && axis == 'col'){
        data <- SummarizedExperiment::colData(inSCE)
    } else if(!is.null(axis) && axis == 'row'){
        data <- SummarizedExperiment::rowData(inSCE)
    } else {
        stop('please specify "col" or "row"')
    }
    nColor <- 0
    for(i in names(data)){
        if(length(grep('counts', i)) > 0){
            next
        }
        column <- stats::na.omit(data[[i]])
        if(is.numeric(column)){
            if(!all(as.integer(column) == column)){
                # Temporarily the way to tell whether numeric categorical
                next
            }
        }
        if(is.factor(column)){
            uniqLevel <- levels(column)
        } else {
            uniqLevel <- unique(column)
        }
        if(!length(uniqLevel) == nrow(data)){
            # Don't generate color for all-uniq annotation (such as IDs/symbols)
            nColor <- nColor + length(uniqLevel)
        }
    }
    if (nColor == 0) {
        return(list())
    }
    allColors <- colorGen(nColor)
    nUsed <- 0
    allColorMap <- list()
    for(i in names(data)){
        if(length(grep('counts', i)) > 0){
            next
        }
        column <- stats::na.omit(data[[i]])
        if(is.numeric(column)){
            if(!all(as.integer(column) == column)){
                # Temporarily the way to tell whether numeric categorical
                next
            }
        }
        if(is.factor(column)){
            uniqLevel <- levels(column)
        } else {
            uniqLevel <- unique(column)
        }
        if(!length(uniqLevel) == nrow(data)){
            subColors <- allColors[(nUsed+1):(nUsed+length(uniqLevel))]
            names(subColors) <- uniqLevel
            allColorMap[[i]] <- subColors
            nUsed <- nUsed + length(uniqLevel)
        }
    }
    return(allColorMap)
}

# Pass newly generated QC metric variable from vals$original to vals$counts, the
# latter might be a subset.
passQCVar <- function(sce.original, sce.counts, algoList) {
  vars <- c()
  for (a in algoList) {
    if (a == "scDblFinder") {
      new <- grep("scDblFinder", names(colData(sce.original)), value = TRUE)
    } else if (a == "cxds") {
      new <- grep("scds_cxds", names(colData(sce.original)), value = TRUE)
    } else if (a == "bcds") {
      new <- grep("scds_bcds", names(colData(sce.original)), value = TRUE)
    } else if (a == "cxds_bcds_hybrid") {
      new <- grep("scds_hybrid", names(colData(sce.original)), value = TRUE)
    } else if (a == "decontX") {
      new <- grep("decontX", names(colData(sce.original)), value = TRUE)
    } else if (a == "soupX") {
      new <- grep("soupX", names(colData(sce.original)), value = TRUE)
    } else if (a == "scrublet") {
      new <- grep("scrublet", names(colData(sce.original)), value = TRUE)
    } else if (a == "doubletFinder") {
      new <- grep("doubletFinder", names(colData(sce.original)), value = TRUE)
    } else if (a == "QCMetrics") {
      new <- c("total", "sum", "detected")
      new <- c(new, grep("percent.top", names(colData(sce.original)), value = TRUE))
      new <- c(new, grep("mito_", names(colData(sce.original)), value = TRUE))
      new <- c(new, grep("^subsets_.+_sum$", names(colData(sce.original)), value = TRUE))
      new <- c(new, grep("^subsets_.+_detected$", names(colData(sce.original)), value = TRUE))
      new <- c(new, grep("^subsets_.+_percent$", names(colData(sce.original)), value = TRUE))
    } 
    vars <- c(vars, new)
  }
  sce.original <- sce.original[rownames(sce.counts), colnames(sce.counts)]
  colData(sce.counts)[vars] <- colData(sce.original)[vars]
  return(sce.counts)
}
