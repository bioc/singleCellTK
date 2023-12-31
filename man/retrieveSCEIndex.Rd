% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/miscFunctions.R
\name{retrieveSCEIndex}
\alias{retrieveSCEIndex}
\title{Retrieve cell/feature index by giving identifiers saved in col/rowData}
\usage{
retrieveSCEIndex(
  inSCE,
  IDs,
  axis,
  by = NULL,
  exactMatch = TRUE,
  firstMatch = TRUE
)
}
\arguments{
\item{inSCE}{Input \linkS4class{SingleCellExperiment} object. Required}

\item{IDs}{Character vector of identifiers for features or cells to find in
\code{rowData} or \code{colData} of \code{inSCE}}

\item{axis}{A character scalar to specify whether to search for features or
cells. Use \code{"row"}, \code{"feature"} or \code{"gene"} for features;
\code{"col"} or \code{"cell"} for cells.}

\item{by}{Character. In which column to search for features/cells in
\code{rowData}/\code{colData}. Default \code{NULL} for search the
\code{rownames}/\code{colnames}}

\item{exactMatch}{A logical scalar. Whether to only identify exact matches
or to identify partial matches using \code{\link{grep}}. Default \code{TRUE}}

\item{firstMatch}{A logical scalar. Whether to only identify the first
matches or to return all plausible matches. Default \code{TRUE}}
}
\value{
A unique, non-NA numeric vector of indices for the matching
features/cells in \code{inSCE}.
}
\description{
Originally written in \code{\link[celda]{retrieveFeatureIndex}}.
Modified for also retrieving cell indices and only working for
\linkS4class{SingleCellExperiment} object. This will return indices of
features among the \code{rowData}/\code{colData}. Partial matching (i.e.
grepping) can be used.
}
\examples{
data(scExample, package = "singleCellTK")
retrieveSCEIndex(inSCE = sce, IDs = "ENSG00000205542",
 axis = "row")
}
\author{
Yusuke Koga, Joshua Campbell, Yichen Wang
}
