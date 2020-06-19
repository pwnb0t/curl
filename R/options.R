#' List curl version and options.
#'
#' \code{curl_version()} shows the versions of libcurl, libssl and zlib and
#' supported protocols. \code{curl_options()} lists all options available in
#' the current version of libcurl.  The dataset \code{curl_symbols} lists all
#' symbols (including options) provides more information about the symbols,
#' including when support was added/removed from libcurl.
#'
#' @export
#' @param filter string: only return options with string in name
#' @examples # Available options
#' curl_options()
#'
#' # List proxy options
#' curl_options("proxy")
#'
#' # Symbol table
#' curl_symbols("proxy")
curl_options <- function(filter = ""){
  m <- grep(filter, names(option_table), ignore.case = TRUE)
  option_table[m]
}

option_table <- (function(){
  env <- new.env()
  if(file.exists("tools/option_table.txt")){
    source("tools/option_table.txt", env)
  } else if(file.exists("../tools/option_table.txt")){
    source("../tools/option_table.txt", env)
  } else {
    stop("Failed to find 'tools/option_table.txt' from:", getwd())
  }
  option_table <- unlist(as.list(env))
  names(option_table) <- sub("^curlopt_", "", tolower(names(option_table)))
  option_table <- option_table[!grepl('^obsolete', names(option_table))]
  option_table[order(names(option_table))]
})()

#' @export
#' @useDynLib curl R_list_options
list_options <- function(){
  out <- .Call(R_list_options)
  out[[1]] <- tolower(out[[1]])
  as.data.frame(as.list(out), col.names = c("name", "value", "type", "oldtype", "alias"))
}

#' @export
#' @useDynLib curl R_get_opt_by_name
option_by_name <- function(name){
  name <- as.character(name)
  .Call(R_get_opt_by_name, name)
}

#' @export
#' @useDynLib curl R_get_opt_by_id
option_by_id <- function(id){
  id <- as.integer(id)
  .Call(R_get_opt_by_id, id)
}
