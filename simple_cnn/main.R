library(here)

# TODO: wrap each experiment in a single function call
# time_torch = function(lr, batch_size, n_epochs, etc.(?))
# performs data setup, instantiates learner
# times the training
# returns the elapsed time

# time_mlr3torch = function()



n_epochs = 3
batch_size = 64
lr = 0.01

source(here("simple_cnn", "download_data.R"))

source(here("simple_cnn", "mlp", "torch", "set_up_data.R"))
source(here("simple_cnn", "mlp", "torch", "instantiate_learner.R"))
start_time_torch = proc.time()
source(here("simple_cnn", "mlp", "torch", "train_learner.R"))
# source(here("simple_cnn", "mlp", "torch", "evaluate_learner.R"))
elapsed_time_torch = proc.time() - start_time_torch

print("torch")
print(elapsed_time_torch)

# mlr3torch
source(here("simple_cnn", "download_data.R"))

source(here("simple_cnn", "mlp", "mlr3torch", "set_up_data.R"))
source(here("simple_cnn", "mlp", "mlr3torch", "instantiate_learner.R"))
start_time_mlr3torch = proc.time()
source(here("simple_cnn", "mlp", "mlr3torch", "train_learner.R"))
# source(here("simple_cnn", "mlp", "mlr3torch", "evaluate_learner.R"))
elapsed_time_mlr3torch = proc.time() - start_time_mlr3torch

print("mlr3torch")
print(elapsed_time_mlr3torch)
