#!/usr/bin/env Rscript
source('StreamingLm.R')

# The linear model to find
model <- y~x1

# We will be reading lines from the stdin input stream
standard_in_connection <- file("stdin", open = "r")
number_of_rows_per_update <- 2 

# The data are comma-separated values with these columns:
column_classes <- c(rep('integer',2))
column_names <- c('y','x1')

# Run the streaming linear regression
solution <- StreamingLm(
    model = model,
    file = standard_in_connection,
    number_of_rows_per_update = number_of_rows_per_update,
    column_classes = column_classes,
    column_names = column_names
  )

# Output solution to standard out
print(summary(solution))

close(standard_in_connection)
