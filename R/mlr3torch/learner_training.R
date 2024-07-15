# TODO: determine whether we want to keep this function
# pro: maintain the same interface, potentially better for timing consistency
# con: doesn't really do anything
train_mlr3torch_learner = function(learner, task) {
    learner$train(task)
}
