
# dir <- "outs/filtered_feature_bc_matrix/"
.constructSCEFromSTARsoloOutputs <- function(dir,
    sample,
    matrixFileName,
    featuresFileName,
    barcodesFileName,
    gzipped,
    class,
    delayedArray) {

    cb <- .readBarcodes(file.path(dir, barcodesFileName))
    fe <- .readFeatures(file.path(dir, featuresFileName))
    ma <- .readMatrixMM(file.path(dir, matrixFileName),
        gzipped = gzipped,
        class = class,
        delayedArray = delayedArray)

    coln <- paste(sample, cb[[1]], sep = "_")
    rownames(ma) <- fe[[1]]

    sce <- SingleCellExperiment::SingleCellExperiment(
        assays = list(counts = ma))
    SummarizedExperiment::rowData(sce) <- fe
    SummarizedExperiment::colData(sce) <- S4Vectors::DataFrame(cb,
        column_name = coln,
        sample = sample,
        row.names = coln)

    return(sce)
}


# main function
.importSTARsolo <- function(STARsoloDirs,
    samples,
    STARsoloOuts,
    matrixFileNames,
    featuresFileNames,
    barcodesFileNames,
    gzipped,
    class,
    delayedArray,
    rowNamesDedup) {

    if (length(STARsoloDirs) != length(samples)) {
        stop("'STARsoloDirs' and 'samples' have unequal lengths!")
    }

    res <- vector("list", length = length(samples))

    temp <- STARsoloOuts
    # in case the old style arguments get passed in
    if (length(STARsoloOuts) == 2 && identical(STARsoloOuts, c("Gene", "GeneFull"))) {
        STARsoloOuts <- paste0(STARsoloOuts, "/filtered")
    } else if (length(STARsoloOuts) == 1 && (STARsoloOuts == "Gene" || STARsoloOuts == "GeneFull")) {
        STARsoloOuts <- paste0(STARsoloOuts, "/filtered")
    }
    STARsoloOuts <- .getVectorized(STARsoloOuts, length(samples))
    matrixFileNames <- .getVectorized(matrixFileNames, length(samples))
    featuresFileNames <- .getVectorized(featuresFileNames, length(samples))
    barcodesFileNames <- .getVectorized(barcodesFileNames, length(samples))
    gzipped <- .getVectorized(gzipped, length(samples))

    for (i in seq_along(samples)) {
        dir <- file.path(STARsoloDirs[i], STARsoloOuts[i])
        scei <- .constructSCEFromSTARsoloOutputs(dir,
            sample = samples[i],
            matrixFileName = matrixFileNames[i],
            featuresFileName = featuresFileNames[i],
            barcodesFileName = barcodesFileNames[i],
            gzipped = gzipped[i],
            class = class,
            delayedArray = delayedArray)
        res[[i]] <- scei
    }

    sce <- do.call(SingleCellExperiment::cbind, res)

    if (isTRUE(rowNamesDedup)) {
        if (any(duplicated(rownames(sce)))) {
            message("Duplicated gene names found, adding '-1', '-2', ",
                    "... suffix to them.")
        }
        sce <- dedupRowNames(sce)
    }

    # Load metrics summary and store in sce
    metrics_summary <- .importMetricsStarSolo(
      samplePaths = STARsoloDirs, 
      sampleNames = samples, 
      metricsPath = temp, 
      metricsFile = "Summary.csv")
    # sce <- setSampleSummaryStatsTable(sce, "starsolo", metrics_summary)
    if (ncol(metrics_summary) > 0) {
      sce@metadata$sctk$sample_summary[["starsolo"]] <- metrics_summary
    }

    return(sce)
}

