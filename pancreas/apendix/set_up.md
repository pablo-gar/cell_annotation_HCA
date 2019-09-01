# Appendix - Set up and download pancreas datasets
This is a guide to fully set up all necessary files, scripts and python/R packages from this repository ([https://github.com/pablo-gar/cell_annotation_HCA](https://github.com/pablo-gar/cell_annotation_HCA))

Upon setting up you can proceed with training and applying cell type annotation models for scRNA-seq data as well as reproduce the results obtained for the pancreas dataset

**Please refer to my final [internship report](https://docs.google.com/document/d/1tpxBt77FsQdK-G5lwYVyPz2CBeBTTi_TNJt99cmH7bA/edit?usp=sharing) for a complete description of the results**

## Downloading scripts, enviroments and results
Just clone the repo

```bash
git clone https://github.com/pablo-gar/cell_annotation_HCA
```

## Set up python and R installations
*This requres a conda and R>= 3.4 installation*

Install python environment

```bash
cd environments
conda env create -f czi_cell_annotation.yml
```

Intsall R packages

```bash
