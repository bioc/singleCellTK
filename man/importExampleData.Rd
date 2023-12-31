% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/importExampleData.R
\name{importExampleData}
\alias{importExampleData}
\title{Retrieve example datasets}
\usage{
importExampleData(
  dataset,
  class = c("Matrix", "matrix"),
  delayedArray = FALSE,
  rowNamesDedup = TRUE
)
}
\arguments{
\item{dataset}{Character. Name of the dataset to retrieve.}

\item{class}{Character. The class of the expression matrix stored in the SCE
object. Can be one of \code{"Matrix"} or \code{"matrix"}. \code{"Matrix"}
will store the data as a sparse matrix from package \link{Matrix} while
\code{"matrix"} will store the data in a standard matrix. Default
\code{"Matrix"}.}

\item{delayedArray}{Boolean. Whether to read the expression matrix as
\link{DelayedArray} object or not. Default \code{FALSE}.}

\item{rowNamesDedup}{Boolean. Whether to deduplicate rownames. Default 
\code{TRUE}.}
}
\value{
The specified \link[SingleCellExperiment]{SingleCellExperiment} object.
}
\description{
Retrieves published example datasets stored in
\link[SingleCellExperiment]{SingleCellExperiment} using the
\link{scRNAseq} and
\link[TENxPBMCData]{TENxPBMCData} packages. See 'Details' for a
list of available datasets.
}
\details{
See the list below for the available datasets and their
descriptions.
\describe{
\item{"fluidigm_pollen"}{Retrieved with
\code{\link{ReprocessedFluidigmData}}. Returns a dataset of 65
 human neural cells from Pollen et al. (2014), each sequenced at high and low
 coverage (SRA accession SRP041736).}
\item{"allen_tasic"}{Retrieved with
\code{\link{ReprocessedAllenData}}. Returns a dataset of 379 mouse
brain cells from Tasic et al. (2016).}
\item{"NestorowaHSCData"}{Retrieved with
\code{\link{NestorowaHSCData}}. Returns a dataset of 1920 mouse  
 haematopoietic stem cells from Nestorowa et al. 2015}
\item{"pbmc3k"}{Retrieved with \code{\link[TENxPBMCData]{TENxPBMCData}}.
 2,700 peripheral blood mononuclear cells (PBMCs) from 10X Genomics.}
\item{"pbmc4k"}{Retrieved with \code{\link[TENxPBMCData]{TENxPBMCData}}.
 4,340 peripheral blood mononuclear cells (PBMCs) from 10X Genomics.}
\item{"pbmc6k"}{Retrieved with \code{\link[TENxPBMCData]{TENxPBMCData}}.
 5,419 peripheral blood mononuclear cells (PBMCs) from 10X Genomics.}
\item{"pbmc8k"}{Retrieved with \code{\link[TENxPBMCData]{TENxPBMCData}}.
 8,381 peripheral blood mononuclear cells (PBMCs) from 10X Genomics.}
\item{"pbmc33k"}{Retrieved with \code{\link[TENxPBMCData]{TENxPBMCData}}.
 33,148 peripheral blood mononuclear cells (PBMCs) from 10X Genomics.}
\item{"pbmc68k"}{Retrieved with \code{\link[TENxPBMCData]{TENxPBMCData}}.
 68,579 peripheral blood mononuclear cells (PBMCs) from 10X Genomics.}
}
}
\examples{
sce <- importExampleData("pbmc3k")
}
\author{
Joshua D. Campbell, David Jenkins
}
