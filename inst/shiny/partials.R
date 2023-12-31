#------------#
# ROW MAKING #
#------------#

make3ColTableRow <- function(selector, id, col1, col2) {
  fluidRowStyle <- paste0(paste0("#", id), "{border-bottom: 1px solid #bababa; padding-top: .9%; padding-bottom: .5%}")
  removeBtnStyle <- paste0(paste0("#remove", id), "{padding-top: 0; padding-bottom: 0;}")
  insertUI(
    selector = selector,
    ui = fluidRow(
      id = id,
      tags$style(HTML(paste0(fluidRowStyle, removeBtnStyle))),
      column(4, col1),
      column(4, col2),
      column(4, actionButton(paste0("remove", id), "X"))
    )
  )
}

# make4ColTableRow <- function(selector, id, col1, col2, col3) {
#   fluidRowStyle <- paste0(paste0("#", id), "{border-bottom: 1px solid #bababa; padding-top: .9%; padding-bottom: .5%}")
#   removeBtnStyle <- paste0(paste0("#remove", id), "{padding-top: 0; padding-bottom: 0;}")
#   insertUI(
#     selector = selector,
#     ui = fluidRow(
#       id = id,
#       tags$style(HTML(paste0(fluidRowStyle, removeBtnStyle))),
#       column(3, col1),
#       column(3, col2),
#       column(3, col3),
#       column(3, actionButton(paste0("remove", id), "X"))
#     )
#   )
# }

addToGeneralSampleTable <- function(inputID, id, col2, col3) {
  col1 <- ""
  if (inputID == "files") {
    col1 <- "Files"
  } else if (inputID == "example") {
    col1 <- "Example"
  } else if (inputID == "rds") {
    col1 <- "RDS"
  } else if (inputID == "cellRanger2") {
    col1 <- "Cell Ranger 2"
  } else if (inputID == "cellRanger3") {
    col1 <- "Cell Ranger 3"
  } else if (inputID == "starSolo") {
    col1 <- "STARsolo"
  } else if (inputID == "busTools") {
    col1 <- "BUStools"
  } else if (inputID == "seqc") {
    col1 <- "SEQC"
  } else if (inputID == "optimus") {
    col1 <- "Optimus"
  }

  fluidRowStyle <- paste0(paste0("#", id), "{border-bottom: 1px solid #bababa; padding-top: .9%; padding-bottom: .5%}")
  removeBtnStyle <- paste0(paste0("#remove", id), "{padding-top: 0; padding-bottom: 0;}")
  insertUI(
    selector = "#newSampleImport",
    ui = fluidRow(
      id = id,
      tags$style(HTML(paste0(fluidRowStyle, removeBtnStyle))),
      column(3, col1),
      column(3, col2),
      column(3, col3),
      column(3, actionButton(paste0("remove", id), "X"))
    )
  )
}


#---------------#
# IMPORT MODALS #
#---------------#

# modal to import CellRanger data
importCRModal <- function() {
  modalDialog(
    h3("Add a Cell Ranger Sample"),
    tags$br(),
    h4("Option 1 - Select a directory containing multiple sample directories (and no other directories)."),
    actionButton("crOpt1", "Add"),
    tags$br(),
    h4("Option 2 - Select a single sample directory."),
    actionButton("crOpt2", "Add"),
    tags$br(),
    h4("Option 3 - Select a directory containing your data files (barcodes.tsv, features.tsv, matrix.mtx)."),
    actionButton("crOpt3", "Add"),

    footer = tagList(
      modalButton("Cancel"),
      actionButton("crOK", "OK")
    )
  )
}

