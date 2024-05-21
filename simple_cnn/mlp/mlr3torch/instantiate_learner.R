library(mlr3)
library(mlr3torch)

n_epochs = 2

learner_mlr3torch_mlp = lrn("regr.mlp",
  # defining network parameters
  activation     = nn_relu,
  neurons        = c(20, 20),
  # training parameters
  batch_size     = 16,
  epochs         = n_epochs,
  device         = "cpu",
  # Defining the optimizer, loss, and callbacks
  optimizer      = t_opt("adam", lr = 0.1),
  loss           = t_loss("mse"),
  callbacks      = t_clbk("history"), # this saves the history in the learner
  # Measures to track
  measures_valid = msrs(c("regr.mse")),
  measures_train = msrs(c("regr.mse")),
  # predict type (required by logloss)
  predict_type = "response"
)
