# Performance benchmarks for `mlr3torch`

## Installation

To install `torch` and friends, run the commands in `install_torch.sh`.

Python packages: `environment.yml` contains a full Python dependency list.

R packages: running `R/install_packages.R` will install all R dependencies.

## Usage

`mamba activate mlr3torch`

Modify the parameters in `config.yml` as you wish. Run `make run_benchmark` (see the Makefile for the commands).

Do NOT touch `python/config.yaml`.