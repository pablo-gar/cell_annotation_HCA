# Read header with cell lines
con <- file("pancreas_refseq_rpkms_counts_3514sc.tsv")
header <- readLines(con, n=1)
header <- strsplit(header, "\t")[[1]][-1]
close(con)

# Read metadata
metadata <- read.table("E-MTAB-5061.sdrf.tsv", sep = "\t", stringsAsFactors = F, row.names = 1, header = T)
metadata <- metadata[header,]

conversion <- c(`not applicable` = "unsure",`gamma cell` = "gamma",`alpha cell` = "alpha",
                `beta cell` = "beta",`acinar cell` = "acinar",`epsilon cell` = "epsilon",
                `unclassified cell` = "unsure", `ductal cell` = "ductal", `delta cell` = "delta",
                `unclassified endocrine cell` = "endocrine" ,`endothelial cell` = "endothelial",
                `co-expression cell` = "coexpression_cell" ,`PSC cell` = "PSC",`mast cell` = "mast",
                `MHC class II cell` = "MHC"
)

metadata$cellType <- conversion[metadata$Characteristics.cell.type.]
metadata$id <- rownames(metadata)

write.table(cbind(colnames(metadata), t(metadata)), "pancreas_refseq_rpkms_counts_3514sc_cellTypesCorrected.tsv", sep = "\t", col.names = F, row.names = F, quote = F)
