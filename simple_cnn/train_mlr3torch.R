# train the mlr3torch learner

# key difference: torch dataloader contains target varialbe
# but mlr3torch dataset contains only input features, not target

# will likely need to use DataBackendLazy

# task_dataset(train_ds)

databackend_gtcorr = DataBackendLazy$new()

# TODO: get the y values
tsk_gtcorr = TaskRegr$new(id = "guess_the_corr", backend = train_mlr3torch_ds, target = "y"))
