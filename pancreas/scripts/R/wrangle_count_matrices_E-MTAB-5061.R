x.con <- file("pancreas_refseq_rpkms_counts_3514sc.tsv", "r")
x.header <- readLines(x.con, n=1)
x.header <- strsplit(x.header, "\t")[[1]]
x.header[1] <- "Gene"

x <- read.table("pancreas_refseq_rpkms_counts_3514sc.tsv", header =  T, sep = "\t", stringsAsFactors = F)

x_fpkm <- x[,c(1,3:3516)]
x_coun <- x[,c(1,3517:7030)]

colnames(x_fpkm) <- x.header
colnames(x_coun) <- x.header

write.table(x_fpkm, "pancreas_refseq_rpkms_3514sc.tsv", sep = "\t", quote = F, row.names = F)
write.table(x_coun, "pancreas_refseq_counts_3514sc.tsv", sep = "\t", quote = F, row.names = F)


