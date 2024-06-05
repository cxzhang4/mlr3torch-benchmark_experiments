library(here)

time_torch = function(n_epochs, batch_size, lr) {
    source(here("simple_cnn", "R", "torch", "set_up_data.R"))
    source(here("simple_cnn", "R", "torch", "create_learner.R"))
    start_time_torch = proc.time()
    source(here("simple_cnn", "R", "torch", "train_learner.R"))
    elapsed_time_torch = proc.time() - start_time_torch

    source(here("simple_cnn", "R", "torch", "evaluate_learner.R"))

    return(elapsed_time_torch)
}

time_mlr3torch = function(n_epochs, batch_size, lr) {
    source(here("simple_cnn", "R", "mlr3torch", "set_up_data.R"))
    source(here("simple_cnn", "R", "mlr3torch", "create_learner.R"))
    start_time_mlr3torch = proc.time()
    source(here("simple_cnn", "R", "mlr3torch", "train_learner.R"))
    elapsed_time_mlr3torch = proc.time() - start_time_mlr3torch

    source(here("simple_cnn", "R", "mlr3torch", "evaluate_learner.R"))

    return(elapsed_time_mlr3torch)
}