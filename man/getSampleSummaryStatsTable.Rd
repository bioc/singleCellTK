% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/allGenerics.R, R/sampleSummaryStats.R
\name{getSampleSummaryStatsTable}
\alias{getSampleSummaryStatsTable}
\alias{setSampleSummaryStatsTable<-}
\alias{getSampleSummaryStatsTable,SingleCellExperiment-method}
\alias{setSampleSummaryStatsTable<-,SingleCellExperiment-method}
\title{Stores and returns table of SCTK QC outputs to metadata.}
\usage{
getSampleSummaryStatsTable(inSCE, statsName, ...)

setSampleSummaryStatsTable(inSCE, statsName, ...) <- value

\S4method{getSampleSummaryStatsTable}{SingleCellExperiment}(inSCE, statsName, ...)

\S4method{setSampleSummaryStatsTable}{SingleCellExperiment}(inSCE, statsName, ...) <- value
}
\arguments{
\item{inSCE}{Input \linkS4class{SingleCellExperiment} object with saved
\link{assay} data and/or \link{colData} data. Required.}

\item{statsName}{A \code{character} value indicating the slot
that stores the stats table within the metadata of the
SingleCellExperiment object. Required.}

\item{...}{Other arguments passed to the function.}

\item{value}{The summary table for QC statistics generated from SingleCellTK
to be added to the SCE object.}
}
\value{
For \code{getSampleSummaryStatsTable}, A matrix/array object. 
Contains a summary table for QC statistics generated from SingleCellTK. For
\code{setSampleSummaryStatsTable<-}, A SingleCellExperiment object where the 
summary table is updated in the \code{metadata} slot.
}
\description{
Stores and returns table of QC metrics generated from
 QC algorithms within the metadata slot of the SingleCellExperiment object.
}
\examples{
data(scExample, package = "singleCellTK")
sce <- subsetSCECols(sce, colData = "type != 'EmptyDroplet'")
sce <- sampleSummaryStats(sce, simple = TRUE, statsName = "qc_table")
getSampleSummaryStatsTable(sce, statsName = "qc_table")
}
