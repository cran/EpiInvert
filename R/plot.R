#' @title 
#' \code{EpiInvert_plot} 
#' 
#' @description EpiInvert_plot() plots the results obtained by EpiInvert
#'
#' @param x an object of class \code{estimate_EpiInvert}.
#'
#' @param what one of the following drawing options: 
#' 
#'  \itemize{
#'  \item{all}{: a plot combining the main EpiInvert results.}
#'  \item{R}{: a plot of the reproduction number Rt estimation. }
#'  \item{incid}{: a plot combining the obtained incidence curves. }
#'  \item{SI}{: the serial interval used in the EpiInvert estimation. }
#'  
#' }
#' 
#' @param date_start the start date to plot 
#' 
#' @param date_end the final date to plot 
#' 
#' @return a plot.
#' 
#' @seealso \code{\link{EpiInvert}} 


#' @export
EpiInvert_plot <- function(x, what = "all",date_start="1000-01-01",date_end="3000-01-01"){
  
  ################################## Graphical Theme #####################################
  
  theme_graphs <-ggplot2::theme_bw()+
    ggplot2::theme(
    plot.margin = ggplot2::unit(c(0.1,0.1,0.1,0.1), "cm"),
    panel.spacing = ggplot2::unit(0, "lines"),
    axis.title = ggplot2::element_blank()
  )
  theme_graphs_no_xlab<-theme_graphs+ggplot2::theme(axis.text.x = ggplot2::element_blank(),axis.ticks.x = ggplot2::element_blank() )
  
  
  if (what == "R") {
    d2 <- data.frame(date = as.Date(x$dates), Rt = x$Rt, 
                     Rt_CI95 = x$Rt_CI95)
    d <- dplyr::filter(d2, date >= as.Date(date_start, format = "%Y-%m-%d") & 
                         date <= as.Date(date_end, format = "%Y-%m-%d"))
    g <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = Rt)) + 
      ggplot2::geom_line() + ggplot2::ylim(0, 1.02 * max(d$Rt)) + 
      ggplot2::scale_x_date(date_labels = "%Y-%m-%d") + 
      theme_graphs +
      ggplot2::geom_ribbon(ggplot2::aes(ymin = Rt -  Rt_CI95, ymax = Rt + Rt_CI95), fill = I(rgb(0.7,  0.7, 0.7)),colour = NA) + 
      ggplot2::geom_line(ggplot2::aes(y = Rt)) + 
      ggplot2::geom_hline(yintercept = 1) + ggplot2::geom_text(data=data.frame(1,1),x = -Inf, 
                                                               y = Inf, label = "Rt", hjust = -0.5, vjust = 1.5,inherit.aes = F)
    p <- ggplot2::ggplotGrob(g)
    grid::grid.draw(rbind(p))
  }
  else if (what == "incid") {
    d2 <- data.frame(date = as.Date(x$dates), i_original = x$i_original, 
                     i_festive = x$i_festive, i_bias_free = x$i_bias_free, 
                     i_restored = x$i_restored, Rt = x$Rt, seasonality = x$seasonality, 
                     epsilon = x$epsilon, Rt_CI95 = x$Rt_CI95)
    d <- dplyr::filter(d2, date >= as.Date(date_start) & 
                         date <= as.Date(date_end))
    N <- length(d$date)
    m = data.frame(date = as.Date(d$date), values = c(d$i_festive, d$i_original, d$i_bias_free, d$i_restored), 
                   incidence = c(rep("2. festive bias free", N), rep("1. original", N), rep("3. weekly + festive biases free",  N), rep("4. restored", N)))
    g <- ggplot2::ggplot(m, ggplot2::aes(date, values, col = incidence)) + 
      ggplot2::geom_line() + ggplot2::scale_color_manual(values = c("black",  "green", "blue", "red")) + 
      ggplot2::scale_x_date(date_labels = "%Y-%m-%d") + 
      theme_graphs + 
      ggplot2::geom_line(size = 0.7)
    p <- ggplot2::ggplotGrob(g)
    grid::grid.draw(rbind(p))
  }
  else if (what == "SI") {
    days <- c(x$shift_si_distr)
    for (i in 2:length(x$si_distr)) {
      days <- append(days, i + x$shift_si_distr - 1)
    }
    dsi <- data.frame(days = days, si_distr = x$si_distr)
    g <- ggplot2::ggplot(dsi, ggplot2::aes(x = days, y = si_distr)) + 
      ggplot2::geom_line() + ggplot2::ylim(0, 1.02 * max(x$si_distr)) + 
      theme_graphs +
      ggplot2::labs(x = "days", y = "") + ggplot2::geom_text(data=data.frame(1,1),x = -Inf, 
                                                             y = Inf, label = "serial interval distribution", 
                                                             hjust = -0.1, vjust = 1.5,inherit.aes = F)
    p <- ggplot2::ggplotGrob(g)
    grid::grid.draw(rbind(p))
  }
  else if (what == "all") {
    d2 <- data.frame(date = as.Date(x$dates), i_original = x$i_original, 
                     i_festive = x$i_festive, i_bias_free = x$i_bias_free, 
                     i_restored = x$i_restored, Rt = x$Rt, seasonality = x$seasonality, 
                     epsilon = x$epsilon, Rt_CI95 = x$Rt_CI95)
    d <- dplyr::filter(d2, date >= as.Date(date_start) & 
                         date <= as.Date(date_end))
    maxI <- max(d$i_original)
    
    
    g1 <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = i_original)) + 
      ggplot2::geom_line() +
      theme_graphs_no_xlab+
      ggplot2::scale_y_continuous(labels = function(x) format(x,scientific = TRUE), limits = c(0, 1.2 * maxI)) + 
      
      ggplot2::geom_text(data=data.frame(1,1),x = -Inf, y = Inf, label = "original incidence",hjust = -0.11, vjust = 1.5,inherit.aes = F)
    
    
    
    g2 <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = i_festive)) + 
      ggplot2::geom_line() + theme_graphs_no_xlab + ggplot2::scale_y_continuous(labels = function(x) format(x,  scientific = TRUE), limits = c(0, 1.2 * maxI)) + 
      ggplot2::geom_text(data=data.frame(1,1),x = -Inf, y = Inf, label = "festive bias free incidence",hjust = -0.11, vjust = 1.5,inherit.aes = F)
    
    g3 <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = i_bias_free)) + 
      ggplot2::geom_line() + theme_graphs_no_xlab + ggplot2::scale_y_continuous(labels = function(x) format(x, scientific = TRUE), limits = c(0, 1.2 * maxI)) + 
      ggplot2::geom_text(data=data.frame(1,1),x = -Inf, y = Inf, label = "weekly + festive biases free incidence",hjust = -0.07, vjust = 1.5,inherit.aes = F)
    
    g4 <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = i_restored)) + 
      ggplot2::geom_line() + theme_graphs_no_xlab + ggplot2::scale_y_continuous(labels = function(x) format(x, scientific = TRUE), limits = c(0, 1.2 * maxI)) + 
      ggplot2::geom_text(data=data.frame(1,1),x = -Inf, y = Inf, label = "restored incidence", hjust = -0.12, vjust = 1.5,inherit.aes = F)
    
    g5 <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = Rt)) + 
      ggplot2::ylim(0, 1.2 * max(d$Rt)) + ggplot2::geom_line() + 
      theme_graphs_no_xlab + ggplot2::geom_ribbon(ggplot2::aes(ymin = Rt - Rt_CI95, ymax = Rt + Rt_CI95), fill = I(rgb(0.7, 0.7, 0.7)), colour = NA) + 
      ggplot2::geom_line(ggplot2::aes(y = Rt)) + 
      ggplot2::geom_hline(yintercept = 1) + 
      ggplot2::geom_text(data=data.frame(1,1),x = -Inf,  y = Inf, label = "Rt", hjust = -0.9, vjust = 1.5,inherit.aes = F)
    
    g6 <- ggplot2::ggplot(d, ggplot2::aes(x = date, y = seasonality)) + 
      ggplot2::ylim(0, 1.2 * max(d$seasonality)) + ggplot2::geom_line() + 
      theme_graphs_no_xlab + ggplot2::geom_text(data=data.frame(1,1),x = -Inf,  y = Inf, label = "seasonality", hjust = -0.2, vjust = 1.5,inherit.aes = F)
    
    g7 <- ggplot2::ggplot() + 
      ggplot2::ylim(min(d$epsilon), 1.2 * max(d$epsilon)) + 
      ggplot2::geom_line(data=d,ggplot2::aes(x = date, y = epsilon)) + 
      ggplot2::scale_x_date(date_labels = "%Y-%m-%d") + 
      theme_graphs+
      ggplot2::labs(x = "", y = "normalized noise") + 
      ggplot2::geom_text(data=data.frame(1,1),x = -Inf, y = Inf, label = paste("normalized noise ( a = ", 
                                                                               trunc(100 * x$power_a)/100, ")"), hjust = -0.1, 
                         vjust = 1.5)
    p1 <- ggplot2::ggplotGrob(g1)
    p2 <- ggplot2::ggplotGrob(g2)
    p3 <- ggplot2::ggplotGrob(g3)
    p4 <- ggplot2::ggplotGrob(g4)
    p5 <- ggplot2::ggplotGrob(g5)
    p6 <- ggplot2::ggplotGrob(g6)
    p7 <- ggplot2::ggplotGrob(g7)
    grid::grid.draw(rbind(p1, p2, p3, p4, p5, p6, p7))
  }
  else {
    stop("The drawing option is not recognized.")
  }
}

