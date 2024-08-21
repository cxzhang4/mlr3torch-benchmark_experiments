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

source(here("R", "read_bench_results.R"))
source(here("R", "output_dir_name.R"))

config = config::get()

data_dir = here("data", "correlation")
should_download = length(list.files(data_dir)) == 0
get_data(data_dir, should_download)

trn_idx = 1:(config$train_size)
train_torch_ds = create_torch_ds(data_dir, trn_idx, config$architecture_id)
input_dim = prod(dim(train_torch_ds[1]$x))
output_dim = 1
train_dl = dataloader(train_torch_ds, batch_size = config$batch_size, shuffle = TRUE)

torch_learner = create_torch_learner(config$architecture_id)
torch_opt = create_opt(torch_learner, config$learning_rate)

print("torch learner:")
print(torch_learner)
print(paste("torch batch size:", train_dl$batch_size), sep = " ")

train_mlr3torch_ds = create_mlr3torch_dataset(data_dir, config$architecture_id, trn_idx)
train_responses = fread(here(data_dir, "guess-the-correlation", "train_responses.csv"))
response_col_name = "corr"
tsk_gtcorr = create_task_from_ds(train_mlr3torch_ds, train_responses, response_col_name, config$architecture_id)

mlr3torch_learner = create_mlr3torch_learner(tsk_gtcorr, torch_learner,
                                             config$architecture_id, config$batch_size, config$n_epochs,
                                             config$learning_rate, config$accelerator)

benchmark_results = mark(
  train_torch_learner(torch_learner, torch_opt, config$accelerator, train_dl, config$n_epochs),
  train_mlr3torch_learner(mlr3torch_learner, tsk_gtcorr),
  min_time = 1,
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

print("mlr3torch learner:")
if ("GraphLearner" %in% class(mlr3torch_learner)) {
  print(mlr3torch_learner$base_learner()$model$network)
  print(paste("mlr3torch number of epochs:", mlr3torch_learner$base_learner()$param_set$get_values()$epochs))
  print(paste("mlr3torch batch size:", mlr3torch_learner$base_learner()$param_set$get_values()$batch_size, sep = " "))
} else {
  print(mlr3torch_learner$model$network)
  print(paste("mlr3torch number of epochs:", mlr3torch_learner$param_set$get_values()$epochs))
  print(paste("mlr3torch batch size:", mlr3torch_learner$param_set$get_values()$batch_size, sep = " "))
}

print(benchmark_results)

config_tbl = unclass(config) %>%
  as_tibble()

library_tbl = list(library = c("torch", "mlr3torch")) %>%
  as_tibble()

benchmark_results_output = tibble(library = c("torch", "mlr3torch")) %>%
  bind_cols(benchmark_results) %>%
  select(total_time) %>%
  bind_cols(library_tbl, ., config_tbl)

output_dir_name = output_dir_name()
dir.create(output_dir_name)
output_file_name = here(output_dir_name, "benchmark_results.csv")
write_csv(benchmark_results_output, output_file_name)

output_dir_name_file = "output_dir_name.txt"
invisible(file.create(output_dir_name_file))
writeLines(output_dir_name, output_dir_name_file)

invisible(file.copy(from = "config.yml", to = output_dir_name))