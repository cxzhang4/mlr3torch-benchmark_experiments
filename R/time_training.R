time_torch = function(learner, opt, train_dl, n_epochs) {
    system.time(
        train_learner(learner, opt, train_dl, n_epochs)
    )
}

# time_mlr3torch = function(learner, tsk, n_epochs, batch_size, lr) {
#     system.time(
#         learner$train(tsk)
#     )
# }

source(here("R", "torch", "set_up_data.R"))
source(here("R", "torch", "create_learner.R"))
source(here("R", "torch", "train_learner.R"))

# source(here("R", "mlr3torch", "set_up_data.R"))
# source(here("R", "mlr3torch", "create_learner.R"))
# source(here("R", "mlr3torch", "train_learner.R"))
