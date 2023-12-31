cxdsBcdsHybridHelpModal <- function() {
  modalDialog(
    tags$style(HTML("
      div {
        word-wrap: break-word;
      }
      ")),
    tags$div(
      h3("CXDS_BCDS Hybrid Parameters"),
      h4("CXDS Parameters:"),
      fluidRow(
        column(4, tags$b("Parameter Name")),
        column(8, tags$b("Description"))
      ),
      tags$hr(),
      fluidRow(
        column(4, "ntop"),
        column(8, "Integer. Indimessageing number of top variance genes to consider. Default: 500")
      ),
      tags$hr(),
      fluidRow(
        column(4, "binThresh"),
        column(8, 'Integer. Minimum counts to consider a gene "present" in a cell. Default: 0')
      ),
      tags$hr(),
      fluidRow(
        column(4, "retRes"),
        column(8, "Check off to return gene pair scores & top-scoring gene pairs.")
      ),
      
      tags$hr(),
      h4("BCDS Parameters:"),
      fluidRow(
        column(4, tags$b("Parameter Name")),
        column(8, tags$b("Description"))
      ),
      tags$hr(),
      fluidRow(
        column(4, "ntop"),
        column(8, "Integer. Indicating number of top variance genes to consider. Default: 500")
      ),
      tags$hr(),
      fluidRow(
        column(4, "srat"),
        column(8, 'Numeric. Indicating ratio between orginal number of "cells" and simulated doublets. Default: 1')
      ),
      tags$hr(),
      fluidRow(
        column(4, "nmax"),
        column(8, 'Maximum number of training rounds; integer or "tune". Default: "tune"')
      ),
      tags$hr(),
      fluidRow(
        column(4, "retRes"),
        column(8, "Check off to return the trained classifier.")
      ),
      tags$hr(),
      fluidRow(
        column(4, "varImp"),
        column(8, "Check off to return variable importance.")
      ),
      
      tags$hr(),
      h4("General Parameters:"),
      fluidRow(
        column(4, tags$b("Parameter Name")),
        column(8, tags$b("Description"))
      ),
      tags$hr(),
      fluidRow(
        column(4, "verb"),
        column(8, "Check off to print log messages to the console. Default: TRUE.")
      )
    )
  )
}

