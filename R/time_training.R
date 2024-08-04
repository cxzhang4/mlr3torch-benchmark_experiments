# time_torch = function(learner, opt, accelerator, train_dl, n_epochs) {
#     system.time(
#         train_torch_learner(learner, opt, accelerator, train_dl, n_epochs)
#     )
# }

# time_mlr3torch = function(learner, task) {
#     system.time(
#         train_mlr3torch_learner(learner, task)
#     )
# }

# mark(
#   train_torch_learner(learner, opt, accelerator, train_dl, n_epochs),
#   train_mlr3torch_learner(learner, task),
#   min_time = 60,
#   iterations = NULL,
#   min_iterations = 1,
#   max_iterations = 10000,
#   check = FALSE,
#   memory = capabilities("profmem"),
#   filter_gc = TRUE,
#   relative = FALSE,
#   time_unit = NULL,
#   exprs = NULL,
#   env = parent.frame()
# )