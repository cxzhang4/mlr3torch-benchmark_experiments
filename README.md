# Performance benchmarks for `mlr3torch`

## Installation

To install `torch` and friends, run the commands in `install_torch.sh`.

Python packages: `environment.yml` contains a full Python dependency list.

R packages: running `R/install_packages.R` will install all R dependencies.

## Usage

`mamba activate mlr3torch`

Modify the parameters in `config.yml` as you wish. Run `make run_benchmark` (see the Makefile for the commands).

Do NOT touch `python/config.yaml`.

## TODO

- Verify the number of parameters in each network is the same (done)

- "actually training the network"

    - similar validation loss? (TODO: adjust mlr3torch code to use the "split ==" condition)

- Verify batch size (done)

- Number of epochs (done)

Quarto document that describes "this". 

Modify the output format. A new folder for every run. 

