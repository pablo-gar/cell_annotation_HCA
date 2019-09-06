# Appendix - Data wrangling and retrieval
This is a guide to download all training and test pancreas datasets

**Please refer to my final [internship report](https://docs.google.com/document/d/1tpxBt77FsQdK-G5lwYVyPz2CBeBTTi_TNJt99cmH7bA/edit?usp=sharing) for a complete description of the results**

This guide is intended to be followed after the [set up](https://github.com/pablo-gar/cell_annotation_HCA/blob/master/pancreas/apendix/set_up.md)

## Enge et al. 

### Author data
To download the paper data first download supplementary file `GSE81547_RAW.tar` from [GSE81547](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE81547) into `./pancreas/data` of the the git repo root (see [set up](https://github.com/pablo-gar/cell_annotation_HCA/blob/master/pancreas/apendix/set_up.md)) 

Extract cell type information

```bash
cd ./pancreas/data/
Rscript ../scripts/R/get_pancreas_cell_types.R
mv ../scripts/R/pancreas_GSE81547_cell_features.tsv ./GSE81547_cell_features.tsv
```

Create cell-by-gene count matrix

```bash
tar -xf GSE81547_RAW.tar

# Get gene names
for i in GSM*gz
do
    cat <(echo geneName) <(gunzip -c $i |  cut -f 1) > GSM1gene_names
    break
done

# Uncompress all files

for i in GSM*gz
do
    geo=$(perl -pe 's/_.+//' <(echo $i))
    gunzip -c $i | cut -f 2 > $geo.tsv.temp
    cat <(echo $geo) $geo.tsv.temp > $geo.tsv
    rm $geo.tsv.temp
    rm $i
done

# Compile all
paste GSM* | grep -v -e "no_feature" -e "ambiguous" -e "too_low_aQual" -e "not_aligned" -e "alignment_not_unique" > GSE81547_counts.tsv
rm GSM*

# Make loom file
python3 ../../scripts/hca/loom/python/create_loom_from_matrix_and_cell_labels.py GSE81547_counts.tsv GSE81547_cell_features.tsv paper.loom
```

This will create the `paper.loom` file that contains the count matrix along cell type annotations

### DCP data
```bash
# hca.loom
#   loom matrix from HCA 

python3 ../../scripts/hca/matrix_service/python/get_HCA_matrix_by_project_title.py "Single cell transcriptome analysis of human pancreas reveals transcriptional signatures of aging and somatic mutation patterns." hca.loom

# hca_sra.loom
#  loom matrix from HCA with sraIds appended
python3 ../../scripts/hca/loom/python/append_sraIds_HCA_matrix.py hca.loom hca_sra.loom

# hca_cellTypes.loom
#  loom matrix from HCA with sraIds and cell types appended
python3 ~/scripts/hca_data_integration/loom/python/append_col_attribute_from_loom.py sra_run cellType insdc_run_accessions paper.loom hca_sra.loom hca_cellTypes.loom
```

This will create the `hca_cellTypes.loom` that contains the DCP count matrix along with cell type labels 

## Segerstolpe et al.

Execute the following in `./pancreas/data` to create `paper_alternative.loom` which will contain the paper's count matrix along with cell types

```bash
# pancreas_refseq_rpkms_counts_3514sc.tsv
# pancreas_refseq_rpkms_3514sc.tsv
# pancreas_refseq_counts_3514sc.tsv
    curl https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-5061/E-MTAB-5061.processed.1.zip > E-MTAB-5061.processed.1.zip
    unzip E-MTAB-5061.processed.1.zip
    rm E-MTAB-5061.processed.1.zip
    mv pancreas_refseq_rpkms_counts_3514sc.txt pancreas_refseq_rpkms_counts_3514sc.tsv

    Rscript ../scripts/wrangle_count_matrices_E-MTAB-5061.R

# E-MTAB-5061.sdrf.txt
    curl https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-5061/E-MTAB-5061.sdrf.txt > E-MTAB-5061.sdrf.tsv

# pancreas_refseq_rpkms_counts_3514sc_cellTypesCorrected.tsv
    Rscript ../scripts/R/order_cell_types_E-MTAB-5061.R

# paper_alternative.loom 
    python3 ../../scripts/hca/loom/python/create_loom_from_matrix_and_cell_labels.py pancreas_refseq_counts_3514sc.tsv pancreas_refseq_rpkms_counts_3514sc_cellTypesCorrected.tsv paper_alternative.loom

# paper_alternative_rpkm.loom
    python3 ../../scripts/hca/loom/python/create_loom_from_matrix_and_cell_labels.py pancreas_refseq_rpkms_3514sc.tsv pancreas_refseq_rpkms_counts_3514sc_cellTypesCorrected.tsv paper_alternative_rpkms.loom
```

## Baron et al.
Execute the following in `./pancreas/data` to create `paper_alternative_GSE84133.loom` which will contain the paper's count matrix along with cell types

```bash

# GSE84133_human_counts.tsv
#   Raw gene counts for all 3 human samples
# GSE84133_human_cellTypes.tsv
#   Cell types
    Rscript ../scripts/R/get_pancreas_cell_types_GSE84133.R
    mv ../scripts/R/*tsv ./

# paper_alternative_GSE84133.loom 
    python3 ../../scripts/hca/loom/python/create_loom_from_matrix_and_cell_labels.py GSE84133_human_counts.tsv GSE84133_human_cellTypes.tsv paper_alternative_GSE84133.loom

```

## Lawlor et al.
Execute the following in `./pancreas/data` to create `paper_alternative_GSE86469.loom` which will contain the paper's count matrix along with cell types

```bash

# GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.tsv
#   original count matrix from paper, values are counts per million
# GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.diabetes.tsv
#   only cells from donors with diabetes
# GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.healthy.tsv
#   only cells from healthy donors
# GSE86469_cell_features.tsv
#   cell types and other metadata
# GSE86469_cell_features_diabetes.tsv
#   only cells from donors with diabetes
# GSE86469_cell_features_healthy.tsv
#   only cells from healthy donors 

    Rscript ../scripts/R/get_pancreas_cell_types_GSE86469.R
    mv ../scripts/R/*tsv ./

# paper_alternative_GSE86469.loom 
    python3 ../../scripts/hca/loom/python/create_loom_from_matrix_and_cell_labels.py GSE86469_GEO.islet.single.cell.processed.data.RSEM.raw.expected.counts.healthy.tsv GSE86469_cell_features_healthy.tsv paper_alternative_GSE86469.loom

```