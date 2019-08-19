# Runs models on data, make sure that you wrangled datasets first
cd ../data
script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative.loom"
test_loom="hca_cellTypes.loom"
python3 $script_path/model_create.py svm_SVC $train_loom $test_loom cellType paper_model_alternative.h5ad hca_model_alternative.h5ad

train_loom="paper_model_alternative.h5ad"
test_loom="hca_model_alternative.h5ad"
for model_name in RandomForest LogisticRegression MLPClassifier KNeighbors GaussianProcess 
do
    python3 $script_path/model_create.py $model_name $train_loom $test_loom cellType paper_model_alternative.h5ad hca_model_alternative.h5ad
done

# Get benchmarking results
mkdir ../results
python3 $script_path/model_plot.py hca_model_alternative.h5ad cellType ../results/_model_results_alternative
