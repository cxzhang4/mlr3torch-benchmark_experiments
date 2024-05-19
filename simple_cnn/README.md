This directory contains a rudimentary running time benchmark for `mlr3torch`.

The code is structured as follows:
- `download_data.R` downloads the specific data that we are using. This should only happen one time, and will be common across all models/training frameworks/etc., and therefore should not factor into their running time.
- `set_up_data.R` sets up the data for the learner, i.e. constructs datasets, performs resampling, etc.
- `instantiate_learner.R` defines the learner that will be trained on the data.
- `train_learner.R` trains the learner.
- `evaluate_learner.R` evaluates the learner on the test set.

