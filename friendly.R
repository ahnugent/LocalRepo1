friendly.name <- function(var.name, prefix = "") {
    
    # July 2015
    # Breaks the input string up into parts and reassembles in a more user-friendly manner.
    # prefix is only applied if the 1st pattern search succeeds; otherwise, the input string is returned.
    #   (This leaves categorical column names unchanged.)
    
    l <- nchar(var.name)
    signal.origin <- ""
    signal.metric <- ""
    signal.axis <- ""
    p1 <- str_locate(var.name, "-")[1]
    if (!is.na(p1)) {
        signal.origin <- substr(var.name, 1, p1 - 1)           # grab the signal name
        p2 <- str_locate(substr(var.name, p1 + 1, l), "-")[1] + p1
        if (!is.na(p2)) {
            signal.metric <- substr(var.name, p1 + 1, p2 - 3)  #: grab the metric name, but pizz off the "()"
            signal.axis <- substr(var.name, p2 + 1, l)         #: 'X', 'Y', 'Z'
        } else {
            signal.metric <- substr(var.name, p1 + 1, l - 2)   #: grab the metric name, but pizz off the "()"
        }
        if (signal.metric == "std") { signal.metric <- "sdev" }
        result <- paste(prefix, signal.metric, signal.axis, signal.origin) 
    } else {
        result <- var.name
    }
    result <- str_trim(gsub("\\s+"," ", result))  #: collapse white space to single space; trim
    result <- gsub(" ", ".", result)              #: replace space chars with "." for R naming compatibility
    return(result)
}
