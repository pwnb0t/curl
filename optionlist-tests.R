x = curl_options()
optdf = list_options()

# Should be empty
setdiff(names(x), optdf$name)

# Only aliases
setdiff(optdf$name, names(x))
subset(optdf, alias == TRUE)$name

# Compare values
both = intersect(names(x), optdf$name)
subdf <- optdf[match(both, optdf$name),]
all.equal(unname(x[both]), subdf$value)

# Compare long types
stopifnot(unique(subset(optdf, oldtype == 0)$type) == 0:1)
stopifnot(unique(subset(optdf, type %in% 0:1)$oldtype) == 0)

# Compare off_t types
#subset(optdf, oldtype==2)
stopifnot(all.equal(which(optdf$oldtype == 2), which(optdf$type == 2)))

# Compare string types
cat(subset(optdf, oldtype == 4 & type == 3)$name, sep = '\n')

# Test option_by_name
stopifnot(identical(optdf$name, tolower(sapply(optdf$name, option_by_name, USE.NAMES = F))))

# Test normalized names
optdf$newname <- tolower(sapply(optdf$value, option_by_id, USE.NAMES = F))

stopifnot(all(subset(optdf, name != newname)$alias))