#' @title 
#' \code{EpiInvertForecast_plot} 
#' 
#' @description EpiInvertForecast_plot() plot the restored incidence forecast
#'
#' @param EpiInvert_results the list returned by the EpiInvert execution
#'
#' @param Forecast the list returned by the EpiInvertForecast execution
#' 
#' @return a plot with the last 28 days of the original and restored incidence curves and a 28-day 
#' forecast of the same curves. It also includes a shaded area with a 95% empiric confidence interval
#' of the restored incidence forecast estimation
#' 

#' @export
EpiInvertForecast_plot <- function(EpiInvert_results,Forecast){
  
  Do <- utils::tail(EpiInvert_results$dates,28)
  Oo <- utils::tail(EpiInvert_results$i_original,28)
  Ro <- utils::tail(EpiInvert_results$i_restored,28)
  
  Df <- Forecast$dates
  Of <- Forecast$i_original_forecast
  Rf <- Forecast$i_restored_forecast
  Cf025 <- Forecast$i_restored_forecast_CI025
#  Cf25 <- Forecast$i_restored_forecast_CI25
#  Cf75 <- Forecast$i_restored_forecast_CI75
  Cf975 <- Forecast$i_restored_forecast_CI975
  
  CImin <- pmax(Rf+Cf025,0)
  CImax <- Rf+Cf975
  
  Nf <- length(Forecast$dates)
  
  #utils::globalVariables(c("date", "incid", "legend", "ymi", "yma"))
  dfr <- data.frame(
        date = c(as.Date(Do),as.Date(Do),as.Date(Df),as.Date(Df)),
        incid = c(Oo,Ro,Of,Rf),
        legend2 = c(rep("original incidence",28),rep("restored incidence",28),rep("forecast original incidence",Nf),rep("forecast restored incidence",Nf)),
        ymi = c(Oo,Ro,Of,CImin),
        yma = c(Oo,Ro,Of,CImax)
  )
  
  date2 <- dfr$date
  incid2 <- dfr$incid
  legend <- dfr$legend
  ymi2 <- dfr$ymi
  yma2 <- dfr$yma
  
                  
  g <- ggplot2::ggplot(dfr, ggplot2::aes(date2,incid2, col=legend))+ 
       ggplot2::geom_ribbon(ggplot2::aes(ymin = ymi2, ymax = yma2), fill = I(rgb(0.9,  0.9, 0.9)), linetype = 0 )+ 
       ggplot2::geom_line(size = 0.7)+
       ggplot2::scale_color_manual(values = c("blue",  "green", "black", "red")) + 
       ggplot2::scale_x_date(date_labels = "%Y-%m-%d") + 
       ggplot2::theme_bw()+
       ggplot2::theme(axis.title = ggplot2::element_blank() )+
       ggplot2::theme(legend.position="bottom")
  
  p <- ggplot2::ggplotGrob(g)
  grid::grid.draw(rbind(p))
 
}

