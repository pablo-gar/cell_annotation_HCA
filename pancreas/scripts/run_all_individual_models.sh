# Runs models on data, make sure that you wrangled datasets first
cd ../data
mkdir -p ../results

##

script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative_GSE86469.loom"
test_loom="hca_cellTypes.loom"
out_train="paper_model_alternative_GSE86469.h5ad"
out_test="hca_model_alternative_GSE86469.h5ad"
prefix="../results/_model_results_alternative_GSE86469"

python3 $script_path/model_create.py svm_SVC $train_loom $test_loom cellType $out_train $out_test

train_loom=$out_train
test_loom=$out_test
for model_name in RandomForest LogisticRegression MLPClassifier KNeighbors
do
    python3 $script_path/model_create.py $model_name $train_loom $test_loom cellType $out_train $out_test
done

# Get benchmarking results
python3 $script_path/model_plot.py $out_test cellType $prefix


##

train_loom="paper_alternative.loom"
test_loom="hca_cellTypes.loom"
out_train="paper_model_alternative.h5ad"
out_test="hca_model_alternative.h5ad"
prefix="../results/_model_results_alternative"

python3 $script_path/model_create.py svm_SVC $train_loom $test_loom cellType $out_train $out_test

train_loom=$out_train
test_loom=$out_test
for model_name in RandomForest LogisticRegression MLPClassifier KNeighbors
do
    python3 $script_path/model_create.py $model_name $train_loom $test_loom cellType $out_train $out_test
done

# Get benchmarking results
python3 $script_path/model_plot.py $out_test cellType $prefix


##

script_path="../../scripts/hca/loom/python"

train_loom="paper_alternative_GSE84133.loom"
test_loom="hca_cellTypes.loom"
out_train="paper_model_alternative_GSE84133.h5ad"
out_test="hca_model_alternative_GSE84133.h5ad"
prefix="../results/_model_results_alternative_GSE84133"

python3 $script_path/model_create.py svm_SVC $train_loom $test_loom cellType $out_train $out_test

train_loom=$out_train
test_loom=$out_test
for model_name in RandomForest LogisticRegression MLPClassifier KNeighbors
do
    python3 $script_path/model_create.py $model_name $train_loom $test_loom cellType $out_train $out_test
done

# Get benchmarking results
python3 $script_path/model_plot.py $out_test cellType $prefix

