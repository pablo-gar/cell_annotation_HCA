# Appendix - Hyper parameter tuning for machine learning models

This is document list what parameters were tuned for each machine learning model used in the study.

For each set of parameters below, up to 50 random combinations were tested using a 5-fold cross-validation strategy.

The list of parameters and their options is presented as python dictionaries ready to use in the sklearn suite. Parameters not shown were set as the defaults from sklearn.

**Please refer to my final [internship report](https://docs.google.com/document/d/1tpxBt77FsQdK-G5lwYVyPz2CBeBTTi_TNJt99cmH7bA/edit?usp=sharing) for a complete description of the results and methods**

## Parameters selected per model and training set

### Training on Enge et al.
* KNeighbors
  *  n_neighbors :  5
  *  p :  2
  *  weights :  distance
* LogisticRegression
  *  C :  100
  *  fit_intercept :  True
  *  l1_ratio :  0.75
  *  multi_class :  multinomial
  *  penalty :  elasticnet
  *  solver :  saga
  *  tol :  0.1
* MLPClassifier
  *  activation :  logistic
  *  hidden_layer_sizes :  [100 100]
  *  learning_rate :  adaptive
  *  solver :  adam
* RandomForest
  *  bootstrap :  False
  *  max_features :  auto
  *  min_samples_leaf :  1
  *  min_samples_split :  5
  *  n_estimators :  200
* svm_SVC
  *  C :  10
  *  gamma :  1.916969131867515e-05
  *  kernel :  rbf

### Training on Segerstolpe et al.
* KNeighbors
  *  n_neighbors :  2
  *  p :  2
  *  weights :  uniform
* LogisticRegression
  *  C :  200
  *  fit_intercept :  True
  *  l1_ratio :  0.5
  *  multi_class :  multinomial
  *  penalty :  elasticnet
  *  solver :  saga
  *  tol :  0.01
* MLPClassifier
  *  activation :  relu
  *  hidden_layer_sizes :  [500 500 500]
  *  learning_rate :  adaptive
  *  solver :  adam
* RandomForest
  *  bootstrap :  False
  *  max_depth :  80
  *  max_features :  auto
  *  min_samples_leaf :  1
  *  min_samples_split :  10
  *  n_estimators :  1800
* svm_SVC
  *  C :  50
  *  gamma :  3.0789559171473314e-06
  *  kernel :  rbf

### Training on Lawlor et al.
* KNeighbors
  *  n_neighbors :  10
  *  p :  2
  *  weights :  distance
* LogisticRegression
  *  C :  50
  *  fit_intercept :  False
  *  l1_ratio :  1.0
  *  multi_class :  multinomial
  *  penalty :  elasticnet
  *  solver :  saga
  *  tol :  0.001
* MLPClassifier
  *  activation :  logistic
  *  hidden_layer_sizes :  1000
  *  learning_rate :  constant
  *  solver :  lbfgs
* RandomForest
  *  bootstrap :  False
  *  max_depth :  70
  *  max_features :  sqrt
  *  min_samples_leaf :  1
  *  min_samples_split :  2
  *  n_estimators :  800
* svm_SVC
  *  C :  10
  *  gamma :  1.5134379235124851e-05
  *  kernel :  rbf

### Training on Baron et al.
* KNeighbors
  *  n_neighbors :  2
  *  p :  2
  *  weights :  distance
* LogisticRegression
  *  C :  700
  *  fit_intercept :  False
  *  l1_ratio :  0.5
  *  multi_class :  multinomial
  *  penalty :  elasticnet
  *  solver :  saga
  *  tol :  1e-07
* MLPClassifier
  *  activation :  relu
  *  hidden_layer_sizes :  [500 500]
  *  learning_rate :  adaptive
  *  solver :  adam
* RandomForest
  *  bootstrap :  False
  *  max_depth :  80
  *  max_features :  auto
  *  min_samples_leaf :  1
  *  min_samples_split :  10
  *  n_estimators :  1800
* svm_SVC
  *  C :  50
  *  gamma :  0.00017803593647345033
  *  kernel :  rbf



## Parameter space per method

### SVM-SVC 

gamma_factor = 1 / (# genes x matrix variance)

```python
    x = [{'kernel': ['rbf'],
         'gamma': [gamma_factor * 1, gamma_factor * 1e1, gamma_factor * 1e2, gamma_factor * 1e3,
                   gamma_factor * 1e-1, gamma_factor * 1e-2, gamma_factor * 1e-3],
          'C': [1, 10, 50, 100, 500, 1000]
          },
          
         {'kernel': ['linear'],
          'C': [1, 10, 50, 100, 500, 1000]
         }
        ]
```

### Logistic regression 

```python
    x = [{'penalty': ['elasticnet'],
          'tol': [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1],
          'C': [1, 10, 20, 50, 70, 100, 200, 500, 700, 1000, 2000],
          'fit_intercept': [True, False],
          'solver': ['saga'],
          'multi_class': ['multinomial'],
          'l1_ratio': [0.00, 0.25, 0.50, 0.75, 1.00]
          }
         ]
```


### Random Forest 

```python
    x = [{'bootstrap': [True, False],
          'max_depth': [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, None],
          'max_features': ['auto', 'sqrt'],
          'min_samples_leaf': [1, 2, 4],
          'min_samples_split': [2, 5, 10],
          'n_estimators': [200, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000]}
        ]
```

### kNN

```python
    x = [{'n_neighbors': [2, 5, 10, 25, 50, 100, 200],
          'weights': ['uniform', 'distance'],
          'p': [1, 2],
          }
         ]

```

### MLP

```python
    x = [{'hidden_layer_sizes': [(100), (100, 100), (100, 100, 100),
                                 (500), (500, 500), (500, 500, 500),
                                 (1000), (1000, 1000), (1000, 1000, 1000)],
          'activation': ['logistic', 'relu'],
          'solver': ['adam', 'lbfgs'],
          'learning_rate': ['constant', 'adaptive']
          }
         ]

```

