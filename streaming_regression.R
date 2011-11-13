#!/usr/bin/env Rscript
require(biglm)

# We will be reading lines from the stdin input stream
standard_in_connection <- file("stdin", open = "r")

chunkSize <- 2
colClasses <- c(rep('integer',2)) # The data are numbers (for now)
col.names <- c('y','x1')

model <- y~x1

solution <- NULL

while (TRUE) {

  chunk <- read.csv(standard_in_connection, nrows=chunkSize, head=FALSE, colClasses=colClasses, col.names=col.names)

  if(nrow(chunk) == 0) break
  print(chunk)

  if(is.null(solution)) # First loop only
    solution <- biglm(formula=model, data=chunk)
  else # Subsqeuent loops
    solution <- update(object=solution, moredata=chunk)

}

print(summary(solution))

close(standard_in_connection)
