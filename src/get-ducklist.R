get_ducklist <- function(path = NULL)
{
  if (is.null(path))
  {
    stop("Path to get_ducklist() is NULL.")
  }
  
  return(list.files(path, full.names = T))
}