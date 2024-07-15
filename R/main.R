library(here)
library(torch)

source(here("R", "get_data.R"))

source(here("R", "torch", "data_setup.R"))
source(here("R", "torch", "learner_creation.R"))
source(here("R", "torch", "learner_training.R"))

source(here("R", "mlr3torch", "data_setup.R"))
source(here("R", "mlr3torch", "learner_creation.R"))
source(here("R", "mlr3torch", "learner_training.R"))

source(here("R", "time_training.R"))

config = config::get()

# get data if necessary
data_dir = here("data", "correlation")
should_download = list.files(data_dir) == 0
get_data(data_dir, should_download)

# arbitrarily define indices
trn_idx = 1:(config$train_size)

# torch
trn_idx = 1:(config$train_size)
train_torch_ds = create_torch_ds(data_dir, trn_idx)
input_dim = prod(dim(train_torch_ds[1]$x))
output_dim = 1
train_dl = dataloader(train_torch_ds, batch_size = config$batch_size, shuffle = TRUE)

torch_learner = create_torch_learner(config$architecture_id)
torch_opt = create_opt(torch_learner, config$learning_rate)

torch_results = time_torch(torch_learner, torch_opt, train_dl, config$n_epochs)

# mlr3torch
train_mlr3torch_ds = create_mlr3torch_dataset(data_dir, trn_idx)

train_responses = fread(here(data_dir, "guess-the-correlation", "train_responses.csv"))
response_col_name = "corr"
tsk_gtcorr = create_task_from_ds(train_mlr3torch_ds, train_responses, response_col_name)

# define learner
mlr3torch_learner = create_mlr3torch_learner(config$architecture_id, config$batch_size, config$n_epochs, 
                                             config$learning_rate, config$accelerator)
mlr3torch_results = time_mlr3torch(mlr3torch_learner, tsk_gtcorr)

# save results

print(torch_results)
print(mlr3torch_results)