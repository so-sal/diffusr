# diffusr: network diffusion algorithms in R
#
# Copyright (C) 2016 Simon Dirmeier
#
# This file is part of diffusr.
#
# diffusr is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# diffusr is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with diffusr. If not, see <http://www.gnu.org/licenses/>.


#' Graph diffusion using a heat diffusion process on a Laplacian matrix.
#'
#' @description An amount of starting heat gets distribution using the
#' Laplacian matrix of a graph. Every iteration (or time interval) \code{t}
#'heat streams from the starting nodes into surrounding nodes.
#'
#' @export
#' @docType methods
#' @rdname heat-diffusion-methods
#'
#' @param h0   an \code{n x p}-dimensional numeric non-negative vector/matrix
#'  of starting temperatures
#' @param graph  an (\code{n x n})-dimensional numeric non-negative adjacence
#'  matrix representing the graph
#' @param t  time point when heat is measured
#' @param ...  additional parameters
#' @return  returns the heat on every node as numeric vector
#'
#' @references
#' \url{https://en.wikipedia.org/wiki/Laplacian_matrix} \cr
#' \url{https://en.wikipedia.org/wiki/Heat_equation}
#'
#' @examples
#' # count of nodes
#' n <- 5
#' # starting distribution (has to sum to one)
#' h0 <- as.vector(rmultinom(1, 1, prob=rep(.2, n)))
#' # adjacency matrix (either normalized or not)
#' graph <- matrix(abs(rnorm(n*n)), n, n)
#' # computation of stationary distribution
#' ht <- heat.diffusion(h0, graph)
setGeneric(
  "heat.diffusion",
  function(h0, graph, t=.5, ...)
  {
    standardGeneric("heat.diffusion")
  },
  package="diffusr"
)

#' @rdname heat-diffusion-methods
#' @aliases heat.diffusion,numeric,matrix-method
setMethod(
  "heat.diffusion",
  signature = signature(h0="numeric", graph="matrix"),
  function(h0, graph, t=.5, ...)
  {
    h0 <- as.matrix(h0, ncol=1)
    heat.diffusion(h0, graph, t, ...)
  }
)

#' @rdname heat-diffusion-methods
#' @aliases heat.diffusion,matrix,matrix-method
setMethod(
  "heat.diffusion",
  signature = signature(h0="matrix", graph="matrix"),
  function(h0, graph, t=.5, ...)
  {
    stopifnot(length(t) == 1)
    if (t < 0) stop("pls provide positive t")
    .check.starting.matrix(h0)
    .check.graph(graph, h0)
    if (any(diag(graph) != 0))
    {
      message("setting diag of graph to zero")
      diag(graph) <- 0
    }

    invisible(
      heat_diffusion_(h0, normalize.laplacian(graph), t))
  }
)
