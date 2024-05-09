# train the mlr3torch learner

# key difference: torch dataloader contains target varialbe
# but mlr3torch dataset contains only input features, not target

# task_dataset(train_ds)
# library(mlr3)

names(train_mlr3torch_ds)

# TODO: get the y values
tsk_gtcorr = as_task_regr(train_mlr3torch_ds, target = "y")
