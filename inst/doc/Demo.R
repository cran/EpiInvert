## ----setup, echo = FALSE------------------------------------------------------

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>", 
  fig.width = 8, 
  fig.height = 8, 
  fig.path = "../inst/doc/figs-demo/"
)


## ---- eval=FALSE--------------------------------------------------------------
#   install.packages("devtools")
#   devtools::install_github("lalvarezmat/EpiInvert")

## ---- echo = TRUE,message = FALSE---------------------------------------------
library(EpiInvert)
library(ggplot2)
library(dplyr)
library(grid)

## -----------------------------------------------------------------------------
data(incidence)
tail(incidence)

## -----------------------------------------------------------------------------
data(festives)
head(festives)

## ----echo = TRUE, message = FALSE,results = FALSE-----------------------------
res <- EpiInvert(incidence$DEU,"2022-05-05",festives$DEU)

## ----fig1, fig.width = 6, fig.height = 10, fig.align = "center"---------------
EpiInvert_plot(res)


## ----echo = TRUE, message = FALSE,results = FALSE-----------------------------
res <- EpiInvert(incidence$FRA,"2022-05-05",festives$FRA,
                 select_params(list(max_time_interval = 365)))

## ----fig2, fig.width = 7, fig.height = 4, fig.align = "center"----------------
 EpiInvert_plot(res,"incid","2021-12-15","2022-01-15")


## ----echo = TRUE, message = FALSE,results =TRUE-------------------------------
data(si_distr_data)
head(si_distr_data)

## ----echo = TRUE, message = FALSE,results = FALSE-----------------------------
res <- EpiInvert(incidence$UK,"2022-05-05",festives$UK,
       select_params(list(si_distr = si_distr_data,
       shift_si_distr=-2)))

## ----fig3, fig.width = 4, fig.height = 4, fig.align = "center"----------------
 EpiInvert_plot(res,"SI")


## ----echo = TRUE, message = FALSE,results = FALSE-----------------------------
res <- EpiInvert(incidence$USA,"2022-05-05",festives$USA,
       select_params(list(mean_si = 11,sd_si=6,shift_si=-1)))

## ----fig4, fig.width = 7, fig.height = 4, fig.align = "center"----------------
 EpiInvert_plot(res,"R")


## -----------------------------------------------------------------------------
incidence <- read.csv(url("https://www.ctim.es/covid19/incidence.csv"))
tail(incidence)

## ----echo = TRUE, message = FALSE,results = FALSE-----------------------------
res <- EpiInvert(incidence$USA,incidence$date[length(incidence$date)],festives$USA)

## ----fig5, fig.width = 6, fig.height = 10, fig.align = "center"---------------
 EpiInvert_plot(res)


