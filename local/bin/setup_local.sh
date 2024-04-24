#!/usr/bin/env bash
start=$(pwd)
source /usr/local/etc/bashrc
## Adding a few random packages used for rendering the ML classifier document.
Rscript -e 'BiocManager::install(c("glmnet", "ranger", "xgboost"))' 2>/dev/null 1>&2
## Adding a few random packages used for rendering the WGCNA document.
Rscript -e 'BiocManager::install(c("irr", "CorLevelPlot", "flashClust"))' 2>/dev/null 1>&2

git clone https://github.com/abelew/EuPathDB.git 2>/dev/null 1>&2
cd EuPathDB || exit

echo "Installing hpgltools packages from Depends via devtools." | tee -a ${log}
Rscript -e 'devtools::install_dev_deps(".", dependencies = "Depends")' 2>/dev/null 1>&2
echo "Installing hpgltools packages from Imports via devtools." | tee -a ${log}
Rscript -e 'devtools::install_dev_deps(".", dependencies = "Imports")' 2>/dev/null 1>&2
echo "Installing hpgltools packages from Suggests via devtools." | tee -a ${log}
Rscript -e 'devtools::install_dev_deps(".", dependencies = "Suggests")' 2>/dev/null 1>&2

make install

cd $start

echo "Instlaling a Leishmania panamensis annotation package." | tee -a ${log}
Rscript -e 'library(EuPathDB); meta <- download_eupath_metadata(webservice = "tritrypdb"); panamensis_entry <- get_eupath_entry("MHOM", metadata = meta[["valid"]]); panamensis_db <- make_eupath_orgdb(panamensis_entry)' 2>dev/null 1>&2
