% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{sceBatches}
\alias{sceBatches}
\title{Example Single Cell RNA-Seq data in SingleCellExperiment object, with
different batches annotated}
\format{
An object of class \code{SingleCellExperiment} with 100 rows and 250 columns.
}
\usage{
data('sceBatches')
}
\value{
Example Single Cell RNA-Seq data in SingleCellExperiment object, with
different batches annotated
}
\description{
Two batches of pancreas scRNAseq dataset are combined with their original
counts. Cell types and batches are annotated in `colData(sceBatches)`.
Two batches came from Wang, et al., 2016, annotated as `'w'`; and Xin, et
al., 2016, annotated as `'x'`. Two common cell types, `'alpha'` and
`'beta'`, that could be found in both original studies with relatively
large population were kept for cleaner demonstration.
}
\keyword{datasets}
