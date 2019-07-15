
library("GEOquery")
geo_id  <- "GSE93593"
out_file <- "GSE93593_cell_features.tsv" # Will contain cell characteristics

# Reading geo data
gsm <- getGEO(geo_id, GSEMatrix = T)

# Shows available metadata
colnames(pData(phenoData(gsm[[1]])))

# Getting metadata
cols <- c("title", "geo_accession", "cell type:ch1", "cre line:ch1", "days in culture:ch1")
cols_rename <- c("sampleName", "geo", "cellType_mother", "creLine", "days")

metadata <- pData(phenoData(gsm[[1]]))[, cols]
colnames(metadata) <- cols_rename
metadata$cellType <- with(metadata, paste0(creLine, "_", days))
head(metadata)

# Save data
metadata <- t(metadata)
write.table(metadata, out_file, sep = "\t", quote = F, col.names = F)
