# train the torch learner
device = "cuda"

Sys.setenv(CUDA_VISIBLE_DEVICES="2")

learner_torch_mlp$to(device)



# library(coro)

# opt <- optim_adam(learner_torch_mlp$parameters)

# ### training loop --------------------------------------

# for (t in 1:50) {
#     l <- c()
  
#     coro::loop(for (b in train_dl) {
#         b[[1]]$to(device)
#         b[[2]]$to(device)

#         opt$zero_grad()
#         output <- learner_torch_mlp(b[[1]])
#         loss <- nnf_mse_loss(output$squeeze(2), b[[2]])
#         loss$backward()
#         opt$step()
#         l <- c(l, loss$item())
#     })
# }


