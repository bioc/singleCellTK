% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scanpyFunctions.R
\name{runScanpyTSNE}
\alias{runScanpyTSNE}
\title{runScanpyTSNE
Computes tSNE from the given sce object and stores the tSNE computations back
into the sce object}
\usage{
runScanpyTSNE(
  inSCE,
  useAssay = NULL,
  useReducedDim = "scanpyPCA",
  reducedDimName = "scanpyTSNE",
  dims = 40,
  perplexity = 30,
  externalReduction = NULL,
  seed = 12345
)
}
\arguments{
\item{inSCE}{(sce) object on which to compute the tSNE}

\item{useAssay}{Specify name of assay to use. Default is \code{NULL}, so
\code{useReducedDim} param will be used instead.}

\item{useReducedDim}{selected reduction method to use for computing tSNE.
Default \code{"scanpyPCA"}.}

\item{reducedDimName}{Name of new reducedDims object containing Scanpy tSNE
Default \code{scanpyTSNE}.}

\item{dims}{Number of reduction components to use for tSNE computation.
Default \code{40}.}

\item{perplexity}{Adjust the perplexity tuneable parameter for the underlying
tSNE call. Default \code{30}.}

\item{externalReduction}{Pass DimReduc object if PCA computed through
other libraries. Default \code{NULL}.}

\item{seed}{Specify numeric value to set as a seed. Default \code{12345}.}
}
\value{
Updated sce object with tSNE computations stored
}
\description{
runScanpyTSNE
Computes tSNE from the given sce object and stores the tSNE computations back
into the sce object
}
\examples{
data(scExample, package = "singleCellTK")
\dontrun{
sce <- runScanpyNormalizeData(sce, useAssay = "counts")
sce <- runScanpyFindHVG(sce, useAssay = "scanpyNormData", method = "seurat")
sce <- runScanpyScaleData(sce, useAssay = "scanpyNormData")
sce <- runScanpyPCA(sce, useAssay = "scanpyScaledData")
sce <- runScanpyFindClusters(sce, useReducedDim = "scanpyPCA")
sce <- runScanpyTSNE(sce, useReducedDim = "scanpyPCA")
}
}
