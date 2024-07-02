# TODO: implement
# create data descriptor
valid_dd_gtcorr = as_data_descriptor(valid_mlr3torch_ds, list(x = c(NA, 1, 130, 130)))
# create lazy tensor
valid_lt = lazy_tensor(valid_dd_gtcorr)

# construct the data.table for training
valid_dt_train = data.table(corr = train_responses[["corr"]][val_idx], x = valid_lt)

# construct the task
tsk_gtcorr_valid = as_task_regr(valid_dt_train, target = "corr", id = "guess_the_correlation")

valid_preds = learner_mlr3torch_cnn$predict(tsk_gtcorr_valid)
print(valid_preds$score(msr("regr.mse")))