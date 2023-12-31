exampleDatasets <- c() ## Need to add final small example data here
if ("TENxPBMCData" %in% rownames(installed.packages())){
  exampleDatasets <- c(exampleDatasets,
                       "PBMC 3K (10X)" = "pbmc3k",
                       "PBMC 4K (10X)" =  "pbmc4k",
                       "PBMC 6K (10X)" = "pbmc6k",
                       "PBMC 8K (10X)" = "pbmc8k",
                       "PBMC 33K (10X)" = "pbmc33k",
                       "PBMC 68K (10X)" = "pbmc68k")
}

if ("scRNAseq" %in% rownames(installed.packages())){
  exampleDatasets <- c(exampleDatasets,
                       "Fluidigm (Pollen et al, 2014)" = "fluidigm_pollen",
                       "Mouse Brain (Tasic et al, 2016)" = "allen_tasic",
                       "NestorowaHSC (Nestorowa et al, 2016)" = "NestorowaHSCData")
}

# User Interface for import Workflow ---
shinyPanelImport <- fluidPage(
  useShinyjs(),
  tags$style(appCSS),
  tags$div(
    class = "jumbotron", style = "background-color:#ededed",
    tags$div(
      class = "container",
      h1("Single Cell Toolkit"),
      p("Filter, cluster, and analyze single cell RNA-Seq data"),
      p(
        "Need help?",
        tags$a(href = paste0(docs.base, "index.html"),
               "Read the docs.", target = "_blank")
      )
    )
  ),
  tags$br(),
  h1("Import"),
  h5(tags$a(href = paste0(docs.artPath, "import_data.html"),
            "(help)", target = "_blank")),
  tags$hr(),

  bsCollapse(
    id = "importUI",
    open = "1. Add sample to import:",
    bsCollapsePanel(
      "1. Add sample to import:",
      radioButtons("uploadChoice", label = NULL, c("Cell Ranger (Version 3 or above)" = "cellRanger3",
                                                   # "Cell Ranger (Version 2)" = "cellRanger2",
                                                   "STARsolo" = "starSolo",
                                                   "BUStools" = "busTools",
                                                   "SEQC" = "seqc",
                                                   "Optimus" = "optimus",
                                                   #"Import from a preprocessing tool" = 'directory',
                                                   "Import from flat files (.csv, .txt, .mtx)" = "files",
                                                   "Upload SingleCellExperiment or Seurat object stored in an RDS File" = "rds",
                                                   "Import example datasets" = "example")
      ),
      tags$hr(),
      conditionalPanel(condition = sprintf("input['%s'] == 'files'", "uploadChoice"),
                       h4("Upload data in tab separated text format:"),
                       fluidRow(
                         column(width = 4,
                                wellPanel(
                                  h5("Example count file:"),
                                  HTML('<table class="table"><thead><tr class="header"><th>Gene</th>
                 <th>Cell1</th><th>Cell2</th><th>&#x2026;</th><th>CellN</th>
                 </tr></thead><tbody><tr class="odd"><td>Gene1</td><td>0</td>
                 <td>0</td><td>&#x2026;</td><td>0</td></tr><tr class="even">
                 <td>Gene2</td><td>5</td><td>6</td><td>&#x2026;</td><td>0</td>
                 </tr><tr class="odd"><td>Gene3</td><td>4</td><td>3</td>
                 <td>&#x2026;</td><td>8</td></tr><tr class="even">
                 <td>&#x2026;</td><td>&#x2026;</td><td>&#x2026;</td>
                 <td>&#x2026;</td><td>&#x2026;</td></tr><tr class="odd">
                 <td>GeneM</td><td>10</td><td>10</td><td>&#x2026;</td><td>10</td>
                 </tr></tbody></table>'),
                                  tags$a(href = "https://drive.google.com/open?id=1n0CtM6phfkWX0O6xRtgPPg6QuPFP6pY8",
                                         "Download an example count file here.", target = "_blank"),
                                  tags$br(),
                                  fileInput(
                                    "countsfile",
                                    HTML(
                                      paste("Input assay (eg. counts, required):",
                                            tags$span(style = "color:red", "*", sep = ""))
                                    ),
                                    accept = c(
                                      "text/csv", "text/comma-separated-values", "mtx",
                                      "text/tab-separated-values", "text/plain", ".csv", ".tsv"
                                    )
                                  )
                                ),
                                h4("Input Assay Type:"),
                                selectInput("inputAssayType", label = NULL,
                                            c("counts", "normcounts", "logcounts", "cpm",
                                              "logcpm", "tpm", "logtpm")
                                )
                         ),
                         column(width = 4,
                                wellPanel(
                                  h5("Example cell annotation file:"),
                                  HTML('<table class="table"><thead><tr class="header"><th>Cell</th>
                 <th>Annot1</th><th>&#x2026;</th></tr></thead><tbody><tr class="odd">
                 <td>Cell1</td><td>a</td><td>&#x2026;</td></tr><tr class="even">
                 <td>Cell2</td><td>a</td><td>&#x2026;</td></tr><tr class="odd">
                 <td>Cell3</td><td>b</td><td>&#x2026;</td></tr><tr class="even">
                 <td>&#x2026;</td><td>&#x2026;</td><td>&#x2026;</td></tr><tr class="odd"><td>CellN</td>
                 <td>b</td><td>&#x2026;</td></tr></tbody></table>'),
                                  tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                                         "Download an example annotation file here.", target = "_blank"),
                                  tags$br(),
                                  fileInput(
                                    "annotFile", "Cell annotations (optional):",
                                    accept = c(
                                      "text/csv", "text/comma-separated-values",
                                      "text/tab-separated-values", "text/plain", ".csv", ".tsv"
                                    )
                                  )
                                )
                         ),
                         column(width = 4,
                                wellPanel(
                                  h5("Example feature file:"),
                                  HTML('<table class="table"><thead><tr class="header"><th>Gene</th>
               <th>Annot2</th><th>&#x2026;</th></tr></thead><tbody><tr class="odd">
                 <td>Gene1</td><td>a</td><td>&#x2026;</td></tr><tr class="even">
                 <td>Gene2</td><td>a</td><td>&#x2026;</td></tr><tr class="odd">
                 <td>Gene3</td><td>b</td><td>&#x2026;</td></tr><tr class="even">
                 <td>&#x2026;</td><td>&#x2026;</td><td>&#x2026;</td></tr><tr class="odd"><td>GeneM</td>
                 <td>b</td><td>&#x2026;</td></tr></tbody></table>'),
                                  tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                                         "Download an example feature file here.", target = "_blank"),
                                  tags$br(),
                                  fileInput(
                                    "featureFile", "Feature annotations (optional):",
                                    accept = c(
                                      "text/csv", "text/comma-separated-values",
                                      "text/tab-separated-values", "text/plain", ".csv", ".tsv"
                                    )
                                  )
                                )
                         )
                       ),
                       actionButton("addFilesImport", "Add to dataset list")
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'example'", "uploadChoice"),
        h4("Choose Example Dataset:"),
        selectInput("selectExampleData", label = NULL, exampleDatasets, width = "340px"),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'fluidigm_pollen'", "selectExampleData"),
          h4(tags$a(href = "http://dx.doi.org/10.1038/nbt.2967", "130 cells from (Pollen et al. 2014), 65 at high coverage and 65 at low coverage", target = "_blank")),
          "Transcriptomes of cell populations in both of low-coverage (~0.27 million reads per cell) and high-coverage (~5 million reads per cell) to identify cell-type-specific biomarkers, and to compare gene expression across samples specifically for cells of a given type as well as to reconstruct developmental lineages of related cell types. Data was loaded from the 'scRNASeq' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'allen_tasic'", "selectExampleData"),
          h4(tags$a(href = "http://dx.doi.org/10.1038/nn.4216", "Mouse visual cortex cells from (Tasic et al. 2016)", target = "_blank")),
          "Subset of 379 cells from the mouse visual cortex. Data was loaded from the 'scRNASeq' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'NestorowaHSCData'", "selectExampleData"),
          h4(tags$a(href = "https://www.nature.com/articles/nbt.2967", "1920 Mouse haematopoietic stem cells from (Nestorowa et al. 2015).", target= "_blank")),
          "Data was loaded from the 'scRNASeq' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'pbmc3k'", "selectExampleData"),
          h4(tags$a(href = "https://doi.org/10.1038/ncomms14049", "2,700 peripheral blood mononuclear cells (PBMCs) from 10X Genomics", target = "_blank")),
          "Data was loaded with the 'TENxPBMCData' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'pbmc4k'", "selectExampleData"),
          h4(tags$a(href = "https://doi.org/10.1038/ncomms14049", "4,430 peripheral blood mononuclear cells (PBMCs) from 10X Genomics", target = "_blank")),
          "Data was loaded with the 'TENxPBMCData' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'pbmc6k'", "selectExampleData"),
          h4(tags$a(href = "https://doi.org/10.1038/ncomms14049", "5,419 peripheral blood mononuclear cells (PBMCs) from 10X Genomics", target = "_blank")),
          "Data was loaded with the 'TENxPBMCData' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'pbmc8k'", "selectExampleData"),
          h4(tags$a(href = "https://doi.org/10.1038/ncomms14049", "8,381 peripheral blood mononuclear cells (PBMCs) from 10X Genomics", target = "_blank")),
          "Data was loaded with the 'TENxPBMCData' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'pbmc33k'", "selectExampleData"),
          h4(tags$a(href = "https://doi.org/10.1038/ncomms14049", "33,148 peripheral blood mononuclear cells (PBMCs) from 10X Genomics", target = "_blank")),
          "Data was loaded with the 'TENxPBMCData' package.",
          tags$br(),
          tags$br()
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'pbmc68k'", "selectExampleData"),
          h4(tags$a(href = "https://doi.org/10.1038/ncomms14049", "68,579 peripheral blood mononuclear cells (PBMCs) from 10X Genomics", target = "_blank")),
          "Data was loaded with the 'TENxPBMCData' package.",
          tags$br(),
          tags$br()
        ),
        actionButton("addExampleImport", "Add to sample list")
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'rds'", "uploadChoice"),
        h4("Choose an RDS file that contains a SingleCellExperiment or Seurat object:"),
        fileInput(
          "rdsFile", "SingleCellExperiment or Seurat RDS file:", accept = c(".rds", ".RDS")
        ),
        actionButton("addRDSImport", "Add to sample list")
      ),
      #conditionalPanel(
      #condition = sprintf("input['%s'] == 'directory'", "uploadChoice"),
      #tags$style(HTML("
      #div {
      #  word-wrap: break-word;
      #}
      #")),
      #h3("2. Choose a Preprocessing Tool:"),
      #radioButtons("algoChoice", label = NULL, c("Cell Ranger v2" = "cellRanger2",
      #                                          "Cell Ranger v3" = "cellRanger3",
      #                                         "STARsolo" = "starSolo",
      #                                        "BUStools" = "busTools",
      #                                       "SEQC" = "seqc",
      #                                      "Optimus" = "optimus")
      #),
      #tags$br(),
      # conditionalPanel(
      #   condition = sprintf("input['%s'] == 'cellRanger2'", "uploadChoice"),
      #   actionButton("addCR2Sample", "Add a sample"),
      # ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'cellRanger3'", "uploadChoice"),
        h4("Upload data for Cell Ranger:"),
        h5("Select matrix, barcodes and feature files for a sample using the file selectors below:"),
        fluidRow(
          column(width = 4,
                 wellPanel(
                   tags$b("Matrix file (e.g. matrix.mtx or matrix.mtx.gz):"),
                   fileInput(
                     "countsfile_custom", "Matrix file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".mtx",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=1n0CtM6phfkWX0O6xRtgPPg6QuPFP6pY8",
                          "Download an example matrix.mtx file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Barcodes file (e.g. barcodes.tsv or barcodes.tsv.gz):"),
                   fileInput(
                     "annotFile_custom", "Barcodes file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                          "Download an example barcodes.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Features file (e.g. features.tsv or features.tsv.gz):"),
                   fileInput(
                     "featureFile_custom", "Features file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                          "Download an example features.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   h5("(OPTIONAL)"),
                   h5("Metrics Summary file (metrics_summary.csv):"),
                   fileInput(
                     "summaryFile_custom", "Summary file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = FALSE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                   #        "Download an example metrics_summary.csv file here.", target = "_blank")
                 )
          )
        ),
        textInput("sampleNameCR", "Name for this sample:", value = "sample", placeholder = "sample"),
        tags$h5("Note: Each sample should be given a unique name", style = "color: red;"),
        actionButton("addFilesImport_custom", "Add to dataset list")
        #actionButton("addCR3Sample", "Add a sample"),
      ),
      # conditionalPanel(
      #   condition = sprintf("input['%s'] == 'starSolo'", "uploadChoice"),
      #   wellPanel(
      #     h5("Please select the directory that contains your /Gene directory as your base directory. ")
      #   ),
      #   actionButton("addSSSample", "Add a sample"),
      # ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'starSolo'", "uploadChoice"),
        h4("Upload data for starSolo:"),
        h5("Select matrix, barcodes and feature files for a sample using the file selectors below:"),
        fluidRow(
          column(width = 4,
                 wellPanel(
                   tags$b("Matrix file (e.g. matrix.mtx or matrix.mtx.gz):"),
                   fileInput(
                     "countsfile_custom_starSolo", "Matrix file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".mtx",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=1n0CtM6phfkWX0O6xRtgPPg6QuPFP6pY8",
                          "Download an example matrix.mtx file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Barcodes file (e.g. barcodes.tsv or barcodes.tsv.gz):"),
                   fileInput(
                     "annotFile_custom_starSolo", "Barcodes file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                          "Download an example barcodes.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Features file (e.g. features.tsv or features.tsv.gz):"),
                   fileInput(
                     "featureFile_custom_starSolo", "Features file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                          "Download an example features.tsv file here.", target = "_blank")
                 )
          )
        ),
        textInput("sampleNameSS", "Name for this sample:", value = "sample", placeholder = "sample"),
        tags$h5("Note: Each sample should be given a unique name", style = "color: red;"),
        actionButton("addFilesImport_custom_starSolo", "Add to dataset list")
        #actionButton("addCR3Sample", "Add a sample"),
      ),
      # conditionalPanel(
      #   condition = sprintf("input['%s'] == 'busTools'", "uploadChoice"),
      #   wellPanel(
      #     h5("Please select your /genecount directory as your base directory.")
      #   ),
      #   actionButton("addBUSSample", "Add a sample"),
      # ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'busTools'", "uploadChoice"),
        h4("Upload data for BUSTools:"),
        h5("Select matrix, barcodes and feature files for a sample using the file selectors below:"),
        fluidRow(
          column(width = 4,
                 wellPanel(
                   tags$b("Matrix file (e.g. matrix.mtx or matrix.mtx.gz):"),
                   fileInput(
                     "countsfile_custom_busTools", "Matrix file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".mtx",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=1n0CtM6phfkWX0O6xRtgPPg6QuPFP6pY8",
                          "Download an example matrix.mtx file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Barcodes file (e.g. barcodes.tsv or barcodes.tsv.gz):"),
                   fileInput(
                     "annotFile_custom_busTools", "Barcodes file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                          "Download an example barcodes.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Features file (e.g. features.tsv or features.tsv.gz):"),
                   fileInput(
                     "featureFile_custom_busTools", "Features file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   ),
                   tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                          "Download an example features.tsv file here.", target = "_blank")
                 )
          )
        ),
        textInput("sampleNameBT", "Name for this sample:", value = "sample", placeholder = "sample"),
        tags$h5("Note: Each sample should be given a unique name", style = "color: red;"),
        actionButton("addFilesImport_custom_busTools", "Add to dataset list")
        #actionButton("addCR3Sample", "Add a sample"),
      ),
      # conditionalPanel(
      #   condition = sprintf("input['%s'] == 'seqc'", "uploadChoice"),
      #   wellPanel(
      #     h5("Please select the directory that contains your sample files as your base directory.")
      #   ),
      #   actionButton("addSEQSample", "Add a sample"),
      # ),
      # conditionalPanel(
      #   condition = sprintf("input['%s'] == 'seqc'", "uploadChoice"),
      #   wellPanel(
      #     h5("Please select the directory that contains your sample files as your base directory.")
      #   ),
      #   actionButton("addSEQSample", "Add a sample"),
      # ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'seqc'", "uploadChoice"),
        h4("Upload data for SEQC:"),
        h5("Select matrix, barcodes and feature files for a sample using the file selectors below:"),
        fluidRow(
          column(width = 4,
                 wellPanel(
                   tags$b("Read counts file (e.g. pbmc_1k_sparse_read_counts.mtx or pbmc_1k_sparse_read_counts.mtx.gz:"),
                   fileInput(
                     "readCounts_custom_seqc", "Read counts file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".mtx",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1n0CtM6phfkWX0O6xRtgPPg6QuPFP6pY8",
                   #        "Download an example matrix.mtx file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Molecule counts file (e.g. pbmc_1k_sparse_molecule_counts.mtx or pbmc_1k_sparse_molecule_counts.mtx.gz):"),
                   fileInput(
                     "moleculeCounts_custom_seqc", "Molecule counts file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".mtx",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                   #        "Download an example barcodes.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Barcodes file (e.g. pbmc_1k_sparse_counts_barcodes.csv):"),
                   fileInput(
                     "barcodes_custom_seqc", "Barcodes file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", 
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                   #        "Download an example features.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Genes file (e.g. pbmc_1k_sparse_counts_genes.csv):"),
                   fileInput(
                     "genes_custom_seqc", "Genes file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                   #        "Download an example features.tsv file here.", target = "_blank")
                 )
          )
        ),
        textInput("sampleNameSC", "Name for this sample:", value = "sample", placeholder = "sample"),
        tags$h5("Note: Each sample should be given a unique name", style = "color: red;"),
        actionButton("addFilesImport_custom_seqc", "Add to dataset list")
        #actionButton("addCR3Sample", "Add a sample"),
      ),
      conditionalPanel(
        condition = sprintf("input['%s'] == 'optimus'", "uploadChoice"),
        h4("Upload data for Optimus:"),
        h5("Select matrix, barcodes and feature files for a sample using the file selectors below:"),
        fluidRow(
          column(width = 4,
                 wellPanel(
                   tags$b("Counts file (e.g. sparse_counts.npz):"),
                   fileInput(
                     "matrix_custom_optimus", "Counts file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".npz",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1n0CtM6phfkWX0O6xRtgPPg6QuPFP6pY8",
                   #        "Download an example matrix.mtx file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Column index file (e.g. sparse_counts_col_index.npy):"),
                   fileInput(
                     "colIndex_custom_optimus", "Column index file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".npy",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=10IDmZQUiASN4wnzO4-WRJQopKvxCNu6J",
                   #        "Download an example barcodes.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Row index file (e.g. sparse_counts_row_index.npy):"),
                   fileInput(
                     "rowIndex_custom_optimus", "Row index file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values", ".npy",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                   #        "Download an example features.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Cell metrics file (e.g. merged-cell-metrics.csv or merged-cell-metrics.csv.gz):"),
                   fileInput(
                     "cellMetrics_custom_optimus", "Cell metrics file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                   #        "Download an example features.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Gene metrics file (e.g. merged-gene-metrics.csv or merged-gene-metrics.csv.gz):"),
                   fileInput(
                     "geneMetrics_custom_optimus", "Gene metrics file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                   #        "Download an example features.tsv file here.", target = "_blank")
                 )
          ),
          column(width = 4,
                 wellPanel(
                   tags$b("Empty drops file (e.g. empty_drops_result.csv):"),
                   fileInput(
                     "emptyDrops_custom_optimus", "Empty drops file:",
                     accept = c(
                       "text/csv", "text/comma-separated-values",
                       "text/tab-separated-values", "text/plain", ".csv", ".tsv", ".gz"
                     ),
                     multiple = TRUE
                   )
                   # ,
                   # tags$a(href = "https://drive.google.com/open?id=1gxXaZPq5Wrn2lNHacEVaCN2a_FHNvs4O",
                   #        "Download an example features.tsv file here.", target = "_blank")
                 )
          )
        ),
        textInput("sampleNameOP", "Name for this sample:", value = "sample", placeholder = "sample"),
        tags$h5("Note: Each sample should be given a unique name", style = "color: red;"),
        actionButton("addFilesImport_custom_optimus", "Add to dataset list")
        #actionButton("addCR3Sample", "Add a sample"),
      ),
      # conditionalPanel(
      #   condition = sprintf("input['%s'] == 'optimus'", "uploadChoice"),
      #   wellPanel(
      #     h5("Please select the directory that contains the following four directories - call-MergeCountFiles, call-MergeCellMetrics, call-MergeGeneMetrics, call-RunEmptyDrops - as your base directory.")
      #   ),
      #   actionButton("addOptSample", "Add a sample"),
      # ),
      style = "primary"
    ),

    bsCollapsePanel(
      "2. Create dataset:",
      wellPanel(
        h4("Samples to Import:"),
        fluidRow(
          column(3, tags$b("Type")),
          column(3, tags$b("Location")),
          column(3, tags$b("Sample Name")),
          column(3, tags$b("Remove"))
        ),
        tags$div(id = "newSampleImport"),
        tags$br(),
        tags$br(),
        actionButton("clearAllImport", "Clear Samples")
      ),
      shinyjs::hidden(
        tags$div(
          id = "combineOptions",
          radioButtons("combineSCEChoice", label = NULL, c("Add to existing dataset" = 'addToExistingSCE',
                                                           "Overwrite existing dataset" = "overwriteSCE")
          )
        )
      ),

        column(
          12,
          fluidRow(
            actionButton("uploadData", "Import"),
            actionButton("backToStepOne", "Add one more sample")
          )
        ),
      style = "primary"
    ),

    bsCollapsePanel(
      "3. Data summary:",
      hidden(
        wellPanel(
          id = "annotationData",
          h3("Data summary"),
          DT::dataTableOutput("summarycontents"),

          tags$hr(),

          h3("Dataset options:"),
          selectInput("importFeatureNamesOpt",
                      "Set feature ID (only showing annotations without the NAs)",
                      c("Default", featureChoice)),
          selectInput("importFeatureDispOpt",
                      "Set feature names to be displayed in downstream visualization",
                      c("Default", featureChoice)),

          withBusyIndicatorUI(actionButton("importFeatureDipSet", "Set")),
        )
      ),

      style = "primary"
    )
  ),
  nonLinearWorkflowUI(id = "nlw-import")
)

