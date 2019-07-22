mkdir ../data
cd ../data

# hca.loom
#   loom matrix from HCA 
    python3 ../../scripts/hca/matrix_service/python/get_HCA_matrix_by_project_title.py "Single-cell RNA-seq analysis  throughout a 125-day differentiation protocol that converted H1 human embryonic stem cells to a variety of ventrally-derived cell types." hca.loom

# hca_sra.loom
#  loom matrix from HCA with sraIds appended
    python3 ../../scripts/hca/loom/python/append_sraIds_HCA_matrix.py hca.loom hca_sra.loom

# hca_cellTypes.loom
#  loom matrix from HCA with sraIds and cell types appended
    python3 ~/scripts/hca_data_integration/loom/python/append_col_attribute_from_loom.py sra_run cellType insdc_run_accessions paper.loom hca_sra.loom hca_cellTypes.loom

# GSE93593_cell_features.tsv
#   tab-separated gene-by-cell count matrix 
    Rscript ../scripts/R/get_h1_cell_types.R
    mv ../scripts/R/GSE93593_cell_features.tsv ./GSE93593_cell_features.tsv
    
# GSE93593_counts.tsv
#   tab-separated gene-by-cell count matrix 
# 
# paper.loom
#   original count matrix from paper
   
    curl ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE93nnn/GSE93593/suppl/GSE93593_counts.csv.gz | gunzip > GSE93593_counts.csv
    perl -pe 's/,/\t/g;s/"//g' GSE93593_counts.csv > GSE93593_counts.tsv

    # Make loom file
    python3 ../../scripts/hca/loom/python/create_loom_from_matrix_and_cell_labels.py GSE93593_counts.tsv GSE93593_cell_features.tsv paper.loom



