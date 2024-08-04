library(here)
library(torch)
library(bench)
library(readr)

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

# torch_results = time_torch(torch_learner, torch_opt, config$accelerator, train_dl, config$n_epochs)

train_mlr3torch_ds = create_mlr3torch_dataset(data_dir, config$architecture_id, trn_idx)
train_responses = fread(here(data_dir, "guess-the-correlation", "train_responses.csv"))
response_col_name = "corr"
tsk_gtcorr = create_task_from_ds(train_mlr3torch_ds, train_responses, response_col_name, config$architecture_id)

mlr3torch_learner = create_mlr3torch_learner(config$architecture_id, config$batch_size, config$n_epochs, 
                                             config$learning_rate, config$accelerator)
# mlr3torch_results = time_mlr3torch(mlr3torch_learner, tsk_gtcorr)

benchmark_results = mark(
  train_torch_learner(torch_learner, torch_opt, config$accelerator, train_dl, config$n_epochs),
  train_mlr3torch_learner(mlr3torch_learner, tsk_gtcorr),
  min_time = 5,
  iterations = NULL,
  min_iterations = 1,
  max_iterations = 10000,
  check = FALSE,
  memory = capabilities("profmem"),
  filter_gc = TRUE,
  relative = FALSE,
  time_unit = NULL,
  exprs = NULL,
  env = parent.frame()
)

print(benchmark_results)

# config_vec = unlist(config)
# names(torch_results) = paste("torch", names(torch_results), sep = "_")
# names(mlr3torch_results) = paste("mlr3torch", names(mlr3torch_results), sep = "_")
# current_experiment_results = c(config_vec, torch_results, mlr3torch_results) %>%
#   t() %>%
#   data.frame() %>%
#   as.data.table()

# experiment_results = fread("experiment_results.csv")
# fwrite(rbind(experiment_results, current_experiment_results, fill = TRUE), "experiment_results.csv")

# current_experiment_results = benchmark_results

set_lists_to_chars <- function(x) {
    if(class(x) == 'list') {
      y <- paste(unlist(x[1]), sep='', collapse=', ')
    } else {
      y <- x 
    }
    return(y)
}

# current_experiment_results = data.frame(lapply(benchmark_results, set_lists_to_chars), stringsAsFactors = F)

# fwrite(current_experiment_results, "experiment_results_bench.csv")
write_delim(benchmark_results, "experiment_results_bench.csv")