#' @name importSTARsolo
#' @rdname importSTARsolo
#' @title Construct SCE object from STARsolo outputs
#' @description Read the barcodes, features (genes), and matrices from STARsolo
#'  outputs. Import them
#'  as one \link[SingleCellExperiment]{SingleCellExperiment} object.
#' @param STARsoloDirs A vector of root directories of STARsolo output files.
#'  The paths should be something like this:
#'  \bold{/PATH/TO/\emph{prefix}Solo.out}. For example: \code{./Solo.out}.
#'  Each sample should have its own path. Must have the same length as
#'  \code{samples}.
#' @param samples A vector of user-defined sample names for the sample to be
#'  imported. Must have the same length as \code{STARsoloDirs}.
#' @param STARsoloOuts Character. The intermediate
#'  folder to filtered or raw cell barcode, feature, and matrix files
#'  for each of \code{samples}. Default \code{"Gene"}.
#'  It can be either Gene or GeneFull as the main folder from
#'  which data needs to be imported. 
#' @param matrixFileNames Filenames for the Market Exchange Format (MEX) sparse
#'  matrix file (.mtx file). Must have length 1 or the same
#'  length as \code{samples}.
#' @param featuresFileNames Filenames for the feature annotation file.
#'  Must have length 1 or the same
#'  length as \code{samples}.
#' @param barcodesFileNames Filenames for the cell barcode list file.
#'  Must have length 1 or the same
#'  length as \code{samples}.
#' @param gzipped Boolean. \code{TRUE} if the STARsolo output files
#'  (barcodes.tsv, features.tsv, and matrix.mtx) were
#'  gzip compressed. \code{FALSE} otherwise. This is \code{FALSE} in STAR
#'  2.7.3a. Default \code{"auto"} which automatically detects if the
#'  files are gzip compressed. Must have length 1 or the same
#'  length as \code{samples}.
#' @param class Character. The class of the expression matrix stored in the SCE
#'  object. Can be one of "Matrix" (as returned by
#'  \link{readMM} function), or "matrix" (as returned by
#'  \link[base]{matrix} function). Default "Matrix".
#' @param delayedArray Boolean. Whether to read the expression matrix as
#'  \link{DelayedArray} object or not. Default \code{FALSE}.
#' @param rowNamesDedup Boolean. Whether to deduplicate rownames. Default
#'  \code{TRUE}.
#' @return A \code{SingleCellExperiment} object containing the count
#'  matrix, the gene annotation, and the cell annotation.
#' @examples
#' # Example #1
#' # FASTQ files were downloaded from
#' # https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.0
#' # /pbmc_1k_v3
#' # They were concatenated as follows:
#' # cat pbmc_1k_v3_S1_L001_R1_001.fastq.gz pbmc_1k_v3_S1_L002_R1_001.fastq.gz >
#' # pbmc_1k_v3_R1.fastq.gz
#' # cat pbmc_1k_v3_S1_L001_R2_001.fastq.gz pbmc_1k_v3_S1_L002_R2_001.fastq.gz >
#' # pbmc_1k_v3_R2.fastq.gz
#' # The following STARsolo command generates the filtered feature, cell, and
#' # matrix files
#' # STAR \
#' #   --genomeDir ./index \
#' #   --readFilesIn ./pbmc_1k_v3_R2.fastq.gz \
#' #                 ./pbmc_1k_v3_R1.fastq.gz \
#' #   --readFilesCommand zcat \
#' #   --outSAMtype BAM Unsorted \
#' #   --outBAMcompression -1 \
#' #   --soloType CB_UMI_Simple \
#' #   --soloCBwhitelist ./737K-august-2016.txt \
#' #   --soloUMIlen 12
#'
#' # The top 20 genes and the first 20 cells are included in this example.
#' sce <- importSTARsolo(
#'   STARsoloDirs = system.file("extdata/STARsolo_PBMC_1k_v3_20x20",
#'     package = "singleCellTK"),
#'   samples = "PBMC_1k_v3_20x20")
#' @export
importSTARsolo <- function(
    STARsoloDirs,
    samples,
    STARsoloOuts = c("Gene", "GeneFull"),
    matrixFileNames = "matrix.mtx",
    featuresFileNames = "features.tsv",
    barcodesFileNames = "barcodes.tsv",
    gzipped = "auto",
    class = c("Matrix", "matrix"),
    delayedArray = FALSE,
    rowNamesDedup = TRUE) {

    # accepted STARSolo output directories
    STARsoloOutputs <- c("Gene", "GeneFull", "Gene/filtered", "Gene/raw", "GeneFull/raw", "GeneFull/filtered")
    class <- match.arg(class)
    STARsoloOuts <- match.arg(STARsoloOuts, STARsoloOutputs, several.ok = TRUE)
    # in case the old style arguments get passed in
    if (identical(STARsoloOuts, c("Gene", "GeneFull"))) {
        STARsoloOuts <- paste0(STARsoloOuts, "/filtered")
    }

    .importSTARsolo(
        STARsoloDirs = STARsoloDirs,
        samples = samples,
        STARsoloOuts = STARsoloOuts,
        matrixFileNames = matrixFileNames,
        featuresFileNames = featuresFileNames,
        barcodesFileNames = barcodesFileNames,
        gzipped = gzipped,
        class = class,
        delayedArray = delayedArray,
        rowNamesDedup = rowNamesDedup)
}


# Find metrics_summary.csv file in each sample and merge them into a single dataframe
# Additionally, if file not available for a sample, fill that sample with NA
.importMetricsStarSolo <- function(samplePaths, sampleNames, metricsPath, metricsFile){
  # Check if samplePaths and sampleNames are equal in length
  if(!identical(length(samplePaths), length(sampleNames))){
    stop("Vectors samplePaths and sampleNames must be equal in length.")
  }
  
  # Processing
  metrics_summary <- list()
  for(i in seq(samplePaths)){
    metricsPath <- paste0(samplePaths[i], "/", metricsPath)
    metrics_summary[[i]] <- list.files(pattern= paste0("*", metricsFile, "$"), path = metricsPath, full.names = TRUE)
    if(length(metrics_summary[[i]]) > 0){
      metrics_summary[[i]] <- lapply(metrics_summary[[i]], utils::read.csv, header = FALSE, check.names = FALSE, row.names = 1)[[1]]
    }
    else{
      message("Metrics summary file (", metricsFile, ") not found for sample: ", sampleNames[i])
      ms_colnames_union <- Reduce(union, lapply(metrics_summary, colnames))
      metrics_summary[[i]] <- data.frame(matrix(data = NA, nrow = 1, ncol = length(ms_colnames_union)))
      colnames(metrics_summary[[i]]) <- ms_colnames_union
    }
  }

  # Merge StarSolo summary csv files from all/multiple samples into a single data.frame
  for(i in seq_along(metrics_summary)){
    metrics_summary[[i]] <- as.data.frame(t(metrics_summary[[i]]))
  }
  metrics_summary <- plyr::rbind.fill(metrics_summary)
  metrics_summary <- t(metrics_summary)
  if (ncol(metrics_summary) > 0) {
    colnames(metrics_summary) <- sampleNames
  }

  return(metrics_summary)
}
