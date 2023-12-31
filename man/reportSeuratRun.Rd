% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/htmlReports.R
\name{reportSeuratRun}
\alias{reportSeuratRun}
\title{Generates an HTML report for Seurat Run (including Normalization,
 Feature Selection, Dimensionality Reduction & Clustering) and returns the
 SCE object with the results computed and stored inside the object.}
\usage{
reportSeuratRun(
  inSCE,
  biological.group = NULL,
  phenotype.groups = NULL,
  variable.features = 2000,
  pc.count = 50,
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
  outputFile = NULL,
  outputPath = NULL,
  subtitle = NULL,
  authors = NULL,
  showSession = FALSE,
  pdf = FALSE,
  forceRun = TRUE
)
}
\arguments{
\item{inSCE}{Input \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object.}

\item{biological.group}{A character value that specifies the name of the
\code{colData()} column to use as the main biological group in the Seurat
report for tSNE & UMAP visualization.}

\item{phenotype.groups}{A character value that specifies the name of the
\code{colData()} column to use as additional phenotype variables in the
Seurat report for tSNE & UMAP visualization.}

\item{variable.features}{A numeric value indicating the number of top
variable genes to identify in the report. Default is \code{2000}.}

\item{pc.count}{A numeric value indicating the number of principal
components to use in the analysis workflow. Default is \code{50}.}

\item{runHVG}{A logical value indicating if feature selection should be run
in the report. Default \code{TRUE}.}

\item{plotHVG}{A logical value indicating if the top variable genes should
be visualized through a mean-to-variance plot. Default is \code{TRUE}.}

\item{runDimRed}{A logical value indicating if PCA should be computed in the
report. Default is \code{TRUE}.}

\item{plotJackStraw}{A logical value indicating if the JackStraw plot should
be visualized for the principal components. Default is \code{FALSE}.}

\item{plotElbowPlot}{A logical value indicating if the ElbowPlot should be
visualized for the principal components. Default is \code{FALSE}.}

\item{plotHeatmaps}{A logical value indicating if the Heatmaps should be
visualized for the principal components. Default is \code{FALSE}.}

\item{runClustering}{A logical value indicating if Clustering should be
run over multiple resolutions as defined by the \code{minResolution} and
\code{maxResolution} parameters. Default is \code{TRUE}.}

\item{plotTSNE}{A logical value indicating if TSNE plot should be visualized
for clusters. Default is \code{TRUE}.}

\item{plotUMAP}{A logical value indicating if UMAP plot should be visualized
for clusters. Default is \code{TRUE}.}

\item{minResolution}{A numeric value indicating the minimum resolution to use
for clustering. Default \code{0.3}.}

\item{maxResolution}{A numeric value indicating the maximum resolution to use
for clustering. Default \code{1.5}.}

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

\item{forceRun}{A logical value indicating if all computations previously
computed should be re-calculated regardless if these computations are
available in the input object. Default is \code{TRUE}.}
}
\value{
A \code{\link[SingleCellExperiment]{SingleCellExperiment}} object
 with computations stored.
}
\description{
Generates an HTML report for Seurat Run (including Normalization,
 Feature Selection, Dimensionality Reduction & Clustering) and returns the
 SCE object with the results computed and stored inside the object.
}
