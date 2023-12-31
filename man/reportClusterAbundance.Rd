% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/htmlReports.R
\name{reportClusterAbundance}
\alias{reportClusterAbundance}
\title{Get plotClusterAbundance .html report}
\usage{
reportClusterAbundance(
  inSCE,
  cluster,
  variable,
  output_dir = ".",
  output_file = "plotClusterAbundance_Report",
  pdf = FALSE,
  showSession = TRUE
)
}
\arguments{
\item{inSCE}{A \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object.}

\item{cluster}{A single \code{character}, specifying the name to store the
cluster label in \code{\link{colData}}.}

\item{variable}{A single \code{character}, specifying the name to store the
phenotype labels in \code{\link{colData}}.}

\item{output_dir}{name of the output directory to save the rendered file. If
\code{NULL} the file is stored to the current working directory.
Default \code{NULL}.}

\item{output_file}{name of the generated file. If \code{NULL} then the output
file name will be based on the name of the Rmarkdown template. Default
\code{NULL}.}

\item{pdf}{A \code{logical} value indicating if a pdf should also be
generated for each figure in the report. Default is \code{TRUE}.}

\item{showSession}{A \code{logical} value indicating if session information
should be displayed or not. Default is \code{TRUE}.}
}
\value{
An HTML file of the report will be generated at the path specified
in the arguments.
}
\description{
A function to generate .html Rmarkdown report containing the
visualizations of the plotClusterAbundance function output
}
