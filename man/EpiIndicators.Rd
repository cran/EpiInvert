% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/EpiIndicators.R
\name{EpiIndicators}
\alias{EpiIndicators}
\title{\code{EpiIndicators}}
\usage{
EpiIndicators(df, config = EpiIndicators_params())
}
\arguments{
\item{df}{a dataframe with 3 columns: the first column corresponds to the date 
of each indicator value, the second column is the value of the first indicator 
f(t) and the third column is the value of the second indicator g(t). A zero 
value is expected in the case that the real value of an indicator is not 
available. Indicators must be smooth functions. So, for instance, the raw 
registered number of cases or deaths are not adequate to run the function. 
These particular indicators should be smoothed before executing EpiIndicators(), 
for instance you can use the restored indicator values obtained  by EpiInvert()}

\item{config}{a list of the following optional parameters obtained using the 
function EpiIndicators_params(): 
s_min = -10,
\itemize{
 \item{s_min}{: min value allowed for the shift s(t) (default value -10)}
 \item{s_max}{: max value allowed for the shift s(t) (default value 25)}
 \item{wr}{: energy regularization parameter for the ratio  r(t) (default value 1000)}
 \item{ws}{: energy regularization parameter for the shift  s(t) (default value 10)}
 \item{s_init}{: manually fixed initial value (at time t=0) for s(t) (default value -1e6)
 by default s_init is not fixed and it is automatically estimated }
 \item{s_end}{: manually fixed final value (at the last time) for s(t) 
 (default value -1e6) by default s_end is not fixed and it is automatically 
 estimated}
 \item{r_init}{: manually fixed initial value (at time t=0) for r(t) (default value -1e6)
 by default r_init is not fixed and it is automatically estimated }
 \item{r_end}{: manually fixed final value (at the last time) for r(t) 
 (default value -1e6) by default r_end is not fixed and it is automatically 
 estimated}
}}
}
\value{
{
  A dataframe with the following columns :
  \itemize{

  \item{date}{: the date of the indicator values. }

  \item{f}{: the first indicator f(t).}
  
  \item{g}{: the second indicator g(t). }
  
  \item{r}{: the estimated ratio r(t) }
  
  \item{s}{: the estimated shift (delay)  s(t) }
  
  \item{f.r}{: the result of r(t)*f(t) }
  
  \item{g.s}{: the result of g(t+s(t))}

  }
}
}
\description{
EpiIndicators estimates the ratio, r(t), and shift(delay), s(t), between 2 
epidemiological indicators f(t) and g(t) following the relation 
        r(t)*f(t) = g(t+s(t))
}
\details{
EpiIndicators estimates the ratio, r(t), and shift(delay), s(t) between 2 
epidemiological indicators f(t) and g(t) following the relation 
          r(t)*f(t) = g(t+s(t))
a variational method is proposed to add regularity constraints to the 
estimates of r(t) and s(t).
}
\examples{
## load data of epidemiological indicators obtained from the World in data
## organization
data("owid")

## Filter the data to get France epidemiological indicators
library(dplyr)
sel <- filter(owid,iso_code=="FRA")

## Generate a dataframe with the dates and the cases and deaths restored 
## using EpiInvert()
df<-data.frame(sel$date,sel$new_cases_restored_EpiInvert,sel$new_deaths_restored_EpiInvert)

## Run EpiIndicators
res <- EpiIndicators(df)

## Plot the results 
EpiIndicators_plot(res)

}
\author{
Luis Alvarez \email{lalvarez@ulpgc.es}
}
