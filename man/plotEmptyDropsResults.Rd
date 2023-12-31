% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggPerQCWrapper.R
\name{plotEmptyDropsResults}
\alias{plotEmptyDropsResults}
\title{Plots for runEmptyDrops outputs.}
\usage{
plotEmptyDropsResults(
  inSCE,
  sample = NULL,
  combinePlot = "all",
  fdrCutoff = 0.01,
  defaultTheme = TRUE,
  dotSize = 0.5,
  titleSize = 18,
  axisLabelSize = 18,
  axisSize = 15,
  legendSize = 15,
  legendTitleSize = 16,
  relHeights = 1,
  relWidths = 1,
  samplePerColumn = TRUE,
  sampleRelHeights = 1,
  sampleRelWidths = 1
)
}
\arguments{
\item{inSCE}{Input \linkS4class{SingleCellExperiment} object with saved
dimension reduction components or a variable with saved results from
\code{\link{runEmptyDrops}}. Required.}

\item{sample}{Character vector or colData variable name. Indicates which 
sample each cell belongs to. Default \code{NULL}.}

\item{combinePlot}{Must be either \code{"all"}, \code{"sample"}, or object,
\code{"none"}. \code{"all"} will combine all plots into a single .ggplot 
while \code{"sample"} will output a list of plots separated by sample. 
Default \code{"all"}.}

\item{fdrCutoff}{Numeric. Thresholds barcodes based on the FDR values from
\code{\link{runEmptyDrops}} as "Empty Droplet" or "Putative Cell". Default 
\code{0.01}.}

\item{defaultTheme}{Removes grid in plot and sets axis title size to 
\code{10} when \code{TRUE}. Default \code{TRUE}.}

\item{dotSize}{Size of dots. Default \code{0.5}.}

\item{titleSize}{Size of title of plot. Default \code{18}.}

\item{axisLabelSize}{Size of x/y-axis labels. Default \code{18}.}

\item{axisSize}{Size of x/y-axis ticks. Default \code{15}.}

\item{legendSize}{size of legend. Default \code{15}.}

\item{legendTitleSize}{size of legend title. Default \code{16}.}

\item{relHeights}{Relative heights of plots when combine is set. Default 
\code{1}.}

\item{relWidths}{Relative widths of plots when combine is set. Default 
\code{1}.}

\item{samplePerColumn}{If \code{TRUE}, when there are multiple samples and 
combining by \code{"all"}, the output .ggplot will have plots from each 
sample on a single column. Default \code{TRUE}.}

\item{sampleRelHeights}{If there are multiple samples and combining by 
\code{"all"}, the relative heights for each plot. Default \code{1}.}

\item{sampleRelWidths}{If there are multiple samples and combining by 
\code{"all"}, the relative widths for each plot. Default \code{1}.}
}
\value{
list of .ggplot objects
}
\description{
A wrapper function which visualizes outputs from the
\code{\link{runEmptyDrops}} function stored in the \code{colData} slot of the 
\linkS4class{SingleCellExperiment} object.
}
\examples{
data(scExample, package = "singleCellTK")
sce <- runEmptyDrops(inSCE = sce)
plotEmptyDropsResults(inSCE = sce)
}
\seealso{
\code{\link{runEmptyDrops}}, \code{\link{plotEmptyDropsScatter}}
}
