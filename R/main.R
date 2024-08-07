library(here)
library(torch)
library(bench)
library(readr)
library(magrittr)
library(tibble)
library(dplyr)

source(here("R", "get_data.R"))

source(here("R", "torch", "data_setup.R"))
source(here("R", "torch", "learner_creation.R"))
source(here("R", "torch", "learner_training.R"))

source(here("R", "mlr3torch", "data_setup.R"))
source(here("R", "mlr3torch", "learner_creation.R"))
source(here("R", "mlr3torch", "learner_training.R"))

source(here("R", "time_training.R"))

config = config::get()

data_dir = here("data", "correlation")
should_download = list.files(data_dir) == 0
get_data(data_dir, should_download)

trn_idx = 1:(config$train_size)
train_torch_ds = create_torch_ds(data_dir, trn_idx, config$architecture_id)
input_dim = prod(dim(train_torch_ds[1]$x))
output_dim = 1
train_dl = dataloader(train_torch_ds, batch_size = config$batch_size, shuffle = TRUE)

torch_learner = create_torch_learner(config$architecture_id)
torch_opt = create_opt(torch_learner, config$learning_rate)

train_mlr3torch_ds = create_mlr3torch_dataset(data_dir, config$architecture_id, trn_idx)
train_responses = fread(here(data_dir, "guess-the-correlation", "train_responses.csv"))
response_col_name = "corr"
tsk_gtcorr = create_task_from_ds(train_mlr3torch_ds, train_responses, response_col_name, config$architecture_id)

mlr3torch_learner = create_mlr3torch_learner(config$architecture_id, config$batch_size, config$n_epochs, 
                                             config$learning_rate, config$accelerator)

benchmark_results = mark(
  train_torch_learner(torch_learner, torch_opt, config$accelerator, train_dl, config$n_epochs),
  train_mlr3torch_learner(mlr3torch_learner, tsk_gtcorr),
  min_time = 50,
  iterations = NULL,
  min_iterations = 1,
  max_iterations = 10000,
  check = FALSE,
  memory = FALSE, # TODO: determine what this arg should be 
  filter_gc = TRUE,
  relative = FALSE,
  time_unit = NULL,
  exprs = NULL,
  env = parent.frame()
)

print(benchmark_results)

config_vec = unlist(config)
config_cols = as_tibble(t(config_vec))

benchmark_results = benchmark_results %>%
  select(min, median, `itr/sec`, n_itr, total_time) %>%
  bind_cols(config_cols)

output_file_name = "benchmark_results-r.csv"
if (file.exists(output_file_name)) {
  prev_results = read_csv(output_file_name)
  write_delim(prev_results %>% bind_rows(benchmark_results), output_file_name)
} else {
  write_delim(benchmark_results, output_file_name)
}