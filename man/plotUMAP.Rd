% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotUMAP.R
\name{plotUMAP}
\alias{plotUMAP}
\title{Plot UMAP results either on already run results or run first and then plot.}
\usage{
plotUMAP(
  inSCE,
  colorBy = NULL,
  shape = NULL,
  reducedDimName = "UMAP",
  runUMAP = FALSE,
  useAssay = "counts"
)
}
\arguments{
\item{inSCE}{Input \linkS4class{SingleCellExperiment} object with saved
dimension reduction components. Required}

\item{colorBy}{color by a condition(any column of the annotation data).}

\item{shape}{add shapes to each condition.}

\item{reducedDimName}{saved dimension reduction name in the
\linkS4class{SingleCellExperiment} object. Required.}

\item{runUMAP}{If the dimension reduction components are already available
set this to FALSE, otherwise set to TRUE. Default is False.}

\item{useAssay}{Indicate which assay to use. The default is "logcounts"}
}
\value{
a UMAP plot of the reduced dimensions.
}
\description{
Plot UMAP results either on already run results or run first and then plot.
}
\examples{
data(scExample, package = "singleCellTK")
sce <- subsetSCECols(sce, colData = "type != 'EmptyDroplet'")
sce <- runQuickUMAP(sce)
plotUMAP(sce)
}
