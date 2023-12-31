% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/htmlReports.R
\name{reportSeuratDimRed}
\alias{reportSeuratDimRed}
\title{Generates an HTML report for Seurat Dimensionality Reduction
 and returns the SCE object with the results computed and stored
 inside the object.}
\usage{
reportSeuratDimRed(
  inSCE,
  pc.count = 50,
  runDimRed = TRUE,
  plotJackStraw = FALSE,
  plotElbowPlot = TRUE,
  plotHeatmaps = TRUE,
  outputFile = NULL,
  outputPath = NULL,
  subtitle = NULL,
  authors = NULL,
  showSession = FALSE,
  pdf = FALSE,
  forceRun = TRUE
)
}
\arguments{
\item{inSCE}{Input \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object.}

\item{pc.count}{A numeric value indicating the number of principal components
to compute. Default is \code{50}.}

\item{runDimRed}{A logical value indicating if dimenionality reduction should
be computed. Default \code{TRUE}.}

\item{plotJackStraw}{A logical value indicating if JackStraw plot should be
visualized. Default \code{FALSE}.}

\item{plotElbowPlot}{A logical value indicating if ElbowPlot should be
visualized. Default \code{TRUE}.}

\item{plotHeatmaps}{A logical value indicating if heatmaps should be
visualized. Default \code{TRUE}.}

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

\item{forceRun}{A logical value indicating if all computations previously
computed should be re-calculated regardless if these computations are
available in the input object. Default is \code{TRUE}.}
}
\value{
A \code{\link[SingleCellExperiment]{SingleCellExperiment}} object
 with computations stored.
}
\description{
Generates an HTML report for Seurat Dimensionality Reduction
 and returns the SCE object with the results computed and stored
 inside the object.
}
