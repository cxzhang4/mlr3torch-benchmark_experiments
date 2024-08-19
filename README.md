# Performance benchmarks for `mlr3torch`

## Installation

To create a `mamba` environment and install R `torch`, run the commands in `install_torch.sh`.

Python packages: `environment.yml` contains a full Python dependency list.

R packages: run `R/install_packages.R`. The R dependency versions are not currently managed.

## Usage

`mamba activate mlr3torch`

Modify the parameters in `config.yml` as you wish. 

Run `make benchmark`, then `make report`. 

Do NOT touch `python/config.yaml`.

Contact [Carson](https://github.com/cxzhang4) if you have issues.