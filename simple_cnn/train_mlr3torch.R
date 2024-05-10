# train the mlr3torch learner

# key difference: torch dataloader contains target variable
# but mlr3torch dataset contains only input features, not target

# will likely need to use DataBackendLazy

# task_dataset(train_ds)

# problem: we need y values

# but we need to construct the lazy tensor without y values


ds = dataset("example",
  initialize = function() self$iris = iris[, -5],
  .getitem = function(i) list(x = torch_tensor(as.numeric(self$iris[i, ]))),
  .length = function() nrow(self$iris)
)()

ds$.getitem(1)$unsqueeze(1)

dd_gtcorr = as_data_descriptor(train_mlr3torch_ds, 
    dataset_shapes = list(x = c(NA, 16900L))
)

# TODO: get the y values
tsk_gtcorr = TaskRegr$new(id = "guess_the_corr", backend = train_mlr3torch_ds, target = "y")
