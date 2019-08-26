
library("GEOquery")
library("curl")
library('biomaRt')


# For cell types
geo_id  <- "GSE86469"
out_file <- "GSE86469_cell_features.tsv" # Will contain cell characteristics
out_file_dia <- "GSE86469_cell_features_diabetes.tsv" # Will contain cell characteristics
out_file_non_dia <- "GSE86469_cell_features_healthy.tsv" # Will contain cell characteristics

# Gene count matrix
url_count_mat <- "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE86nnn/GSE86469/suppl/GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.csv.gz"
out_file_count_mat <- "GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.tsv"
out_file_count_mat_dia <- "GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.diabetes.tsv"
out_file_count_mat_non_dia <- "GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.healthy.tsv"

# Reading geo data
gsm <- getGEO(geo_id, GSEMatrix = T)

# Shows available metadata
colnames(pData(phenoData(gsm[[1]])))

# Getting metadata
cols <- c("geo_accession", "title", "characteristics_ch1", paste0("characteristics_ch1.", 1:7))
nCols <- length(cols)
metadata <- pData(phenoData(gsm[[1]]))[, cols]

# Renaming to readeble names
cell_chars  <- sapply(metadata[1,4:nCols], as.character)
cols_rename <- c("geo", "cellID", "cellType", sapply(strsplit(cell_chars, ":"), function(x) x[[1]]))
colnames(metadata) <- cols_rename
                                           
# Cleaning certain values
for(i in 3:nCols) 
    metadata[,i] <- sapply(strsplit(as.character(metadata[,i, drop=T]), ": "), function(x) x[[2]])

# Changing the cell type ontology
correspondance <- setNames(c('unsure', 'beta', 'PSC', 'ductal', 'alpha', 'acinar', 'gamma', 'delta'),
                           c('None/Other', 'Beta', 'Stellate', 'Ductal', 'Alpha', 'Acinar', 'Gamma/PP', 'Delta'))
metadata[,'cellType'] <- correspondance[as.character(metadata[,'cellType'])]

# Separating between diabetes and non-diabetes
metadata_dia <- metadata[metadata$disease == "Type 2 Diabetic",]
metadata_non_dia <- metadata[metadata$disease == "Non-Diabetic",]
head(metadata)
head(metadata_dia)
head(metadata_non_dia)


# Save data
metadata <- t(metadata)
metadata_dia <- t(metadata_dia)
metadata_non_dia <- t(metadata_non_dia)

write.table(metadata, out_file, sep = "\t", quote = F, col.names = F)
write.table(metadata_dia, out_file_dia, sep = "\t", quote = F, col.names = F)
write.table(metadata_non_dia, out_file_non_dia, sep = "\t", quote = F, col.names = F)

# Now downloading and rearraging gene by cell counts

# Getting count matrix
con <- gzcon(url(url_count_mat))
count_mat <- readLines(con)
count_mat <- read.csv(textConnection(count_mat), check.names =F)
#colnames(count_mat)[-1] <- gsub("^X", "", colnames(count_mat)[-1])
close(con)

# Getting genes names
mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
G_list <- getBM(filters= "ensembl_gene_id", 
                attributes= c("ensembl_gene_id","hgnc_symbol", "description"), 
                values=count_mat[,1], 
                mart= mart)

head(G_list)

# Swapping ensembl ids to gene names
G_list <- G_list[!duplicated(G_list$ensembl_gene_id),]
rownames(G_list) <- G_list$ensembl_gene_id

count_mat[,1] <- as.character(count_mat[,1])
colnames(count_mat)[1] <- 'Gene'
gene_names <- G_list[count_mat[,1],2]
count_mat[!is.na(gene_names),1] <- gene_names[!is.na(gene_names)]

# Separate between diabetes and non-diabates
count_mat <- count_mat[,c("Gene", as.character(metadata["cellID",]))]
count_mat_dia <- count_mat[,c("Gene", as.character(metadata_dia["cellID",]))]
count_mat_non_dia <- count_mat[,c("Gene",as.character(metadata_non_dia["cellID",]))]

# Save data
write.table(count_mat, out_file_count_mat, sep = "\t", quote = F, col.names = T, row.names = F)
write.table(count_mat_dia, out_file_count_mat_dia, sep = "\t", quote = F, col.names = T, row.names = F)
write.table(count_mat_non_dia, out_file_count_mat_non_dia, sep = "\t", quote = F, col.names = T, row.names = F)


