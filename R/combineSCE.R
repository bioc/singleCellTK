.constructSCE <- function(
    matrices,
    features,
    barcodes,
    metadata,
    reducedDims) {
  
  sce <- SingleCellExperiment::SingleCellExperiment(assays = matrices)
  SummarizedExperiment::rowData(sce) <- S4Vectors::DataFrame(features)
  SummarizedExperiment::colData(sce) <- S4Vectors::DataFrame(barcodes)
  S4Vectors::metadata(sce) <- metadata
  SingleCellExperiment::reducedDims(sce) <- reducedDims
  return(sce)
}

.getDimUnion <- function(dataList){
  Row <- lapply(dataList, function(x) {rownames(x)})
  RowUnion <- base::Reduce(union, Row)
  Col <- lapply(dataList, function(x) {colnames(x)})
  ColUnion <- base::Reduce(union, Col)
  return(list(RowUnion, ColUnion))
}

.getMatUnion <- function(dimsList, x,
                         combineRow, combineCol,
                         sparse = FALSE,
                         fill = c("NA", "0")){
  row <- dimsList[[1]]
  col <- dimsList[[2]]
  matOrigin <- x
  fill <- match.arg(fill)
  if (fill == "0") {
    fill <- 0
  } else {
    fill <- NA
  }
  
  ### combine row
  if (isTRUE(combineRow) & (!is.null(row))) {
    missRow <- row[!row %in% rownames(x)]
    missMat <- Matrix::Matrix(fill, nrow = length(missRow), ncol = ncol(matOrigin),
                              dimnames = list(missRow, colnames(matOrigin)))
    if (!isTRUE(sparse)) {
      missMat <- as.matrix(missMat)
    }
    
    mat <- rbind(matOrigin, missMat)
    if (anyDuplicated(rownames(mat))) {
      mat <- mat[!duplicated(rownames(mat)), ]
    }
    matOrigin <- mat[row, ]
  }
  
  ### combine cols
  if (isTRUE(combineCol) & (!is.null(col))) {
    missCol <- col[!col %in% colnames(x)]
    missMat <- Matrix::Matrix(fill, nrow = nrow(matOrigin), ncol = length(missCol),
                              dimnames = list(rownames(matOrigin), missCol))
    if (!isTRUE(sparse)) {
      missMat <- as.matrix(missMat)
    }
    
    mat <- cbind(matOrigin, missMat)
    if (anyDuplicated(colnames(mat))) {
      mat <- mat[, !duplicated(colnames(mat))]
    }
    matOrigin <- mat[, col]
  }
  return(matOrigin)
}


.mergeRowDataSCE <- function(sce.list, by.r) {
    feList <- lapply(sce.list, function(x){
        rw <- SummarizedExperiment::rowData(x)
        rw[['rownames']] <- rownames(rw)
        return(rw)
    })
    
    ## Get merged rowData
    if (is.null(by.r)) {
        by.r <- unique(c('rownames', by.r))
        unionFe <- Reduce(function(r1, r2) merge(r1, r2, by=unique(c(by.r, intersect(names(r1), names(r2)))), all=TRUE), feList)
    }
    else {
      by.r <- unique(c('rownames', by.r))
      unionFe <- Reduce(function(r1, r2) merge(r1, r2, by=by.r, all=TRUE), feList)
    }
    allGenes <- unique(unlist(lapply(feList, rownames)))
    
    ## rowData
    newFe <- unionFe
    if (nrow(newFe) != length(allGenes)) {
        warning("Conflicts were found when merging two rowData. ",
                "Resolved the conflicts by choosing the first entries.",
                "To avoid conflicts, please provide the 'by.r' arguments to ",
                "specify columns in rowData that does not have conflict between two singleCellExperiment object. ")
        newFe <- newFe[!duplicated(newFe$rownames), ]
    }
    rownames(newFe) <- newFe[['rownames']]
    newFe <- newFe[allGenes,]
    return(newFe)
}

.mergeColDataSCE <- function(sceList, by.c) {
  cbList <- lapply(sceList, function(x) {
    cD <- SummarizedExperiment::colData(x)
    cD[['rownames']] <- rownames(cD)
    return(cD)
  })
  
  # Merge columns
  if (is.null(by.c)) {
    by.c <- unique(c("rownames", by.c))
    unionCb <- Reduce(function(c1, c2) merge(c1, c2, by=unique(c(by.c, intersect(names(c1), names(c2)))), all=TRUE), cbList)
  }
  else {
    by.c <- unique(c("rownames", by.c))
    unionCb <- Reduce(function(c1, c2) merge(c1, c2, by=by.c, all=TRUE), cbList)
  }
  rownames(unionCb) <- unionCb[['rownames']]
  newCbList <- list()
  for (i in seq_along(sceList)) {
    newCbList[[i]] <- unionCb[colnames(sceList[[i]]), , drop=FALSE]
  }
  return(newCbList)
}

