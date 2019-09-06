# Appendix - Applying machine learning methods to learn and predict cell type annotations

This is a guide to train different machine learning models on different scRNA-seq annotated datasets, and to test them on Enge et al. DCP data.  

**Please refer to my final [internship report](https://docs.google.com/document/d/1tpxBt77FsQdK-G5lwYVyPz2CBeBTTi_TNJt99cmH7bA/edit?usp=sharing) for a complete description of the results**

This guide is intended to be followed after the [set up](https://github.com/pablo-gar/cell_annotation_HCA/blob/master/pancreas/apendix/set_up.md), and [downloading the data]

## Reproducing all results from report
Run the following to reproduce the results in the report. To more details as to how to run individual combinations of training data and machine learning method see the two sections below

#### Models training on individual training sets

```bash
cd pancreas/scripts
bash run_all_individual_models.sh
```

#### Models training on integrated training sets
Combat integration

```bash
cd pancreas/scriptsrun_models_4_integration.sh
bash run_all_individual_models.sh
```
Concatenation

```bash
cd pancreas/scriptsrun_models_4_integration.sh
bash run_models_4_concatenatio.sh
```

## Training models on individual training sets

To train and test an individual model with given dataset run `model_create.py` from the `./pancreas/data` and a desired training and test data:

```bash
cd pancreas/data
mkdir -p ../results

##

script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative_GSE86469.loom"
test_loom="hca_cellTypes.loom"
out_train="paper_model_alternative_GSE86469.h5ad"
out_test="hca_model_alternative_GSE86469.h5ad"
prefix="../results/_model_results_alternative_GSE86469"
model_name="svm_SVC"

python3 $script_path/model_create.py $model_name $train_loom $test_loom cellType $out_train $out_test
```

The `$out_train` and `$out_test` files will be h5ad files with the original matrices containing an extra cell metadata vector with cell type predictions named as `cellType_predicted_[Model Name] ` 

Then you can create a summary of the results by:

```bash
python3 $script_path/model_plot.py $out_test cellType $prefix
```



## Training models on integrated training sets

### Combat-integrated training sets

To train and test a model with multiple datasets by combat integration run `model_create_from_multiple.py ` from the `./pancreas/data` and the desired training sets and test set:

```bash
cd pancreas/data
mkdir -p ../results

##

script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative.loom paper_alternative_GSE86469.loom paper_alternative_GSE84133.loom"
test_loom="hca_cellTypes.loom"

out_h5ad_train="paper_model_alternative_integrated.h5ad"
out_h5ad_test="hca_model_alternative_integrated.h5ad"

model_name="svm_SVC"

python3 $script_path/model_create_from_multiple.py $model_name cellType combat False True $out_h5ad_train $out_h5ad_test ../results/integrated/plots_integration/ $test_loom $train_loom
```

The `$out_train` and `$out_test` files will be h5ad files with the original matrices (concatenated matrix for trained data)  containing an extra cell metadata vector with cell type predictions named as `cellType_predicted_[Model Name] ` 

Then you can create a summary of the results by:

```bash
python3 $script_path/model_plot2.py $out_h5ad_test cellType ../results/integrated/_model_results_3_training
```

### Concatenated training sets

To train and test a model with multiple datasets by concatenation run `model_create_from_multiple.py ` from the `./pancreas/data` and the desired training sets and test set:

```bash
cd pancreas/data
mkdir -p ../results

script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative.loom paper_alternative_GSE86469.loom paper_alternative_GSE84133.loom"
test_loom="hca_cellTypes.loom"

out_h5ad_train="paper_model_alternative_integrated.h5ad"
out_h5ad_test="hca_model_alternative_integrated.h5ad"

model_name="svm_SVC"

python3 $script_path/model_create_from_multiple.py $model_name cellType concatenate True True $out_h5ad_train $out_h5ad_test ../results/integrated/plots_integration/ $test_loom $train_loom

```

The `$out_train` and `$out_test` files will be h5ad files with the original matrices (concatenated matrix for trained data)  containing an extra cell metadata vector with cell type predictions named as `cellType_predicted_[Model Name] ` 

Then you can create a summary of the results by:

```bash
python3 $script_path/model_plot.py $out_h5ad_test cellType ../results/concatenated/_model_results_3_training
```

To train and test a model with multiple datasets by combat integration run `model_create.py` from the `./pancreas/data` and the desired training sets and test set: