#' A dataset containing daily incidence of COVID-19 for France, 
#' Germany, UK and the USA
#'
#'
#' @format A data frame with 5 variables:
#' \describe{
#'   \item{date}{date of the incidence.}
#'   \item{FRA}{incidence of France.}
#'   \item{DEU}{incidence of Germany.}
#'   \item{UK}{incidence of UK.}
#'   \item{USA}{incidence of USA.}
#' }
#' 
#' An updated version of this dataset can be found at 
#' https://www.ctim.es/covid19/incidence.csv
#' 
#' @source \url{https://github.com/owid/covid-19-data/tree/master/public/data}
#' @source \url{https://www.santepubliquefrance.fr/dossiers/coronavirus-covid-19/coronavirus-chiffres-cles-et-evolution-de-la-covid-19-en-france-et-dans-le-monde}
#' @source \url{https://experience.arcgis.com/experience/478220a4c454480e823b17327b2bf1d4/page/page_1/}
"incidence"

#' A dataset containing festive days in  France, 
#' Germany, UK and the USA
#'
#'
#' @format A list with 4 variables:
#' \describe{
#'   \item{FRA}{festive day of France}
#'   \item{DEU}{festive day  of Germany}
#'   \item{UK}{festive day  of UK}
#'   \item{USA}{festive day  of USA}
#'  
#' }
"festives"

#' A dataset containing the values of a serial interval
#'
#' @format A numeric vector with 1 variable representing 
#' the serial interval 
#' 
"si_distr_data"