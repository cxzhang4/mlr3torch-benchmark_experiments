# Performance benchmarks for `mlr3torch`

## Installation

To install `torch` and friends, run the commands in `install_torch.sh`.

Python packages: `environment.yml` contains a full Python dependency list.

R packages: running `R/install_packages.R` will install all R dependencies.

## Usage

`mamba activate mlr3torch`

Modify the parameters in `config.yml` as you wish. 

Run `make benchmark`, then `make report`. 

Do NOT touch `python/config.yaml`.

## TODO

- "actually training the network"

    - similar validation loss? (TODO: adjust mlr3torch code to use the "split ==" condition)

    - time validation

    - track validation loss

    - time prediction on test set