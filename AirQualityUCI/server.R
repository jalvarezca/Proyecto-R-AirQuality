
library(shiny)
library(lubridate)


source("DatosETL.R")

server <- function(input, output) {
  

# Graficos de CO ----------------------------------------------------------
  output$plotCODia <- renderPlot(
    ggplot(
      data = datos,
      aes(x = Dia,y =CO)) + 
      geom_boxplot() + 
      ggtitle("Concentracion por dia de CO") +
      xlab("Dia") +
      ylab("Niveles de CO")
  )
  
  output$plotCOMes <- renderPlot(
    ggplot(data = datos,
      aes(x = lubridate::month(datos$Date, label = TRUE),
          y = CO)) + 
      geom_boxplot() + 
      ggtitle("Concentracion CO por Mes") +
      xlab("Mes") +
      ylab("Niveles de CO")
  )
  # Graficos de NMHC ----------------------------------------------------------
  output$plotNMHCDia <- renderPlot(
    ggplot(
      data = datos,
      aes(x = Dia,y =NMHC)) +
      geom_boxplot() +
      ggtitle("Concentracion por dia de NMHC") +
      xlab("Dia") +
      ylab("Niveles de NMHC")
  )

  output$plotNMHCMes <- renderPlot(
    ggplot(data = datos,
           aes(x = lubridate::month(datos$Date, label = TRUE),
               y = NMHC)) +
      geom_boxplot() +
      ggtitle("Concentracion NMHC por Mes") +
      xlab("Mes") +
      ylab("Niveles de NMHC")
  )
  # Graficos de C6H6 ----------------------------------------------------------
  output$plotC6H6Dia <- renderPlot(
    ggplot(
      data = datos,
      aes(x = Dia,y =C6H6)) + 
      geom_boxplot() + 
      ggtitle("Concentracion por dia de C6H6") +
      xlab("Dia") +
      ylab("Niveles de C6H6")
  )
  
  output$plotC6H6Mes <- renderPlot(
    ggplot(data = datos,
           aes(x = lubridate::month(datos$Date, label = TRUE),
               y = C6H6)) + 
      geom_boxplot() + 
      ggtitle("Concentracion C6H6 por Mes") +
      xlab("Mes") +
      ylab("Niveles de C6H6")
  )
  
}