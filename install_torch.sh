wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
# install, restart shell, make sure conda stuff is loaded etc.
mamba create -n mlr3torch r-base cudatoolkit nvidia/label/cuda-11.8.0::cuda
mamba activate mlr3torch
export PRECXX11ABI=1
export CUDA_HOME="${CONDA_PREFIX}"
export LD_LIBRARY_PATH="${CONDA_PREFIX}/lib:${LD_LIBRARY_PATH}"