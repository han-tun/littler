#!/usr/bin/r -i
##
##  Call 'rcmdcheck' on a package
##
##  Copyright (C) 2016         Dirk Eddelbuettel
##
##  Released under GPL (>= 2)

suppressMessages(library(docopt))       # we need docopt (>= 0.3) as on CRAN

## configuration for docopt
doc <- "Usage: rcc.r [-h] [-c] [-q] [--args ARGS] [--libpath LIBP] [--repos REPO] [PATH...]

-c --as-cran         should '--as-cran' be added to ARGS [default: FALSE]
-a --args ARGS       additional arguments to be passed to 'R CMD CHECK' [default: ]
-l --libpath LIBP    additional library path to be used by 'R CMD CHECK' [default: ]
-r --repos REPO      additional repositories to be used by 'R CMD CHECK' [default: ]
-q --quiet           should 'rcmdcheck' be called qietly [default: FALSE]
-h --help            show this help text"

opt <- docopt(doc)			# docopt parsing

if (opt$args == "") {                   # special treatment for --args and -c
    if (opt$`as-cran`) {
        opt$args <- "--as-cran"
    } else {
        opt$args <- character()
    }
}

if (length(opt$PATH) == 0) opt$PATH <- "." 		# default argument current directory
if (opt$libpath == "") opt$libpath <- .libPaths()	# default library pathr
if (opt$repos == "") opt$repos <- getOption("repos")	# default repos

if (requireNamespace("rcmdcheck", quietly=TRUE) == FALSE)
    stop("This command requires the 'rcmdcheck' package.", call.=FALSE)

suppressMessages(library(rcmdcheck))

sapply(opt$PATH,                        # iterate over arguments
       rcmdcheck,                       # calling 'rcmdcheck()' with arguments
       opt$quiet,                       # quiet argument, default false
       opt$args,			# args arguments, possibly with --as-cran
       opt$libpath,			# libpath argument
       opt$repos)			# repos argument

