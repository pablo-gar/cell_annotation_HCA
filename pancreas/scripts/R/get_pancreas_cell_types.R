
library("GEOquery")
geo_id  <- "GSE81547"
out_file <- "pancreas_GSE81547_cell_features.tsv" # Will contain cell characteristics

# Reading geo data
gsm <- getGEO(geo_id, GSEMatrix = T)

# Shows available metadata
colnames(pData(phenoData(gsm[[1]])))

# Example to get metadatas
cols <- c("source_name_ch1", 
          "characteristics_ch1", "characteristics_ch1.1", "characteristics_ch1.2")
metadata <- pData(phenoData(gsm[[1]]))[, cols]
head(metadata)

# Save data
write.table(metadata, out_file, sep = "\t", quote = F)


