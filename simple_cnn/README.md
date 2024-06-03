This directory contains a rudimentary running time benchmark of `mlr3torch` against `torch` and `pytorch`.

- `download_data.R` downloads the specific data that we are using. This should only happen one time, and will be common across all models/training frameworks/etc., and therefore should not factor into their running time.

The R code is structured as follows:
- For each framework, we have
    - `set_up_data.R` sets up the data for the learner, i.e. constructs datasets, performs resampling, etc.
    - `create_learner.R` defines the learner that will be trained on the data.
    - `train_learner.R` trains the learner. This is timed.
    - `evaluate_learner.R` evaluates the learner on out-of-sample data. This is timed.
- `time_training.R` wraps everything into a nicer interface.
- `main.R` performs the benchmark.

The Python code is structured as follows:
- `data.py` defines the Dataset class and relevant transformations.
- `model.py` defines the architecture of the learner.
- `main.py` performs the benchmark: imports the data, trains the learner, evaluates the learner.

The relevant `conda` environment is defined in `environment.yml` in the root of the repository.