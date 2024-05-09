source("set_up_data.R")

# start_time_torch <- proc.time()
# source("learner_torch.R")
# source("train_torch.R")
# # source("predict_torch.R")
# elapsed_time_torch <- proc.time() - start_time_torch

start_time_mlr3torch <- proc.time()
source("learner_mlr3torch.R")
source("train_mlr3torch.R")
# source("predict_mlr3torch.R")
elapsed_time_mlr3torch <- proc.time() - start_time_mlr3torch

print(paste("Torch: ", elapsed_time_torch, sep = ""))
print(paste("mlr3torch: ", elapsed_time_mlr3torch, sep = ""))