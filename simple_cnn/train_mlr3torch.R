# train the mlr3torch learner

# will likely need to use DataBackendLazy

dd_gtcorr = as_data_descriptor(train_mlr3torch_ds, 
    dataset_shapes = list(x = c(NA, 130, 130))
)

lt = lazy_tensor(dd_gtcorr)

# TODO: determine whether assuming the ordering is preserved is a good assumption
# if not, figure out how to get x IDs and join them with the ys

library(data.table)
train_responses = fread(here("simple_cnn", "data/correlation/guess-the-correlation/train_responses.csv"))

# here, x is a list column
dt_train = cbind(train_responses, x = lt)
# print(head(dt_train))
backend = DataBackendDataTable$new(data = dt_train, primary_key = "id")

# for this particular data: responses are stored in a csv that has ids
# problem: we did not store the ids or the response values in the dataset

tsk_gtcorr = TaskRegr$new(id = "guess_the_corr", backend = backend, target = "corr")

## if we really want to pivot to e.g. iris

# ds = dataset("example",
#   initialize = function() self$iris = iris[, -5],
#   .getitem = function(i) list(x = torch_tensor(as.numeric(self$iris[i, ]))),
#   .length = function() nrow(self$iris)
# )()
# 
# ds$.getitem(1)$unsqueeze(1)

