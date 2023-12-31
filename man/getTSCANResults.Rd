% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runTSCAN.R
\name{getTSCANResults}
\alias{getTSCANResults}
\alias{getTSCANResults,SingleCellExperiment-method}
\alias{getTSCANResults<-}
\alias{getTSCANResults<-,SingleCellExperiment-method}
\alias{listTSCANResults}
\alias{listTSCANResults,SingleCellExperiment-method}
\alias{listTSCANTerminalNodes}
\alias{listTSCANTerminalNodes,SingleCellExperiment-method}
\title{getTSCANResults accessor function}
\usage{
getTSCANResults(x, analysisName = NULL, pathName = NULL)

\S4method{getTSCANResults}{SingleCellExperiment}(x, analysisName = NULL, pathName = NULL)

getTSCANResults(x, analysisName, pathName = NULL) <- value

\S4method{getTSCANResults}{SingleCellExperiment}(x, analysisName, pathName = NULL) <- value

listTSCANResults(x)

\S4method{listTSCANResults}{SingleCellExperiment}(x)

listTSCANTerminalNodes(x)

\S4method{listTSCANTerminalNodes}{SingleCellExperiment}(x)
}
\arguments{
\item{x}{Input \linkS4class{SingleCellExperiment} object.}

\item{analysisName}{Algorithm name implemented, should be one of
\code{"Pseudotime"}, \code{"DEG"}, or \code{"ClusterDEAnalysis"}.}

\item{pathName}{Sub folder name within the \code{analysisName}. See details.}

\item{value}{Value to be stored within the \code{pathName} or
\code{analysisName}}
}
\value{
Get or set TSCAN results
}
\description{
SCTK allows user to access all TSCAN related results with
\code{"getTSCANResults"}. See details.
}
\details{
When \code{analysisName = "Pseudotime"}, returns the list result from
\code{\link{runTSCAN}}, including the MST structure.

When \code{analysisName = "DEG"}, returns the list result from
\code{\link{runTSCANDEG}}, including \code{DataFrame}s containing genes that
increase/decrease along each the pseudotime paths. \code{pathName} indicates
the path index, the available options of which can be listed by
\code{listTSCANTerminalNodes}.

When \code{analysisName = "ClusterDEAnalysis"}, returns the list result from
\code{\link{runTSCANClusterDEAnalysis}}. Here \code{pathName} needs to match
with the \code{useCluster} argument when running the algorithm.
}
\examples{
data("mouseBrainSubsetSCE", package = "singleCellTK")
mouseBrainSubsetSCE <- runTSCAN(inSCE = mouseBrainSubsetSCE,
                                useReducedDim = "PCA_logcounts")
results <- getTSCANResults(mouseBrainSubsetSCE, "Pseudotime")
}
