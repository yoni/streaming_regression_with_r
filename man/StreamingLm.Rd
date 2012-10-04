\name{StreamingLm}
\alias{StreamingLm}
\title{Streaming Regression with R}
\usage{
  StreamingLm(model, file, number_of_rows_per_update,
    column_classes, column_names)
}
\arguments{
  \item{model}{the linear model}

  \item{file}{the file connection. For example, a standard
  input connection or a file connection}

  \item{number_of_rows_per_update}{the number or rows to
  read before running an update to the solution}

  \item{column_classes}{the class types for each column of
  the comma-separated-value rows read from the connection}

  \item{column_names}{the names of the columns to read. For
  example, one or more of the variables in the model.}
}
\description{
  Reads rows of CSV-valued data from a file connection
  (e.g. standard in) and runs repeated updates to the
  solution of a linear model.
}
\details{
  Intended to be used for very large scale data analysis
  using standard-in streaming.

  Utilizes biglm's update function to update a solution
  based on chunked rows of CSV input data.
}
\examples{
# Run streaming regression on two rows of data. Result should be y = 0 + 0.5 * x1
con <- pipe(description="echo '1,2\\n2,4'")
open(con)
solution <- StreamingLm(model=y~x1, file=con, number_of_rows_per_update=2, column_classes=rep('integer',2),column_names=c('y','x1'))
coef(solution) # y = 0 + 0.5 * x1
# Run streaming regression on the standard lm example

## Annette Dobson (1990) "An Introduction to Generalized Linear Models".
## Page 9: Plant Weight Data.
csv_data <- '4.17,1\\n5.58,1\\n5.18,1\\n6.11,1\\n4.5,1\\n4.61,1\\n5.17,1\\n4.53,1\\n5.33,1\\n5.14,1\\n4.81,2\\n4.17,2\\n4.41,2\\n3.59,2\\n5.87,2\\n3.83,2\\n6.03,2\\n4.89,2\\n4.32,2\\n4.69,2'
con = pipe(description=sprintf('echo \%s', csv_data))
open(con)
solution <- StreamingLm(model=weight~group, file=con, number_of_rows_per_update=2, column_classes=rep('numeric',2),column_names=c('weight','group'))

# Trees example used in the biglm examples
data(trees)
trees_csv <- capture.output(write.csv(trees, row.names=FALSE))[-1]
command <- sprintf('echo "\%s"', paste(trees_csv, collapse='\\n'))
con = pipe(description=command)
model <- log(Volume) ~ log(Girth) + log(Height)

open(con)
solution <- StreamingLm(model=model, file=con, number_of_rows_per_update=5, column_classes=rep('numeric',3),column_names=c('Girth','Height','Volume'))
summary(solution)
}

