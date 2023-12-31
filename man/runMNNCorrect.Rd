% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runBatchCorrection.R
\name{runMNNCorrect}
\alias{runMNNCorrect}
\title{Apply the mutual nearest neighbors (MNN) batch effect correction method to
SingleCellExperiment object}
\usage{
runMNNCorrect(
  inSCE,
  useAssay = "logcounts",
  batch = "batch",
  assayName = "MNN",
  k = 20L,
  propK = NULL,
  sigma = 0.1,
  cosNormIn = TRUE,
  cosNormOut = TRUE,
  varAdj = TRUE,
  BPPARAM = BiocParallel::SerialParam()
)
}
\arguments{
\item{inSCE}{Input \linkS4class{SingleCellExperiment} object}

\item{useAssay}{A single character indicating the name of the assay requiring
batch correction. Default \code{"logcounts"}.}

\item{batch}{A single character indicating a field in \code{colData} that
annotates the batches of each cell; or a vector/factor with the same length
as the number of cells. Default \code{"batch"}.}

\item{assayName}{A single characeter. The name for the corrected assay. Will
be saved to \code{\link{assay}}. Default
\code{"MNN"}.}

\item{k}{An integer scalar specifying the number of nearest neighbors to
consider when identifying MNNs. See "See Also". Default \code{20}.}

\item{propK}{A numeric scalar in (0, 1) specifying the proportion of cells in
each dataset to use for mutual nearest neighbor searching. See "See Also".
Default \code{NULL}.}

\item{sigma}{A numeric scalar specifying the bandwidth of the Gaussian
smoothing kernel used to compute the correction vector for each cell. See
"See Also". Default \code{0.1}.}

\item{cosNormIn}{A logical scalar indicating whether cosine normalization
should be performed on the input data prior to calculating distances between
cells. See "See Also". Default \code{TRUE}.}

\item{cosNormOut}{A logical scalar indicating whether cosine normalization
should be performed prior to computing corrected expression values. See "See
Also". Default \code{TRUE}.}

\item{varAdj}{A logical scalar indicating whether variance adjustment should
be performed on the correction vectors. See "See Also". Default \code{TRUE}.}

\item{BPPARAM}{A \linkS4class{BiocParallelParam} object specifying whether
the PCA and nearest-neighbor searches should be parallelized.}
}
\value{
The input \linkS4class{SingleCellExperiment} object with
\code{assay(inSCE, assayName)} updated.
}
\description{
MNN is designed for batch correction of single-cell RNA-seq data where the
batches are partially confounded with biological conditions of interest. It
does so by identifying pairs of MNN in the high-dimensional log-expression
space. For each MNN pair, a pairwise correction vector is computed by
applying a Gaussian smoothing kernel with bandwidth `sigma`.
}
\examples{
data('sceBatches', package = 'singleCellTK')
logcounts(sceBatches) <- log1p(counts(sceBatches))
sceCorr <- runMNNCorrect(sceBatches)
}
\references{
Haghverdi L, Lun ATL, et. al., 2018
}
\seealso{
\code{\link[batchelor]{mnnCorrect}}
}
