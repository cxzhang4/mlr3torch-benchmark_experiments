time_torch = function(learner, opt, train_dl, n_epochs) {
    system.time(
        train_torch_learner(learner, opt, train_dl, n_epochs)
    )
}

time_mlr3torch = function(learner, task) {
    system.time(
        train_mlr3torch_learner(learner, task)
    )
}

# TODO: decide how much logic we might want to implement here

# source(here("R", "torch", "set_up_data.R"))
# source(here("R", "torch", "create_learner.R"))
# source(here("R", "torch", "train_learner.R"))

# source(here("R", "mlr3torch", "set_up_data.R"))
# source(here("R", "mlr3torch", "create_learner.R"))
# source(here("R", "mlr3torch", "train_learner.R"))
