library(mlr3torch)

learner_mlp = lrn("classif.mlp",
                  activation = nn_relu,
                  neurons = c(20, 20),
                  batch_size = 16,
                  epochs = 50,
                  device = "cpu",
                  optimizer = t_opt("adam", lr = 0.1),
                  loss = t_loss("cross_entropy"),
                  callbacks = t_clbk("history"),
                  measures_valid = msrs(c("classif.logloss", "classif.ce")),
                  measures_train = msrs(c("classif.acc")),
                  predict_type = "prob"
)

rr = resample(
  task = tsk("iris"),
  learner = learner_mlp,
  resampling = rsmp("holdout")
)

rr$score()

architecture = po("torch_ingress_num") %>>%
  po("nn_linear", out_features = 20) %>>%
  po("nn_relu") %>>%
  po("nn_head")

graph_mlp = architecture %>>%
  po("torch_loss", loss = t_loss("cross_entropy")) %>>%
  po("torch_optimizer", optimizer = t_opt("adam", lr = 0.1)) %>>% 
  po("torch_callbacks", callbacks = t_clbk("history")) %>>%
  po("torch_model_classif", batch_size = 16, epochs = 50, device = "cpu")

graph_lrn = as_learner(graph_mlp)
graph_lrn$id = "graph_mlp"

rr_iris = resample(
  task = tsk("iris"),
  learner = graph_lrn,
  resampling = rsmp("holdout")
)

rr_iris$score()

tsk_mnist = tsk("mnist")
tsk_mnist
