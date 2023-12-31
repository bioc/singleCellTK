% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seuratFunctions.R
\name{runSeuratFindClusters}
\alias{runSeuratFindClusters}
\title{runSeuratFindClusters
Computes the clusters from the input sce object and stores them back in sce
object}
\usage{
runSeuratFindClusters(
  inSCE,
  useAssay = "seuratNormData",
  useReduction = c("pca", "ica"),
  dims = 10,
  algorithm = c("louvain", "multilevel", "SLM"),
  groupSingletons = TRUE,
  resolution = 0.8,
  seed = 12345,
  externalReduction = NULL,
  verbose = TRUE
)
}
\arguments{
\item{inSCE}{(sce) object from which clusters should be computed and stored
in}

\item{useAssay}{Assay containing scaled counts to use for clustering.}

\item{useReduction}{Reduction method to use for computing clusters. One of
"pca" or "ica". Default \code{"pca"}.}

\item{dims}{numeric value of how many components to use for computing
clusters. Default \code{10}.}

\item{algorithm}{selected algorithm to compute clusters. One of "louvain",
"multilevel", or "SLM". Use \code{louvain} for "original Louvain algorithm"
and \code{multilevel} for "Louvain algorithm with multilevel refinement".
Default \code{louvain}.}

\item{groupSingletons}{boolean if singletons should be grouped together or
not. Default \code{TRUE}.}

\item{resolution}{Set the resolution parameter to find larger (value above 1)
or smaller (value below 1) number of communities. Default \code{0.8}.}

\item{seed}{Specify the seed value. Default \code{12345}.}

\item{externalReduction}{Pass DimReduc object if PCA/ICA computed through
other libraries. Default \code{NULL}.}

\item{verbose}{Logical value indicating if informative messages should
be displayed. Default is \code{TRUE}.}
}
\value{
Updated sce object which now contains the computed clusters
}
\description{
runSeuratFindClusters
Computes the clusters from the input sce object and stores them back in sce
object
}
\examples{
data(scExample, package = "singleCellTK")
\dontrun{
sce <- runSeuratNormalizeData(sce, useAssay = "counts")
sce <- runSeuratFindHVG(sce, useAssay = "counts")
sce <- runSeuratScaleData(sce, useAssay = "counts")
sce <- runSeuratPCA(sce, useAssay = "counts")
sce <- runSeuratFindClusters(sce, useAssay = "counts")
}
}
