library(here)
library(stringr)

output_dir_name = function() {
  date_str = format(Sys.Date(), "%d_%m_%Y")
  run_num = 1
  dir_path = here("results", paste0(date_str, "-", run_num))

  while (dir.exists(dir_path)) {
    run_num = run_num + 1
    dir_path = here("results", paste0(date_str, "-", run_num))
  }

  dir_path
}

result_dir_name = function() {
  date_str = format(Sys.Date(), "%d_%m_%Y")
  run_num = 1
  dir_path = here("results", paste0(date_str, "-", run_num))
  
  while (dir.exists(dir_path)) {
    run_num = run_num + 1
    dir_path = here("results", paste0(date_str, "-", run_num))
  }
  
  run_num = run_num - 1
  dir_path = here("results", paste0(date_str, "-", run_num))
  
  dir_path
}

most_recent_result_name = function() {
  dirs = list.dirs(path = here("results"), full.names = TRUE)
  sorted_dirs = str_sort(dirs)
  sorted_dirs[length(sorted_dirs)]
}
