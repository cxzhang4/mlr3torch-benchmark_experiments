library(here)

source(here("simple_cnn", "download_data.R"))

start_time_torch <- proc.time()
source(here("simple_cnn", "torch", "set_up_data.R"))
source(here("simple_cnn", "torch", "instantiate_learner.R"))
source(here("simple_cnn", "torch", "train_learner.R"))
source(here("simple_cnn", "torch", "evaluate_learner.R"))
elapsed_time_torch <- proc.time() - start_time_torch

print(elapsed_time_torch)

# source(here("simple_cnn", "set_up_data.R"))

# start_time_torch <- proc.time()
# source("learner_torch.R")
# source("train_torch.R")
# # source("predict_torch.R")
# elapsed_time_torch <- proc.time() - start_time_torch

# start_time_mlr3torch <- proc.time()
# source(here("simple_cnn", "learner_mlr3torch.R"))
# source(here("simple_cnn", "train_mlr3torch.R"))
# source("predict_mlr3torch.R")
# elapsed_time_mlr3torch <- proc.time() - start_time_mlr3torch

# print(paste("Torch: ", elapsed_time_torch, sep = ""))
# print(paste("mlr3torch: ", elapsed_time_mlr3torch, sep = ""))

# copy the README code
# i.e. just train on a pre-defined task
# this will help you understand what the data needs to look like
# and will ensure that mlr3torch works at all
# source(here("simple_cnn"), "define_learner.R")

