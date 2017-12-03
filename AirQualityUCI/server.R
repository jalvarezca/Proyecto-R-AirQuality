
library(shiny)


source("DatosETL.R")

server <- function(input, output) {
  
  
  output$plotCODia <- renderPlot(
    ggplot(
      data = datosCODia,
      aes(
        x = DiaLabel,
        y =totalCODia)) + 
      geom_point() + 
      ggtitle("Concentracion CO con respecto al dia") +
      xlab("Dia") +
      ylab("Niveles de CO")
  )
  
  output$plotCOMes <- renderPlot(
    ggplot(
      data = datosCOMes,
      aes(
        x = Mes,
        y =promedio)) + 
      geom_point() + 
      ggtitle("Concentracion CO por Mes") +
      xlab("Mes") +
      ylab("Niveles de CO")
  )
  # output$lineplot <- renderPlot({
  #   plot(filter(.data = grossPerYear1, title_year < input$slider3))
  # }
  # )
  
}