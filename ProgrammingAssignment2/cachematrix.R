## These functions work together to calculate and store the inverse of a given matrix.
## When needed, the inverse of the matrix is either returned from the cache, or if that
## is empty it is calculated (and stored) on the fly.
##
## Usage: 
##   makeCacheMatrix(): this function returns getters and setters for the given matrix
##                      and its inverse. You can either set the matrix by providing it
##                      as an argument, or use NULL as argument and then use the setter.
##   cacheSolve():      Once initialised using makeCacheMatrix(), you can pass your vari-
##                      able to this function. It will use the variable's getters and
##                      setters to determine if the inverse was already calculated and
##                      stored. If so, that inverse matrix is used. If nothing was stored,
##                      the inverse is calculated and returned as well as stored in the
##                      'cache'.
##
## Example:
##   mymatrix <- matrix(c(3,1,2,1), nrow=2, ncol=2)
##   mymatrix.methods <- makeCacheMatrix(NULL)
##   mymatrix.methods$setMatrix(mymatrix)
##   #mymatrix.methods$getMatrix()
##   cacheSolve(mymatrix.methods)
##   cacheSolve(mymatrix.methods)


## Initialise getters and setters 
## Arguments: x, which is a matrix or NULL
## Returns: list of getter and setter methods for the matrix and its inverse
makeCacheMatrix <- function(x = matrix()) {

  # first reset the m variable that will contain the inverse of the matrix
  x.inverse <- NULL

  # define setter function for the matrix x
  # arguments: y, a matrix or NULL
  setMatrix <- function(y) {
    x <<- y
    x.inverse <<- NULL
  }

  # getter for matrix x
  # returns: matrix x
  getMatrix <- function() x

  # setter for inverse of matrix x, inverse is stored in x.inverse
  # NOTE: inverse is not calculated here! Use solve() function and this setter.
  setInverse <- function(solve) x.inverse <<- solve

  # getter for inverse of matrix x
  # returns: inverse of matrix x
  getInverse <- function() x.inverse

  # return the above methods in a list
  list(setMatrix = setMatrix,
       getMatrix = getMatrix,
       setInverse = setInverse,
       getInverse = getInverse)
}



## Write a short comment describing this function
## Call this function to either calculate inverse or get it from cache.
## Arguments: variable initialised using makeCacheMatrix().
## NOTE: make sure makeCacheMatrix().setMatrix has been called on a
## matrix before calling this function!
## Returns: inverse of the matrix
cacheSolve <- function(x, ...) {

  # set timer to proof that caching is faster than calculating
  # thanks to explanation by Randeep Grewal
  #start_time <- Sys.time()

  # get the value that was set by makeCacheMatrix().setInverse
  x.inv <- x$getInverse()

  # return that value only if it is not NULL 
  if(!is.null(x.inv)) {
    message("getting cached data")

    #end_time <- Sys.time()
    #time_duration <- end_time - start_time
    #print(time_duration)

    return(x.inv)
  }

  # else get data, solve and set matrix
  x.matrix <- x$getMatrix()
  x.inv <- solve(x.matrix, ...)
  x$setInverse(x.inv)

  #end_time <- Sys.time()
  #time_duration <- end_time - start_time
  #print(time_duration)

  # and return calculated inverse matrix
  x.inv
}

