% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/htmlReports.R
\name{reportSeuratMarkerSelection}
\alias{reportSeuratMarkerSelection}
\title{Generates an HTML report for Seurat Results (including Clustering & Marker
 Selection) and returns the SCE object with the results computed and stored
 inside the object.}
\usage{
reportSeuratMarkerSelection(
  inSCE,
  biological.group = NULL,
  phenotype.groups = NULL,
  selected.markers = NULL,
  runMarkerSelection = TRUE,
  plotMarkerSelection = TRUE,
  numTopFeatures = 10,
  outputFile = NULL,
  outputPath = NULL,
  subtitle = NULL,
  authors = NULL,
  showSession = FALSE,
  pdf = FALSE
)
}
\arguments{
\item{inSCE}{Input \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object.}

\item{biological.group}{A character value that specifies the name of the
\code{colData()} column to use as the main biological group in the Seurat
report for marker selection and grouping.}

\item{phenotype.groups}{A character vector that specifies the names of the
\code{colData()} columns to use for differential expression in addition to
the \code{biological.group} parameter.}

\item{selected.markers}{A character vector containing the user-specified
gene symbols or feature names of marker genes that be used to generate
gene plots in addition to the gene markers computed from
differential expression.}

\item{runMarkerSelection}{A logical value indicating if the marker selection
computation should be run or not. Default \code{TRUE}.}

\item{plotMarkerSelection}{A logical value indicating if the gene marker
plots should be visualized or not. Default \code{TRUE}.}

\item{numTopFeatures}{A numeric value indicating the number of top features
to visualize in each group. Default \code{10}.}

\item{outputFile}{Specify the name of the generated output HTML file.
If \code{NULL} then the output file name will be based on the name of the
Rmarkdown template. Default \code{NULL}.}

\item{outputPath}{Specify the name of the output directory to save the
rendered HTML file. If \code{NULL} the file is stored to the current
working directory. Default \code{NULL}.}

\item{subtitle}{A character value specifying the subtitle to use in the
report. Default \code{NULL}.}

\item{authors}{A character value specifying the names of the authors to use
in the report. Default \code{NULL}.}

\item{showSession}{A logical value indicating if session information
should be displayed or not. Default is \code{FALSE}.}

\item{pdf}{A logical value indicating if a pdf should also be generated for
each figure in the report. Default is \code{FALSE}.}
}
\value{
A \code{\link[SingleCellExperiment]{SingleCellExperiment}} object
 with computations stored.
}
\description{
Generates an HTML report for Seurat Results (including Clustering & Marker
 Selection) and returns the SCE object with the results computed and stored
 inside the object.
}