.mergeRedimSCE <- function(sceList, reduceList) {
  ## get reducedDims for each SCE SummarizedExperiment::
  reduceList <- lapply(sceList, SingleCellExperiment::reducedDims)
  ## get every reducedDim exists in at least one SCEs
  UnionReducedDims <- unique(unlist(lapply(sceList, SingleCellExperiment::reducedDimNames)))
  
  ## for each reducedDim, get union row/cols
  reducedDims <- list()
  for (reduceDim in UnionReducedDims) {
    x <- lapply(sceList, function(x) {if (reduceDim %in% SingleCellExperiment::reducedDimNames(x)) {SingleCellExperiment::reducedDim(x, reduceDim)}})
    reducedDims[[reduceDim]] <- .getDimUnion(x)
  }
  
  ## Merge reducedDim for each SCE
  redList <- list()
  for (idx in seq_along(sceList)){
    redMat <- reduceList[[idx]]
    
    for (DimName in UnionReducedDims) {
      if (DimName %in% names(redMat)) {
        redMat[[DimName]] <- .getMatUnion(reducedDims[[DimName]], redMat[[DimName]],
                                          combineRow = FALSE, combineCol = TRUE,
                                          sparse = FALSE, fill = "NA")
      } else {
        redMat[[DimName]] <- base::matrix(NA, nrow = ncol(sceList[[idx]]),
                                          ncol = length(reducedDims[[DimName]][[2]]),
                                          dimnames = list(colnames(sceList[[idx]]), reducedDims[[DimName]][[2]]))
      }
    }
    
    redList[[idx]] <- redMat
  }
  
  return(redList)
}

.mergeAssaySCE <- function(sceList) {
  UnionAssays <- Reduce(function(d1, d2) base::union(d1, d2),
                        lapply(sceList, SummarizedExperiment::assayNames))
  assayList <- lapply(sceList, assays)
  assayDims <- list(
    unique(unlist(lapply(sceList, rownames))),
    unique(unlist(lapply(sceList, colnames)))
  )
  
  asList <- list()
  for (idx in seq_along(assayList)){
    assay <- assayList[[idx]]
    for (assayName in UnionAssays) {
      if (assayName %in% names(assay)) {
        assay[[assayName]] <- .getMatUnion(assayDims, assay[[assayName]],
                                           combineRow = TRUE, combineCol = FALSE,
                                           sparse = TRUE, fill = "0")
      } else{
        assay[[assayName]] <- Matrix::Matrix(0, nrow = length(assayDims[[1]]),
                                             ncol = ncol(sceList[[idx]]),
                                             dimnames = list(assayDims[[1]], colnames(sceList[[idx]]))) #assayDims[[assayName]])
      }
    }
    asList[[idx]] <- assay
  }
  
  return(asList)
}

# .mergeMetaSCE <- function(sceList) {
#   metaList <- lapply(sceList, S4Vectors::metadata)
#   metaNames <- unlist(lapply(metaList, names))

#   if ("runBarcodeRanksMetaOutput" %in% metaNames) {
#     barcodeMetas <- lapply(metaList, function(x) {x[["runBarcodeRanksMetaOutput"]]})
#     barcodeMetas <- do.call(rbind, barcodeMetas)

#     for (i in seq_along(metaList)) {
#       metaList[[i]][["runBarcodeRanksMetaOutput"]] <- NULL
#     }

#     metaList[["runBarcodeRanksMetaOutput"]] <- barcodeMetas
#   }

#   return(metaList)
# }