# Upload a base directory (CR) (parent of possibly multiple sample directories)
# For crOpt1
importCRBDir <- function(failed = FALSE) {
  modalDialog(
    h3("Base Directory"),
    #shinyDirectoryInput::directoryInput('bDirectory', label = 'Choose Directory', value = getwd()),

    shinyFiles::shinyDirButton("bDirectory", label = "Choose Directory", title = "Upload"),
    # A UI to display what users select
    verbatimTextOutput("bDirectoryPath", placeholder = TRUE),

    wellPanel(h5("*For any sample names that you do not provide, the sample name will be set to the sample directory name.")),

    tags$div(id = "bDirTable"),

    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),

    footer = tagList(
      modalButton("Cancel"),
      actionButton("BDirOK", "OK")
    )
  )
}

# Upload a sample directory (CR) (parent of 'outs' directory)
# For crOpt2
importCRSDir <- function(failed = FALSE) {
  modalDialog(
    h3("Sample Directory"),
    #shinyDirectoryInput::directoryInput('sDirectory', label = 'Choose Directory', value = '~'),

    shinyFiles::shinyDirButton("sDirectory", label = "Choose Directory", title = "Upload"),
    # A UI to display what users select
    verbatimTextOutput("sDirectoryPath", placeholder = TRUE),
    tags$div(id = "sDirTable"),
    h3("Sample Name"),
    h5("If you do not provide an alternate sample name, the sample name will be set to the sample directory name."),
    textInput("sSampleID", ""),

    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),

    footer = tagList(
      modalButton("Cancel"),
      actionButton("SDirOK", "OK")
    )
  )
}

# Upload a data directory (CR) (parent of 'data files')
# For crOpt3
importCRDDir <- function(failed = FALSE) {
  modalDialog(
    h3("Data Directory"),
    #shinyDirectoryInput::directoryInput('directory', label = 'Choose Directory', value = '~'),

    shinyFiles::shinyDirButton("directory", label = "Choose Directory", title = "Upload"),
    # A UI to display what users select
    verbatimTextOutput("directoryPath", placeholder = TRUE),

    h3("Sample Name"),
    textInput("dSampleID", "*This field is mandatory when uploading a data directory"),

    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),

    footer = tagList(
      modalButton("Cancel"),
      actionButton("DDirOK", "OK")
    )
  )
}

importModal <- function(failed=FALSE, needsDir=FALSE) {
  modalDialog(
    h3("Sample Name"),
    textInput("sampleName", "*This is the name you would like to give your sample."),
    # only some functions need this input
    if (needsDir)
      h3("Sample ID"),
    if (needsDir)
      textInput("sampleID", "*This name must match your sample's directory name."),

    h3("Base Directory"),
    #shinyDirectoryInput::directoryInput('directory', label = 'Choose Directory', value = ),

    shinyFiles::shinyDirButton("directory", label = "Choose Directory", title = "Upload"),
    # A UI to display what users select
    verbatimTextOutput("directoryPath", placeholder = TRUE),

    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),

    footer = tagList(
      modalButton("Cancel"),
      actionButton("modalOk", "OK")
    )
  )
}


importStarModal <- function(failed=FALSE, needsDir=FALSE) {
  modalDialog(
    h3("Sample Name"),
    textInput("sampleName", "*This is the name you would like to give your sample."),
    # only some functions need this input
    if (needsDir)
      h3("Sample ID"),
    if (needsDir)
      textInput("sampleID", "*This name must match your sample's directory name."),
    
    selectInput(
      inputId = "geneFolder",
      label = "Select Gene Folder: ",
      choices = c("Gene" = "Gene",
                  "GeneFull" = "GeneFull")
    ),
    
    
    h3("Base Directory"),
    #shinyDirectoryInput::directoryInput('directory', label = 'Choose Directory', value = ),
    
    shinyFiles::shinyDirButton("directory", label = "Choose Directory", title = "Upload"),
    # A UI to display what users select
    verbatimTextOutput("directoryPath", placeholder = TRUE),
    
    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),
    
    footer = tagList(
      modalButton("Cancel"),
      actionButton("modalStarOk", "OK")
    )
  )
}



#--------------#
# QC/FILTERING #
#--------------#

