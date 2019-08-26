
# Gets data from GSE84133 into genexcell matrix along the celltypes
out_count <- "GSE84133_human_counts.tsv"
out_cellType <- "GSE84133_human_cellTypes.tsv"

# Downloads data
download.file("https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE84133&format=file", destfile="GSE84133_RAW.tar")
untar("GSE84133_RAW.tar")

cell_counts <- list()
for(i in list.files(pattern="*human*")){
    cell_counts[[i]] <- read.table(gzfile(i), sep=',', stringsAsFactors=F, header=T)
}
cell_counts <- do.call(rbind, cell_counts)

# Getting cell types
cell_types <- as.data.frame(setNames(cell_counts[,3], cell_counts[,1]))
colnames(cell_types) <- "cellType"
#Correcting cell types
cell_types$cellType <- as.character(cell_types$cellType)
cell_types$cellType[cell_types$cellType == "activated_stellate"] <- "PSC"
cell_types$cellType[cell_types$cellType == "quiescent_stellate"] <- "PSC"

cell_types$cellID <- rownames(cell_types)
cell_types <- t(cell_types)


#rownames(cell_counts) <- cell_counts[,1]
cell_counts <- cell_counts[,-(1:3)]
cell_counts <- t(cell_counts)
cell_counts <- cbind(gene=rownames(cell_counts), cell_counts)

head(cell_counts[,1:4])
head(cell_types[,1:4])

# Save data
write.table(cell_counts, out_count, sep="\t", quote=F, row.names=F)
write.table(cell_types, out_cellType, sep="\t", quote=F, col.names=F)
