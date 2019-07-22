
library("GEOquery")
library("curl")
library("XML")

geo_id  <- "GSE93593"
sra_study <- "SRP096727" # TODO getting this ID can be automated by making a request to NCBI's eutils
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

# Gettting sra run ids, useful for integrating with HCA data from the DCP

# Do a serch for the project first
request <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=sra&term=", sra_study, "&usehistory=y")
result <- xmlRoot(xmlParse(readLines(curl(request)), asText = TRUE))

# Download sra info table
request <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=sra&query_key=", xmlValue(result[["QueryKey"]]), "&WebEnv=", xmlValue(result[["WebEnv"]]), "&rettype=runinfo&retmode=text")
sra_info <- read.table(curl(request), sep = ",", header = TRUE, stringsAsFactors = F)
sra_info <- sra_info[grep("GSM", sra_info[,"SampleName"]),]

rownames(sra_info) <- sra_info[,"SampleName"] # Make sure that SampleName is actually a GSM id 

# Merge sra run ids and sra exp ids into metadata from GEO
metadata$sra_run <- sra_info[metadata$geo, "Run"]
metadata$sra_sample <- sra_info[metadata$geo, "Sample"]

# Save data
metadata <- t(metadata)
write.table(metadata, out_file, sep = "\t", quote = F, col.names = F)