.mergeMetaSCE <- function(SCE_list) {
  # Merge highest level metadata entries (except "sctk") by sample names in
  # SCE_list. For analysis results in "sctk", merge by SCE_list sample name if 
  # given "all_cells" in one object, else, use existing sample names. 
  samples <- names(SCE_list)
  sampleMeta <- lapply(SCE_list, S4Vectors::metadata)
  metaNames <- unique(unlist(lapply(sampleMeta, names)))
  sampleSctkMeta <- lapply(SCE_list, function(x) {S4Vectors::metadata(x)$sctk})
  sctkMetaNames <- unique(unlist(lapply(sampleMeta, 
                                        function(x) names(x$sctk))))
  sampleMeta$sctk <- NULL
  metaNames <- metaNames[!metaNames %in% c("sctk")]
  NewMeta <- list()
  for (meta in sctkMetaNames) {
    for (i in seq_along(sampleSctkMeta)) {
      # `i` is for identifying each SCE object, usually matching a sample in 
      # the pipeline. `sampleAvail` for samples stored in metadata entry, in
      # case users are merging merged objects. 
      sampleAvail <- names(sampleSctkMeta[[i]][[meta]])
      if (length(sampleAvail) == 1) {
        NewMeta$sctk[[meta]][[samples[i]]] <- sampleSctkMeta[[i]][[meta]][[1]]
      } else if (length(sampleAvail) > 1) {
        names(sampleSctkMeta[[i]][[meta]]) <- 
          paste(names(sampleSctkMeta)[i], 
                names(sampleSctkMeta[[i]][[meta]]), sep = "_")
        NewMeta$sctk[[meta]] <- c(NewMeta$sctk[[meta]], 
                                  sampleSctkMeta[[i]][[meta]])
      }
    }
  }
  for (meta in metaNames) {
    for (i in seq_along(sampleMeta)) {
      NewMeta[[meta]][[samples[i]]] <- sampleMeta[[i]][[meta]]
    }
  }
  
  if ("assayType" %in% metaNames) {
    assayType <- lapply(SCE_list, function(x){S4Vectors::metadata(x)$assayType})
    assayType <- BiocGenerics::Reduce(dplyr::union, assayType)
    
    NewMeta[["assayType"]] <- assayType
  }
  
  return(NewMeta)
}

#' Combine a list of SingleCellExperiment objects as one SingleCellExperiment object
#' @param sceList A list contains \link[SingleCellExperiment]{SingleCellExperiment} objects.
#' Currently, combineSCE function only support combining SCE objects with assay in dgCMatrix format.
#' It does not support combining SCE with assay in delayedArray format.
#' @param by.r Specifications of the columns used for merging rowData. If set as NULL, 
#' the rownames of rowData tables will be used to merging rowData. Default is NULL. 
#' @param by.c Specifications of the columns used for merging colData. If set as NULL, 
#' the rownames of colData tables will be used to merging colData. Default is NULL.
#' @param combined logical; if TRUE, it will combine the list of SingleCellExperiment objects 
#' and return a SingleCellExperiment. If FALSE, it will return a list of SingleCellExperiment whose
#' rowData, colData, assay and reducedDim data slot are compatible within SCE objects in the list. 
#' Default is TRUE.
#' @return A \link[SingleCellExperiment]{SingleCellExperiment} object which combines all
#' objects in sceList. The colData is merged.
#' @examples
#' data(scExample, package = "singleCellTK")
#' combinedsce <- combineSCE(list(sce,sce), by.r = NULL, by.c = NULL, combined = TRUE)
#' @export

combineSCE <- function(sceList, by.r = NULL, by.c = NULL, combined = TRUE){
  if (length(sceList) == 1) {
    return(sceList[[1]])
  }
  if (typeof(sceList) != "list") {
    stop("Error in combineSCE: input must be a list of SCE objects")
  }
  ##  rowData
  newFeList <- .mergeRowDataSCE(sceList, by.r)
  ## colData
  newCbList <- .mergeColDataSCE(sceList, by.c)
  ## reducedDim
  redMatList <- .mergeRedimSCE(sceList)
  ## assay
  assayList <- .mergeAssaySCE(sceList)
  samples <- names(sceList)
  if (is.null(samples)) {
    samples <- paste0("sample", seq_along(sceList))
  }
  New_SCE <- list()
  for (i in seq(length(sceList))) {
    ## create new sce
    sampleName <- samples[i]
    New_SCE[[sampleName]] <- .constructSCE(matrices = assayList[[i]], 
                                           features = newFeList,
                                           barcodes = newCbList[[i]],
                                           metadata = S4Vectors::metadata(sceList[[i]]),
                                           reducedDims = redMatList[[i]])
  }
  
  if (isTRUE(combined)) {
    sce <- do.call(SingleCellExperiment::cbind, New_SCE)
    meta <- .mergeMetaSCE(New_SCE)
    S4Vectors::metadata(sce) <- meta
    return(sce)
  }
  return(New_SCE)
}
