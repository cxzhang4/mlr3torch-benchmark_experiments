library(mlr3)
library(mlr3torch)

# TODO: implement
learner_mlr3torch_cnn = lrn("regr.cnn",
    # defining network parameters
    activation     = nn_relu,
    neurons        = c(20, 20),
    # training parameters
    batch_size     = batch_size,
    epochs         = n_epochs,
    device         = "cpu",
    # Defining the optimizer, loss, and callbacks
    optimizer      = t_opt("adam", lr = lr),
    loss           = t_loss("mse"),
    # predict type (required by logloss)
    predict_type = "response"
)