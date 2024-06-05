# TODO: implement

# load validation set
# already done in set_up_data.R

# predict on validation set
# loss = rep(.Machine$double.xmax, times = valid_dl$.length())
# valid_loss = torch_empty()
coro::loop(for (b in valid_dl) {
    output = learner_torch_cnn(b[[1]])

    batch_loss = nnf_mse_loss(output$squeeze(2), b[[2]], reduction = "none")

    # valid_loss = torch_cat(valid_loss, batch_loss)
})

print(torch_mean(batch_loss))

# print loss 