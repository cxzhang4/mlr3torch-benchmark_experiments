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

cnn_architecture = po("torch_ingress_ltnsr") %>>%
  po("nn_conv2d", out_channels = 32, kernel_size = 3) %>>%
  po("nn_relu") %>>%
  po("nn_avgpool2d") %>>% # TODO: determine whether we need to specify kernel size
  po("nn_conv2d", out_channels = 64, kernel_size = 3) %>>%
  po("nn_relu") %>>%
  po("nn_avgpool2d") %>>%
  po("nn_conv2d", out_channels = 128, kernel_size = 3) %>>%
  po("nn_relu") %>>%
  po("nn_avgpool2d") %>>%
  po("nn_flatten", start_dim = 2) %>>%
  po("nn_linear", out_features = 128) %>>%
  po("nn_head")

graph_cnn = architecture %>>%
    po("torch_loss", loss = t_loss("mse")) %>>%
    po("torch_optimizer", optimizer = t_opt("adam", lr = lr)) %>>%
    po("torch_model_regr", batch_size = batch_size, epochs = n_epochs, device = "cpu")