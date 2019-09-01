# Install R packages

r_version <- "3.6.0"
repos <- "http://cran.us.r-project.org"

packages <- matrix(ncol = 2, byrow = T,
                   data = c(
                     "ggplot2", "3.2.0",
                     "Rcpp", "1.0.1",
                     "IRkernel", "1.0.2",
                     "BiocManager", "1.30.4",
                     "XML", "3.98-1.20",
                     "Seurat", "3.0.2",
                     "sctransform", "0.2.0",
                     "reticulate", "1.13",
                     "curl", "3.3"
                     )
                   )

github <- c("hhoeflin/hdf5r", "mojaveazure/loomR")


bioconductor <- c("GEOquery", "GenomicRanges", "biomaRt")

#################################################################
if(!require("devtools"))
    install.packages("devtools", repos = repos)

library("devtools")



cat("Checking and installing core R packages\n")
for(i in 1:nrow(packages)) {
    if(!require(packages[i,1], character.only = T, quietly = T))
        install_version(packages[i,1], repos = repos, version = packages[i,2])
}


cat("Installing Github packages")
for(i in 1:length(github)) {
    if(!require(basename(github[i]), character.only = T, quietly = T))
        install_github(github[i])
}


cat("Installing Bioconductor packages")
if(!require("BiocManager"))
    stop("BiocManager is not installed, make sure to add it to the main package list\n")
for(i in 1:length(bioconductor)) {
    if(!require(bioconductor[i], character.only = T, quietly = T))
        BiocManager::install(bioconductor[i], update = F, ask = F)
}

cat("\n\nALL DONE!\n\n")
