python3 ~/scripts/hca_data_integration/loom/python/model_preprocessing.py True True True True True False hca_model.h5ad hca_model_cellxgene.h5ad
python3 ~/scripts/hca_data_integration/loom/python/model_preprocessing.py True True True True True False hca_model_alternative.h5ad hca_model_cellxgene_alternative.h5ad

cellxgene launch hca_model_cellxgene.h5ad --open
cellxgene launch hca_model_cellxgene_alternative.h5ad --open
