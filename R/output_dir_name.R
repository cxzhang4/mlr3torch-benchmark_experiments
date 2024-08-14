library(here)

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
