library(here)
library(torch)

source(here("R", "download_data.R"))
source(here("R", "time_training.R"))

config = config::get()

print("torch:")
source(here("R", "torch", "set_up_data.R"))
train_dl = dataloader(train_torch_ds, batch_size = config$batch_size, shuffle = TRUE)
learner_torch = create_learner(config$architecture_id)
opt = create_opt(learner_torch, config$learning_rate)
time_torch(learner_torch, opt, train_dl, config$n_epochs)

# print("mlr3torch:")
# source(here("R", "mlr3torch", "set_up_data.R"))
# fread(here("data", "correlation/guess-the-correlation/train_responses.csv""))

# write config and time to csv

# print("mlr3torch:")
# print(time_mlr3torch(n_epochs, batch_size, lr))