#' @title 
#' \code{EpiIndicators_plot} 
#' 
#' @description EpiIndicators_plot() plots the results obtained by EpiIndicators()
#'
#' @param df : a dataframe obtained as the outcome of executing EpiIndicators()
#'
#' 
#' @return a combination of 3 plots: (A) the indicator f(t) (in green in the main
#' y-axis) and the indicator g(t) (in red in the secondary axis). (B) r(t)*f(t) 
#' (in green in the main y-axis) and g(t+s(t)) (in red in the secondary axis) and  
#' (C) r(t) (in green in the main y-axis) and s(t) (in red in the secondary axis)
#' 

#' @export
EpiIndicators_plot <- function(df){
  
  df$date<-as.Date(df$date)
  df[,2]<-as.numeric(df[,2])
  df[,3]<-as.numeric(df[,3])
  df[,4]<-as.numeric(df[,4])
  df[,5]<-as.numeric(df[,5])
  df[,6]<-as.numeric(df[,6])
  df[,7]<-as.numeric(df[,7])
  
  f_color <- rgb(0,191/255, 196/255, 1)
  g_color <- rgb(248/255,120/255, 111/255, 1)
  
  
  y1<-min(df[,2])
  x1<-min(df[,3])
  m1<-(max(df[,2])-min(df[,2]))/(max(df[,3])-min(df[,3]))
  
  g0<-ggplot2::ggplot(df, ggplot2::aes(x=date)) + ggplot2::theme_bw() + 
    ggplot2::geom_line( ggplot2::aes(y=df[,2]),color=f_color) + 
    ggplot2::geom_line( ggplot2::aes(y=y1+(df[,3]-x1)*m1),color=g_color) + 
    ggplot2::scale_y_continuous(name = "indicator f(t)",sec.axis = ggplot2::sec_axis(~ (. - y1)/m1+x1, name="indicator g(t)"))+
    ggplot2::theme(axis.title.y = ggplot2::element_text(color = f_color),axis.title.y.right = ggplot2::element_text(color = g_color))+
    ggplot2::theme(legend.position = "none",axis.title.x = ggplot2::element_blank())
  
  
  g1<-ggplot2::ggplot(df, ggplot2::aes(x=date)) + ggplot2::theme_bw() + 
    ggplot2::geom_line( ggplot2::aes(y=df[,6]),color=f_color) + 
    ggplot2::geom_line( ggplot2::aes(y=df[,7]),color=g_color) + 
    ggplot2::scale_y_continuous(name = "r(t)*f(t)",sec.axis = ggplot2::sec_axis(~., name="g(t+s(t))"))+
    ggplot2::theme(axis.title.y = ggplot2::element_text(color = f_color),axis.title.y.right = ggplot2::element_text(color = g_color))+
    ggplot2::theme(legend.position = "none",axis.title.x = ggplot2::element_blank())
  
  y0<-min(df[,4])
  x0<-min(df[,5])
  m<-(max(df[,4])-min(df[,4]))/(max(df[,5])-min(df[,5]))
  
  g2<-ggplot2::ggplot(df, ggplot2::aes(x=date)) + ggplot2::theme_bw() + 
    ggplot2::geom_line( ggplot2::aes(y=df[,4]),color=f_color) + 
    ggplot2::geom_line( ggplot2::aes(y=y0+(df[,5]-x0)*m),color=g_color) + 
    ggplot2::scale_y_continuous(name = "ratio r(t)",sec.axis = ggplot2::sec_axis(~ (. - y0)/m+x0, name="shift s(t)"))+
    ggplot2::theme(axis.title.y = ggplot2::element_text(color = f_color),axis.title.y.right = ggplot2::element_text(color = g_color))+
    ggplot2::theme(legend.position = "none",axis.title.x = ggplot2::element_blank())
  
  ggpubr::ggarrange(ggpubr::ggarrange(g0, ncol = 1, labels = c("A")),
                    ggpubr::ggarrange(g1, ncol = 1, labels = c("B")),
                    ggpubr::ggarrange(g2, ncol = 1, labels = c("C")),
                    nrow = 3
                   )
  
  
}