# qcModal <- function(assays=NULL, geneSetList=FALSE, geneSetListLocation=FALSE,
#                     geneSetCollection=FALSE, failed=FALSE, requireAssayStr='') {
#   modalDialog(
#     h3("QC Paramters - some of the algorithms you have selected require the following extra parameters:"),
#     if (!is.null(assays))
#       selectInput("qcAssaySelect", paste0("Select assay for ", requireAssayStr), assays),
#     if (geneSetList)
#       tags$hr(),
#     if (geneSetList)
#       h4(tags$b("Parameters for QCMetrics:")),
#     # The following selectInputs are just place holders until there is gene set code
#     if (geneSetList)
#       selectInput("geneSetList", "Select Gene Set List", assays),
#     if (geneSetListLocation)
#       selectInput("geneLocation", "Select Gene Set List Location", assays),
#     if (geneSetCollection)
#       selectInput("geneCollection", "Select Gene Set Collection", assays),
#
#     if (failed)
#       div(tags$b("Please fill out all the required fields", style = "color: red;")),
#
#     footer = tagList(
#       modalButton("Cancel"),
#       actionButton("modalRunQC", "Run")
#     )
#   )
# }

# creates tabs for results from QC
showQCResTabs <- function(obj, algoList, statuses, plotIds) {
  if (("QCMetrics" %in% algoList) && is.null(statuses$QCMetrics)) {
    appendTab("qcResPlotTabs", tabPanel("QCMetrics",
                                        fluidPage(id = "QCMetricsTab",
                                                  uiOutput(outputId = plotIds$QCMetrics),
                                                  tabsetPanel(
                                                    id ="QCMetricsTabs"
                                                  )
                                        ),
                                ),
              select = TRUE
    )
  }
  for (i in seq_along(algoList)) {
    algo <- algoList[[i]]
    id <- paste0(algo, "Tab")
    if ((algo != "QCMetrics") && is.null(statuses[[algo]])) {
      appendTab("qcResPlotTabs", tabPanel(algo,
                                          fluidPage(id = id,
                                                    uiOutput(outputId = plotIds[[algo]]),
                                                    tabsetPanel(
                                                      id = paste0(algo, "Tabs")
                                                    )
                                          ),
                                  ),
                select = FALSE
      )
    }
  }
}


filteringModal <- function(failed=FALSE, colNames) {
  modalDialog(
    h3("Select an Annotation"),
    selectInput("filterColSelect", "", colNames),
    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),
    shinyjs::hidden(
      tags$div(id = "convertFilterType",
               # checkboxInput("convertToCat", "Convert to categorical filter?"),
      )
    ),
    tags$div(id = "filterCriteria"),
    tags$div(id = "filterCrErrors"),
    footer = tagList(
      modalButton("Cancel"),
      actionButton("filtModalOK", "OK")
    )
  )
}

rowFilteringModal <- function(failed=FALSE, assayInput) {
  modalDialog(
    h3("Select an Assay"),
    selectInput("filterAssaySelect", "", assayInput),
    if (failed)
      div(tags$b("Please fill out all the required fields", style = "color: red;")),
    tags$div(id = "rowFilterCriteria"),

    footer = tagList(
      modalButton("Cancel"),
      actionButton("rowFiltModalOK", "OK")
    )
  )
}

addFilteringThresholdOptions <- function(colInput) {
  minCol <- min(colInput)
  maxCol <- max(colInput)

  gt_label_str <- sprintf("Keep values above (please pick a number between %.5f and %.5f):", minCol, maxCol)
  lt_label_str <- sprintf("Keep values below (please pick a number between %.5f and %.5f):", minCol, maxCol)


  insertUI(
    selector = "#filterCriteria",
    ui = tags$div(
      id="newThresh",
      checkboxInput("colGT", "Greater than:"),
      shinyjs::hidden(
        numericInput("filterThreshGT", gt_label_str, minCol, min = minCol, max = maxCol)
      ),
      checkboxInput("colLT", "Less than:"),
      shinyjs::hidden(
        numericInput("filterThreshLT", lt_label_str, minCol, min = minCol, max = maxCol)
      )
    )
  )
}





