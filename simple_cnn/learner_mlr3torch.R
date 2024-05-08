# Define the network architecture for both the torch and mlr3torch learner

library(mlr3torch)

learner_mlr3torch_mlp = lrn("regr.mlp",
  # defining network parameters
  activation     = nn_relu,
  neurons        = c(20, 20),
  # training parameters
  batch_size     = 16,
  epochs         = 50,
  device         = "cpu",
  # Defining the optimizer, loss, and callbacks
  optimizer      = t_opt("adam", lr = 0.1),
  loss           = t_loss("mse"),
  callbacks      = t_clbk("history"), # this saves the history in the learner
  # Measures to track
  measures_valid = msrs(c("regr.mse")),
  measures_train = msrs(c("regr.mse")),
  # predict type (required by logloss)
  predict_type = "prob"
)