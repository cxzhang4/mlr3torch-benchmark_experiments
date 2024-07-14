library(here)
library(torch)

source(here("R", "get_data.R"))

source(here("R", "torch", "set_up_data.R"))
source(here("R", "torch", "create_learner.R"))
source(here("R", "torch", "train_learner.R"))

source(here("R", "mlr3torch", "set_up_data.R"))
source(here("R", "mlr3torch", "create_learner.R"))
source(here("R", "mlr3torch", "train_learner.R"))

source(here("R", "time_training.R"))

config = config::get()

data_dir = here("data", "correlation")

# arbitrarily define indices
trn_idx = 1:(config$train_size)

# get data (if necessary)

# torch

# set up dataset and dataloader

# define learner

# begin time

    # train learner

# end time


# mlr3torch

# set up dataset and dataloader

# define learner

# begin time

    # train learner

# end time
