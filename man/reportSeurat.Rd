% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/htmlReports.R
\name{reportSeurat}
\alias{reportSeurat}
\title{Generates an HTML report for the complete Seurat workflow and returns the
 SCE object with the results computed and stored inside the object.}
\usage{
reportSeurat(
  inSCE,
  biological.group = NULL,
  phenotype.groups = NULL,
  selected.markers = NULL,
  clustering.resolution = 0.8,
  variable.features = 2000,
  pc.count = 50,
  outputFile = NULL,
  outputPath = NULL,
  subtitle = NULL,
  authors = NULL,
  showSession = FALSE,
  pdf = FALSE,
  runHVG = TRUE,
  plotHVG = TRUE,
  runDimRed = TRUE,
  plotJackStraw = FALSE,
  plotElbowPlot = TRUE,
  plotHeatmaps = TRUE,
  runClustering = TRUE,
  plotTSNE = TRUE,
  plotUMAP = TRUE,
  minResolution = 0.3,
  maxResolution = 1.5,
  runMSClusters = TRUE,
  runMSBioGroup = TRUE,
  numTopFeatures = 10,
  forceRun = TRUE
)
}
\arguments{
\item{inSCE}{Input \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object.}

\item{biological.group}{A character value that specifies the name of the
\code{colData()} column to use as the main biological group in the Seurat
report for marker selection and grouping.}

\item{phenotype.groups}{A character vector that specifies the names of the
\code{colData()} columns to use for differential expression in addition to
the \code{biological.group} parameter.}

\item{selected.markers}{A character vector containing the user-specified
gene symbols or feature names of marker genes that be used to generate
gene plots in addition to the gene markers computed from
differential expression.}

\item{clustering.resolution}{A numeric value indicating the user-specified
final resolution to use with clustering. Default is \code{0.8}.}

\item{variable.features}{A numeric value indicating the number of top
variable features to identify. Default \code{2000}.}

\item{pc.count}{A numeric value indicating the number of principal components
to use in the analysis workflow. Default is \code{50}.}

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

\item{runHVG}{A logical value indicating if the feature selection
computation should be run or not. Default is \code{TRUE}.}

\item{plotHVG}{A logical value indicating if the plot for the top most
variable genes should be visualized in a mean-to-variance plot.
Default is \code{TRUE}.}

\item{runDimRed}{A logical value indicating if PCA should be computed.
Default is \code{TRUE}.}

\item{plotJackStraw}{A logical value indicating if JackStraw plot be
visualized for the principal components. Default is \code{FALSE}.}

\item{plotElbowPlot}{A logical value indicating if the ElbowPlot be
visualized for the principal components. Default is \code{TRUE}.}

\item{plotHeatmaps}{A logical value indicating if heatmaps should be plotted
for the principal components. Default is \code{TRUE}.}

\item{runClustering}{A logical value indicating if clustering section should
be run in the report. Default is \code{TRUE}.}

\item{plotTSNE}{A logical value indicating if TSNE plots should be visualized
for clustering results. Default is \code{TRUE}.}

\item{plotUMAP}{A logical value indicating if the UMAP plots should be
visualized for the clustering results. Default is \code{TRUE}.}

\item{minResolution}{A numeric value indicating the minimum resolution to
use for clustering. Default is \code{0.3}.}

\item{maxResolution}{A numeric value indicating the maximum resolution to use
for clustering. Default is \code{1.5}.}

\item{runMSClusters}{A logical value indicating if marker selection should
be run between clusters. Default is \code{TRUE}.}

\item{runMSBioGroup}{A logical value indicating if marker selection should
be run between the \code{biological.group} parameter.
Default is \code{TRUE}.}

\item{numTopFeatures}{A numeric value indicating the number of top features
to visualize in each group. Default \code{10}.}

\item{forceRun}{A logical value indicating if all algorithms should be
re-run regardless if they have been computed previously in the input object.
Default is \code{TRUE}.}
}
\value{
A \code{\link[SingleCellExperiment]{SingleCellExperiment}} object
 with computations stored.
}
\description{
Generates an HTML report for the complete Seurat workflow and returns the
 SCE object with the results computed and stored inside the object.
}
