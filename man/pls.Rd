\name{pls}
\encoding{UTF-8}
\alias{pls}

\title{Partial Least Squares (PLS) Regression}

\description{Function to perform Partial Least Squares (PLS) regression.

}

\usage{
pls(X,
Y,
ncomp = 2,
scale = TRUE,
mode = c("regression", "canonical", "invariant", "classic"),
tol = 1e-06,
max.iter = 100,
near.zero.var = FALSE,
logratio="none",
multilevel=NULL,
all.outputs = TRUE)
}

\arguments{
  \item{X}{numeric matrix of predictors. \code{NA}s are allowed.}
  \item{Y}{numeric vector or matrix of responses (for multi-response models). 
    \code{NA}s are allowed.}
  \item{ncomp}{the number of components to include in the model. Default to 2.}
\item{scale}{boleean. If scale = TRUE, each block is standardized
to zero means and unit variances (default: TRUE)}
 \item{mode}{character string. What type of algorithm to use, (partially) matching
    one of \code{"regression"}, \code{"canonical"}, \code{"invariant"} or \code{"classic"}. 
	See Details.}
\item{tol}{Convergence stopping value.}
\item{max.iter}{integer, the maximum number of iterations.}
\item{near.zero.var}{boolean, see the internal \code{\link{nearZeroVar}} function (should be set to TRUE in particular for data with many zero values). Setting this argument to FALSE (when appropriate) will speed up the computations. Default value is FALSE}
\item{logratio}{one of ('none','CLR'). Default to 'none'}
\item{multilevel}{Design matrix for repeated measurement analysis, where multlevel decomposition is required. For a one factor decomposition, the repeated measures on each individual, i.e. the individuals ID is input as the first column. For a 2 level factor decomposition then 2nd AND 3rd columns indicate those factors. See examples in \code{?spls}).}
\item{all.outputs}{boolean. Computation can be faster when some specific (and non-essential) outputs are not calculated. Default = \code{TRUE}.}
}

\details{
\code{pls} function fit PLS models with \eqn{1, \ldots ,}\code{ncomp} components. 
Multi-response models are fully supported. The \code{X} and \code{Y} datasets
can contain missing values.

The type of algorithm to use is specified with the \code{mode} argument. Four PLS 
algorithms are available: PLS regression \code{("regression")}, PLS canonical analysis 
\code{("canonical")}, redundancy analysis \code{("invariant")} and the classical PLS 
algorithm \code{("classic")} (see References). Different modes relate on how the Y matrix is deflated across the iterations of the algorithms - i.e. the different components.

- Regression mode: the Y matrix is deflated with respect to the information extracted/modelled from the local regression on X. Here the goal is to predict Y from X (Y and X play an asymmetric role). Consequently the latent variables computed to predict Y from X are different from those computed to predict X from Y.

- Canonical mode: the Y matrix is deflated to the information extracted/modelled from the local regression on Y. Here X and Y play a symmetric role and the goal is similar to a Canonical Correlation type of analysis.

- Invariant mode: the Y matrix is not deflated

- Classic mode: is similar to a regression mode. It gives identical results for the variates and loadings associated to the X data set, but differences for the loadings vectors associated to the Y data set (different normalisations are used). Classic mode is the PLS2 model as defined by Tenenhaus (1998), Chap 9.

Note that in all cases the results are the same on the first component as deflation only starts after component 1.

The estimation of the missing values can be performed 
by the reconstitution of the data matrix using the \code{nipals} function. Otherwise, missing 
values are handled by casewise deletion in the \code{pls} function without having to 
delete the rows with missing data.

logratio transform and multilevel analysis are performed sequentially as internal pre-processing step, through \code{\link{logratio.transfo}} and \code{\link{withinVariation}} respectively.

}

\value{
\code{pls} returns an object of class \code{"pls"}, a list 
that contains the following components:

  \item{X}{the centered and standardized original predictor matrix.}
  \item{Y}{the centered and standardized original response vector or matrix.}
  \item{ncomp}{the number of components included in the model.}
  \item{mode}{the algorithm used to fit the model.}
  \item{variates}{list containing the variates.}
  \item{loadings}{list containing the estimated loadings for the \eqn{X} and 
	\eqn{Y} variates.}
  \item{names}{list containing the names to be used for individuals and variables.}
  \item{tol}{the tolerance used in the iterative algorithm, used for subsequent S3 methods}
  \item{iter}{Number of iterations of the algorthm for each component}
  \item{max.iter}{the maximum number of iterations, used for subsequent S3 methods}
  \item{nzv}{list containing the zero- or near-zero predictors information.}
  \item{scale}{whether scaling was applied per predictor.}
  \item{logratio}{whether log ratio transformation for relative proportion data was applied, and if so, which type of transformation.}
  \item{explained_variance}{amount of variance explained per component (note that contrary to PCA, this amount may not decrease as the aim of the method is not to maximise the variance, but the covariance between data sets).}
  \item{input.X}{numeric matrix of predictors in X that was input, before any saling / logratio / multilevel transformation.}
  \item{mat.c}{matrix of coefficients from the regression of X / residual matrices X on the X-variates, to be used internally by \code{predict}.}
  \item{defl.matrix}{residual matrices X for each dimension.}
}

\references{
Tenenhaus, M. (1998). \emph{La regression PLS: theorie et pratique}. Paris: Editions Technic.

Wold H. (1966). Estimation of principal components and related models by iterative least squares. In: Krishnaiah, P. R. (editors), \emph{Multivariate Analysis}. Academic Press, N.Y., 391-420.

Abdi H (2010). Partial least squares regression and projection on latent structure regression (PLS Regression). \emph{Wiley Interdisciplinary Reviews: Computational Statistics}, 2(1), 97-106.
}

\author{Sébastien Déjean and Ignacio González and Kim-Anh Lê Cao.}

\seealso{\code{\link{spls}}, \code{\link{summary}}, 
\code{\link{plotIndiv}}, \code{\link{plotVar}}, \code{\link{predict}}, \code{\link{perf}} and http://www.mixOmics.org for more details.}

\examples{
data(linnerud)
X <- linnerud$exercise
Y <- linnerud$physiological
linn.pls <- pls(X, Y, mode = "classic")

data(liver.toxicity)
X <- liver.toxicity$gene
Y <- liver.toxicity$clinic

toxicity.pls <- pls(X, Y, ncomp = 3)
}

\keyword{regression}
\keyword{multivariate}
