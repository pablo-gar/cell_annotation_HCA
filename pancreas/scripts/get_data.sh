mkdir ../data
cd ../data

# hca.loom
#   loom matrix from HCA 

    python3 ../../scripts/hca/matrix_service/python/get_HCA_matrix_by_project_title.py "Single cell transcriptome analysis of human pancreas reveals transcriptional signatures of aging and somatic mutation patterns." hca.loom


# GSE81547_RAW.tar
#   original count files from paper
#   dowload using supplementary file in https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE81547



# GSE81547_cell_features.tsv
#   tab-separated file with each row containing a vector of metadata, with length being the number of cells
#   first column contains the names of the metadata: age, gender, cellType
    Rscript ../scripts/R/get_pancreas_cell_types.R
    mv ../scripts/R/pancreas_GSE81547_cell_features.tsv ./GSE81547_cell_features.tsv
   

# paper.loom
#   loom matrix from the original publication
# GSE81547_counts.tsv
#   gene count matrix in tsv format from original publication
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

        
