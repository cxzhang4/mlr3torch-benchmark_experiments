# train the torch learner
opt <- optim_adam(learner_torch_mlp$parameters)

### training loop --------------------------------------

for (t in 1:50) {
  ### -------- Forward pass --------
  y_pred <- learner_torch_mlp(x)
  
  ### -------- Compute loss -------- 
  loss <- nnf_mse_loss(y_pred, y)
#   if (t %% 10 == 0)
#     cat("Epoch: ", t, "   Loss: ", loss$item(), "\n")
  
  ### -------- Backpropagation --------
  opt$zero_grad()
  loss$backward()
  
  ### -------- Update weights -------- 
  opt$step()
}