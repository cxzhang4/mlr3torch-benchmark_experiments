train_torch_learner = function(learner, opt, accelerator, train_dl, n_epochs) {
    # device = torch_device(accelerator)
    # print(device)
    learner = learner$to(device = accelerator)
    for (t in seq_len(n_epochs)) {
        coro::loop(for (b in train_dl) {
            opt$zero_grad()

            output = learner(b[[1]]$to(device = accelerator))
            target = b[[2]]$to(device = accelerator)
            loss = nnf_mse_loss(output$squeeze(2), target)

            loss$backward()
            opt$step()
        })
    }
}
