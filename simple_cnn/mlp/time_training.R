library(here)

time_torch = function(n_epochs, batch_size, lr) {
    source(here("simple_cnn", "mlp", "torch", "set_up_data.R"))
    source(here("simple_cnn", "mlp", "torch", "instantiate_learner.R"))
    start_time_torch = proc.time()
    source(here("simple_cnn", "mlp", "torch", "train_learner.R"))
    elapsed_time_torch = proc.time() - start_time_torch

    return(elapsed_time_torch)
}

time_mlr3torch = function(n_epochs, batch_size, lr) {
    source(here("simple_cnn", "mlp", "mlr3torch", "set_up_data.R"))
    source(here("simple_cnn", "mlp", "mlr3torch", "instantiate_learner.R"))
    start_time_mlr3torch = proc.time()
    source(here("simple_cnn", "mlp", "mlr3torch", "train_learner.R"))
    elapsed_time_mlr3torch = proc.time() - start_time_mlr3torch

    return(elapsed_time_mlr3torch)
}