generate_zonation_command <- function(zonation_dir = NULL,
                                      output_dir = NULL,
                                      settings_path = NULL,
                                      zonation_mode = NULL)
{
  cmd_filename <- paste0(zonation_dir, "/run.cmd")
  cmd_file <- file(cmd_filename)
  cmd_string <- "@setlocal\n"
  cmd_string <- paste0(cmd_string, "@PATH=C:\\Program Files (x86)\\Zonation5;%PATH%\n")
  cmd_string <- paste0(cmd_string, "z5_16bit --mode=", zonation_mode, " ")
  cmd_string <- paste0(cmd_string, settings_path, " ")
  cmd_string <- paste0(cmd_string, output_dir, "\n@pause")
  writeLines(cmd_string, cmd_file)
  close(cmd_file)
  
  return(cmd_filename)
}