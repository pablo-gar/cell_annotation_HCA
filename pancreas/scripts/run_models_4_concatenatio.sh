# Runs models on data, make sure that you wrangled datasets first
cd ../data
mkdir -p ../results/integrated/plots_integration/ 


script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative.loom paper_alternative_GSE86469.loom paper_alternative_GSE84133.loom"
test_loom="hca_cellTypes.loom"

out_h5ad_train="paper_model_alternative_concatenated.h5ad"
out_h5ad_test="hca_model_concatenated.h5ad"

python3 $script_path/model_create_from_multiple.py svm_SVC cellType concatenate True True $out_h5ad_train $out_h5ad_test ../results/integrated/plots_integration/ $test_loom $train_loom

train_loom=${out_h5ad_train}
test_loom=${out_h5ad_test}
for model_name in RandomForest LogisticRegression MLPClassifier KNeighbors
do
    python3 $script_path/model_create_from_multiple.py $model_name cellType concatenate True False $out_h5ad_train $out_h5ad_test ../results/integrated/plots_integration/ $test_loom $train_loom 
done

# Get benchmarking results
python3 $script_path/model_plot.py $out_h5ad_test cellType ../results/integrated/_model_results_3_training
