library(bench)
library(dplyr)
library(readr)

bench_result_names = c("expression", "min", "median", "itr/sec", "mem_alloc", 
                       "gc/sec", "n_itr", "n_gc", "total_time", "result", "memory", "time", "gc")

bench_time_columns = c("min", "median", "total_time")

read_bench_results = function(file_name, col_types) {
  # read_csv(file_name) %>%
  #   mutate( across( everything(), ~ ifelse(cur_column() %in% bench_time_columns, as_bench_time(.), .) ) )
  read_csv(file_name) %>%
    mutate(min = as_bench_time(min),
           median = as_bench_time(median),
           total_time = as_bench_time(total_time))
}
