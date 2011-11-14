require(biglm)

#' Streaming Regression with R
#' 
#' Reads rows od CSV-valued data from standard in and runs
#' repeated updates to the solution of a linear model.
#'
#' Intended to be used for very large scale data analysis using standard-in streaming.
#' 
#' Utilizes biglm's update function to update a solution based on chunked rows of CSV input data. 
#' 
#' Running the Example:
#'   ./example.sh
#'
#' @param model the linear model
#' @param file the file connection. For example, a standard input connection or a file connection
#' @param number_of_rows_per_update the number or rows to read before running an update to the solution
#' @param column_classes the class types for each column of the comma-separated-value rows read from the connection
#' @param column_names the names of the columns to read. For example, one or more of the variables in the model.
#' @examples
#' require(StreamingLm)
#' con <- pipe(description="echo '1,2\n2,4'") # y = 0 + 0.5 * x1
#' open(con)
#' solution <- StreamingLm(model=y~x1, file=con, number_of_rows_per_update=2, column_classes=rep('integer',2),column_names=c('y','x1'))
#' coef(solution) # y = 0 + 0.5 * x1
#' @export
StreamingLm <- function (
    model,
    file,
    number_of_rows_per_update,
    column_classes,
    column_names
  ) {

  solution <- NULL

  while (TRUE) {

    # Get the next rows of data
    chunk <- read.csv(file=file, nrows=number_of_rows_per_update, head=FALSE, colClasses=column_classes, col.names=column_names)

    # We're done when there are no more rows
    if(nrow(chunk) == 0) break

    if(is.null(solution)) # First loop only
      solution <- biglm(formula=model, data=chunk)
    else # Subsqeuent loops
      solution <- update(object=solution, moredata=chunk)

  }

  solution  

}

